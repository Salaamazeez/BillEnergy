page 50100 "Item Card Custom"
{
    PageType = Card;
    SourceTable = Item;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Item List Custom';

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = All;
            }

            field(Description; Rec.Description)
            {
                ApplicationArea = All;
            }

            field(Type; Rec.Type)
            {
                ApplicationArea = All;
            }

            field(Inventory; Rec.Inventory)
            {
                ApplicationArea = All;
            }

            field("Substitutes Exist"; Rec."Substitutes Exist")
            {
                ApplicationArea = All;
            }

            field("Assembly BOM"; Rec."Assembly BOM")
            {
                ApplicationArea = All;
            }

            field("Base Unit of Measure"; Rec."Base Unit of Measure")
            {
                ApplicationArea = All;
            }

            field("Cost is Adjusted"; Rec."Cost is Adjusted")
            {
                ApplicationArea = All;
            }

            field("Unit Cost"; Rec."Unit Cost")
            {
                ApplicationArea = All;
            }

            field("Unit Price"; Rec."Unit Price")
            {
                ApplicationArea = All;
            }

            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = All;
            }


        }
    }
}