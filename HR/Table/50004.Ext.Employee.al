tableextension 50004 EmployeeExt extends Employee
{
    fields
    {

        field(50002; "No. 2"; Text[50])
        {

        }
        field(50003; "Leave Setup Code"; code[20])
        {
            Caption = 'Leave Setup Code';
            DataClassification = ToBeClassified;
            TableRelation = LeaveSetup;
        }
        field(50004; PFA; code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'PFA';
            TableRelation = PensionFundAdmin."PFA Code";

        }
        field(50005; "RSA PIN"; Code[20])
        {
            trigger OnValidate()
            begin
                TestField(PFA);
            end;
        }
        field(50006; "PAYER ID"; code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'PAYER ID';

        }
        field(50007; "Payroll Bank"; code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payroll Bank';
            TableRelation = PayrollBank."Bank Code";

        }

        field(50008; Blocked; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Blocked';

            trigger OnValidate()
            begin
                TestField("Grounds for Term. Code");
                TestField("Termination Date");
            end;
        }
        field(50009; "Reimbursable Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Reimbursable Amount';
        }

        field(50010; "Rent Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Rent Amount';
        }
        field(50011; "Job Function Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Job Function Code';
            TableRelation = JobFunction."Job Title";

            trigger OnValidate()
            begin
                //clear("Job Title");

                //if JobFunction.Get("Job Title Code") then
                //  "Job Title" := JobFunction."Job Title";
            end;
        }
        field(50012; "Is Rig Employee"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Is Rig Employee';
        }
 field(50013; "Pushed to the Post"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Pushed to the Post';
        }

        modify("Bank Account No.")
        {
            //Caption = 'Bank Code';
            trigger OnAfterValidate()
            begin
                TestField("Payroll Bank");
            end;
        }

    }
    trigger OnAfterInsert()
    begin
        //TestField("Job Title");
    end;

    var

        JobFunction: Record JobFunction;
}
