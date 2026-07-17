namespace BILLENERGY.BILLENERGY;
using Microsoft.HumanResources.Employee;
using Microsoft.Sales.Comment;
using System.Automation;
using System.Security.User;

page 50155 PayrollHeader
{
    //ApplicationArea = All;
    Caption = 'Payroll Header';
    PageType = Document;
    SourceTable = PayrollHeader;
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Payroll Period"; Rec."Payroll Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';

                }
                field("Payroll Creation Date"; Rec."Payroll Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Creation Date field.', Comment = '%';

                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';

                }
                field("Employee Filter"; Rec."Employee Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Filter field.', Comment = '%';

                }

                field("Shortcut Dimension 1 Filter"; Rec."Shortcut Dimension 1 Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Filter field.', Comment = '%';

                }
                field("Shortcut Dimension 2 Filter"; Rec."Shortcut Dimension 2 Filter")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Filter field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Closed By"; Rec."Closed By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Closed By field.', Comment = '%';

                }
                field("Closed Date"; Rec."Closed Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Closed Date field.', Comment = '%';

                }
                field("Closed Time"; Rec."Closed Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Closed Time field.', Comment = '%';

                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';

                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';

                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';

                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ToolTip = 'Specifies the value of the Total Amount field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(PayrollLines; PayrollSubform)
            {
                ApplicationArea = All;
                SubPageLink = "Payroll Period" = field("Payroll Period");
            }
        }
    }
    actions
    {
        // 1. Define the action container area
        area(Processing)
        {
            action(ProcessPayroll)
            {
                ApplicationArea = All;
                Caption = 'Process Payroll';
                ToolTip = 'Executes a process to Process Payroll';
                Image = Calculate;

                // 3. Make the action easy to find in the action bar
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                // 4. Run your custom logic when clicked
                trigger OnAction()

                begin
                    PayrollCodeunit.ProcessPayroll(Rec."Payroll Period", Rec."Shortcut Dimension 1 Filter", Rec."Shortcut Dimension 2 Filter", Rec."Employee Filter");
                end;
            }
            action(Payslip)
            {
                ApplicationArea = All;
                Caption = 'Print Payslip';
                ToolTip = 'Executes a process to Print the Payslip';
                Image = Payroll;

                // 3. Make the action easy to find in the action bar
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                // 4. Run your custom logic when clicked
                trigger OnAction()

                begin
                    Report.Run(Report::Payslip, true, false);
                end;
            }
            action(PayrollSummary)
            {
                ApplicationArea = All;
                Caption = 'Payroll Summary';
                ToolTip = 'Executes a process to Print the Payroll Summary report';
                Image = Payroll;

                // 3. Make the action easy to find in the action bar
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                // 4. Run your custom logic when clicked
                trigger OnAction()

                begin
                    PayrollLines.Reset();
                    PayrollLines.SetRange("Payroll Period", Rec."Payroll Period");
                    if PayrollLines.FindFirst() then
                        Report.Run(Report::PayrollSummary, true, false, PayrollLines);
                end;
            }

            action(ClosePayroll)
            {
                ApplicationArea = All;
                Caption = 'Close Payroll';
                ToolTip = 'Executes a process to close the payroll';
                Image = ClosePeriod;

                // 3. Make the action easy to find in the action bar
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                // 4. Run your custom logic when clicked
                trigger OnAction()

                begin
                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    //Rec."Approval Status" := Rec."Approval Status"::Closed
                end;
            }

            action(SendPaySlip)
            {
                ApplicationArea = All;
                Caption = 'Send Payslip';
                ToolTip = 'Executes a process to send the Payslip';
                Image = SendToMultiple;

                // 3. Make the action easy to find in the action bar
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                // 4. Run your custom logic when clicked
                trigger OnAction()
                var
                    SendPayslip: Codeunit SendPayslipProcessor;
                begin
                    SendPayslip.RunSendPaySlip(rec."Payroll Period");
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
                        if ApprovalMgt.ApproveDoc(Rec."Payroll Period") then begin
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
                    RunPageLink = "Table ID" = const(60021), "Document No." = field("Payroll Period");

                    //Visible = OpenApprovalEntriesExistForCurrUser;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    Visible = false;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Comment List";
                    RunPageLink = "Document Type" = const(0),
                                  "No." = field("Payroll Period"),
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
                    ApprovalEntries.SetRecordFilters(Database::PayrollHeader, 6, Format(Rec."Payroll Period"));
                    ApprovalEntries.Run;
                end;
            }


        }
    }

    trigger OnOpenPage()
    begin
        If UserSteup.Get(UserId) then
            if (UserSteup."Global Dimension 1 Code" <> '') then begin
                //UserSteup.TestField("Global Dimension 1 Code");

                //Rec.FilterGroup(2);
                //Rec.SetRange("Shortcut Dimension 1 Filter", UserSteup."Global Dimension 1 Code");
                //Rec.FilterGroup(0);
                IF (Rec."Approval Status" = Rec."Approval Status"::Closed) then
                    CurrPage.Editable := false;
            end;
    end;

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

    trigger OnDeleteRecord(): Boolean
    begin
        PayrollDetLines.Reset();
        PayrollDetLines.SetRange("Payroll Period", rec."Payroll Period");
        if PayrollDetLines.FindSet() then
            PayrollDetLines.DeleteAll();

        PayrollLines.Reset();
        PayrollLines.SetRange("Payroll Period", rec."Payroll Period");
        if PayrollLines.FindSet() then
            PayrollLines.DeleteAll();
    end;


    var
        UserSteup: Record "User Setup";
        EmployeeRec: Record Employee;
        PayrollCodeunit: Codeunit "PayrollCodeunite";
        PayrollHead: Record PayrollHeader;
        PayrollLines: Record PayrollLine;
        PayrollDetLines: Record PayrollDetailLine;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        EnableControl: Boolean;
        CheckPrevPeriodClose: Codeunit CheckPreviousPeriodClose;
}
