
page 50561 "Approved Store  Requisition Su"
{
    //Created by Salaam Azeez
    PageType = ListPart;
    // ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTable = "Store Requisition Line";
    AutoSplitKey = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;

                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;

                }
                field("Stock Code"; Rec."Stock Code")
                {
                    ApplicationArea = All;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;

                }
                field("Unit of Issue"; Rec."Unit of Issue")
                {
                    ApplicationArea = All;

                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;

                }
                field("Requested Qty."; Rec."Requested Qty.")
                {
                    ApplicationArea = All;

                }
                field("Issued Qty."; Rec."Issued Qty.")
                {
                    ApplicationArea = All;

                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;

                }
                field("Gen Bus. Posting Group"; Rec."Gen Bus. Posting Group")
                {
                    ApplicationArea = All;

                }

                field(Value; Rec.Value)
                {
                    ApplicationArea = All;

                }
                field("Qty in Store at Request"; Rec."Qty in Store at Request")
                {
                    ApplicationArea = All;

                }
                field("Qty in Store at the moment"; Rec."Qty in Store at the moment")
                {
                    ApplicationArea = All;

                }


            }
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