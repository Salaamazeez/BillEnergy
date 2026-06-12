namespace BILLENERGY.BILLENERGY;

using Microsoft.HumanResources.Employee;

page 50161 EmployeeReimbursableSalary
{
    ApplicationArea = All;
    Caption = 'Reimbursable Salary Setup';
    PageType = List;
    SourceTable = Employee;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies an identification number for the entry or record.';
                    Editable = false;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ToolTip = 'Specifies the value of the Last Date Modified field.', Comment = '%';
                    Editable = false;
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies the value of the First Name field.', Comment = '%';
                    Editable = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                    Editable = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.', Comment = '%';
                    Editable = false;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.', Comment = '%';
                    Editable = false;
                }
                field("Reimbursable Amount"; Rec."Reimbursable Amount")
                {
                    ToolTip = 'Specifies the value of the Reimbursable Amount field.', Comment = '%';
                }
            }
        }
    }
}
