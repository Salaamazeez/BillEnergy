namespace BILLENERGY.BILLENERGY;
using Microsoft.HumanResources.Employee;
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
        }
    }

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
}
