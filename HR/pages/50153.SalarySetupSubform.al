namespace BILLENERGY.BILLENERGY;

page 50153 SalarySetupSubform
{
    ApplicationArea = All;
    Caption = 'Salary Setup Subform';
    PageType = ListPart;
    SourceTable = SalarySetupLine;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Salary Code"; Rec."Salary Code")
                {
                    ToolTip = 'Specifies the value of the Salary Code field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Element Code"; Rec."Element Code")
                {
                    ToolTip = 'Specifies the value of the Element Code field.', Comment = '%';
                }
                field("Element Name"; Rec."Element Name")
                {
                    ToolTip = 'Specifies the value of the Element Name field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field(Earning; Rec.Earning)
                {
                    ToolTip = 'Specifies the value of the Earning field.', Comment = '%';
                }
                field(Deduction; Rec.Deduction)
                {
                    ToolTip = 'Specifies the value of the Deduction field.', Comment = '%';
                }
                field(Calculated; Rec.Calculated)
                {
                    ToolTip = 'Specifies the value of the Calculated field.', Comment = '%';
                    Visible = false;
                }
                field("Calculation formula"; Rec."Calculation formula")
                {
                    ToolTip = 'Specifies the value of the Calculation formula field.', Comment = '%';
                    Visible = false;
                }
                field("Use formula"; Rec."Use formula")
                {
                    ToolTip = 'Specifies the value of the Use formula field.', Comment = '%';
                    Visible = false;
                }
                field(Taxable; Rec.Taxable)
                {
                    ToolTip = 'Specifies the value of the Taxable field.', Comment = '%';
                    Visible = false;
                }
            }
        }
    }
}
