page 50555 "Apprv. Stores Returns List"
{
    //Created by Salaam Azeez
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Stores Return";
    SourceTableView = WHERE(Status = CONST(Approved), Posted = CONST(false));
    CardPageId = "Apprv. Stores Returns Card";

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