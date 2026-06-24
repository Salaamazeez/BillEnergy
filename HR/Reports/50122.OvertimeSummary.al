namespace BILLENERGY.BILLENERGY;
using Microsoft.Foundation.Company;
using Microsoft.HumanResources.Employee;

report 50122 OvertimeSummary
{
    ApplicationArea = All;
    Caption = 'Overtime Summary';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'OvertimeSummary.rdl';

    dataset
    {

        dataitem(OvertimeLine; OvertimeLine)

        {
            DataItemTableView = SORTING("Period Code", "Employee No.");

            RequestFilterFields = "Period Code", "Employee No.", "Global Dimension 1 Code", "Global Dimension 2 Code";

            column(EmployeeNo; "Employee No.")
            { }
            column(EmployeeName; "Employee Name")
            { }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            { }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            { }
            column(PayrollPeriod; "Period Code")
            { }
            column(JobTitle; "Job Title")
            { }
            column(LabelPaySummary; LabelPaySummary)
            { }

            column(DaysWorked; "Days Worked")
            { }

            column(ExtraDaysWorked; "Extra Days Worked")
            { }
            column(GrossPay; "Gross Pay")
            { }

            column(PAYE; PAYE)
            { }
            column(Pension; Pension)
            { }
            column(NetPay; "Net Pay")
            { }
            column(OvertimeAmount; "Overtime Amount")
            { }

            column(PayrollBank; PayrollBank)
            { }

            column(BankAccountNo; BankAccountNo)
            { }

            trigger OnPreDataItem()
            begin
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(Employee);
                If Employee.get("Employee No.") then begin
                    BankAccountNo := Employee."Bank Account No.";
                    PayrollBank := Employee."Payroll Bank";
                end;
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
        LabelPaySummary: Label 'OVERTIME SUMMARY';
        CompInfo: Record "Company Information";

        Employee: Record Employee;

        PayrollBank: Code[50];
        BankAccountNo: Code[20];

    trigger OnInitReport()
    begin
    end;

    trigger OnPreReport()
    begin
    END;

}
