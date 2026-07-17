page 50554 "Stores Returns Subform"
{
    //Created by Salaam Azeez
    PageType = ListPart;
    //ApplicationArea = All;
    //UsageCategory = Lists;
    AutoSplitKey = true;
    SourceTable = "Stores Return Line";
    RefreshOnActivate = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {


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
                field("Returned Qty."; Rec."Returned Qty.")
                {
                    ApplicationArea = All;

                }
                field("Qty to Return"; Rec."Qty to Return")
                {
                    ApplicationArea = All;
                }
                field("Qty Returned"; Rec."Qty Returned")
                {
                    ApplicationArea = All;
                }
                field("Issued Qty"; Rec."Issued Qty")
                {
                    ApplicationArea = All;

                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;

                }

                field(Value; Rec.Value)
                {
                    ApplicationArea = All;

                }
                field("Gen Bus. Posting Group"; Rec."Gen Bus. Posting Group")
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // "Qty issued" := Abs("Issued Qty.");
        Rec."Qty to Return" := Rec."Issued Qty" - Rec."Qty Returned";
        Rec.Modify()
    end;

    trigger OnClosePage()
    begin
        // "Qty issued" := Abs("Issued Qty.");
        Rec."Qty to Return" := Rec."Issued Qty" - Rec."Qty Returned";
        // "Qty. to Issue" := "Requested Qty." - Abs("Issued Qty.");
        Rec.Modify()
    end;
}