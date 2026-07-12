namespace BILLENERGY.BILLENERGY;
using Microsoft.HumanResources.Employee;
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
        CheckPrevPeriodClose: Codeunit CheckPreviousPeriodClose;
}
