
page 50031 "Cash Adv. Expense Code"
{
    //Created by Akande
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Expense Code";
    SourceTableView = order(ascending) where("Expense Type" = filter("Cash Advance"));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Expense Code"; rec."Expense Code")
                {
                    ApplicationArea = All;

                }
                field("Expense Type"; Rec."Expense Type")
                {
                    ApplicationArea = All;

                }

                field("Account Type"; rec."Account Type")
                {
                    ApplicationArea = All;

                }
                field(Description; rec.Description)
                {

                }
                field("Account No."; rec."Account No.")
                {
                    ApplicationArea = All;

                }
                field("Account Name"; rec."Account Name")
                {

                }

                field("Payment to"; rec."Payment to")
                {
                    ApplicationArea = All;

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

