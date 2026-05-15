page 50509 "Pending Store  Requisition Sub"
{
    //Created by Salaam Azeez
    PageType = ListPart;
    //ApplicationArea = All;
    // UsageCategory = Lists;
    SourceTable = "Store Requisition Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Stock Code"; Rec."Stock Code")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Unit of Issue"; Rec."Unit of Issue")
                {
                    ApplicationArea = All;

                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Requested Qty."; Rec."Requested Qty.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Issued Qty."; Rec."Issued Qty.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Qty issued"; Rec."Qty issued")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Qty. to Issue"; Rec."Qty. to Issue")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Gen Bus. Posting Group"; Rec."Gen Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Requested Value"; Rec."Requested Value")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Qty in Store at Request"; Rec."Qty in Store at Request")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Qty in Store at the moment"; Rec."Qty in Store at the moment")
                {
                    ApplicationArea = All;
                    Editable = false;

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