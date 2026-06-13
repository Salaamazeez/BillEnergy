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
                    ApplicationArea = All;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ToolTip = 'Specifies the value of the Last Date Modified field.', Comment = '%';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies the value of the First Name field.', Comment = '%';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.', Comment = '%';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.', Comment = '%';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Reimbursable Amount"; Rec."Reimbursable Amount")
                {
                    ToolTip = 'Specifies the value of the Reimbursable Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        // 1. Define the action container area
        area(Processing)
        {
            // 2. Define your action button


            action(UploadReimbursable)
            {
                ApplicationArea = All;
                Caption = 'Upload Reimbursable';
                ToolTip = 'upload  the Reimbursable Amount for Employee';
                Image = ImplementPriceChange;

                // 3. Make the action easy to find in the action bar
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                // 4. Run your custom logic when clicked
                trigger OnAction()
                begin
                    Report.Run(Report::ImportReimbursablePay);
                end;
            }


        }

    }
}
