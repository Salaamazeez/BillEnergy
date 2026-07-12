namespace BILLENERGY.BILLENERGY;

codeunit 50013 CheckPreviousPeriodClose
{

    trigger OnRun()
    begin

    end;

    procedure CheckPreviousPayroll(PayPeriods: Code[20]): Boolean
    var
        PrevMonth: Integer;
        PayYear: Integer;
        CurrentYear: Integer;
        PrevPeriod: code[20];
        PayrollHead: Record PayrollHeader;

    begin

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

        IF PrevPeriod <> '' THEN BEGIN
            PayrollHead.RESET;
            PayrollHead.SETRANGE("Payroll Period", PrevPeriod);
            //PayrollHead.SETFILTER("Approval Status", '<>%1', PayrollHead."Approval Status"::Closed);
            IF PayrollHead.FINDFIRST THEN
                IF (PayrollHead."Approval Status" = PayrollHead."Approval Status"::Closed) then
                    exit(True)
                else
                    exit(false);
        END;
    end;


    procedure CheckPreviouOvertime(PayPeriods: Code[20]): Boolean
    var
        PrevMonth: Integer;
        PayYear: Integer;
        CurrentYear: Integer;
        PrevPeriod: code[20];
        OvertimeHead: Record OvertimeHeader;

    begin

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

        IF PrevPeriod <> '' THEN BEGIN
            OvertimeHead.RESET;
            OvertimeHead.SETRANGE("Period Code", PrevPeriod);
            //OvertimeHead.SETFILTER("Approval Status", '<>%1', OvertimeHead."Approval Status"::Closed);
            IF OvertimeHead.FINDFIRST THEN
                IF (OvertimeHead."Approval Status" = OvertimeHead."Approval Status"::Closed) then
                    exit(True)
                else
                    exit(false);
        END;
    end;

    procedure CheckPreviouReimb(PayPeriods: Code[20]): Boolean
    var
        PrevMonth: Integer;
        PayYear: Integer;
        CurrentYear: Integer;
        PrevPeriod: code[20];
        ReimbHead: Record ReimbursableHeader;

    begin

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

        IF PrevPeriod <> '' THEN BEGIN
            ReimbHead.RESET;
            ReimbHead.SETRANGE("Period Code", PrevPeriod);
            //ReimbHead.SETFILTER("Approval Status", '<>%1', ReimbHead."Approval Status"::Closed);
            If ReimbHead.FindFirst() then
                IF (ReimbHead."Approval Status" = ReimbHead."Approval Status"::Closed) then
                    exit(True)
                else
                    exit(false);
        END;
    end;
}
