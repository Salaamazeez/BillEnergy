namespace BILLENERGY.BILLENERGY;
using Microsoft.HumanResources.Employee;
using Microsoft.Sales.Comment;
using System.Automation;
using System.Security.User;

page 50175 Reimbursable
{
    //ApplicationArea = All;
    Caption = 'Reimbursable Salary';
    PageType = Document;
    SourceTable = ReimbursableHeader;
    UsageCategory = Tasks;
    InsertAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Period Code"; Rec."Period Code")
                {
                    ToolTip = 'Specifies the value of the Period Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }

                field("Employee Code Filter"; Rec."Employee Code Filter")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code Filter"; Rec."Global Dimension 1 Code Filter")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code Filter field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code Filter"; Rec."Global Dimension 2 Code Filter")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code Filter field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Paid Document No."; Rec."Paid Document No.")
                {
                    ToolTip = 'Specifies the value of the Paid Document No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Reimbursable Paid"; Rec."Reimbursable Paid")
                {
                    ToolTip = 'Specifies the value of the Reimbursable Paid field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ToolTip = 'Specifies the value of the Total Amount field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(Reimbursablelines; ReimbursableSalarySubform)
            {
                ApplicationArea = All;
                SubPageLink = "Payroll Period" = field("Period Code");
            }
        }
    }
    actions
    {
        // 1. Define the action container area
        area(Processing)
        {
            action(CalculateReimbursable)
            {
                ApplicationArea = All;
                Caption = 'Calculate Reimbursable Pay';
                ToolTip = 'Executes a process to calculate the Reimbursable for rig staff';
                Image = Calculate;

                // 3. Make the action easy to find in the action bar
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                // 4. Run your custom logic when clicked
                trigger OnAction()

                begin

                    // IF (Not CheckPrevPeriodClose.CheckPreviouReimb(Rec."Period Code")) then
                    //   Error(LabelClose);

                    Rec."Approval Status" := Rec."Approval Status"::Open;
                    Rec.TestField("Global Dimension 1 Code Filter");
                    Rec.TestField("Period Code");
                    PayrollCodeunit.ProcessReimbPayroll(Rec."Period Code", Rec."Global Dimension 1 Code Filter", Rec."Global Dimension 2 Code Filter", Rec."Employee Code Filter");
                end;
            }
            action(ReportRebursable)
            {
                ApplicationArea = All;
                Caption = 'Reimbursable Summary';
                ToolTip = 'Executes a process to Print the Reimbursable Summary for rig staff';
                Image = Payment;

                // 3. Make the action easy to find in the action bar
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                // 4. Run your custom logic when clicked
                trigger OnAction()

                begin
                    ReimbursLine.Reset();
                    ReimbursLine.SetRange("Payroll Period", rec."Period Code");
                    if ReimbursLine.FindFirst() then
                        Report.Run(Report::ReimbursableSummary, true, false, ReimbursLine);
                end;
            }

            action(CloseReimb)
            {
                ApplicationArea = All;
                Caption = 'Close Reimbursable';
                ToolTip = 'Close the Reimbursable';
                Image = Closed;

                // 3. Make the action easy to find in the action bar
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                // 4. Run your custom logic when clicked
                trigger OnAction()
                begin
                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    Rec."Approval Status" := Rec."Approval Status"::Closed;
                    rec.Modify();
                end;
            }

            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        ApprovalMgt: Codeunit "Approval Mgt";

                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                        if ApprovalMgt.ApproveDoc(Rec."Period Code") then begin
                            Rec."Approval Status" := Rec."Approval Status"::Approved;
                            Rec.Modify()
                        end;
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        MyApprovalMgt: Codeunit "Approval Mgt";
                        RecRef: RecordRef;
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                        RecRef.GetTable(Rec);
                        MyApprovalMgt.CheckAndRejectDoc(RecRef)
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    Visible = false;
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Table ID" = const(60021), "Document No." = field("Period Code");

                    //Visible = OpenApprovalEntriesExistForCurrUser;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Visible = false;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = const(0),
                                  "No." = field("Period Code"),
                                  "Document Line No." = const(0);
                    ToolTip = 'View or add comments for the record.';
                }
            }

            group(Action13)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                group(Release)
                {
                    action("Re&lease")
                    {
                        ApplicationArea = Basic;
                        Image = ReleaseDoc;
                        Promoted = true;
                        PromotedCategory = Process;
                        ShortCutKey = 'Ctrl+F9';

                        trigger OnAction()
                        var
                            RecRef: RecordRef;
                            ReleaseDocument: Codeunit "Release Documents";

                        begin
                            //Rec.TestMandatoryFields();
                            RecRef.GetTable(Rec);
                            ReleaseDocument.PerformanualManualDocRelease(RecRef);
                            CurrPage.Update;
                        end;
                    }
                    action("Re&open")
                    {
                        ApplicationArea = Basic;
                        Image = ReOpen;
                        Promoted = true;
                        PromotedCategory = Process;

                        trigger OnAction()
                        var
                            RecRef: RecordRef;
                            ReleaseDocument: Codeunit "Release Documents";
                        begin
                            RecRef.GetTable(Rec);
                            ReleaseDocument.PerformManualReopen(RecRef);
                            CurrPage.Update;
                        end;
                    }
                }
            }
            group("Request Approval")
            {
                action("Send &Approval Request")
                {
                    ApplicationArea = Basic;
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ApprovalsMgmt: Codeunit "Approval Mgt";
                        Err001: Label 'Kindly select a %1 value';
                        Err002: Label 'Kindly input a %1 value';
                    begin
                        //Rec.TestMandatoryFields();
                        RecRef.GetTable(Rec);
                        if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                            ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    end;
                }

                action("Cancel Approval Re&quest")
                {
                    ApplicationArea = Basic;
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ApprovalsMgmt: Codeunit "Approval Mgt";
                    begin
                        RecRef.GetTable(Rec);
                        ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    end;
                }




            }

        }

        area(Navigation)
        {

            action(Approvals)
            {
                ApplicationArea = Basic;
                Image = Approvals;

                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                begin
                    ApprovalEntries.SetRecordFilters(Database::ReimbursableHeader, 6, Rec."Period Code");
                    ApprovalEntries.Run;
                end;
            }

        }

    }


    trigger OnAfterGetRecord()
    begin
        EnableFields;
        SetControlAppearance;
    end;


    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    procedure EnableFields()
    begin
        CurrPage.Editable(Rec."Approval Status" <> Rec."Approval Status"::"Pending Approval");
        //CurrPage.Editable(Rec."Former PR No." = '');

    end;

    trigger OnOpenPage()
    begin
        If UserSteup.Get(UserId) then;
        //UserSteup.TestField("Global Dimension 1 Code");

        //Rec.FilterGroup(2);
        //Rec.SetRange("Global Dimension 1 Code Filter", UserSteup."Global Dimension 1 Code");
        //Rec.FilterGroup(0);

        IF (Rec."Approval Status" = Rec."Approval Status"::Closed) then
            CurrPage.Editable := false;
    end;

    var
        LabelClose: Label 'Previous Reimbursable must be close first.';
        CheckPrevPeriodClose: Codeunit CheckPreviousPeriodClose;
        UserSteup: Record "User Setup";
        EmployeeRec: Record Employee;
        PayrollCodeunit: Codeunit "PayrollCodeunite";
        ReimbursableHead: Record ReimbursableHeader;
        ReimbursLine: Record ReimbursableSalaryLines;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        EnableControl: Boolean;
}
