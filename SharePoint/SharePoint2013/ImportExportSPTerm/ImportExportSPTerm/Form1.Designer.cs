namespace ImportExportSPTerm
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.lblexport = new System.Windows.Forms.Label();
            this.butexport = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.txtpathExport = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.button1 = new System.Windows.Forms.Button();
            this.txtimportpath = new System.Windows.Forms.TextBox();
            this.cbWebApp = new System.Windows.Forms.ComboBox();
            this.cbImportwebapp = new System.Windows.Forms.ComboBox();
            this.cbTermGroup = new System.Windows.Forms.ComboBox();
            this.cbTermset = new System.Windows.Forms.ComboBox();
            this.button2 = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // lblexport
            // 
            this.lblexport.AutoSize = true;
            this.lblexport.Location = new System.Drawing.Point(29, 9);
            this.lblexport.Name = "lblexport";
            this.lblexport.Size = new System.Drawing.Size(78, 13);
            this.lblexport.TabIndex = 0;
            this.lblexport.Text = "Export Termset";
            // 
            // butexport
            // 
            this.butexport.Location = new System.Drawing.Point(33, 130);
            this.butexport.Name = "butexport";
            this.butexport.Size = new System.Drawing.Size(75, 23);
            this.butexport.TabIndex = 1;
            this.butexport.Text = "Export";
            this.butexport.UseVisualStyleBackColor = true;
            this.butexport.Click += new System.EventHandler(this.butexport_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(29, 36);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(76, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "Location Path:";
            // 
            // txtpathExport
            // 
            this.txtpathExport.Location = new System.Drawing.Point(152, 29);
            this.txtpathExport.Name = "txtpathExport";
            this.txtpathExport.Size = new System.Drawing.Size(311, 20);
            this.txtpathExport.TabIndex = 3;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(29, 55);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(113, 13);
            this.label2.TabIndex = 4;
            this.label2.Text = "Web Application URL:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(30, 78);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(64, 13);
            this.label3.TabIndex = 6;
            this.label3.Text = "GroupName";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(30, 104);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(75, 13);
            this.label4.TabIndex = 9;
            this.label4.Text = "TermSetName";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(30, 163);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(77, 13);
            this.label5.TabIndex = 10;
            this.label5.Text = "Import Termset";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(30, 216);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(94, 13);
            this.label6.TabIndex = 11;
            this.label6.Text = "Location Path(xml)";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(30, 187);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(113, 13);
            this.label7.TabIndex = 13;
            this.label7.Text = "Web Application URL:";
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(33, 253);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 15;
            this.button1.Text = "Import";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // txtimportpath
            // 
            this.txtimportpath.Location = new System.Drawing.Point(152, 216);
            this.txtimportpath.Name = "txtimportpath";
            this.txtimportpath.Size = new System.Drawing.Size(311, 20);
            this.txtimportpath.TabIndex = 16;
            // 
            // cbWebApp
            // 
            this.cbWebApp.FormattingEnabled = true;
            this.cbWebApp.Location = new System.Drawing.Point(152, 55);
            this.cbWebApp.Name = "cbWebApp";
            this.cbWebApp.Size = new System.Drawing.Size(311, 21);
            this.cbWebApp.TabIndex = 17;
            this.cbWebApp.Text = "--Select webapp url--";
            this.cbWebApp.SelectedIndexChanged += new System.EventHandler(this.cbWebApp_SelectedIndexChanged);
            // 
            // cbImportwebapp
            // 
            this.cbImportwebapp.FormattingEnabled = true;
            this.cbImportwebapp.Location = new System.Drawing.Point(152, 189);
            this.cbImportwebapp.Name = "cbImportwebapp";
            this.cbImportwebapp.Size = new System.Drawing.Size(311, 21);
            this.cbImportwebapp.TabIndex = 18;
            this.cbImportwebapp.Text = "--Select webapp url--";
            // 
            // cbTermGroup
            // 
            this.cbTermGroup.FormattingEnabled = true;
            this.cbTermGroup.Location = new System.Drawing.Point(152, 82);
            this.cbTermGroup.Name = "cbTermGroup";
            this.cbTermGroup.Size = new System.Drawing.Size(311, 21);
            this.cbTermGroup.TabIndex = 19;
            this.cbTermGroup.SelectedIndexChanged += new System.EventHandler(this.cbTermGroup_SelectedIndexChanged);
            // 
            // cbTermset
            // 
            this.cbTermset.FormattingEnabled = true;
            this.cbTermset.Location = new System.Drawing.Point(152, 109);
            this.cbTermset.Name = "cbTermset";
            this.cbTermset.Size = new System.Drawing.Size(311, 21);
            this.cbTermset.TabIndex = 20;
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(469, 216);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(75, 20);
            this.button2.TabIndex = 21;
            this.button2.Text = "Upload";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(681, 326);
            this.Controls.Add(this.button2);
            this.Controls.Add(this.cbTermset);
            this.Controls.Add(this.cbTermGroup);
            this.Controls.Add(this.cbImportwebapp);
            this.Controls.Add(this.cbWebApp);
            this.Controls.Add(this.txtimportpath);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.txtpathExport);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.butexport);
            this.Controls.Add(this.lblexport);
            this.Name = "Form1";
            this.Text = "Import Export SPTerm";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblexport;
        private System.Windows.Forms.Button butexport;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtpathExport;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.TextBox txtimportpath;
        private System.Windows.Forms.ComboBox cbWebApp;
        private System.Windows.Forms.ComboBox cbImportwebapp;
        private System.Windows.Forms.ComboBox cbTermGroup;
        private System.Windows.Forms.ComboBox cbTermset;
        private System.Windows.Forms.Button button2;
    }
}

