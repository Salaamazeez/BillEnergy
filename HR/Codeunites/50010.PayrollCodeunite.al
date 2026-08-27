namespace BILLENERGY.BILLENERGY;
using Microsoft.HumanResources.Setup;
using Microsoft.Finance.Payroll;
using Microsoft.HumanResources.Employee;
using Microsoft.Finance.GeneralLedger.Journal;

codeunit 50010 PayrollCodeunite
{
    var
        DaysInMonth: Integer;
        Window: Dialog;
        DaysWorked: Integer;
        NoOfDaysInPayPeriod: Integer;
        Paye: Decimal;

        PoratePay: Boolean;
        LastDateOfMonth: Date;
        StartDate: Date;
        HRSetup: Record "Human Resources Setup";

        PayrollPeriodsCode: Code[20];
        PayrollHeader: Record PayrollHeader;
        PayrollLine: Record PayrollLine;
        PayrollDetailLine: Record PayrollDetailLine;
        PayRollPeriod: Record PayrollPeriods;
        PayrollOtherVar: Record PayrollOthervariables;
        PayrollElement: Record PayrollElement;
        Employee: Record Employee;
        PayrollHead: Record PayrollHeader;
        SalaSetupLine: Record SalarySetupLine;
        SalarySetupLine2: Record SalarySetupLine;
        //PayrollReimbLine : Record 50016;
        SalarySetupHeader: Record SalarySetupHeader;
        //PayrollReimbHead : Record 50015;

        ReimbursableSalaryLines: Record ReimbursableSalarylines;
        ReimbursableSalary: Record ReimbursableHeader;

        ElementAmount: Decimal;
        TotallGross: Decimal;
        SumTaxable: Decimal;
        SumPension: Decimal;
        SumGross: Decimal;
        SumTotalGross: Decimal;
        SumDeduction: Decimal;
        CompPension: Decimal;
        BasicAmt: Decimal;
        HouseAmt: Decimal;
        TransAmt: Decimal;
        UtilityAmr: Decimal;

        NHISAmt: Decimal;
        PensionAmt: Decimal;
        NHFAmt: Decimal;
        ITFAmt: Decimal;
        CurrentYear: Integer;
        TaxableIncome: Decimal;
        AnnualGross: Decimal;

        GenHead: Record 81;
        GenLine: Record 81;
        DocNo: Code[20];

        LineNo: Integer;
        SumAllDeductions: Decimal;
        SumAllEarnings: Decimal;
        InsertControlAccount: Boolean;

        PrevPeriod: Code[10];
        PrevMonth: Integer;
        PayYear: Integer;
        CompPension2: Decimal;
        OtherEarnAmt: Decimal;
        TotalTaxableIncome: Decimal;

        LifeInsurAmt: Decimal;

        PayrollPeriods: Code[10];
        JnlbatchName: Code[20];
        GenJnlTemp: Record 80;
        GenLedgSetup: Record 98;

        SalaryControlAmt: Decimal;
        RentRelief: Decimal;
        EVCRelief: Decimal;
        AllowRelief: Decimal;
        NHFRelief: Decimal;
        NHISRelief: Decimal;
        PensionRelief: Decimal;
        HMOAmt: Decimal;
        LifeRelief: Decimal;

        TEXT000: Label 'Lines\#2###############\Detail Lines\#1###############';
        TEXT001: Label 'Do you want to post %1.';
        TEXT002: Label 'Setup does not exist for element %1.';
        Text003: Label 'Processing Reimbursable Payroll for Employee No. #1######\';
        Text004: Label 'Reimbursable Payroll Processing completed successfuly.';
        Text005: Label 'There is no Open Payroll Tax setup';
        Text006: Label 'There was no active and approved employee, hence payroll was not processed';
        Text007: Label '%1 was not selected in Payroll Element setup';
        Text008: Label 'Processing Reimbursable Salary Journal for department. #1######\';
        Text009: Label 'Reimbursable Salary journal';
        Text011: Label 'Previous Reimbursable Payroll %1 must be close before you can run the current payroll';
        Text012: Label 'Previous Payroll %1 must be close before you can run the current payroll';
        Text01: Label 'Salary Control Account';

    trigger OnRun()
    begin

    end;

    PROCEDURE ProcessPayroll(PayPeriods: Code[10]; GlobalDim1Code: Code[20]; GlobalDim2Code: Code[20]; EmployeeNo: Code[20]);
    BEGIN

        //Check Previous Period for Closure before running current payroll period
        EVALUATE(PrevMonth, FORMAT(COPYSTR(PayPeriods, 6, 2)));

        EVALUATE(PayYear, FORMAT(COPYSTR(PayPeriods, 1, 4)));

        CurrentYear := PayYear;

        //For Month greater the January
        IF (PrevMonth > 1) THEN
            PrevMonth := PrevMonth - 1;

        //If Month is January then Previous Month will be Decemebr and year will less 1
        IF (PrevMonth = 1) THEN BEGIN
            PrevMonth := 12;
            PayYear := PayYear - 1;
        END;


        IF (PrevMonth < 10) THEN
            PrevPeriod := FORMAT(PayYear) + '-0' + FORMAT(PrevMonth)
        ELSE
            PrevPeriod := FORMAT(PayYear) + '-' + FORMAT(PrevMonth);

        /*    
        IF PrevPeriod <> '' THEN BEGIN
            PayrollHead.RESET;
            PayrollHead.SETRANGE("Payroll Period", PrevPeriod);
            PayrollHead.SETFILTER("Approval Status", '<>%1', PayrollHead."Approval Status"::Closed);
            IF PayrollHead.FINDFIRST THEN
                ERROR(Text012, PrevPeriod);
        END;
        */

        //Filter for only Active Employee
        Employee.RESET;
        Employee.SETFILTER(Status, '<>%1', Employee.Status::Terminated);
        Employee.SetFilter(Blocked, '%1', false);
        Employee.SETFILTER("Employment Date", '<>%1', 0D);

        IF (EmployeeNo <> '') THEN
            Employee.SETRANGE("No.", EmployeeNo);
        IF (GlobalDim1Code <> '') THEN
            Employee.SETRANGE("Global Dimension 1 Code", GlobalDim1Code);
        IF (GlobalDim2Code <> '') THEN
            Employee.SETRANGE("Global Dimension 2 Code", GlobalDim2Code);

        Window.OPEN('Processing Payroll for Employee No.  #1########\' +
                      'for Payroll Period  #2########\');

        IF Employee.FINDSET THEN BEGIN
            //Employee.TESTFIELD("Employee Category");
            REPEAT
                Window.UPDATE(1, Employee."No.");
                Window.UPDATE(2, PayPeriods);
                CompPension := 0;
                BasicAmt := 0;
                NHISAmt := 0;
                LifeInsurAmt := 0;
                NHFAmt := 0;
                SumDeduction := 0;
                SumGross := 0;
                SumPension := 0;
                SumTaxable := 0;
                SumTotalGross := 0;
                TaxableIncome := 0;
                AnnualGross := 0;
                TotalTaxableIncome := 0;
                EVCRelief := 0;
                LifeRelief := 0;
                NHISRelief := 0;
                ITFAmt := 0;
                DaysWorked := 0;
                PoratePay := False;

                //Employee.TESTFIELD("Employee Category");
                Employee.TESTFIELD("Employment Date");

                if (Employee."Is Rig Employee") then
                    NoOfDaysInPayPeriod := GetNoOfWorkDaysForRigStaff(PayPeriods)
                else
                    NoOfDaysInPayPeriod := GetNoOfDaysInPayPeriod(PayPeriods);

                DaysWorked := GetTotalDaysWorked(PayPeriods, Employee);

                //Create the Payroll Line for an Employee
                CreatePayrollLine(PayPeriods, Employee);

                //For Earnings
                PayrollElement.RESET;
                PayrollElement.SETFILTER(Earning, '%1', TRUE);
                IF PayrollElement.FINDSET THEN BEGIN
                    REPEAT
                        SalaSetupLine.RESET;
                        SalaSetupLine.SETRANGE("Salary Code", Employee."Emplymt. Contract Code");
                        SalaSetupLine.SETRANGE("Element Code", PayrollElement."Element Code");
                        IF SalaSetupLine.FINDFIRST THEN BEGIN
                            ElementAmount := CalculateAmount(Employee, PayrollElement, SalaSetupLine, PayPeriods);
                            IF ElementAmount <> 0 THEN
                                InsertPayrollDetailLine(Employee, PayrollElement, SalaSetupLine, PayPeriods, ElementAmount);
                        END ELSE BEGIN
                            IF PayrollOtherVar.GET(Employee."No.", PayPeriods, PayrollElement."Element Code") THEN BEGIN
                                IF (PayrollOtherVar.Earning) THEN BEGIN
                                    ElementAmount := CalculateAmount(Employee, PayrollElement, SalaSetupLine, PayPeriods);
                                    IF ElementAmount <> 0 THEN
                                        InsertPayrollDetailLine(Employee, PayrollElement, SalaSetupLine, PayPeriods, ElementAmount);
                                END;
                            END;
                        END;
                    UNTIL PayrollElement.NEXT = 0;
                END ELSE
                    ERROR(Text007, 'Earning');

                //For Deduction
                PayrollElement.RESET;
                PayrollElement.SETFILTER(Deduction, '%1', TRUE);
                IF PayrollElement.FINDSET THEN BEGIN
                    REPEAT
                        SalaSetupLine.RESET;
                        SalaSetupLine.SETRANGE("Salary Code", Employee."Emplymt. Contract Code");
                        SalaSetupLine.SETRANGE("Element Code", PayrollElement."Element Code");
                        IF SalaSetupLine.FINDFIRST THEN BEGIN
                            ElementAmount := CalculateAmount(Employee, PayrollElement, SalaSetupLine, PayPeriods);
                            IF ElementAmount <> 0 THEN
                                InsertPayrollDetailLine(Employee, PayrollElement, SalaSetupLine, PayPeriods, ElementAmount);
                        END ELSE BEGIN
                            /*IF PayrollElement."Is Loan" THEN BEGIN
                                ElementAmount := CalculateAmount(Employee, PayrollElement, EmpBookLine, PayPeriods);
                                IF ElementAmount <> 0 THEN
                                    InsertPayrollDetailLine(Employee, PayrollElement, EmpBookLine, PayPeriods, ElementAmount);
                            END;
                            */

                            IF (PayrollOtherVar.GET(Employee."No.", PayPeriods, PayrollElement."Element Code")) THEN BEGIN
                                //IF (PayrollElement."Element Code"='100') THEN BEGIN
                                IF (PayrollOtherVar.Deduction) THEN BEGIN
                                    ElementAmount := CalculateAmount(Employee, PayrollElement, SalaSetupLine, PayPeriods);
                                    IF ElementAmount <> 0 THEN
                                        InsertPayrollDetailLine(Employee, PayrollElement, SalaSetupLine, PayPeriods, ElementAmount);
                                END;
                            END;
                        END;
                    UNTIL PayrollElement.NEXT = 0;
                END ELSE
                    ERROR(Text007, 'Deduction');

                //For none Earnings and Deduction
                PayrollElement.RESET;
                PayrollElement.SETFILTER(Earning, '%1', FALSE);
                PayrollElement.SETFILTER(Deduction, '%1', FALSE);
                //PayrollElement.SETFILTER("Is Reimbursable", '%1', FALSE);
                PayrollElement.SETFILTER("Is Total Gross", '%1', FALSE);
                IF PayrollElement.FINDSET THEN BEGIN
                    REPEAT
                        SalaSetupLine.RESET;
                        SalaSetupLine.SETRANGE("Salary Code", Employee."Emplymt. Contract Code");
                        SalaSetupLine.SETRANGE("Element Code", PayrollElement."Element Code");
                        IF SalaSetupLine.FINDFIRST THEN;
                        BEGIN
                            ElementAmount := CalculateAmount(Employee, PayrollElement, SalaSetupLine, PayPeriods);
                            IF ElementAmount <> 0 THEN
                                InsertPayrollDetailLine(Employee, PayrollElement, SalaSetupLine, PayPeriods, ElementAmount);
                        END;
                    UNTIL PayrollElement.NEXT = 0;
                END ELSE
                    ERROR(Text007);

            UNTIL Employee.NEXT = 0;
            Window.CLOSE;
        END ELSE
            ERROR(Text006);
    END;

    PROCEDURE CreatePayrollLine(PayrollPeriodCode: Code[20]; EmpLRec: Record Employee);
    BEGIN

        PayrollLine.RESET;
        PayrollLine.SETRANGE("Payroll Period", PayrollPeriodCode);
        PayrollLine.SETRANGE("Employee Code", EmpLRec."No.");
        IF PayrollLine.ISEMPTY THEN BEGIN
            PayrollLine.INIT;
            PayrollLine."Payroll Period" := PayrollPeriodCode;
            PayrollLine."Employment Date" := EmpLRec."Employment Date";
            PayrollLine.VALIDATE("Employee Code", EmpLRec."No.");
            PayrollLine."Employee Name" := EmpLRec."Last Name" + ' ' + EmpLRec."First Name" + ' ' + EmpLRec."Middle Name";
            //PayrollLine."Attendance Period" := PayrollPeriodCode;
            PayrollLine."Global Dimension 2 Code" := EmpLRec."Global Dimension 2 Code";
            PayrollLine."Global Dimension 1 Code" := EmpLRec."Global Dimension 1 Code";
            PayrollLine."Employment Contract Code" := EmpLRec."Emplymt. Contract Code";
            PayrollLine."Job Title" := EmpLRec."Job Title";
            PayrollLine."Salary Code" := EmpLRec."Emplymt. Contract Code";

            PayrollLine."No. of Worked Days" := DaysWorked;
            PayrollLine."Working Days" := HRSetup."Maximum Work Days";
            //PayrollLine."Working Days" := NoOfDaysInPayPeriod;
            //PayrollLine."Late/Absent Hour":=PayrollOtherVar."Hours/Days Late";
            //payrollline."Book Amount" := Round(AnnualGross / 12, 0.01, '>');
            //PayrollLine."Employee Type" := EmpLRec."Engagement Type";
            PayrollLine.INSERT();
        END;
    END;

    PROCEDURE CalculateAmount(EmployeeL: Record Employee; PayrollElementL: Record PayrollElement; SalarySetupLineL: Record SalarySetupLine; PayPeriodCode: Code[20]): Decimal;

    var
        TextBasic: Label 'Basic Pay Element code is not setup in the Payroll Element page';
        PayElement: Record PayrollElement;
        SalSetupLine: Record SalarySetupLine;

    BEGIN

        IF HRSetup.GET then
            HRSetup.TestField("Maximum Work Days");

        ElementAmount := 0;
        OtherEarnAmt := 0;
        DaysInMonth := 0;
        Clear(SalSetupLine);
        clear(PayElement);


        //IF (PayrollElementL."Function of Poration") THEN BEGIN //Need to add element to be porated

        IF ((PoratePay) AND (PayrollElementL."Function of Poration")) THEN
            ElementAmount := ROUND(((SalarySetupLineL.Amount / HRSetup."Maximum Work Days") * DaysWorked), 0.01, '>')
        ELSE
            ElementAmount := ROUND(SalarySetupLineL.Amount, 0.01, '>');
        //END;


        //ElementAmount := ROUND(SalarySetupLineL.Amount, 0.01, '>');

        IF (PayrollElementL."Is Basic") THEN
            BasicAmt := ElementAmount;

        //Get other Earnings from Other Payroll Variables Tables


        //Sum For TotalGross/Taxaxable
        IF PayrollElementL."Function of Paye" THEN BEGIN
            SumTaxable := SumTaxable + ElementAmount;
        END;


        //Sum For Gross
        IF (PayrollElementL.Earning) THEN BEGIN
            SumGross := SumGross + ElementAmount;
        END;


        //Sum For Pension Calculation (Basic, House, Transport)
        IF PayrollElementL."Function of Pension" THEN BEGIN
            SumPension := SumPension + ElementAmount;
        END;

        //Calculate for Pension Employee
        IF PayrollElementL."Is Pension Employee" THEN BEGIN
            HRSetup.TestField("Pension Employee %");
            ElementAmount := ROUND(((HRSetup."Pension Employee %" / 100) * SumPension), 0.01, '>');
            PensionAmt := ElementAmount;
            SumDeduction := SumDeduction + ElementAmount;
        END;


        //Calculate for Company Pension
        IF PayrollElementL."Is Pension Employer" THEN BEGIN
            HRSetup.TestField("Pension Employer %");
            ElementAmount := ROUND(((HRSetup."Pension Employer %" / 100) * SumPension), 0.01, '>');
            CompPension := ElementAmount;
        END;

        //Calculate tax/Paye
        IF (PayrollElementL."Is PAYE") THEN BEGIN
            ElementAmount := CalculateTax(SumTaxable, EmployeeL, PayPeriodCode);
            SumDeduction := SumDeduction + ElementAmount;
        END;

        //Get Other None Taxable & other taxable Earning from Payroll Other variable Table
        IF PayrollOtherVar.GET(EmployeeL."No.", PayPeriodCode, PayrollElementL."Element Code") THEN BEGIN
            IF PayrollOtherVar.Earning THEN BEGIN
                IF PayrollElementL."Function of Paye" THEN
                    SumTaxable += ROUND((PayrollOtherVar.Amount), 0.01, '>');
                SumGross += ROUND((PayrollOtherVar.Amount), 0.01, '>')
            END;
        END;

        IF PayrollOtherVar.GET(EmployeeL."No.", PayPeriodCode, PayrollElementL."Element Code") THEN BEGIN

            IF HRSetup.Get() then begin
                HRSetup.TestField("Overtime Rate");
                HRSetup.TestField("PH-WK Overtime Rate");
                HRSetup.TestField("Working Hours");
            end;

            //Get Basic Element Code
            PayElement.Reset();
            PayElement.SetFilter("Is basic", '%1', True);
            If (Not PayElement.FindFirst()) then
                Error(Textbasic);

            //Check Employment contract code in Employee needed to get Basic pay In Salary Setup
            EmployeeL.TestField("Emplymt. Contract Code");

            //Get Basic Pay from Salary Setup line
            SalSetupLine.Reset();
            SalSetupLine.SetRange("Salary Code", EmployeeL."Emplymt. Contract Code");
            SalSetupLine.SetRange("Element Code", PayElement."Element Code");
            If SalSetupLine.FindFirst() then
                SalSetupLine.TestField(Amount);

            //Get Days In Month base on Rig Staff and Office Staff
            /*
            IF (EmployeeL."Is Rig Employee") then
                DaysInMonth := GetNoOfWorkDaysForRigStaff(PayPeriodCode)
            else
                DaysInMonth := GetNoOfDaysInPayPeriod(PayPeriodCode);
             */

            if (PayrollElementL."Is Overtime") then begin
                //ElementAmount := ROUND((((SalSetupLine.Amount / DaysInMonth) / HRSetup."Working Hours") *
                //((HRSetup."Overtime Rate" / 100) * PayrollOtherVar."Hours/Days Late")), 0.01, '>');
                ElementAmount := ROUND((((SalSetupLine.Amount / HRSetup."Maximum Work Days") / HRSetup."Working Hours") *
                                                                ((HRSetup."Overtime Rate" / 100) * PayrollOtherVar."Hours/Days Late")), 0.01, '>');
                SumGross := SumGross + ElementAmount;
            end;

            if (PayrollElementL."Is Overtime WKE-PH") then begin
                //ElementAmount := ROUND((((SalSetupLine.Amount / DaysInMonth) / HRSetup."Working Hours") *
                //((HRSetup."PH-WK Overtime Rate" / 100) * PayrollOtherVar."Hours/Days Late")), 0.01, '>');
                ElementAmount := ROUND((((SalSetupLine.Amount / HRSetup."Maximum Work Days") / HRSetup."Working Hours") *
                                                                ((HRSetup."PH-WK Overtime Rate" / 100) * PayrollOtherVar."Hours/Days Late")), 0.01, '>');
                SumGross := SumGross + ElementAmount;

            END;
        end;

        //Get other Deduction from Payroll Other Variable Table and Loan
        IF PayrollOtherVar.GET(EmployeeL."No.", PayPeriodCode, PayrollElementL."Element Code") THEN BEGIN
            //IF PayrollOtherVar.Deducted THEN BEGIN
            IF PayrollElementL."Is Absence" THEN begin
                //ElementAmount := ((PayrollOtherVar."Gross Pay" - (PensionAmt + Paye)) / (PayrollOtherVar."Maximum Working Hour" * NoOfDaysInPayPeriod) * PayrollOtherVar."Hours/Days Late");
                ElementAmount := ((PayrollOtherVar."Gross Pay") / (PayrollOtherVar."Maximum Working Hour" * HRSetup."Maximum Work Days") * PayrollOtherVar."Hours/Days Late");
            end;

            if PayrollElementL."Is Late" then begin
                //ElementAmount := ((PayrollOtherVar."Gross Pay" - (PensionAmt + Paye)) / (PayrollOtherVar."Maximum Working Hour" * NoOfDaysInPayPeriod) * PayrollOtherVar."Hours/Days Late");
                ElementAmount := ((PayrollOtherVar."Gross Pay") / (PayrollOtherVar."Maximum Working Hour" * HRSetup."Maximum Work Days") * PayrollOtherVar."Hours/Days Late");
            end;
            //ElementAmount:=ROUND(((SumGross/30)*(PayrollOtherVar.Quantity)),0.01,'>')
            //ELSE
            //IF PayrollElementL.Deduction THEN
            //  ElementAmount := ROUND((PayrollOtherVar.Amount), 0.01, '>');
            //END;
            //IF (PayrollOtherVar.Type=PayrollOtherVar.Type::Deduction) THEN
            SumDeduction += ElementAmount;
        END;

        //Get Loans

        /*
        IF PayrollElementL."Is NHF" THEN BEGIN
              PayrollElementL.TESTFIELD("Calculated Percentage");
              ElementAmount := ROUND(((PayrollElementL."Calculated Percentage") / 100) * BasicAmt, 0.01, '>');
              NHFAmt := ElementAmount;
              SumDeduction := SumDeduction + ElementAmount;
          END;
        */

        /*
        IF PayrollElementL."Is Life-Insurance" THEN BEGIN
          PayrollElementL.TESTFIELD("Calculated Percentage");
          ElementAmount:=ROUND(((PayrollElementL."Calculated Percentage")/100)*BasicAmt,0.01,'>');
          LifeInsurAmt:=ElementAmount;
          SumDeduction:=SumDeduction+ElementAmount;
        END;
        */

        IF PayrollElementL."Is Gross" THEN BEGIN
            ElementAmount := ROUND((SumGross), 0.01, '>');
        END;

        /*
           IF PayrollElementL."Is Total Gross" THEN BEGIN
             ElementAmount:=ROUND((SumTaxable),0.01,'>');
           END;
        */

        IF PayrollElementL."Is Total Deduction" THEN BEGIN
            ElementAmount := ROUND(SumDeduction, 0.01, '>');
        END;

        IF PayrollElementL."Is Net" THEN BEGIN
            ElementAmount := ROUND((SumTaxable - SumDeduction), 0.01, '>');
        END;

        IF ElementAmount <> 0 THEN
            EXIT(ElementAmount)
        ELSE
            EXIT(0);
    END;


    PROCEDURE GetNoOfDaysInPayPeriod(PayPeriodCode: Code[20]): Integer;
    var
        JC: Record JourneyCalendar;
        ErrorJC: Label 'Periods Calendar needs to be created for the Period %1';

    BEGIN

        NoOfDaysInPayPeriod := 0;
        CLEAR(LastDateOfMonth);
        CLEAR(StartDate);

        if (PayYear = 0) then
            EVALUATE(PayYear, FORMAT(COPYSTR(PayPeriodCode, 1, 4)));

        /*
        PayRollPeriod.RESET;
        IF PayRollPeriod.GET(PayPeriodCode) THEN BEGIN
            LastDateOfMonth := PayRollPeriod."End Date";
            StartDate := PayRollPeriod."Start Date";
            WHILE StartDate <= PayRollPeriod."End Date" DO BEGIN
                NoOfDaysInPayPeriod += 1;
                StartDate := CALCDATE('+1D', StartDate);
            END;
            EXIT(NoOfDaysInPayPeriod);
        END;
        */

        PayRollPeriod.RESET;
        IF PayRollPeriod.GET(PayPeriodCode) THEN BEGIN
            LastDateOfMonth := PayRollPeriod."End Date";
            StartDate := PayRollPeriod."Start Date";
            JC.SetRange(Year, Format(PayYear));
            JC.SetRange("Start Date", StartDate, LastDateOfMonth);
            JC.SetFilter(Sunday, '%1', false);
            JC.SetFilter(Saturday, '%1', false);
            if JC.FindSet() then
                NoOfDaysInPayPeriod := JC.Count
            else
                ERROR(ErrorJC, PayPeriodCode);
        end;
        EXIT(NoOfDaysInPayPeriod);
    END;

    PROCEDURE GetTotalDaysWorked(PayPeriodCode: Code[20]; EmployeeRec: Record Employee): Integer;
    var
        JC: Record JourneyCalendar;
        ErrorJC: Label 'Periods Calendar needs to be created for the Period %1';
    //PoratePay: Boolean;

    BEGIN
        DaysWorked := 0;
        PoratePay := FALSE;

        if (PayYear = 0) then
            EVALUATE(PayYear, FORMAT(COPYSTR(PayPeriodCode, 1, 4)));

        IF PayRollPeriod.GET(PayPeriodCode) THEN BEGIN

            /*
            IF (((PayRollPeriod."End Date" - EmployeeRec."Employment Date") + 1) < GetNoOfDaysInPayPeriod(PayPeriodCode)) THEN BEGIN
                DaysWorked := ((PayRollPeriod."End Date" - EmployeeRec."Employment Date") + 1);
                PoratePay := TRUE;
            END ELSE
                DaysWorked := GetNoOfDaysInPayPeriod(PayPeriodCode);
            EXIT(DaysWorked);
            */
            if (EmployeeRec."Employment Date" > PayRollPeriod."Start Date") then begin
                LastDateOfMonth := PayRollPeriod."End Date";
                StartDate := PayRollPeriod."Start Date";
                JC.SetRange(Year, Format(PayYear));
                JC.SetRange("Start Date", EmployeeRec."Employment Date", LastDateOfMonth);
                //JC.SetFilter(Sunday, '%1', false);
                //JC.SetFilter(Saturday, '%1', false);

                if JC.FindSet() then begin
                    DaysWorked := JC.Count;
                    PoratePay := TRUE;
                end
                else
                    ERROR(ErrorJC, PayPeriodCode);


            end else begin
                LastDateOfMonth := PayRollPeriod."End Date";
                StartDate := PayRollPeriod."Start Date";

                JC.SetRange(Year, Format(PayYear));
                JC.SetRange("Start Date", StartDate, LastDateOfMonth);
                //JC.SetFilter(Sunday, '%1', false);
                //JC.SetFilter(Saturday, '%1', false);

                if JC.FindSet() then
                    DaysWorked := JC.Count
                else
                    ERROR(ErrorJC, PayPeriodCode);
            end;
            exit(DaysWorked);
        END;
    END;


    PROCEDURE GetNoOfWorkDaysForRigStaff(PayPeriodCode: Code[20]): Integer;
    var
        JC: Record JourneyCalendar;
        ErrorJC: Label 'Periods Calendar needs to be created for the Period %1';

    BEGIN

        NoOfDaysInPayPeriod := 0;
        CLEAR(LastDateOfMonth);
        CLEAR(StartDate);

        if (PayYear = 0) then
            EVALUATE(PayYear, FORMAT(COPYSTR(PayPeriodCode, 1, 4)));

        PayRollPeriod.RESET;
        IF PayRollPeriod.GET(PayPeriodCode) THEN BEGIN
            LastDateOfMonth := PayRollPeriod."End Date";
            StartDate := PayRollPeriod."Start Date";
            WHILE StartDate <= PayRollPeriod."End Date" DO BEGIN
                NoOfDaysInPayPeriod += 1;
                StartDate := CALCDATE('+1D', StartDate);
            END;
            EXIT(NoOfDaysInPayPeriod);
        END;

        /*PayRollPeriod.RESET;
        IF PayRollPeriod.GET(PayPeriodCode) THEN BEGIN
            LastDateOfMonth := PayRollPeriod."End Date";
            StartDate := PayRollPeriod."Start Date";
            JC.SetRange(Year, Format(PayYear));
            JC.SetRange("Start Date", StartDate, LastDateOfMonth);
            JC.SetFilter(Sunday, '%1', false);
            JC.SetFilter(Saturday, '%1', false);
            if JC.FindSet() then
                NoOfDaysInPayPeriod := JC.Count
            else
                ERROR(ErrorJC, PayPeriodCode);
        end;
        EXIT(NoOfDaysInPayPeriod);
        */
    END;


    PROCEDURE InsertPayrollDetailLine(EmployeeL: Record Employee; PayrollElementL: Record PayrollElement; SalarySetupLineL: Record SalarySetupLine; PayPeriodCode: Code[20]; ElementAmt: Decimal);
    BEGIN

        PayrollDetailLine.INIT;
        PayrollDetailLine."Payroll Period" := PayPeriodCode;
        //PayrollDetailLine."Attendance Period":=PayPeriodCode;
        PayrollDetailLine."Element Code" := PayrollElementL."Element Code";
        PayrollDetailLine."Element Name" := PayrollElementL."Element Name";
        PayrollDetailLine."Employee No." := EmployeeL."No.";
        PayrollDetailLine."Employee Name" := EmployeeL."Last Name" + ' ' + EmployeeL."First Name" + ' ' + EmployeeL."Middle Name";
        PayrollDetailLine."Global Dimension 1 Code" := EmployeeL."Global Dimension 1 Code";
        PayrollDetailLine."Global Dimension 2 Code" := EmployeeL."Global Dimension 2 Code";
        PayrollDetailLine." Employment Contract Code" := Employee."Emplymt. Contract Code";
        PayrollDetailLine."Salary Code" := Employee."Emplymt. Contract Code";
        PayrollDetailLine."Payroll Creation Date" := TODAY;
        PayrollDetailLine."Employment Date" := EmployeeL."Employment Date";
        //PayrollDetailLine.:=EmployeeL."Employee Category";
        PayrollDetailLine."Pension Fund Manager" := EmployeeL.PFA;
        PayrollDetailLine."Pension Fund No." := EmployeeL."RSA PIN";
        PayrollDetailLine."Payroll Bank" := EmployeeL."Payroll Bank";
        PayrollDetailLine."Bank Account No." := EmployeeL."Bank Account No.";

        If PayrollElementL."Element Code" IN ['60', '65', '330', '340'] then
            PayrollDetailLine."No of Late/Absent (Hr)" := PayrollOtherVar."Hours/Days Late";
        //PayrollDetailLine."Absent (Days)" := PayrollOtherVar."Hours/Days Late";
        //PayrollDetailLine."Late Days" := PayrollOtherVar."Hours/Days Late";

        PayrollDetailLine."Payable Amount" := ElementAmt;
        //PayrollDetailLine."No of Days In the Month" := NoOfDaysInPayPeriod;
        PayrollDetailLine."No of Days In the Month" := HRSetup."Maximum Work Days";
        PayrollDetailLine."No of Worked Days" := DaysWorked;

        IF PayrollElementL.Earning THEN BEGIN
            PayrollDetailLine."Payable Amount" := ElementAmt;
            //PayrollDetailLine."Part of Payable Value":=TRUE;
        END;

        IF PayrollElementL.Deduction THEN BEGIN
            IF (NOT PayrollElementL."Is Pension Employer") THEN BEGIN
                PayrollDetailLine."Payable Amount" := -ElementAmt;
                //PayrollDetailLine."Part of Payable Value":=True;
            END ELSE BEGIN
                IF PayrollElementL."Is Pension Employer" THEN BEGIN
                    PayrollDetailLine."Payable Amount" := ElementAmt;
                    //PayrollDetailLine."Part of Payable Value":=FALSE;
                END ELSE BEGIN
                    PayrollDetailLine."Payable Amount" := ElementAmt;
                    //PayrollDetailLine."Part of Payable Value":=FALSE;
                END;
            END;
        END;

        IF PayrollElement."Part of Net Payable" THEN
            PayrollDetailLine."Part of Payable Value" := TRUE;

        IF (NOT PayrollElementL.Earning) AND (NOT PayrollElementL.Deduction) THEN BEGIN
            PayrollDetailLine."Payable Amount" := ElementAmt;
            //PayrollDetailLine."Part of Book Value:=TRUE;
        END;
        if PayrollElementL."Appear in Payslip" then
            PayrollDetailLine.INSERT();
    END;

    PROCEDURE CalculateTax(MonthlyGross: Decimal; EmployeeLRec: Record Employee; PayPeriod: Code[10]): Decimal;
    VAR
        PayrollTax: Record PayrollTaxHeader;
        PayrollTaxline: Record PayrollTaxLine;
        Payelement: Record PayrollElement;
        CRA: Decimal;
        Tax: Decimal;
        CumTax: Decimal;
        TotalReleif: Decimal;
        AnnualGross: Decimal;
    BEGIN

        Tax := 0;
        CumTax := 0;
        CRA := 0;

        LifeRelief := 0;
        EVCRelief := 0;
        AllowRelief := 0;
        NHFRelief := 0;
        NHISRelief := 0;
        PensionRelief := 0;
        CompPension2 := 0;
        RentRelief := 0;
        Paye := 0;

        AnnualGross := (MonthlyGross * 12);

        //Calculate Total Taxable Income

        TotalTaxableIncome := (AnnualGross);

        //Get the Payroll Tax Setup
        PayrollTax.RESET;
        //PayrollTax.SETRANGE("Payroll Tax Year",CurrentYear);
        PayrollTax.SETFILTER(Open, '%1', true);
        IF (NOT PayrollTax.FINDFIRST) THEN
            ERROR(Text005)
        ELSE BEGIN
            PayrollTax.TESTFIELD("Rent Relief Cap");
            PayrollTax.TESTFIELD("Rent Relief%");
            //PayrollTax.TESTFIELD("Cosolidation Relief Amount");
            //PayrollTax.TESTFIELD("Relief Cut-Off Amount");
        END;

        //Calculate the Releifs - Allowance, Pension, NHIS, NHF , LIFE , EVC, HMODed

        /*
        Payelement.RESET;
        Payelement.SETFILTER("Is Company Pension", '%1', TRUE);
        IF Payelement.FINDFIRST THEN
            Payelement.TESTFIELD("Calculated Percentage");
        */

        //HMO Deduction
        /*
        PayrollOtherDed.RESET;
          PayrollOtherDed.SETRANGE("Employee Code", EmployeeLRec."No.");
          PayrollOtherDed.SETRANGE("Payroll Period", PayPeriod);
          PayrollOtherDed.SETFILTER("Element Code", '%1', '199');
          IF (PayrollOtherDed.FINDFIRST) THEN
              HMOAmt := (PayrollOtherDed.Amount) * 12
          ELSE
              HMOAmt := 0;
        */

        //PENSION
        Payelement.RESET;
        Payelement.SETFILTER("Is Pension Employee", '%1', TRUE);
        IF Payelement.FINDFIRST THEN BEGIN
            if HRSetup.Get then
                HRSetup.TestField("Pension Employee %");
            PensionRelief := ((SumPension * (HRSetup."Pension Employee %" / 100)) * 12);
        END ELSE
            PensionRelief := 0;

        //Rent Relief to be capp at 500k for now
        //CRA := (PayrollTax."Rent Relief%" / 100) * EmployeeLRec."Rent Amount";

        //if (CRA > PayrollTax."Rent Relief Cap") then
        RentRelief := PayrollTax."Rent Relief Cap";
        //else
        //RentRelief := CRA;

        //NHF
        /*
        IF (EmployeeLRec."NHF Scheme") THEN BEGIN
              Payelement.RESET;
              Payelement.SETFILTER("Is NHF", '%1', TRUE);
              IF Payelement.FINDFIRST THEN BEGIN
                  Payelement.TESTFIELD("Calculated Percentage");
                  NHFRelief := ((BasicAmt * (Payelement."Calculated Percentage" / 100)) * 12);
              END ELSE
                  NHFRelief := 0;
          END ELSE
              NHFRelief := 0;
        */

        //NHIS
        /*
        IF (EmployeeLRec.Category=EmployeeLRec.Category::"Local") THEN
         NHISRelief:=(NHISAmt*12)
        ELSE
         NHISRelief:=0;
        */

        /*
        //LIFE
        IF (EmployeeLRec.Category=EmployeeLRec.Category::"Local") THEN
         LifeRelief:=(EmployeeLRec."Life-Assurance"*12)
        ELSE
         LifeRelief:=0;
        */

        //EVC
        /*
        IF (EmployeeLRec.Category=EmployeeLRec.Category::"Local") THEN
         EVCRelief:=(EmployeeLRec.EVC*12)
        ELSE
         EVCRelief:=0;
        */

        //Taxable Income

        //FINAct 2022
        AllowRelief := EVCRelief + LifeRelief + NHFRelief + RentRelief + PensionRelief + NHISRelief + HMOAmt;

        //Calculate The Net Taxable Income
        //FINAct 2022
        TaxableIncome := AnnualGross - AllowRelief;


        //Claculate the Tax from the Payroll Tax Line
        PayrollTaxline.SETRANGE("Tax Code", PayrollTax."Tax Code");
        //PayrollTaxline.SETRANGE("Payroll Tax Year",PayrollTax."Payroll Tax Year");
        IF PayrollTaxline.FINDSET THEN BEGIN
            REPEAT
                CASE PayrollTaxline."Line No." OF
                    10000:
                        BEGIN
                            PayrollTaxline.TESTFIELD("Tax Slab%", 0);
                            //PayrollTaxline.TESTFIELD("Tax Slab2 %");
                            PayrollTaxline.TESTFIELD("Upper Limit");
                            PayrollTaxline.TESTFIELD("Lower Limit", 0);

                            /*IF TaxableIncome <= 0 THEN BEGIN
                                CumTax := (PayrollTaxline."Tax Slab2%" / 100) * AnnualGross;
                                EXIT(ROUND(((CumTax / 12)), 0.01, '>'));
                            END;
                            */

                            /*IF (TaxableIncome > PayrollTaxline."Upper Limit") AND (TaxableIncome < PayrollTaxline."Lower Limit") THEN BEGIN
                                IF ((PayrollTaxline."Tax Slab %" / 100) * TaxableIncome) > ((PayrollTaxline."Tax Slab2 %" / 100) * AnnualGross) THEN
                                    CumTax := (PayrollTaxline."Tax Slab %" / 100) * TaxableIncome
                                ELSE
                                    CumTax := (PayrollTaxline."Tax Slab2 %" / 100) * AnnualGross;
                                EXIT(ROUND(((CumTax / 12)), 0.01, '>'));
                            END;
                            */

                            IF (TaxableIncome >= PayrollTaxline."Lower Limit") AND (TaxableIncome <= PayrollTaxline."Upper limit") THEN BEGIN
                                Tax := (PayrollTaxline."Tax Slab%" / 100) * PayrollTaxline."Upper Limit";
                                CumTax += Tax;
                            END;
                        END;

                    20000:
                        BEGIN
                            PayrollTaxline.TESTFIELD("Tax Slab%");
                            PayrollTaxline.TESTFIELD("Upper Limit");
                            PayrollTaxline.TESTFIELD("Lower Limit");

                            IF (TaxableIncome - PayrollTaxline."Lower Limit") >= PayrollTaxline."Upper Limit" THEN BEGIN
                                Tax := 0;
                                Tax := (PayrollTaxline."Tax Slab%" / 100) * PayrollTaxline."Upper Limit";
                                CumTax += Tax;
                            END ELSE
                                IF (TaxableIncome - PayrollTaxline."Lower Limit") <= 0 THEN BEGIN
                                    Tax := 0;
                                    CumTax += Tax;
                                END ELSE BEGIN
                                    Tax := 0;
                                    Tax := (PayrollTaxline."Tax Slab%" / 100) * (TaxableIncome - PayrollTaxline."Lower Limit");
                                    CumTax += Tax;
                                END;
                        END;

                    30000:
                        BEGIN
                            PayrollTaxline.TESTFIELD("Tax Slab%");
                            PayrollTaxline.TESTFIELD("Upper Limit");
                            PayrollTaxline.TESTFIELD("Lower Limit");

                            IF (TaxableIncome - PayrollTaxline."Lower Limit") >= PayrollTaxline."Upper Limit" THEN BEGIN
                                Tax := 0;
                                Tax := (PayrollTaxline."Tax Slab%" / 100) * PayrollTaxline."Upper Limit";
                                CumTax += Tax;
                            END ELSE
                                IF (TaxableIncome - PayrollTaxline."Lower Limit") <= 0 THEN BEGIN
                                    Tax := 0;
                                    CumTax += Tax;
                                END ELSE BEGIN
                                    Tax := 0;
                                    Tax := (PayrollTaxline."Tax Slab%" / 100) * (TaxableIncome - PayrollTaxline."Lower Limit");
                                    CumTax += Tax;
                                END;
                        END;

                    40000:
                        BEGIN
                            PayrollTaxline.TESTFIELD("Tax Slab%");
                            PayrollTaxline.TESTFIELD("Upper Limit");
                            PayrollTaxline.TESTFIELD("Lower Limit");

                            IF (TaxableIncome - PayrollTaxline."Lower Limit") >= PayrollTaxline."Upper Limit" THEN BEGIN
                                Tax := 0;
                                Tax := (PayrollTaxline."Tax Slab%" / 100) * PayrollTaxline."Upper Limit";
                                CumTax += Tax;
                            END ELSE
                                IF (TaxableIncome - PayrollTaxline."Lower Limit") <= 0 THEN BEGIN
                                    Tax := 0;
                                    CumTax += Tax;
                                END ELSE BEGIN
                                    Tax := 0;
                                    Tax := (PayrollTaxline."Tax Slab%" / 100) * (TaxableIncome - PayrollTaxline."Lower Limit");
                                    CumTax += Tax;
                                END;
                        END;

                    50000:
                        BEGIN
                            PayrollTaxline.TESTFIELD("Tax Slab%");
                            PayrollTaxline.TESTFIELD("Upper Limit");
                            PayrollTaxline.TESTFIELD("Lower Limit");

                            IF (TaxableIncome - PayrollTaxline."Lower Limit") >= PayrollTaxline."Upper Limit" THEN BEGIN
                                Tax := 0;
                                Tax := (PayrollTaxline."Tax Slab%" / 100) * PayrollTaxline."Upper Limit";
                                CumTax += Tax;
                            END ELSE
                                IF (TaxableIncome - PayrollTaxline."Lower Limit") <= 0 THEN BEGIN
                                    Tax := 0;
                                    CumTax += Tax;
                                END ELSE BEGIN
                                    Tax := 0;
                                    Tax := (PayrollTaxline."Tax Slab%" / 100) * (TaxableIncome - PayrollTaxline."Lower Limit");
                                    CumTax += Tax;
                                END;
                        END;

                    60000:
                        BEGIN
                            PayrollTaxline.TESTFIELD("Tax Slab%");
                            PayrollTaxline.TESTFIELD("Upper Limit");
                            PayrollTaxline.TESTFIELD("Lower Limit");

                            IF (TaxableIncome - PayrollTaxline."Lower Limit") >= PayrollTaxline."Upper Limit" THEN BEGIN
                                Tax := 0;
                                Tax := (PayrollTaxline."Tax Slab%" / 100) * (TaxableIncome - PayrollTaxline."Upper Limit");
                                CumTax += Tax;
                            END ELSE
                                IF (TaxableIncome - PayrollTaxline."Lower Limit") <= 0 THEN BEGIN
                                    Tax := 0;
                                    CumTax += Tax;
                                END ELSE BEGIN
                                    Tax := 0;
                                    Tax := (PayrollTaxline."Tax Slab%" / 100) * (TaxableIncome - PayrollTaxline."Lower Limit");
                                    CumTax += Tax;
                                END;
                        END;

                END;
            UNTIL PayrollTaxline.NEXT = 0;

            if cumTax <> 0 then Begin
                Paye := ROUND((CumTax / 12), 0.01, '>');
                EXIT(ROUND(((CumTax / 12)), 0.01, '>'))
            end else
                EXIT(0);

            /*
            IF ((CumTax <> 0) AND (NOT PoratePay)) THEN
                EXIT(ROUND(((CumTax / 12)), 0.01, '>'))
            ELSE IF (PoratePay) THEN BEGIN
                //EmpBookLine2.RESET;
                //EmpBookLine2.SETRANGE(Band,EmployeeLRec.Band);
                //EmpBookLine2.SETRANGE("Element Code",'175');
                //IF EmpBookLine2.FINDFIRST THEN
                //EXIT(ROUND(((EmpBookLine2.Amount/NoOfDaysInPayPeriod)*DaysWorked),0.01,'>'));
                EXIT(ROUND(((CumTax / NoOfDaysInPayPeriod) * DaysWorked), 0.01, '>'));
            END ELSE
                EXIT(0);
                *//
        END;
    END;


    PROCEDURE GeneratePeriod(PostingDate: Date): Code[7];

    VAR
        Dday: Integer;
        Mmonth: Integer;
        Yyear: Integer;
        Pperiod: Code[10];
    BEGIN
        Dday := DATE2DMY(PostingDate, 1);
        Mmonth := DATE2DMY(PostingDate, 2);
        Yyear := DATE2DMY(PostingDate, 3);
        IF (Mmonth = 1) THEN
            Pperiod := FORMAT(Yyear) + '-0' + FORMAT(Mmonth);
        IF (Mmonth = 2) THEN
            Pperiod := FORMAT(Yyear) + '-0' + FORMAT(Mmonth);
        IF (Mmonth = 3) THEN
            Pperiod := FORMAT(Yyear) + '-0' + FORMAT(Mmonth);
        IF (Mmonth = 4) THEN
            Pperiod := FORMAT(Yyear) + '-0' + FORMAT(Mmonth);
        IF (Mmonth = 5) THEN
            Pperiod := FORMAT(Yyear) + '-0' + FORMAT(Mmonth);
        IF (Mmonth = 6) THEN
            Pperiod := FORMAT(Yyear) + '-0' + FORMAT(Mmonth);
        IF (Mmonth = 7) THEN
            Pperiod := FORMAT(Yyear) + '-0' + FORMAT(Mmonth);
        IF (Mmonth = 8) THEN
            Pperiod := FORMAT(Yyear) + '-0' + FORMAT(Mmonth);
        IF (Mmonth = 9) THEN
            Pperiod := FORMAT(Yyear) + '-0' + FORMAT(Mmonth);
        IF (Mmonth = 10) THEN
            Pperiod := FORMAT(Yyear) + '-' + FORMAT(Mmonth);
        IF (Mmonth = 11) THEN
            Pperiod := FORMAT(Yyear) + '-' + FORMAT(Mmonth);
        IF (Mmonth = 12) THEN
            Pperiod := FORMAT(Yyear) + '-' + FORMAT(Mmonth);
        EXIT(Pperiod);
    END;

    PROCEDURE ProcessReimbPayroll(PayPeriods: Code[10]; GlobalDim1Code: Code[20]; GlobalDim2Code: Code[20]; EmployeeNo: Code[20]);
    BEGIN

        //Check Previous Period for Closure before running current payroll period
        EVALUATE(PrevMonth, FORMAT(COPYSTR(PayPeriods, 6, 2)));

        EVALUATE(PayYear, FORMAT(COPYSTR(PayPeriods, 1, 4)));

        CurrentYear := PayYear;

        //For Month greater the January
        IF (PrevMonth > 1) THEN
            PrevMonth := PrevMonth - 1;

        //If Month is January then Previous Month will be Decemebr and year will less 1
        IF (PrevMonth = 1) THEN BEGIN
            PrevMonth := 12;
            PayYear := PayYear - 1;
        END;


        IF (PrevMonth < 10) THEN
            PrevPeriod := FORMAT(PayYear) + '-0' + FORMAT(PrevMonth)
        ELSE
            PrevPeriod := FORMAT(PayYear) + '-' + FORMAT(PrevMonth);

        /*
        IF PrevPeriod <> '' THEN BEGIN
            ReimbursableSalary.RESET;
            ReimbursableSalary.SETRANGE(ReimbursableSalary."Period Code", PrevPeriod);
            ReimbursableSalary.SETFILTER("Approval Status", '<>%1', ReimbursableSalary."Approval Status"::Closed);
            IF ReimbursableSalary.FINDFIRST THEN
                ERROR(Text011, PrevPeriod);
        END;
        */

        //Filter for only Active Employee
        Employee.RESET;
        Employee.SETFILTER(Status, '<>%1', Employee.Status::Terminated);
        Employee.SetFilter(Blocked, '%1', false);
        Employee.SETFILTER("Employment Date", '<>%1', 0D);

        //Employee.SETFILTER("Reimbursable Amount", '<>%1', 0);

        IF (EmployeeNo <> '') THEN
            Employee.SETRANGE("No.", EmployeeNo);
        IF (GlobalDim1Code <> '') THEN
            Employee.SETRANGE("Global Dimension 1 Code", GlobalDim1Code);
        IF (GlobalDim2Code <> '') THEN
            Employee.SETRANGE("Global Dimension 2 Code", GlobalDim2Code);

        Window.OPEN('Processing Reimbursable Payroll for Employee No.  #1########\' +
                      'for Payroll Period  #2########\');

        IF Employee.FINDSET THEN BEGIN
            //Employee.TESTFIELD("Employee Category");
            REPEAT
                Window.UPDATE(1, Employee."No.");
                Window.UPDATE(2, PayPeriods);

                //Employee.TESTFIELD("Employee Category");
                Employee.TESTFIELD("Employment Date");

                /*
                if (Employee."Is Rig Employee") then
                    NoOfDaysInPayPeriod := GetNoOfWorkDaysForRigStaff(PayPeriods)
                else
                    NoOfDaysInPayPeriod := GetNoOfDaysInPayPeriod(PayPeriods);
                */

                DaysWorked := GetTotalDaysWorked(PayPeriods, Employee);
                //Create the Payroll Line for an Employee
                //CreatePayrollLine(PayPeriods,Employee);

                //For Earnings
                PayrollElement.RESET;
                PayrollElement.SETFILTER("Is Reimbursable", '%1', TRUE);
                IF PayrollElement.FINDFIRST THEN BEGIN
                    Employee.TESTFIELD("Reimbursable Amount");
                    ElementAmount := CalculateReimbAmount(Employee, PayrollElement, PayPeriods);
                    IF ElementAmount <> 0 THEN
                        InsertPayrollReimbLine(Employee, PayrollElement, PayPeriods, ElementAmount);
                END ELSE
                    ERROR(Text007, 'Is Reimbursable');
            UNTIL Employee.NEXT = 0;
            Window.CLOSE;
        END ELSE
            ERROR(Text006);
    END;

    PROCEDURE CalculateReimbAmount(EmployeeL: Record Employee; PayrollElementL: Record PayrollElement; PayPeriodCode: Code[20]): Decimal;
    VAR
        ReimbAmtPorate: Decimal;
    BEGIN
        If HRSetup.GET then
            HRSetup.TestField("Maximum Work Days");

        ElementAmount := 0;
        ReimbAmtPorate := 0;

        //IF (PayrollElementL."Function of Poration") THEN BEGIN //Need to add element to be porated
        IF (PoratePay) THEN BEGIN

            // if (EmployeeL."Is Rig Employee") then
            //   ReimbAmtPorate := ROUND(((EmployeeL."Reimbursable Amount" / DaysInMonth) * DaysWorked), 0.01, '>')
            //else
            //ReimbAmtPorate := ROUND(((EmployeeL."Reimbursable Amount" / NoOfDaysInPayPeriod) * DaysWorked), 0.01, '>');
            ReimbAmtPorate := ROUND(((EmployeeL."Reimbursable Amount" / HRSetup."Maximum Work Days") * DaysWorked), 0.01, '>');
            ElementAmount += ReimbAmtPorate;
        END ELSE BEGIN

            ElementAmount := ROUND((EmployeeL."Reimbursable Amount"), 0.01, '>');
        END;

        //END;

        IF (ElementAmount <> 0) THEN
            EXIT(ElementAmount)
        ELSE
            EXIT(0);
    END;

    PROCEDURE InsertPayrollReimbLine(EmployeeL: Record Employee; PayrollElementL: Record PayrollElement; PayPeriodCode: Code[20]; ElementAmt: Decimal);
    BEGIN

        ReimbursableSalarylines.INIT;
        ReimbursableSalarylines."Payroll Period" := PayPeriodCode;
        ReimbursableSalarylines."Element Code" := PayrollElementL."Element Code";
        ReimbursableSalarylines."Element Name" := PayrollElementL."Element Name";
        ReimbursableSalarylines."Employee No." := EmployeeL."No.";
        ReimbursableSalarylines."Employee Name" := EmployeeL."Last Name" + ' ' + EmployeeL."First Name" + ' ' + EmployeeL."Middle Name";
        ReimbursableSalarylines."Global Dimension 1 Code" := EmployeeL."Global Dimension 1 Code";
        ReimbursableSalarylines."Global Dimension 2 Code" := EmployeeL."Global Dimension 2 Code";
        //ReimbursableSalarylines."Document Date" := TODAY;
        ReimbursableSalarylines."Employment Date" := EmployeeL."Employment Date";
        //ReimbursableSalarylines."Employee Category" := EmployeeL."Employee Category";
        ReimbursableSalarylines."Job Title" := EmployeeL."Job Title";
        ReimbursableSalarylines."Payroll Bank" := EmployeeL."Payroll Bank";
        ReimbursableSalarylines."Payroll Bank Account No." := EmployeeL."Bank Account No.";
        ReimbursableSalarylines."Net Pay" := ElementAmt;
        ReimbursableSalarylines."Book Value" := EmployeeL."Reimbursable Amount";
        //if (EmployeeL."Is Rig Employee") then
        //  ReimbursableSalarylines."No. of Days In the Month" := DaysInMonth
        //else
        //ReimbursableSalarylines."No. of Days In the Month" := NoOfDaysInPayPeriod;
        ReimbursableSalaryLines."No. of Days In the Month" := HRSetup."Maximum Work Days";
        ReimbursableSalarylines."No. of Days Worked" := DaysWorked;

        ReimbursableSalarylines.INSERT(TRUE);

    END;


    PROCEDURE CalculateOTTax(MonthlyGross: Decimal; EmployeeLRec: Record Employee; PayPeriod: Code[10]; SumPension: Decimal): Decimal;
    VAR
        PayrollTax: Record PayrollTaxHeader;
        PayrollTaxline: Record PayrollTaxLine;
        Payelement: Record PayrollElement;
        CRA: Decimal;
        Tax: Decimal;
        CumTax: Decimal;
        TotalReleif: Decimal;
        AnnualGross: Decimal;
        AnnualPension: Decimal;
        AllowRelief: Decimal;
    BEGIN

        Tax := 0;
        CumTax := 0;
        CRA := 0;

        LifeRelief := 0;
        EVCRelief := 0;
        AllowRelief := 0;
        NHFRelief := 0;
        NHISRelief := 0;
        PensionRelief := 0;
        CompPension2 := 0;
        RentRelief := 0;
        AllowRelief := 0;
        AnnualGross := 0;
        //AnnualPension := 0;

        AnnualGross := (MonthlyGross * 12);
        //AnnualPension := (SumPension * 12);

        //Calculate Total Taxable Income

        TotalTaxableIncome := (AnnualGross);

        //Get the Payroll Tax Setup
        PayrollTax.RESET;
        //PayrollTax.SETRANGE("Payroll Tax Year",CurrentYear);
        PayrollTax.SETFILTER(Open, '%1', true);
        IF (NOT PayrollTax.FINDFIRST) THEN
            ERROR(Text005)
        ELSE BEGIN
            PayrollTax.TESTFIELD("Rent Relief Cap");
            PayrollTax.TESTFIELD("Rent Relief%");
        END;

        //Calculate the Releifs - Allowance, Pension, NHIS, NHF , LIFE , EVC, HMODed

        //PENSION
        Payelement.RESET;
        Payelement.SETFILTER("Is Pension Employee", '%1', TRUE);
        IF Payelement.FINDFIRST THEN BEGIN
            if HRSetup.Get then
                HRSetup.TestField("Pension Employee %");

            PensionRelief := ((SumPension * (HRSetup."Pension Employee %" / 100)) * 12);
        END ELSE
            Error('Employee Pension is not Setup in the Payroll Element');

        //Rent Relief
        //CRA := (PayrollTax."Rent Relief%" / 100) * EmployeeLRec."Rent Amount";

        //if (CRA > PayrollTax."Rent Relief Cap") then
        //  RentRelief := PayrollTax."Rent Relief Cap"
        //else
        //  RentRelief := CRA;
        RentRelief := PayrollTax."Rent Relief Cap";

        //FINAct 2022
        AllowRelief := EVCRelief + LifeRelief + NHFRelief + RentRelief + PensionRelief + NHISRelief + HMOAmt;


        //Calculate The Net Taxable Income
        //FINAct 2022
        TaxableIncome := AnnualGross - AllowRelief;

        //Claculate the Tax from the Payroll Tax Line
        PayrollTaxline.SETRANGE("Tax Code", PayrollTax."Tax Code");
        //PayrollTaxline.SETRANGE("Payroll Tax Year",PayrollTax."Payroll Tax Year");
        IF PayrollTaxline.FINDSET THEN BEGIN
            REPEAT
                CASE PayrollTaxline."Line No." OF
                    10000:
                        BEGIN
                            PayrollTaxline.TESTFIELD("Tax Slab%", 0);
                            //PayrollTaxline.TESTFIELD("Tax Slab2 %");
                            PayrollTaxline.TESTFIELD("Upper Limit");
                            PayrollTaxline.TESTFIELD("Lower Limit", 0);

                            IF (TaxableIncome >= PayrollTaxline."Lower Limit") AND (TaxableIncome <= PayrollTaxline."Upper limit") THEN BEGIN
                                Tax := (PayrollTaxline."Tax Slab%" / 100) * PayrollTaxline."Upper Limit";
                                CumTax += Tax;
                            END;
                        END;

                    20000:
                        BEGIN
                            PayrollTaxline.TESTFIELD("Tax Slab%");
                            PayrollTaxline.TESTFIELD("Upper Limit");
                            PayrollTaxline.TESTFIELD("Lower Limit");

                            IF (TaxableIncome - PayrollTaxline."Lower Limit") >= PayrollTaxline."Upper Limit" THEN BEGIN
                                Tax := 0;
                                Tax := (PayrollTaxline."Tax Slab%" / 100) * PayrollTaxline."Upper Limit";
                                CumTax += Tax;
                            END ELSE
                                IF (TaxableIncome - PayrollTaxline."Lower Limit") <= 0 THEN BEGIN
                                    Tax := 0;
                                    CumTax += Tax;
                                END ELSE BEGIN
                                    Tax := 0;
                                    Tax := (PayrollTaxline."Tax Slab%" / 100) * (TaxableIncome - PayrollTaxline."Lower Limit");
                                    CumTax += Tax;
                                END;
                        END;

                    30000:
                        BEGIN
                            PayrollTaxline.TESTFIELD("Tax Slab%");
                            PayrollTaxline.TESTFIELD("Upper Limit");
                            PayrollTaxline.TESTFIELD("Lower Limit");

                            IF (TaxableIncome - PayrollTaxline."Lower Limit") >= PayrollTaxline."Upper Limit" THEN BEGIN
                                Tax := 0;
                                Tax := (PayrollTaxline."Tax Slab%" / 100) * PayrollTaxline."Upper Limit";
                                CumTax += Tax;
                            END ELSE
                                IF (TaxableIncome - PayrollTaxline."Lower Limit") <= 0 THEN BEGIN
                                    Tax := 0;
                                    CumTax += Tax;
                                END ELSE BEGIN
                                    Tax := 0;
                                    Tax := (PayrollTaxline."Tax Slab%" / 100) * (TaxableIncome - PayrollTaxline."Lower Limit");
                                    CumTax += Tax;
                                END;
                        END;

                    40000:
                        BEGIN
                            PayrollTaxline.TESTFIELD("Tax Slab%");
                            PayrollTaxline.TESTFIELD("Upper Limit");
                            PayrollTaxline.TESTFIELD("Lower Limit");

                            IF (TaxableIncome - PayrollTaxline."Lower Limit") >= PayrollTaxline."Upper Limit" THEN BEGIN
                                Tax := 0;
                                Tax := (PayrollTaxline."Tax Slab%" / 100) * PayrollTaxline."Upper Limit";
                                CumTax += Tax;
                            END ELSE
                                IF (TaxableIncome - PayrollTaxline."Lower Limit") <= 0 THEN BEGIN
                                    Tax := 0;
                                    CumTax += Tax;
                                END ELSE BEGIN
                                    Tax := 0;
                                    Tax := (PayrollTaxline."Tax Slab%" / 100) * (TaxableIncome - PayrollTaxline."Lower Limit");
                                    CumTax += Tax;
                                END;
                        END;

                    50000:
                        BEGIN
                            PayrollTaxline.TESTFIELD("Tax Slab%");
                            PayrollTaxline.TESTFIELD("Upper Limit");
                            PayrollTaxline.TESTFIELD("Lower Limit");

                            IF (TaxableIncome - PayrollTaxline."Lower Limit") >= PayrollTaxline."Upper Limit" THEN BEGIN
                                Tax := 0;
                                Tax := (PayrollTaxline."Tax Slab%" / 100) * PayrollTaxline."Upper Limit";
                                CumTax += Tax;
                            END ELSE
                                IF (TaxableIncome - PayrollTaxline."Lower Limit") <= 0 THEN BEGIN
                                    Tax := 0;
                                    CumTax += Tax;
                                END ELSE BEGIN
                                    Tax := 0;
                                    Tax := (PayrollTaxline."Tax Slab%" / 100) * (TaxableIncome - PayrollTaxline."Lower Limit");
                                    CumTax += Tax;
                                END;
                        END;

                    60000:
                        BEGIN
                            PayrollTaxline.TESTFIELD("Tax Slab%");
                            PayrollTaxline.TESTFIELD("Upper Limit");
                            PayrollTaxline.TESTFIELD("Lower Limit");

                            IF (TaxableIncome - PayrollTaxline."Lower Limit") >= PayrollTaxline."Upper Limit" THEN BEGIN
                                Tax := 0;
                                Tax := (PayrollTaxline."Tax Slab%" / 100) * (TaxableIncome - PayrollTaxline."Upper Limit");
                                CumTax += Tax;
                            END ELSE
                                IF (TaxableIncome - PayrollTaxline."Lower Limit") <= 0 THEN BEGIN
                                    Tax := 0;
                                    CumTax += Tax;
                                END ELSE BEGIN
                                    Tax := 0;
                                    Tax := (PayrollTaxline."Tax Slab%" / 100) * (TaxableIncome - PayrollTaxline."Lower Limit");
                                    CumTax += Tax;
                                END;
                        END;

                END;
            UNTIL PayrollTaxline.NEXT = 0;

            if cumTax <> 0 then
                EXIT(ROUND(((CumTax / 12)), 0.01, '>'))
            else
                EXIT(0);
        END;
    END;

}
