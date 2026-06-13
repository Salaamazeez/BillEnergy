table 50188 PayrollOthervariables
{
    Caption = 'Payroll Other Variables';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = employee."No.";

            trigger OnValidate()
            begin
                if EmpRec.get("Employee No.") then begin
                    "Global Dimension 1 Code" := EmpRec."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := EmpRec."Global Dimension 2 Code";
                    "Job Title" := EmpRec."Job Title";
                    "Employee Name" := EmpRec."Last Name" + ' ' + Emprec."First Name";
                end;

                if "Employee No." = '' then begin
                    Clear("Global Dimension 1 Code");
                    Clear("Global Dimension 2 Code");
                    Clear("Job Title");
                    Clear("Employee Name");
                end;
            end;

        }
        field(2; "Payroll Period"; Code[10])
        {
            Caption = 'Payroll Period';
            TableRelation = PayrollPeriods."Period Code";

            trigger OnValidate()
            begin
                "Days in the Month" := PayrollCodeUnit.GetNoOfDaysInPayPeriod("Payroll Period");

                if HRSetup.Get() then begin
                    HRSetup.TestField("Working Hours");
                    "Maximum Working Hour" := HRSetup."Working Hours";
                end;

                "No. of Working Hour" := HRSetup."Working Hours" * "Days in the Month";
            end;
        }
        field(3; "Element Code"; Code[10])
        {
            Caption = 'Element Code';
            TableRelation = PayrollElement."Element Code";

            trigger OnValidate()
            begin
                if "Element Code" = '' then
                    Clear("Element Name");
                Clear(Deduction);
                Clear(Earning);

                PayElement.Reset();
                PayElement.SetRange("Element Code", "Element Code");
                if PayElement.FindFirst() then begin
                    "Element Name" := PayElement."Element Name";

                    if PayElement.Earning then
                        Earning := true;

                    if PayElement.Deduction then
                        Deduction := true;
                end;
            end;
        }
        field(4; "Element Name"; Code[50])
        {
            Caption = 'Element Name';
            Editable = false;
        }
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(6; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }

        field(7; Earning; Boolean)
        {
            Caption = 'Earning';
            Editable = false;
        }

        field(8; Deduction; Boolean)
        {
            Caption = 'Deduction';
            Editable = false;
        }


        field(9; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            Editable = false;

        }
        field(10; "Global Dimension 2 Code"; Code[20])
        {

            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            Editable = false;
        }
        field(11; "Hours Late/Days Absent"; Integer)
        {
            Caption = 'Hours Late/Days Absent';
            Editable = false;
        }

        field(12; "Job Title"; Text[100])
        {
            Caption = 'Job Title';
            Editable = false;
        }

        field(13; "Hourly Rate"; Decimal)
        {
            Caption = 'Hourly Rate';
            Editable = false;
        }

        field(14; "No. of Working Hour"; Decimal)
        {
            Caption = 'No. of working Hour';
            Editable = false;
        }

        field(15; "Days in the Month"; Decimal)
        {
            Caption = 'Days in the Month';
            Editable = false;
        }

        field(16; "Maximum Working Hour"; Decimal)
        {
            Caption = 'Maximum working Hour';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Employee No.", "Payroll Period", "Element Code")
        {
            Clustered = true;
        }
    }

    var

        EmpRec: Record Employee;
        PayElement: Record PayrollElement;

        PayrollCodeUnit: Codeunit PayrollCodeunite;

        HRSetup: Record "Human Resources Setup";
}
