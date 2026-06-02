page 50091 "Apprv. Purch. Requisition Lis"
{
    //Created by Salaam Azeez
    PageType = List;
    ApplicationArea = All;
    Caption = 'Apprv. Purch. Requisition List';
    UsageCategory = Lists;
    SourceTable = "Purch. Requistion";
    SourceTableView = WHERE(Status = CONST(Approved), "Purch. Order Created?" = CONST(false));
    CardPageId = "Appr. Purch. Requisition Cards";
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
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
            action("Print")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    PurRequisition: Record "Purch. Requistion";
                begin
                    PurRequisition.SetRange("No.", Rec."No.");
                    if PurRequisition.FindFirst() then
                        //Report.Run(50130,);
                        Report.Run(50102, true, true, PurRequisition);
                end;
            }
        }
    }
}