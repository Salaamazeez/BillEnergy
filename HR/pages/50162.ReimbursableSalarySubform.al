namespace BILLENERGY.BILLENERGY;

page 50162 ReimbursableSalarySubform
{
    //ApplicationArea = All;
    Caption = 'Reimbursable Salary Subform';
    PageType = ListPart;
    SourceTable = ReimbursableSalarylines;
    //UsageCategory = Tasks;
    //Editable = false;
    AutoSplitKey = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Element Code"; Rec."Element Code")
                {
                    ToolTip = 'Specifies the value of the Element Code field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Element Name"; Rec."Element Name")
                {
                    ToolTip = 'Specifies the value of the Element Name field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Employment Contract Code"; Rec."Employment Contract Code")
                {
                    ToolTip = 'Specifies the value of the Employment Contract Code field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ToolTip = 'Specifies the value of the Employment Date field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("No. of Days In the Month"; Rec."No. of Days In the Month")
                {
                    ToolTip = 'Specifies the value of the No. of Days In the Month field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No. of Days Worked"; Rec."No. of Days Worked")
                {
                    ToolTip = 'Specifies the value of the No. of Days Worked field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Book Value"; Rec."Book Value")
                {
                    ToolTip = 'Specifies the value of the Book Value field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Net Pay"; Rec."Net Pay")
                {
                    ToolTip = 'Specifies the value of the Net Pay field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payroll Bank"; Rec."Payroll Bank")
                {
                    ToolTip = 'Specifies the value of the Payroll Bank field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payroll Bank Account No."; Rec."Payroll Bank Account No.")
                {
                    ToolTip = 'Specifies the value of the Payroll Bank Account No. field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }

            }
        }
    }
}
