namespace BILLENERGY.BILLENERGY;
using Microsoft.Foundation.Company;
using Microsoft.HumanResources.Employee;

report 50120 Payslip
{
    //ApplicationArea = All;
    Caption = 'Payslip';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Payslip.rdl';


    dataset
    {

        dataitem(PayrollLine; PayrollLine)

        {
            DataItemTableView = SORTING("Payroll Period", "Employee Code");

            RequestFilterFields = "Employee Code";

            column(EmployeeCode; "Employee Code")
            { }
            column(EmployeeName; "Employee Name")
            { }
            column(BookAmount; "Book Amount")
            { }

            column(PayableAmount; "Payable Amount")
            { }

            column(GlobalDimension1Code; "Global Dimension 1 Code")
            { }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            { }
            column(EmploymentDate; "Employment Date")
            { }
            column(PayrollPeriod; "Payroll Period")
            { }
            column(JobTitle; "Job Title")
            { }
            column(LabelPaySlip; LabelPaySlip)
            { }
            column(Basic; EPayAmount[1])
            { }
            column(House; EPayAmount[2])
            { }
            column(Transport; EPayAmount[3])
            { }
            column(Utility; EPayAmount[4])
            { }
            column(Overtime; EPayAmount[5])
            { }
            column(OvertimePHWKD; EPayAmount[6])
            { }
            column(PAYE; DPayAmount[1])
            { }
            column(PensionEmp; DPayAmount[2])
            { }
            column(LateDed; DPayAmount[3])
            { }
            column(AbsentDed; DPayAmount[4])
            { }


            column(TotalDed; OPayAmount[1])
            { }
            column(GrossPay; OPayAmount[2])
            { }
            column(NetPay; OPayAmount[3])
            { }

            column(CompLogo; CompInfo.Picture)
            { }
            column(WorkingDays; "Working Days")
            { }
            column(NoOfWorkedDays; "No. of Worked Days")
            { }

            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin

                I := 1;
                CLEAR(Name);
                CLEAR(EPayAmount);
                CLEAR(DPayAmount);
                CLEAR(OPayAmount);

                IF Employee.GET(PayrollLine."Employee Code") THEN
                    Name := Employee."Last Name" + ' ' + Employee."First Name" + ' ' + Employee."Middle Name";

                PayrollPeriod := PayrollLine."Payroll Period";

                //For Earnings
                FOR J := 1 TO ElementCount DO BEGIN
                    PayrollDetLine.RESET;
                    PayrollDetLine.SETRANGE("Payroll Period", PayrollLine."Payroll Period");
                    PayrollDetLine.SETRANGE("Employee No.", PayrollLine."Employee Code");
                    PayrollDetLine.SETRANGE("Element Code", EElementCode[J]);
                    IF PayrollDetLine.FINDFIRST THEN
                        EPayAmount[J] := PayrollDetLine."Payable Amount";
                    //I:=I+1;
                END;

                //For Deductions
                FOR J := 1 TO ElementCount DO BEGIN
                    PayrollDetLine.RESET;
                    PayrollDetLine.SETRANGE("Payroll Period", PayrollLine."Payroll Period");
                    PayrollDetLine.SETRANGE("Employee No.", PayrollLine."Employee Code");
                    PayrollDetLine.SETRANGE("Element Code", DElementCode[J]);
                    IF PayrollDetLine.FINDFIRST THEN
                        DPayAmount[J] := PayrollDetLine."Payable Amount";
                    //I:=I+1;
                END;

                //For Others
                FOR J := 1 TO ElementCount DO BEGIN
                    PayrollDetLine.RESET;
                    PayrollDetLine.SETRANGE("Payroll Period", PayrollLine."Payroll Period");
                    PayrollDetLine.SETRANGE("Employee No.", PayrollLine."Employee Code");
                    PayrollDetLine.SETRANGE("Element Code", OElementCode[J]);
                    IF PayrollDetLine.FINDFIRST THEN
                        OPayAmount[J] := PayrollDetLine."Payable Amount";
                    //I:=I+1;
                END;



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
        I: Integer;
        PayrollPeriod: Code[20];
        PayrollDetLine: Record PayrollDetailLine;
        ReportFilter: Text[150];
        Name: Text[200];
        LabelPaySlip: Label 'PAYSLIP';
        CompInfo: Record "Company Information";
        //text003 : Label '"PAYSLIP FOR "';
        PayrollElement: Record PayrollElement;
        ElementCount: Integer;
        Employee: Record Employee;
        J: Integer;
        EElementCode: ARRAY[50] OF Code[20];
        DElementCode: ARRAY[50] OF Code[20];
        OElementCode: ARRAY[50] OF Code[20];
        EPayAmount: ARRAY[50] OF Decimal;
        DPayAmount: ARRAY[50] OF Decimal;
        OPayAmount: ARRAY[50] OF Decimal;


    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin

        //For Earnings
        ElementCount := 1;
        PayrollElement.RESET;
        PayrollElement.SETFILTER(Earning, '%1', TRUE);
        PayrollElement.SETFILTER("Appear In Payslip", '%1', TRUE);
        IF PayrollElement.FINDSET THEN
            REPEAT
                EElementCode[ElementCount] := PayrollElement."Element Code";
                ElementCount := ElementCount + 1;
            UNTIL PayrollElement.NEXT = 0;

        //For Deductions
        ElementCount := 1;
        PayrollElement.RESET;
        PayrollElement.SETFILTER(Deduction, '%1', TRUE);
        PayrollElement.SETFILTER("Appear In Payslip", '%1', TRUE);
        IF PayrollElement.FINDSET THEN
            REPEAT
                DElementCode[ElementCount] := PayrollElement."Element Code";
                ElementCount := ElementCount + 1;
            UNTIL PayrollElement.NEXT = 0;

        //For Others
        ElementCount := 1;
        PayrollElement.RESET;
        PayrollElement.SETFILTER(Earning, '%1', FALSE);
        PayrollElement.SETFILTER(Deduction, '%1', FALSE);
        PayrollElement.SETFILTER("Appear In Payslip", '%1', TRUE);
        IF PayrollElement.FINDSET THEN
            REPEAT
                OElementCode[ElementCount] := PayrollElement."Element Code";
                ElementCount := ElementCount + 1;
            UNTIL PayrollElement.NEXT = 0;


        CompInfo.GET;
        CompInfo.CALCFIELDS(Picture);

    END;




}
