page 50507 "Pending Store Requisitions"
{
    //Created by Salaam Azeez
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Store Requisition";
    SourceTableView = where(Status = const("Pending Approval"));
    CardPageId = "Pending Store Requisition Card";

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