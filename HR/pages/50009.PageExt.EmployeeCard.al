pageextension 50009 EmployeeExt extends "Employee Card"
{
    layout
    {

        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = All;

            }

        }
        addafter(Gender)
        {
            field("Leave Setup Code"; Rec."Leave Setup Code")
            {
                ApplicationArea = All;
                TableRelation = LeaveSetup;
            }
            field("Manager No."; Rec."Manager No.")
            {
                ApplicationArea = All;
                TableRelation = Employee;
            }
        }
        addafter("Application Method")
        {

            field("Payroll Bank"; Rec."Payroll Bank")
            {
                Caption = 'Payroll Bank';

            }
        }
        addafter("Birth Date")
        {
            field("PAYER ID"; Rec."PAYER ID")
            {
                Caption = 'PAYER ID';

            }
            field(PFA; Rec.PFA)
            {
                Caption = 'PFA';

            }
            field("RSA PIN"; Rec."RSA PIN")
            {
                Caption = 'RSA PIN';

            }
        }

        modify("Union Code")
        {
            Visible = false;
        }
        modify("Union Membership No.")
        {
            Visible = false;
        }
        modify("Bank Branch No.")
        {
            Visible = false;
        }
        modify(IBAN)
        {
            Visible = false;
        }
        modify("SWIFT Code")
        {
            Visible = false;
        }
        modify(Payroll)
        {
            Visible = false;
        }
        modify("Payroll (LCY)")
        {
            Visible = false;
        }
        modify("Working Type")
        {
            Visible = false;
        }
        modify("Working Hours")
        {
            Visible = false;
        }
        modify("Social Security No.")
        {
            Caption = 'NIN';
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}