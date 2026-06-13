page 50131 PerfoamceAppraiser
{
    ApplicationArea = All;
    Caption = 'Perfoamce Appraiser';
    PageType = Document;
    SourceTable = PerformanceAppraisalHeader;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name', Comment = '%';
                    ApplicationArea = All;
                }
                field("Line Manager No."; Rec."Line Manager No.")
                {
                    ToolTip = 'Specifies the value of the Line Manager No.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Line Manager Name"; Rec."Line Manager Name")
                {
                    ToolTip = 'Specifies the value of the Line Manager Name', Comment = '%';
                    ApplicationArea = All;
                }
                field("Appraisal Year"; Rec."Appraisal Year")
                {
                    ToolTip = 'Specifies the value of the Appraisal Year field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Appraiser Status', Comment = '%';
                    ApplicationArea = All;
                }
                field("No. of Objectives"; Rec."No. of Objectives")
                {
                    ToolTip = 'Specifies the value of the No. of Objectives', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code', Comment = '%';
                    ApplicationArea = All;
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed', Comment = '%';
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By ', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    ToolTip = 'Specifies the value of the Creation Time.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ToolTip = 'Specifies the value of the Last Modified By', Comment = '%';
                    ApplicationArea = All;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ToolTip = 'Specifies the value of the Last Modified Date', Comment = '%';
                    ApplicationArea = All;
                }
                field("Last Modified time"; Rec."Last Modified time")
                {
                    ToolTip = 'Specifies the value of the Last Modified Time', Comment = '%';
                    ApplicationArea = All;
                }
            }
            part(PerformanceAppraiserLine; PerformanceAppraiserSubform)
            {
                ApplicationArea = All;
                Caption = 'Performance Appraiser Line';
                SubPageLink = "Employee No." = field("Employee No."), "Appraisaer Year" = field("Appraisal Year");
                UpdatePropagation = Both;
            }
            group(DevelopmentalPlan)
            {
                Caption = 'Developmental Plan';

                field("Area"; Rec."Area")
                {
                    ToolTip = 'Specifies the value of the Area', Comment = '%';
                    ApplicationArea = All;
                }
                field("Actions"; Rec."Actions")
                {
                    ToolTip = 'Specifies the value of the Actions', Comment = '%';
                    ApplicationArea = All;
                }
                field("Expected Completon Date"; Rec."Expected Completon Date")
                {
                    ToolTip = 'Specifies the value of the Expected Completon Date', Comment = '%';
                    ApplicationArea = All;
                }
            }
            group(MidYearAppraiser)
            {
                Caption = 'Mid-Year Appraiser';

                field("Employee Progress update"; Rec."Employee Progress update")
                {
                    ToolTip = 'Specifies the value of the Employee Progress update', Comment = '%';
                    ApplicationArea = All;
                }
                field("Emp. Mid-Year Dev. Plan Update"; Rec."Emp. Mid-Year Dev. Plan Update")
                {
                    ToolTip = 'Specifies the value of the Emp. Mid-Year Dev. Plan Update', Comment = '%';
                    ApplicationArea = All;
                }
                field("Manager Progress Update"; Rec."Manager Progress Update")
                {
                    ToolTip = 'Specifies the value of the Manager Progress Update field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Mgr. Mid-Year Dev. Plan Update"; Rec."Mgr. Mid-Year Dev. Plan Update")
                {
                    ToolTip = 'Specifies the value of the Mgr. Mid-Year Dev. Plan Update', Comment = '%';
                    ApplicationArea = All;
                }
            }
            group(EndYearFinalEvaluation)
            {
                Caption = 'End-Year Final Evaluation';


                field("Employee Rating%"; Rec."Employee Rating%")
                {
                    ToolTip = 'Specifies the value of the Employee Rating in percentage', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Final Rating"; Rec."Employee Final Rating")
                {
                    ToolTip = 'Specifies the value of the Employee Final Rating', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Final Comment"; Rec."Employee Final Comment")
                {
                    ToolTip = 'Specifies the value of the Employee Final Comment', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Sign-off"; Rec."Employee Sign-off")
                {
                    ToolTip = 'Specifies the value of the Employee Sign-off', Comment = '%';
                    ApplicationArea = All;
                }
                field("Manager Rating%"; Rec."Manager Rating%")
                {
                    ToolTip = 'Specifies the value of the manager Rating in percentage', Comment = '%';
                    ApplicationArea = All;
                }
                field("Manager Final Rating"; Rec."Manager Final Rating")
                {
                    ToolTip = 'Specifies the value of the Manager Final Rating', Comment = '%';
                    ApplicationArea = All;
                }
                field("Manager Final Comment"; Rec."Manager Final Comment")
                {
                    ToolTip = 'Specifies the value of the Manager Final Comment', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
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
                            Rec.CheckMandatoryFileds();
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
                    begin
                        Rec.CheckMandatoryFileds();
                        ;
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
                        if ApprovalMgt.ApproveDoc(Format(Rec."Appraisal Year")) then begin
                            Rec.Status := Rec.Status::Approved;
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
            }
            action(manualRelease)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                //Visible = IsReleaseVisible;
                trigger OnAction()
                begin
                    rec.PerformManualRelease();
                end;
            }
            action(ManualReopen)
            {
                Caption = 'Reopen';
                Image = ReOpen;
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                //Visible = IsReopenVisible;
                trigger OnAction()
                begin
                    rec.PerformManualReopen();
                end;
            }
            action(ManualClosed)
            {
                Caption = 'Close Appraiser';
                Image = Closed;
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Visible = IsCloseVisible;
                trigger OnAction()
                begin
                    rec.PerformManualclose();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin

        if rec.Closed then
            CurrPage.Editable(false)
        else
            CurrPage.Editable(true);

        HRSetup.Get();
        HRSetup.TestField("Appraisal Year");
        HRSetup.TestField("Objective Setting Start Date");
        HRSetup.TestField("Objective Setting End Date");
        HRSetup.TestField("Mid-Year Review Start Date");
        HRSetup.TestField("Mid-Year Review End Date");
        HRSetup.TestField("Year End Evaluation Start Date");
        HRSetup.TestField("Year End Evaluation End Date");

        Evaluate(AppraiserYear, FORMAT(Date2DMY(Today, 3)));

        IF (AppraiserYear <> HRSetup."Appraisal Year") then
            ERROR(ErrorAppraiserYear, HRSetup."Appraisal Year", AppraiserYear);

        If (TODAY >= HRSetup."Objective Setting Start Date") AND (Today <= HRSetup."Objective Setting End Date") then begin
            GeneralFastTab := true;
            DevPlanFastTab := true;
        end
        else begin
            GeneralFastTab := false;
            DevPlanFastTab := false;
        end;

        If (TODAY >= HRSetup."Mid-Year Review Start Date") AND (Today <= HRSetup."Mid-Year Review End Date") then
            MidYearFastTab := true
        else
            MidYearFastTab := false;

        If (TODAY >= HRSetup."Year End Evaluation Start Date") AND (Today <= HRSetup."Year End Evaluation End Date") then
            EndYearFastTab := true
        else
            EndYearFastTab := false;
    end;


    trigger OnAfterGetRecord()
    begin
        if rec.Closed then
            CurrPage.Editable(false)
        else
            CurrPage.Editable(true);
    end;

    var
        HRSetup: Record "Human Resources Setup";
        AppraiserYear: Integer;
        GeneralFastTab: Boolean;
        DevPlanFastTab: Boolean;
        MidYearFastTab: Boolean;
        EndYearFastTab: Boolean;

        IsSendvisible: Boolean;
        IsCloseVisible: Boolean;
        ErrorAppraiserYear: Label 'The Appraiser Year in the Human Resource Setup %1 is not same as the current year %2. contact the system Administrator to update the Appraiser year in the Human Resource Setup.';
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        EnableControl: Boolean;

}
