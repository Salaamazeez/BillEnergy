namespace BILLENERGY.BILLENERGY;
using Microsoft.HumanResources.Employee;
using Microsoft.HumanResources.Setup;
using System.Security.User;
using Microsoft.Finance.Dimension;
using Microsoft.Sales.Comment;
using System.Automation;

page 50170 Overtime
{
    //ApplicationArea = All;
    Caption = 'Overtime';
    PageType = Document;
    SourceTable = OvertimeHeader;
    //UsageCategory = tasks;
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

                field("Global Dimension 1 Filter"; Rec."Global Dimension 1 Filter")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Filter field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Filter"; Rec."Global Dimension 2 Filter")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Filter field.', Comment = '%';
                    ApplicationArea = All;
                }

                field("Document No."; Rec."Paid Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Overtime Paid"; Rec."Overtime Paid")
                {
                    ToolTip = 'Specifies the value of the Overtime Paid field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                    ApplicationArea = All;
                    //Visible = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    ApplicationArea = All;
                    //Visible = false;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                    ApplicationArea = All;
                    //Visible = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                    ApplicationArea = All;
                    //Visible = false;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ToolTip = 'Specifies the value of the Total Amount field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
            }

            part(Overtimelines; OvertimeSubform)
            {
                ApplicationArea = All;
                SubPageLink = "Period Code" = field("Period Code");
            }


        }
    }
    actions
    {
        // 1. Define the action container area
        area(Processing)
        {
            // 2. Define your action button
            action(UploadOvertimeVariables)
            {
                ApplicationArea = All;
                Caption = 'Upload overtime Variables';
                ToolTip = 'upload  the overtime Variables for rig staff ';
                Image = ImportLog;

                // 3. Make the action easy to find in the action bar
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                // 4. Run your custom logic when clicked
                trigger OnAction()
                begin
                    Rec."Approval Status" := Rec."Approval Status"::Open;
                    Rec.TestField("Global Dimension 1 Filter");
                    Rec.TestField("Period Code");
                    Report.Run(Report::ImportOvertimeVariables);
                end;
            }

            action(ReportOvertime)
            {
                ApplicationArea = All;
                Caption = 'Overtime Summary';
                ToolTip = 'Executes a process to Print the Overtime Summary for rig staff';
                Image = Payment;

                // 3. Make the action easy to find in the action bar
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                // 4. Run your custom logic when clicked
                trigger OnAction()

                begin
                    Overtimeline.Reset();
                    Overtimeline.SetRange("Period Code", rec."Period Code");
                    if Overtimeline.FindFirst() then
                        Report.Run(Report::OvertimeSummary, true, false, Overtimeline);
                end;
            }
            action(CalculateOvertime)
            {
                ApplicationArea = All;
                Caption = 'Calculate Overtime';
                ToolTip = 'Executes a process to calculate the overtime for rig staff';
                Image = Calculate;

                // 3. Make the action easy to find in the action bar
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                // 4. Run your custom logic when clicked
                trigger OnAction()
                begin
                    //If (PayPeriods = '') then
                    //Error(Text002);
                    //IF (Not CheckPrevPeriodClose.CheckPreviouOvertime(Rec."Period Code")) then
                    //  Error(LabelClose);

                    Rec."Approval Status" := Rec."Approval Status"::Open;
                    Rec.TestField("Global Dimension 1 Filter");
                    Rec.TestField("Period Code");

                    rec.TestField("Period Code");

                    IF HRSetup.Get() then
                        HRSetup.TestField("Overtime Rate");

                    PayElement.Reset();
                    PayElement.SetFilter("Is Gross", '%1', True);
                    If (Not PayElement.FindFirst()) then
                        Error(Text003);

                    Overtimeline.RESET;
                    Overtimeline.SETFILTER("Period Code", rec."Period Code");

                    IF (EmployeeNo <> '') THEN
                        Overtimeline.SETRANGE("Employee No.", EmployeeNo);
                    IF (rec."Global Dimension 1 Filter" <> '') THEN
                        Overtimeline.SETRANGE("Global Dimension 1 Code", rec."Global Dimension 1 Filter");
                    IF (Rec."Global Dimension 2 Filter" <> '') THEN
                        Overtimeline.SETRANGE("Global Dimension 2 Code", rec."Global Dimension 2 Filter");

                    Window.OPEN('Processing Overtime for Employee No.  #1########\' +
                                  'for Period  #2########\');

                    IF Overtimeline.FINDSET THEN BEGIN
                        //Employee.TESTFIELD("Employee Category");
                        REPEAT
                            NetPay := 0;
                            SumPension := 0;
                            Paye := 0;
                            Pension := 0;
                            Clear(Employee);
                            Clear(DaysInMonth);

                            DaysInMonth := PayrollCodeunit.GetNoOfDaysInPayPeriod(rec."Period Code");

                            Window.UPDATE(1, Overtimeline."Employee No.");
                            Window.UPDATE(2, PayPeriods);

                            //Get the Gross Salary of the Employee
                            //Overtimeline.TestField("Days Worked");

                            Overtimeline.TestField("Extra Days Worked");

                            If Employee.get(Overtimeline."Employee No.") then
                                Employee.TestField("Emplymt. Contract Code");

                            //Calculate Pension
                            SalSetupLine2.Reset();
                            SalSetupLine2.SetRange("Salary Code", Employee."Emplymt. Contract Code");
                            SalSetupLine2.Setfilter("Function of Pension", '%1', true);
                            If SalSetupLine2.Findset() then Begin
                                repeat
                                    SalSetupLine2.TestField(Amount);
                                    SumPension += SalSetupLine2.Amount;
                                until SalSetupLine2.Next() = 0;
                                Pension := (HRSetup."Pension Employee %" / 100) * SumPension;
                                Overtimeline.Pension := Pension;
                                Overtimeline.Modify();
                            end;

                            SalSetupLine.Reset();
                            SalSetupLine.SetRange("Salary Code", Employee."Emplymt. Contract Code");
                            SalSetupLine.SetRange("Element Code", PayElement."Element Code");
                            If SalSetupLine.FindFirst() then BEGIN
                                SalSetupLine.TestField(Amount);

                                //Get PAYE
                                Paye := PayrollCodeunit.CalculateOTTax(SalSetupLine.Amount, Employee, Overtimeline."Period Code", SumPension);
                                Overtimeline.PAYE := paye;
                                //Calculate Overtime
                                Overtimeline."Overtime Amount" := ROUND((((SalSetupLine.Amount - (Pension + Paye)) / DaysInMonth) *
                                                ((HRSetup."Overtime Rate" / 100) * overtimeline."Extra Days Worked")), 0.01, '>');
                                Overtimeline."Days Worked" := DaysInMonth;
                                Overtimeline."Net Pay" := ROUND(SalSetupLine.Amount - (Pension + Paye), 0.01, '>');
                                Overtimeline.Modify();
                            end;
                        until Overtimeline.Next() = 0;
                        Window.Close();
                    end;
                end;
            }
            action(CloseOvertime)
            {
                ApplicationArea = All;
                Caption = 'Close Overtime';
                ToolTip = 'Close the Overtime';
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
                    ApprovalEntries.SetRecordFilters(Database::OvertimeHeader, 6, Rec."Period Code");
                    ApprovalEntries.Run;
                end;
            }

        }

    }

    trigger OnOpenPage()
    begin
        If UserSteup.Get(UserId) then;
        //UserSteup.TestField("Global Dimension 1 Code");

        //Rec.FilterGroup(2);
        //Rec.SetRange("Global Dimension 1 Filter", UserSteup."Global Dimension 1 Code");
        //Rec.FilterGroup(0);

        IF (Rec."Approval Status" = Rec."Approval Status"::Closed) then
            CurrPage.Editable := false;
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

    var
        CheckPrevPeriodClose: Codeunit CheckPreviousPeriodClose;
        LabelClose: Label 'Previous Overtime must be close first';
        UserSteup: Record "User Setup";
        Text001: Label 'Processing overtime for Rig Employee No. #1######\';
        Text002: Label 'Period Filter cannot be empty';
        Text003: Label 'Gross Pay Element code is not setup in the Payroll Element page';
        Employee: Record Employee;
        Dimval: Record "Dimension Value";
        Overtimeline: Record Overtimeline;
        SalSetupLine: Record SalarySetupLine;
        SalSetupLine2: Record SalarySetupLine;
        PayElement: Record PayrollElement;
        HRSetup: Record "Human Resources Setup";
        PayrollCodeunit: Codeunit PayrollCodeunite;
        EmployeeNo: Code[20];
        GlobalDim1Code: Code[50];
        GlobalDim2Code: Code[50];
        Window: Dialog;
        PayPeriods: Code[10];
        DaysInMonth: Integer;
        NetPay: Decimal;
        Paye: Decimal;
        SumPension: Decimal;
        Pension: Decimal;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        EnableControl: Boolean;


}
