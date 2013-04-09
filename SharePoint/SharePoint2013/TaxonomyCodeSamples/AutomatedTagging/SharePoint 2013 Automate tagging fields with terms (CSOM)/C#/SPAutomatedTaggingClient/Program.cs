using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Text.RegularExpressions;
using Microsoft.SharePoint.Client;
using Microsoft.SharePoint.Client.Taxonomy;

namespace AutomatedTagging
{
    #region Helper Classes

    class ExcelRow
    {
        public string ListItemUrl;

        // InternalName, Guid
        public List<KeyValuePair<string, Guid>> Pairs = new List<KeyValuePair<string, Guid>>();

        public bool Processed = false;
        int CsvLineNumber;

        public ExcelRow(string listItemUrl, int csvLineNumber)
        {
            this.ListItemUrl = listItemUrl;
            this.CsvLineNumber = csvLineNumber;
        }
    }

    class TermSetLookup
    {
        public TaxonomyField taxonomyField;
        TermCollection terms;
        Dictionary<string, Guid> TermsByName = new Dictionary<string, Guid>(StringComparer.OrdinalIgnoreCase);

        public TermSetLookup(TaxonomyField taxonomyField, TermSet termSet)
        {
            this.taxonomyField = taxonomyField;
            this.terms = termSet.GetAllTerms();

            Program.clientContext.Load(this.terms,
              termsArg => termsArg.Include(
                termArg => termArg.Id,
                termArg => termArg.Name
              )
            );
        }

        public void LoadResults()
        {
            foreach (Term term in terms)
                TermsByName.Add(term.Name, term.Id);
        }


        public Guid GetTermId(string label)
        {
            return TermsByName[label];
        }
    }

    #endregion

    class Program
    {

        // The context object for the Client OM session.
        public static ClientContext clientContext;

        static void Main(string[] args)
        {
            Log("\r\nAutomatedTagging (Client OM): Connecting...\r\n");

            Program.clientContext = new ClientContext("http://localhost/");

            List list = Program.clientContext.Web.Lists.GetByTitle("Documents");
            Program.clientContext.Load(list, listArg => listArg.RootFolder.ServerRelativeUrl);

            // We could also support "TaxonomyFieldTypeMulti" here
            IEnumerable<Field> fieldQuery = clientContext.LoadQuery(
                list.Fields
                .Include(
                  fieldArg => fieldArg.TypeAsString,
                  fieldArg => fieldArg.Id,
                  fieldArg => fieldArg.InternalName
                )
              ).Where(fieldArg => fieldArg.TypeAsString == "TaxonomyFieldType");
            clientContext.ExecuteQuery();

            List<TaxonomyField> taxonomyFields = fieldQuery.Cast<TaxonomyField>().ToList();

            foreach (TaxonomyField field in taxonomyFields)
            {
                clientContext.Load(field,
                  fieldArg => fieldArg.SspId,
                  fieldArg => fieldArg.TermSetId);
            }
            clientContext.ExecuteQuery();

#if false
      ExportTemplate(list, taxonomyFields);
#else
            ImportTemplate(list, taxonomyFields);
#endif

            if (Debugger.IsAttached)
                Debugger.Break();
        }

        // This function exports a CSV file template containing the URL for each
        // of the documents in the SharePoint list.  The user will edit this file
        // manually using Excel.
        static void ExportTemplate(List list, List<TaxonomyField> taxonomyFields)
        {
            Log("Writing AutomatedTagging.csv...");

            using (StreamWriter streamWriter = new StreamWriter("AutomatedTagging.csv"))
            {
                streamWriter.WriteLine("Filename,,Field,Tags,Field,Tags,...");

                ProcessListItems(list, new[] { "ID", "ServerUrl" },
                 delegate(ListItem listItem)
                 {
                     streamWriter.Write((string)listItem["ServerUrl"] + ",");

                     foreach (Field field in taxonomyFields)
                     {
                         streamWriter.Write("," + field.InternalName + ",");
                     }
                     streamWriter.WriteLine();
                 });
            }
        }

        // This function reads the CSV file and applies the tags to the
        // taxonomy fields in the SharePoint list
        static void ImportTemplate(List list, List<TaxonomyField> taxonomyFields)
        {
            // Load TermSet for each field
            Dictionary<string, TermSetLookup> termSetsByInternalName
              = GetTermSetsByInternalName(taxonomyFields);

            // Load the Excel file
            Dictionary<string, ExcelRow> excelRowsByUrl = GetExcelRowsByUrl(termSetsByInternalName);

            // STEP 3: Update the list items
            List<string> fieldNames = taxonomyFields.Select(f => f.InternalName).ToList();
            fieldNames.Add("ServerUrl");

            ProcessListItems(list, fieldNames,
              delegate(ListItem listItem)
              {
                  // Does the CSV file contain a row matching this list item?
                  ExcelRow excelRow;
                  if (!excelRowsByUrl.TryGetValue((string)listItem["ServerUrl"], out excelRow))
                      return; // no it does not

                  excelRow.Processed = true;

                  bool updated = false;
                  foreach (KeyValuePair<string, Guid> pair in excelRow.Pairs)
                  {
                      TaxonomyField taxonomyField = taxonomyFields.First(f => f.InternalName == pair.Key);

                      TaxonomyFieldValue taxonomyFieldValue = new TaxonomyFieldValue();
                      // (to clear the tag, you would specify the empty GUID here)
                      taxonomyFieldValue.TermGuid = pair.Value.ToString();

                      TaxonomyFieldValue oldValue = (TaxonomyFieldValue)listItem.FieldValues[taxonomyField.InternalName];
                      if (oldValue == null || oldValue.TermGuid != taxonomyFieldValue.TermGuid)
                      {
                          taxonomyField.SetFieldValueByValue(listItem, taxonomyFieldValue);
                          updated = true;
                      }
                  }

                  if (updated)
                  {
                      Log("Updating item: " + listItem["ServerUrl"]);
                      listItem.Update();
                  }

                  Program.clientContext.ExecuteQuery();
              }
            );

            // Were any items missed?
            Log("");
            List<ExcelRow> missedRows = excelRowsByUrl.Values.Where(row => !row.Processed).ToList();
            if (missedRows.Count > 0)
            {
                Log("Failed to match these rows");
                foreach (ExcelRow row in missedRows)
                    Log("  " + row.ListItemUrl);
            }
        }

        static Dictionary<string, TermSetLookup> GetTermSetsByInternalName(List<TaxonomyField> taxonomyFields)
        {
            Dictionary<string, TermSetLookup> termSetsByInternalName
              = new Dictionary<string, TermSetLookup>(StringComparer.OrdinalIgnoreCase);

            TaxonomySession taxonomySession = TaxonomySession.GetTaxonomySession(Program.clientContext);
            taxonomySession.UpdateCache();

            foreach (TaxonomyField field in taxonomyFields)
            {
                TermStore termStore = taxonomySession.TermStores.GetById(field.SspId);
                TermSet termSet = termStore.GetTermSet(field.TermSetId);
                termSetsByInternalName.Add(field.InternalName, new TermSetLookup(field, termSet));
            }

            Program.clientContext.ExecuteQuery();
            foreach (TermSetLookup termSetLookup in termSetsByInternalName.Values)
            {
                termSetLookup.LoadResults();
            }
            return termSetsByInternalName;
        }

        static Dictionary<string, ExcelRow> GetExcelRowsByUrl(Dictionary<string, TermSetLookup> termSetsByInternalName)
        {
            Dictionary<string, ExcelRow> excelRowsByUrl = new Dictionary<string, ExcelRow>(StringComparer.OrdinalIgnoreCase);

            Log("Reading AutomatedTagging.csv...");

            // Parse the input file
            using (StreamReader streamReader = new StreamReader("AutomatedTagging.csv"))
            {
                if (!streamReader.ReadLine().Contains("Filename"))
                    throw new InvalidOperationException("Invalid file format; header is missing");

                int lineNumber = 1;
                for (; ; )
                {
                    string line = streamReader.ReadLine();
                    ++lineNumber;
                    if (line == null)
                        break;

                    string[] csvValues = ParseCsvLine(line);
                    if (csvValues == null)
                        throw new InvalidOperationException("[line " + lineNumber + "]: Syntax error");

                    if (csvValues.Length < 1)
                        continue;

                    ExcelRow excelRow = new ExcelRow(csvValues[0], lineNumber);
                    for (int i = 2; i + 1 < csvValues.Length; )
                    {
                        string key = csvValues[i++].Trim();
                        if (key == "") break;

                        string value = csvValues[i++].Trim();
                        if (value == "") break;

                        TermSetLookup termSetLookup = termSetsByInternalName[key];
                        Guid termId = termSetLookup.GetTermId(value);

                        excelRow.Pairs.Add(new KeyValuePair<string, Guid>(termSetLookup.taxonomyField.InternalName, termId));
                    }

                    excelRowsByUrl.Add(excelRow.ListItemUrl, excelRow);
                }
            }
            return excelRowsByUrl;
        }

        // (Compare with ContentIterator for Server OM)
        static void ProcessListItems(List list, IList<string> fieldNames, Action<ListItem> action)
        {

            CamlQuery camlQuery = CamlQuery.CreateAllItemsQuery(5, fieldNames.ToArray());

            var retrievalsList = new List<Expression<Func<ListItem, object>>>();
            foreach (string fieldName in fieldNames)
                retrievalsList.Add(listItemArg => listItemArg[fieldName]);
            var retrievals = retrievalsList.ToArray();

            ListItemCollectionPosition itemPosition = null;

            int itemCount = 0;
            for (; ; )
            {
                camlQuery.ListItemCollectionPosition = itemPosition;

                ListItemCollection listItems = list.GetItems(camlQuery);
                clientContext.Load(listItems,
                  listItemsArg => listItemsArg.ListItemCollectionPosition,
                  listItemsArg => listItemsArg.Include(retrievals)
                );
                clientContext.ExecuteQuery();

                itemPosition = listItems.ListItemCollectionPosition;

                foreach (ListItem listItem in listItems)
                {
                    action(listItem);
                    ++itemCount;
                }

                Log("Processed batch: " + itemCount);

                if (itemPosition == null)
                    break;
            }
        }

        #region Utilities

        static Regex csvParseRegex = new Regex(@"
^
(
   (
     (""
        (?<value>  ( [^""] | """" )*  )
     "") |
     (?<value> [^"",][^,]* ) |
     (?<value>)
   )
   ,
)*
   (
     (""
        (?<value>  ( [^""] | """" )*  )
     "") |
     (?<value> [^"",][^,]* ) |
     (?<value>)
   )
$", RegexOptions.ExplicitCapture | RegexOptions.IgnorePatternWhitespace | RegexOptions.Compiled);

        static string[] ParseCsvLine(string csvLine)
        {
            Match match = csvParseRegex.Match(csvLine);
            if (match.Success)
            {
                return (from Capture capture in match.Groups["value"].Captures
                        select capture.Value.Replace("\"\"", "\""))
                    .ToArray();
            }
            return null;
        }

        static void Log(string message)
        {
            Console.WriteLine(message);
            Debug.WriteLine(message);
        }

        #endregion
    }
}

