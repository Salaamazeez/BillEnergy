page 50556 "Apprv. Stores Returns Card"
{
    //Created by Salaam Azeez
    CaptionML = ENU = 'Approved Stores Return: Open Entries';
    PageType = Card;
    // ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "Stores Return";
    RefreshOnActivate = true;
    SourceTableView = WHERE(Status = CONST(Approved), Posted = CONST(false));
    ApplicationArea = All;
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
                field("Issue No."; Rec."Issue No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                // field("Staff No."; "Staff No.")
                // {
                //     ApplicationArea = All;
                //     Editable = false;

                // }
                // field("Staff Name"; "Staff Name")
                // {
                //     ApplicationArea = All;
                //     Editable = false;

                // }

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
            part("Posted Stores Returns Subform"; "Posted Stores Returns Subform")
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
                    // MODIFY;
                    // CheckPostedJnl;

                end;
            }
            action("Post and &Print")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.PostIssuePrint;
                    // Posted := TRUE;
                    // MODIFY;
                    // CheckPostedJnl;
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