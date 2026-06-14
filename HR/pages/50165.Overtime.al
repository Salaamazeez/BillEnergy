namespace BILLENERGY.BILLENERGY;
using Microsoft.HumanResources.Employee;
using Microsoft.HumanResources.Setup;
using Microsoft.Finance.Dimension;

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
                    Report.Run(Report::ImportOvertimeVariables);
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

                            SalSetupLine.Reset();
                            SalSetupLine.SetRange("Salary Code", Employee."Emplymt. Contract Code");
                            SalSetupLine.SetRange("Element Code", PayElement."Element Code");
                            If SalSetupLine.FindFirst() then BEGIN
                                SalSetupLine.TestField(Amount);
                                Overtimeline."Overtime Amount" := ROUND(((SalSetupLine.Amount / DaysInMonth) *
                                                ((HRSetup."Overtime Rate" / 100) * overtimeline."Extra Days Worked")), 0.01, '>');
                                Overtimeline."Days Worked" := DaysInMonth;
                                Overtimeline.Modify();
                            end;
                        until Overtimeline.Next() = 0;
                        Window.Close();
                    end;
                end;
            }
        }

    }

    var
        Text001: Label 'Processing overtime for Rig Employee No. #1######\';
        Text002: Label 'Period Filter cannot be empty';
        Text003: Label 'Gross Pay Element code is not setup in the Payroll Element page';
        Employee: Record Employee;
        Dimval: Record "Dimension Value";
        Overtimeline: Record Overtimeline;
        SalSetupLine: Record SalarySetupLine;
        PayElement: Record PayrollElement;
        HRSetup: Record "Human Resources Setup";
        PayrollCodeunit: Codeunit PayrollCodeunite;
        EmployeeNo: Code[20];
        GlobalDim1Code: Code[50];
        GlobalDim2Code: Code[50];
        Window: Dialog;
        PayPeriods: Code[10];
        DaysInMonth: Integer;

}
