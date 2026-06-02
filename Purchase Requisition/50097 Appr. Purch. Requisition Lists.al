page 50097 "Appr. Purch. Requisition Lists"
{
    //Created by Salaam Azeez
    PageType = List;
    Caption = 'Approved & Converted Purc. Req. List';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purch. Requistion";
    SourceTableView = WHERE(Status = CONST(Approved), "Purch. Order Created?" = CONST(true));
    CardPageId = "Approved Purch. REQ Page";
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
                field("Requester No."; Rec."Requester No.")
                {
                    ApplicationArea = All;

                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                }
                field(Requester; Rec.Requester)
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
    trigger OnOpenPage()
    begin
        UserSetup.GET(USERID);
        Rec.FILTERGROUP(10);
        //SETFILTER("Shortcut Dimension 1 Code",UserSetup."Shortcut Dimension 1 Code");
        //Rec.SETFILTER("Shortcut Dimension 1 Code", UserSetup."PV Amount Approval Limits");
        Rec.FILTERGROUP(0);
    end;

    var
        UserSetup: Record "User Setup";
}