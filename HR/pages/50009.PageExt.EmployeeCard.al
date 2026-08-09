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
                ApplicationArea = All;

            }
            field("Rent Relief Amount"; Rec."Rent Amount")
            {
                Caption = 'Rent Amount';
                ApplicationArea = All;

            }

        }
        addafter("Company E-Mail")
        {
            field(Blocked; Rec.Blocked)
            {
                Caption = 'Blocked';
                ApplicationArea = All;
            }
            field("Job Function Code"; Rec."Job Function Code")
            {
                Caption = 'Job Function Code';
                ApplicationArea = All;
            }
            field("Is Rig Employee"; Rec."Is Rig Employee")
            {
                Caption = 'Is Rig Employee';
                ApplicationArea = All;
            }
            field("Pushed to the Post";Rec."Pushed to the Post"){
                ApplicationArea = All;
            }
        }

        addafter("Birth Date")
        {
            field("PAYER ID"; Rec."PAYER ID")
            {
                Caption = 'PAYER ID';
                ApplicationArea = All;

            }

            field(PFA; Rec.PFA)
            {
                Caption = 'PFA';
                ApplicationArea = All;

            }
            field("RSA PIN"; Rec."RSA PIN")
            {
                Caption = 'RSA PIN';
                ApplicationArea = All;

            }

            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
                CaptionClass = '1,1,1';
            }

            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
                CaptionClass = '1,1,2';
            }

        }
        modify("Board Member")
        {
            Visible = false;
        }
        modify("Social Security No.")
        {
            Caption = 'NIN';
            ApplicationArea = All;
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
        modify("Privacy Blocked")
        {
            Visible = false;
        }
        modify("Balance (LCY)")
        {
            Visible = false;
        }
        modify("Statistics Group Code")
        {
            Visible = false;
        }
        modify("Resource No.")
        {
            Visible = false;
        }
        modify("Salespers./Purch. Code")
        {
            Visible = false;
        }
        modify("Collective Bargain. Agmt. Info")
        {
            Visible = false;
        }
        modify("Employee Posting Group")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = false;
        }
        modify("Application Method")
        {
            Visible = false;
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter(PayEmployee)
        {
            action("Sync Employee To HMRS")
            {
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Sync Employee To HMRS';
                ApplicationArea = Basic;
                trigger OnAction()
                var
                    PortalMgt: Codeunit "Portal Mgt";
                begin
                    PortalMgt.SendEmployeeToHRMS(Rec);
                end;
            }

            action("Update Employee To HMRS")
            {
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Update Employee To HMRS';
                ApplicationArea = Basic;
                trigger OnAction()
                var
                    PortalMgt: Codeunit "Portal Mgt";
                begin
                    PortalMgt.UpdateEmployeeStatusToHRMS(Rec);
                end;
            }
        }
    }

}