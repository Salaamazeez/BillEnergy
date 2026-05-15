page 50518 "Posted Stores Req.s Card"
{
    //Created by Salaam Azeez
    PageType = Card;
    //ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = "Store Requisition";
    // SourceTableView = WHERE(Status = CONST(Approved), Posted = CONST(false), "PRQ Processing?" = CONST(false));
    Editable = false;
    // AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;
                    Editable = false;

                }

                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Project/Job Description"; Rec."Project/Job Description")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Work Order No."; Rec."Work Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Staff No."; Rec."Staff No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ApplicationArea = All;
                    Editable = false;

                }

                field("Requisition Amount "; Rec."Requisition Amount")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field("Last Modified Date Time"; Rec."Last Modified Date Time")
                {
                    ApplicationArea = All;

                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                    Editable = false;

                }


            }
            part("Posted Stores Req. Subform"; "Posted Stores Req. Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(Print)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    StoresRequisition.SETRANGE("No.", Rec."No.");
                    IF StoresRequisition.FINDFIRST THEN
                        REPORT.RUNMODAL(50500, TRUE, TRUE, StoresRequisition);
                end;
            }
            // action("Gate Pass")
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         StoresRequisitionLine.SETRANGE("Document No.", "No.");
            //         IF StoresRequisitionLine.FINDFIRST THEN
            //             REPORT.RUNMODAL(50004, TRUE, TRUE, StoresRequisitionLine);
            //     end;
            // }
            action("Print Posted Voucher")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.SETRANGE("No.", Rec."No.");
                    IF Rec.FINDFIRST THEN
                        REPORT.RUNMODAL(70098, TRUE, TRUE, Rec);

                end;
            }
            action(Approve)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    begin
                    END;
                end;
            }

        }
    }

    var
        myInt: Integer;
        StoresRequisitionLine: Record "Store Requisition Line";
        Text000: TextConst ENU = 'THE STORE REQUISITION  DOES NOT HAVE  INFORMATION ON THE LINE %1';
        StoresRequisition: Record "Store Requisition";
        RecID: RecordId;
        Limit: Decimal;
        DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";
    //DocumentApprovalWorkflow


    procedure StoreRequisitionLineExist(): Boolean
    begin
        StoresRequisitionLine.RESET;
        StoresRequisitionLine.SETRANGE("Document No.", Rec."No.");
        EXIT(StoresRequisitionLine.FINDFIRST);
    end;

}