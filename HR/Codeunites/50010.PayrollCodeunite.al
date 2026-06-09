namespace BILLENERGY.BILLENERGY;
using Microsoft.HumanResources.Setup;
using Microsoft.Finance.Payroll;
using Microsoft.HumanResources.Employee;
using Microsoft.Finance.GeneralLedger.Journal;

codeunit 50010 PayrollCodeunite
{

    var

        HRSetup: Record "Human Resources Setup";
        Window: Dialog;
        DaysWorked: Integer;
        NoOfDaysInPayPeriod: Integer;

        PoratePay: Boolean;
        LastDateOfMonth: Date;
        StartDate: Date;
        PayrollPeriodsCode: Code[20];
        PayrollHeader: Record PayrollHeader;
        PayrollLine: Record PayrollLine;
        PayrollDetailLine: Record PayrollDetailLine;
        PayRollPeriod: Record PayrollPeriods;
        PayrollOtherVar: Record PayrollOthervariables;
        PayrollElement: Record PayrollElement;
        Employee: Record Employee;

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
        PayrollHead: Record PayrollHeader;

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
        EmpBookLine2: Record SalarySetupLine;
        //PayrollReimbLine : Record 50016;
        EmpBook: Record SalarySetupHeader;
        //PayrollReimbHead : Record 50015;

        Text011: Label 'Previous Reimbursabl Payroll period %1 must be close before you can run the current payroll';
        Text01: Label 'Salary Control Account';
        Text009: Label 'Reimbursabl Salary journal';
        Text008: Label 'Processing Reimbursabl Salary Journal for department. #1######\';
        TEXT000: Label 'Lines\#2###############\Detail Lines\#1###############';
        TEXT001: Label 'Do you want to post %1.';
        TEXT002: Label 'Setup does not exists for element %1.';
        Text003: Label 'Processing Reimbursable Payroll for Employee No. #1######\';
        Text004: Label 'Reimbursabl Payroll Processing completed successfuly.';
        Text005: Label 'Payroll Tax setup does not exist for year %1';

    trigger OnRun()
    begin

    end;


}
