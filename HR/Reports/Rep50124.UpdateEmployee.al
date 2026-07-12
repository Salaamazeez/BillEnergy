namespace BILLENERGY.BILLENERGY;

using Microsoft.HumanResources.Employee;

report 50124 UpdateEmployee
{
    ApplicationArea = All;
    Caption = 'Update Employee';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(No; "No.")
            {
            }
            column(EmploymentDate; "Employment Date")
            {
            }

            trigger OnAfterGetRecord()
            begin

                Employee."Employment Date" := 20260203D;
                Employee.Modify();
            end;

        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {

            }
        }
    }





    var
        EmpRec: Record Employee;
}
