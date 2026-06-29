page 50512 "Apprvd SRQ Awaiting ISSUE List"
{
    //Created by Salaam Azeez
    Caption = 'Approved Store Requisition List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Store Requisition";
    SourceTableView = WHERE(Status = CONST(Approved), Posted = CONST(false), "PRQ Processing?" = CONST(false));
    CardPageId = "Apprd SRQ Awaiting ISSUE Card";

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
                field(Posted; Rec.Posted)
                {

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

    // actions
    // {
    //     area(Processing)
    //     {
    //         action(ActionName)
    //         {
    //             ApplicationArea = All;

    //             trigger OnAction();
    //             begin

    //             end;
    //         }
    //     }
    // }
}