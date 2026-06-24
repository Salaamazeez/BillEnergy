namespace BILLENERGY.BILLENERGY;
using Microsoft.Foundation.Company;
using Microsoft.HumanResources.Employee;

report 50123 ReimbursableSummary
{
    ApplicationArea = All;
    Caption = 'Reimbursable Summary';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'ReimbursableSummary.rdl';


    dataset
    {

        dataitem(ReimbursableSalaryLines; ReimbursableSalaryLines)

        {
            DataItemTableView = SORTING("Payroll Period", "Employee No.");

            RequestFilterFields = "Payroll Period", "Employee No.", "Global Dimension 1 Code", "Global Dimension 2 Code";

            column(EmployeeNo; "Employee No.")
            { }
            column(EmployeeName; "Employee Name")
            { }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            { }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            { }
            column(PayrollPeriod; "Payroll Period")
            { }
            column(JobTitle; "Job Title")
            { }
            column(LabelPaySummary; LabelPaySummary)
            { }

            column(BookValue; "Book Value")
            { }

            column(NetPay; "Net Pay")
            { }

            column(PayrollBank; "Payroll Bank")
            { }
            column(BankAccountNo; "Payroll Bank Account No.")
            { }

            column(NoofDaysWorked; "No. of Days Worked")
            { }

            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin

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
    VAR

        Name: Text[200];
        LabelPaySummary: Label 'REIMBURSABLE  SUMMARY';
        CompInfo: Record "Company Information";

        Employee: Record Employee;


    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin

    END;
}
