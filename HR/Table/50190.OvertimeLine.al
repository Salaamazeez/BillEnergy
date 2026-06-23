table 50190 OvertimeLine
{
    Caption = 'Overtime Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Period Code"; Code[10])
        {
            Caption = 'Period Code';
            TableRelation = PayrollPeriods."Period Code";
        }
        field(2; "Employee No."; Code[50])
        {
            Caption = 'Employee No.';
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                if EmpRec.get("Employee No.") then begin
                    if (Not EmpRec.Blocked) then begin
                        EmpRec.TestField("Emplymt. Contract Code");

                        "Global Dimension 1 Code" := EmpRec."Global Dimension 1 Code";
                        "Global Dimension 2 Code" := EmpRec."Global Dimension 2 Code";
                        "Job Title" := EmpRec."Job Title";
                        "Employee Name" := EmpRec."Last Name" + ' ' + Emprec."First Name";

                        if SalSetupHead.Get(EmpRec."Emplymt. Contract Code") then
                            "Gross Pay" := SalSetupHead."Gross Pay";
                    end else
                        Error(ErrorTerminated, EmpRec."No.");
                end;

                if "Employee No." = '' then begin
                    Clear("Global Dimension 1 Code");
                    Clear("Global Dimension 1 Code");
                    Clear("Job Title");
                    Clear("Employee Name");
                    Clear("Gross Pay");
                end;


            end;
        }
        field(3; "Employee Name"; Text[200])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(4; "Element Code"; Code[10])
        {
            Caption = 'Element Code';
            TableRelation = PayrollElement."Element Code";

            trigger OnValidate()
            begin
                if "Element Code" = '' then
                    Clear("Element Name");

                PayElement.Reset();
                PayElement.SetRange("Element Code", "Element Code");
                if PayElement.FindFirst() then begin
                    "Element Name" := PayElement."Element Name";
                end;
            end;
        }
        field(5; "Element Name"; Code[20])
        {
            Caption = 'Element Name';
            Editable = false;
        }
        field(6; "Global Dimension 1 Code"; Code[80])
        {

            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            Editable = false;

        }
        field(7; "Global Dimension 2 Code"; Code[80])
        {

            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            Editable = false;

        }
        field(8; "Extra Days Worked"; Integer)
        {
            Caption = 'Extra Days Worked';
        }
        field(9; "Days Worked"; Integer)
        {
            Caption = 'Days Worked';
        }

        field(10; "Gross Pay"; Decimal)
        {
            Caption = 'Gross Pay';
            Editable = false;
        }
        field(11; "Overtime Amount"; Decimal)
        {
            Caption = 'Overtime Amount';
            Editable = false;
        }
        field(12; "Overtime Paid"; Boolean)
        {
            Caption = 'Overtime Paid';
            Editable = false;
        }
        field(13; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(14; "Overtime Closed"; Boolean)
        {
            Caption = 'Overtime Closed';
            Editable = false;
        }

        field(15; "Job Title"; Text[100])
        {
            Caption = 'Job Title';
            Editable = false;
        }
        field(16; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(17; "Net Pay"; Decimal)
        {
            Caption = 'Net Pay';
            Editable = false;
        }
        field(18; "PAYE"; Decimal)
        {
            Caption = 'PAYE';
            Editable = false;
        }
        field(19; "Pension"; Decimal)
        {
            Caption = 'Pension';
            Editable = false;
        }

    }
    keys
    {
        key(PK; "Period Code", "Employee No.", "Line No.")
        {
            Clustered = true;
        }

        Key(SKey; "Period Code", "Employee No.", "Element Code")
        {

        }
    }



    var
        EmpRec: Record Employee;

        PayElement: Record PayrollElement;

        SalSetupHead: Record SalarySetupHeader;

        ErrorTerminated: Label 'Employee %1 has been terminated, you cannot calculate overtime for and exit employee';



}
