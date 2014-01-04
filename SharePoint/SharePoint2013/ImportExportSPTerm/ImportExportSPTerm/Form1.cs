using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Microsoft.SharePoint.Taxonomy;
using Microsoft.SharePoint;
using System.Xml;
using System.Reflection;
using Microsoft.SharePoint.Administration;

namespace ImportExportSPTerm
{
    public partial class Form1 : Form
    {
        static StringBuilder strExportXml;
        static TaxonomySession session;
        static TermStore termStore;
        static Group group;
        static TermSet termSet;
        DataTable dt;

        public Form1()
        {
            InitializeComponent();
        }

        private void folderBrowserDialog1_HelpRequest(object sender, EventArgs e)
        {

        }

        private void butexport_Click(object sender, EventArgs e)
        {
            string directoryPath = txtpathExport.Text; //get directory path for export
            string groupName = Convert.ToString(cbTermGroup.SelectedItem); //TermStore GroupName
            string TermSetname = Convert.ToString(cbTermset.SelectedItem); // TermSet Name
            string SPSiteURL = Convert.ToString(cbWebApp.SelectedItem);   // site url.



            try
            {
                SPSecurity.RunWithElevatedPrivileges(delegate()
                {
                    ExportTerms(directoryPath, groupName, TermSetname, SPSiteURL);
                });

                string msg = "Export done....Check your " + groupName + "-" + TermSetname + ".xml file on Location Path " + directoryPath;
                MessageBox.Show(msg);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error :" + ex.Message);
            }



        }

        private void button1_Click(object sender, EventArgs e)
        {
            string filedicpath = txtimportpath.Text;
            string SPSiteurl = Convert.ToString(cbImportwebapp.SelectedItem);   // site url.
            try
            {
                SPSecurity.RunWithElevatedPrivileges(delegate()
                {
                    ImportTerms(filedicpath, SPSiteurl);
                });


                MessageBox.Show("Import Done.");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error :" + ex.Message);
            }

        }


        #region Import Code
        private static void ImportTerms(string filePath, string urlSPSite)
        {
            using (SPSite site = new SPSite(urlSPSite))
            {
                // function that return termstore from site.
                termStore = termstorefromWebApp(site);

                XmlDocument doc = new XmlDocument();
                doc.Load(filePath);
                XmlNode termGroup = doc.SelectSingleNode("/Groups/Group");
                ProcessGroup(termGroup);
                termStore.CommitAll();
            }

        }

        private static void ProcessGroup(XmlNode termGroup)
        {
            if (termGroup != null)
            {
                string strGroupName = termGroup.Attributes["Name"].Value;

                //Get TermStore Groups
                GroupCollection groups = termStore.Groups;

                //Find group that we want to Import to
                Group thisGroup = groups.Where(g => g.Name == strGroupName).SingleOrDefault();

                //Check that group exist
                if (thisGroup != null)
                {
                    //Get Current group
                    group = termStore.GetGroup(thisGroup.Id);
                }
                else //If group doesn't exist, create it
                {
                    group = termStore.CreateGroup(strGroupName);
                    termStore.CommitAll();
                }
                Console.WriteLine(strGroupName);

                ProcessTermSet(termGroup);
            }
        }

        private static void ProcessTermSet(XmlNode termGroup)
        {
            foreach (XmlNode termSets in termGroup.ChildNodes)
            {
                //ProcessTermSet
                string strTermSetName = termSets.Attributes["Name"].Value;
                string strTermSetNameFr = termSets.Attributes["NameFr"].Value;

                //Get TermSetCollection
                TermSetCollection termSetColl = group.TermSets;

                //Find termSet that we want to Import to
                TermSet thisTermSet = termSetColl.Where(g => g.Name == strTermSetName).SingleOrDefault();

                if (thisTermSet != null)
                {
                    //Get Current TermSet
                    termSet = thisTermSet;
                    //Delete the current TermSet and all the associate terms
                    termSet.Delete();
                    termStore.CommitAll();
                }

                //Create the TermSet
                termSet = group.CreateTermSet(strTermSetName, 1033);
                termStore.CommitAll();

                Console.WriteLine(strTermSetName);

                //ProcessTerms
                ProcessTerms(termSets.FirstChild, termSet, null);
            }
        }


        private static void ProcessTerms(XmlNode termSetTerms, TermSet termSet, Term currentTerm)
        {
            Term newTerm;

            foreach (XmlNode termsNames in termSetTerms.SelectNodes("Term"))
            {
                string strTermName = termsNames.Attributes["Name"].Value;
                if (currentTerm != null)
                {
                    newTerm = currentTerm.CreateTerm(strTermName, termStore.DefaultLanguage);
                }
                else
                {
                    newTerm = termSet.CreateTerm(strTermName, termStore.DefaultLanguage);
                    // termStore.CommitAll();
                }

                termStore.CommitAll();

                Console.WriteLine(strTermName);
                //ProcessLabels
                foreach (XmlNode labelNames in termsNames.SelectSingleNode("Labels").ChildNodes)
                {
                    string strLCID = labelNames.Attributes["lcid"].Value;
                    string strLabelName = labelNames.Attributes["Name"].Value;
                    string strTermDescription = labelNames.Attributes["Description"].Value;
                    if (Convert.ToInt32(strLCID) != termStore.DefaultLanguage)
                    {
                        newTerm.CreateLabel(strLabelName, Convert.ToInt32(strLCID), true);
                        termStore.CommitAll();
                    }
                    newTerm.SetDescription(strTermDescription, Convert.ToInt32(strLCID));
                    termStore.CommitAll();

                    Console.WriteLine(strLCID);
                    Console.WriteLine(strLabelName);
                }
                foreach (XmlNode subTerms in termsNames.SelectNodes("Terms"))
                {
                    ProcessTerms(subTerms, termSet, newTerm);
                }
            }
        }

        #endregion


        #region Export Code
        private static void ExportTerms(string directoryPath, string groupName, string termsetName, string urlSPSite)
        {

            strExportXml = new StringBuilder();

            using (SPSite site = new SPSite(urlSPSite))
            {
                String fileName = groupName + "-" + termsetName + ".xml";
                fileName = fileName.Replace("/", "").Replace("\\", "").Replace(" ", "");

                // function that return termstore from site.
                termStore = termstorefromWebApp(site);

                Group group = termStore.Groups[groupName];
                TermSet termSet = group.TermSets[termsetName];

                String termsetNameFr = String.Empty;
                try
                {
                    PropertyInfo namesProperty = termSet.GetType().GetProperties(BindingFlags.NonPublic | BindingFlags.Instance).Single(pi => pi.Name == "Names");
                    System.Collections.Generic.Dictionary<int, string> names = (System.Collections.Generic.Dictionary<int, string>)namesProperty.GetValue(termSet, null);


                    if (names[1036] != null)
                    {
                        termsetNameFr = names[1036];
                    }
                }
                catch (System.Collections.Generic.KeyNotFoundException)
                {

                }

                strExportXml.Append("<?xml version=\"1.0\" encoding=\"utf-16\" ?>");
                strExportXml.Append("<Groups>");
                strExportXml.Append("<Group Name=\"" + groupName + "\">");
                strExportXml.Append("<TermSet Name=\"" + termsetName + "\" " + "NameFr=\"" + termsetNameFr + "\">");
                strExportXml.Append("<Terms>");

                foreach (Term trm in termSet.Terms)
                {
                    GetTerm(trm);
                }
                strExportXml.Append("</Terms>");
                strExportXml.Append("</TermSet>");
                strExportXml.Append("</Group>");
                strExportXml.Append("</Groups>");
                System.Console.WriteLine("Export Terms");
                FinalExport(directoryPath, fileName);
            }
        }

        private static void FinalExport(string exportDirectory, string fileName)
        {
            String path = exportDirectory + fileName;
            XmlWriterSettings xmlWritesettings = new XmlWriterSettings();
            xmlWritesettings.Indent = true;
            xmlWritesettings.OmitXmlDeclaration = true;
            xmlWritesettings.Encoding = Encoding.Unicode;

            using (XmlWriter writer = XmlWriter.Create(path, xmlWritesettings))
            {
                writer.WriteRaw(strExportXml.ToString());
            }
            System.Console.WriteLine("Final Export");
        }

        private static void GetTerm(Term term)
        {
            strExportXml.Append("<Term Name=\"" + term.Name.ToString() + "\">");
            strExportXml.Append("<Labels>");
            foreach (Microsoft.SharePoint.Taxonomy.Label lbl in term.Labels)
            {
                strExportXml.Append("<Label lcid=\"" + lbl.Language.ToString() + "\" Name=\"" + lbl.Value + "\" Description=\"" + term.GetDescription(lbl.Language) + "\" />");
                //  Console.WriteLine("     Label: " + lbl.Value + " LCID: " + lbl.Language.ToString());
            }
            strExportXml.Append("</Labels>");
            foreach (Term subtrm in term.Terms)
            {
                strExportXml.Append("<Terms>");
                GetTerm(subtrm);
                strExportXml.Append("</Terms>");
            }
            strExportXml.Append("</Term>");
        }

        #endregion

        private void Form1_Load(object sender, EventArgs e)
        {

            // #### bind combox of all web app url.
            SPFarm Farm = SPFarm.Local;
            SPWebService service = Farm.Services.GetValue<SPWebService>("");
            foreach (SPWebApplication webapp in service.WebApplications)
            {
                cbWebApp.Items.Add(webapp.GetResponseUri(SPUrlZone.Default).AbsoluteUri);
                cbImportwebapp.Items.Add(webapp.GetResponseUri(SPUrlZone.Default).AbsoluteUri);
            }
            // #### bind combox of all web app url.


        }

        private void cbWebApp_SelectedIndexChanged(object sender, EventArgs e)
        {
            string urlSPSite = Convert.ToString(cbWebApp.SelectedItem);
            using (SPSite osite = new SPSite(urlSPSite))
            {
                termStore = termstorefromWebApp(osite);

                cbTermGroup.Text = "";
                cbTermGroup.Items.Clear();
                foreach (Group group in termStore.Groups)
                {
                    cbTermGroup.Items.Add(group.Name);
                }
            }

        }



        private void cbTermGroup_SelectedIndexChanged(object sender, EventArgs e)
        {
            string urlSPSite = Convert.ToString(cbWebApp.SelectedItem);
            using (SPSite osite = new SPSite(urlSPSite))
            {
                termStore = termstorefromWebApp(osite);
                string selectedgroupname = Convert.ToString(cbTermGroup.SelectedItem);

                Group group = termStore.Groups[selectedgroupname];

                cbTermset.Text = "";
                cbTermset.Items.Clear();
                foreach (TermSet termset in group.TermSets)
                {
                    cbTermset.Items.Add(termset.Name);
                }
            }

        }

        public static TermStore termstorefromWebApp(SPSite site)
        {

            TaxonomySession session = new TaxonomySession(site);

            //ThroubleShooting problem during get termstore 
            // http://sharepoint.stackexchange.com/questions/4097/why-are-taxonomy-term-stores-always-empty
            //http://blog.henryong.com/2012/03/20/sharepoint-dev-getting-null-taxonomysession-and-argumentoutofrangeexception-errors-on-termstore-objects/

            // 1st way;
            termStore = session.TermStores["Managed Metadata Service"];

            // 2nd way;
            // termStore = session.DefaultKeywordsTermStore;//Try  session.DefaultSiteCollectionTermStore

            return termStore;

        }

        private void button2_Click(object sender, EventArgs e)
        {

            OpenFileDialog openFileDialog = new OpenFileDialog();
            openFileDialog.CheckFileExists = true;
            openFileDialog.AddExtension = true;
            openFileDialog.Multiselect = false;
            openFileDialog.Filter = "(*.xml)|*.xml";

            if (openFileDialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                foreach (string fileName in openFileDialog.FileNames)
                {
                    txtimportpath.Text = fileName;
                }
            }
        }

    }
}
