page 50517 "Posted Stores Req.s List"
{
    //Created by Salaam Azeez
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Store Requisition";
    SourceTableView = WHERE(Posted = CONST(true));
    CardPageId = "Posted Stores Req.s Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;

                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;

                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;

                }
                field("Project/Job Description"; Rec."Project/Job Description")
                {
                    ApplicationArea = All;

                }
                field("Issued Quantity"; Rec."Issued Quantity")
                {
                    ApplicationArea = All;

                }
                field("Work Order No."; Rec."Work Order No.")
                {
                    ApplicationArea = All;

                }
                field(Status; Rec.Status)
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