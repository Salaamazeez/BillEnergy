namespace BILLENERGY.BILLENERGY;

page 50162 ReimbursableSalary
{
    ApplicationArea = All;
    Caption = 'Reimbursable Salary';
    PageType = List;
    SourceTable = ReimbursableSalary;
    UsageCategory = Tasks;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Element Code"; Rec."Element Code")
                {
                    ToolTip = 'Specifies the value of the Element Code field.', Comment = '%';
                }
                field("Element Name"; Rec."Element Name")
                {
                    ToolTip = 'Specifies the value of the Element Name field.', Comment = '%';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.', Comment = '%';
                }
                field("Employment Contract Code"; Rec."Employment Contract Code")
                {
                    ToolTip = 'Specifies the value of the Employment Contract Code field.', Comment = '%';
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ToolTip = 'Specifies the value of the Employment Date field.', Comment = '%';
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.', Comment = '%';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.', Comment = '%';
                }
                field("No. of Days In the Month"; Rec."No. of Days In the Month")
                {
                    ToolTip = 'Specifies the value of the No. of Days In the Month field.', Comment = '%';
                }
                field("No. of Days Worked"; Rec."No. of Days Worked")
                {
                    ToolTip = 'Specifies the value of the No. of Days Worked field.', Comment = '%';
                }
                field("Book Value"; Rec."Book Value")
                {
                    ToolTip = 'Specifies the value of the Book Value field.', Comment = '%';
                }
                field("Net Pay"; Rec."Net Pay")
                {
                    ToolTip = 'Specifies the value of the Net Pay field.', Comment = '%';
                }
                field("Payroll Bank"; Rec."Payroll Bank")
                {
                    ToolTip = 'Specifies the value of the Payroll Bank field.', Comment = '%';
                }
                field("Payroll Bank Account No."; Rec."Payroll Bank Account No.")
                {
                    ToolTip = 'Specifies the value of the Payroll Bank Account No. field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
            }
        }
    }
}
