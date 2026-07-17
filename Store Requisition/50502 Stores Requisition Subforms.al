page 50003 "Stores Requisition Subforms"
{
    //Created by Salaam Azeez
    PageType = ListPart;
    //ApplicationArea = All;
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
                // field("Line No."; "Line No.")
                // {
                //     ApplicationArea = All;

                // }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;

                }
                // field("Document No."; "Document No.")
                // {
                //     ApplicationArea = All;

                // }
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
                    Visible = false;

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
                    Visible = false;

                }
                field("Qty issued"; Rec."Qty issued")
                {

                    ApplicationArea = All;

                }
                field("Qty. to Issue"; Rec."Qty. to Issue")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Gen Bus. Posting Group"; Rec."Gen Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Requested Value"; Rec."Requested Value")
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field("Qty in Store at Request"; Rec."Qty in Store at Request")
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field("Qty in Store at the moment"; Rec."Qty in Store at the moment")
                {
                    ApplicationArea = All;

                }


            }
        }
        // area(Factboxes)
        // {

        // }
    }

    actions
    {
        area(Processing)
        {
            // ApplicationArea = All;
            action(MyByLocation)
            {
                ApplicationArea = All;


                AccessByPermission = TableData Location = R;
                // ApplicationArea = Location;

                Caption = 'Items b&y Location';
                Image = ItemAvailbyLoc;
                ToolTip = 'Show a list of items grouped by location.';

                trigger OnAction()
                begin
                    PAGE.Run(PAGE::"Items by Location", Rec);
                end;
                // }
            }
        }


    }
    // trigger OnAfterGetRecord()
    // begin
    //     ItmLedgerEntry.SetRange("Document No.", "Document No.");
    //     if ItmLedgerEntry.FindFirst() then begin
    //         repeat
    //             ItmLedgerEntry.CalcFields(Quantity);
    //         until ItmLedgerEntry.Next() = 0;

    //     end;
    //     QtyIssued := ItmLedgerEntry.Quantity;
    //     "Qty. to Issue" := Abs(QtyIssued);
    //     Message('%1', QtyIssued);
    // end;

    // trigger OnClosePage()
    // begin
    //     ItmLedgerEntry.SetRange("Document No.", "Document No.");
    //     if ItmLedgerEntry.FindFirst() then begin
    //         repeat
    //             ItmLedgerEntry.CalcFields(Quantity);
    //         until ItmLedgerEntry.Next() = 0;

    //     end;
    //     QtyIssued := ItmLedgerEntry.Quantity;
    //     "Qty. to Issue" := Abs(QtyIssued);
    //     Message('%1', QtyIssued);
    // end;

    // trigger OnOpenPage()
    // begin
    //     ItmLedgerEntry.SetRange("Document No.", "Document No.");
    //     if ItmLedgerEntry.FindFirst() then begin
    //         repeat
    //             ItmLedgerEntry.CalcFields(Quantity);
    //         until ItmLedgerEntry.Next() = 0;

    //     end;
    //     QtyIssued := ItmLedgerEntry.Quantity;
    //     "Qty. to Issue" := Abs(QtyIssued);
    //     Message('%1', QtyIssued);

    // end;

    // var
    //     QtyIssued: Decimal;
    //     ItmLedgerEntry: Record "Item Ledger Entry";

    // trigger OnAfterGetRecord()
    // begin
    //     "Qty issued" := abs("Issued Qty.");
    //     Modify()
    // end;


}