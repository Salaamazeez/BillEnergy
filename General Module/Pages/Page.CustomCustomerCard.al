page 50101 "Customer Card Custom"
{
    PageType = Card;
    SourceTable = Customer;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Customer List Custom';

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = All;
            }

            field(Name; Rec.Name)
            {
                ApplicationArea = All;
            }

            field("Currency Code"; Rec."Currency Code")
            {
                ApplicationArea = All;
            }

            field("Customer Posting Group"; Rec."Customer Posting Group")
            {
                ApplicationArea = All;
            }

            field("Payment Terms Code"; Rec."Payment Terms Code")
            {
                ApplicationArea = All;
            }

            field("Phone No."; Rec."Phone No.")
            {
                ApplicationArea = All;
            }

            field(Contact; Rec.Contact)
            {
                ApplicationArea = All;
            }

            field("Balance (LCY)"; Rec."Balance (LCY)")
            {
                ApplicationArea = All;
            }

            field("Sales (LCY)"; Rec."Sales (LCY)")
            {
                ApplicationArea = All;
            }

            field("Payments (LCY)"; Rec."Payments (LCY)")
            {
                ApplicationArea = All;
            }
        }

    }
}