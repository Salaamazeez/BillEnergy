page 50511 "Apprd SRQ Awaiting ISSUE Card"
{
    //Created by Salaam Azeez
    PageType = Card;
    // ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "Store Requisition";
    SourceTableView = WHERE(Status = CONST(Approved), Posted = CONST(false), "PRQ Processing?" = CONST(false));
    ApplicationArea = All;

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
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    // Editable = false;
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
            part("Apprv. Stores Req.s Subform"; "Apprv. Stores Req.s Subform")
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
            action("Test Report")
            {
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                begin
                    Rec.TestReport;
                end;
            }
            action("Post")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // TESTFIELD("PRQ Processing?", FALSE);

                    Rec.PostIssue;
                    // Posted := TRUE;
                    //MODIFY;
                    Rec.CheckPostedJnl2;

                end;
            }
            action("Post and &Print")
            {
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                begin
                    Rec.PostIssuePrint;
                    //Posted := TRUE;
                    //  MODIFY;
                    Rec.CheckPostedJnl2;
                end;
            }
            action("SRQ SLIP")
            {
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                begin
                    Rec.SETRANGE("No.", Rec."No.");
                    IF Rec.FINDFIRST THEN
                        REPORT.RUNMODAL(70097, TRUE, TRUE, Rec);
                end;
            }
            action("Transfer To PRQ Section")
            {
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                begin
                    Rec."PRQ Processing?" := TRUE;
                    IF Rec."PRQ Processing?" THEN
                        MESSAGE('The Store Requisition %1 has been transferred to the PRQ Section', Rec."No.")
                end;
            }
            action(Print)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    StoreReqTbl: Record "Store Requisition";
                begin
                    StoreReqTbl.SetRange("No.", Rec."No.");
                    if StoreReqTbl.FindFirst() then
                        Report.RunModal(50500, true, true, StoreReqTbl);
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


    procedure StoreRequisitionLineExist(): Boolean
    begin
        StoresRequisitionLine.RESET;
        StoresRequisitionLine.SETRANGE("Document No.", Rec."No.");
        EXIT(StoresRequisitionLine.FINDFIRST);
    end;

}