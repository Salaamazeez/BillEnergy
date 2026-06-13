namespace BILLENERGY.BILLENERGY;
using Microsoft.HumanResources.Employee;
using Microsoft.Finance.Dimension;
using Microsoft.HumanResources.Setup;

page 50159 Overtime
{
    ApplicationArea = All;
    Caption = 'Overtime';
    PageType = List;
    SourceTable = Overtime;
    UsageCategory = Tasks;
    SourceTableView = where("Overtime Closed" = filter(false));

    layout
    {
        area(Content)
        {
            group(Filter)
            {
                Caption = 'Filters';

                //Add the global variable as a field
                field(PayPeriods; PayPeriods)
                {
                    ApplicationArea = All;
                    Caption = 'Period Filter';
                    ToolTip = 'look up to pick the period for the overtime';
                    TableRelation = PayrollPeriods."Period Code";

                    trigger OnValidate()
                    begin
                    end;
                }
                field(EmployeeNo; EmployeeNo)
                {
                    ApplicationArea = All;
                    Caption = 'Employee No. Filter';
                    ToolTip = 'look up to pick the employee No.';
                    TableRelation = Employee."No.";

                    trigger OnValidate()
                    begin
                    end;
                }
                field(GlobalDim1Code; GlobalDim1Code)
                {
                    ApplicationArea = All;
                    Caption = 'Branch Filter';
                    ToolTip = 'look up to pick the employee Branch for the overtime';
                    //CaptionClass = '1,1,1';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

                    trigger OnValidate()
                    begin
                    end;
                }
                field(GlobalDim2Code; GlobalDim2Code)
                {
                    ApplicationArea = All;
                    Caption = 'Department Filter';
                    ToolTip = 'look up to pick the employee Department for the overtime';
                    //CaptionClass = '1,1,1';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

                    trigger OnValidate()
                    begin
                    end;
                }
            }

            repeater(General)
            {
                field("Period Code"; Rec."Period Code")
                {
                    ToolTip = 'Specifies the value of the Period Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Element Code"; Rec."Element Code")
                {
                    ToolTip = 'Specifies the value of the Element Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Element Name"; Rec."Element Name")
                {
                    ToolTip = 'Specifies the value of the Element Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Department code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Department code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Days Worked"; Rec."Days Worked")
                {
                    ToolTip = 'Specifies the value of the Days Worked field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Extra Days Worked"; Rec."Extra Days Worked")
                {
                    ToolTip = 'Specifies the value of the Extra Days Worked field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Gross Pay"; Rec."Gross Pay")
                {
                    ToolTip = 'Specifies the value of the Gross Pay field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Overtime Amount"; Rec."Overtime Amount")
                {
                    ToolTip = 'Specifies the value of the Overtime Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Overtime Paid"; Rec."Overtime Paid")
                {
                    ToolTip = 'Specifies the value of the Overtime Paid field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Overtime Closed"; Rec."Overtime Closed")
                {
                    ToolTip = 'Specifies the value of the Overtime Closed field.', Comment = '%';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                    Visible = false;
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                    Visible = false;
                    ApplicationArea = All;
                }
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
                    If (PayPeriods = '') then
                        Error(Text002);

                    IF HRSetup.Get() then
                        HRSetup.TestField("Overtime Rate");

                    PayElement.Reset();
                    PayElement.SetFilter("Is Gross", '%1', True);
                    If (Not PayElement.FindFirst()) then
                        Error(Text003);

                    Overtime.RESET;
                    Overtime.SETFILTER("Period Code", PayPeriods);

                    IF (EmployeeNo <> '') THEN
                        Overtime.SETRANGE("Employee No.", EmployeeNo);
                    IF (GlobalDim1Code <> '') THEN
                        Overtime.SETRANGE("Global Dimension 1 Code", GlobalDim1Code);
                    IF (GlobalDim2Code <> '') THEN
                        Overtime.SETRANGE("Global Dimension 2 Code", GlobalDim2Code);

                    Window.OPEN('Processing Overtime for Employee No.  #1########\' +
                                  'for Period  #2########\');

                    IF Overtime.FINDSET THEN BEGIN
                        //Employee.TESTFIELD("Employee Category");
                        REPEAT
                            Clear(Employee);

                            Window.UPDATE(1, Overtime."Employee No.");
                            Window.UPDATE(2, PayPeriods);

                            //Get the Gross Salary of the Employee
                            Rec.TestField("Days Worked");
                            Rec.TestField("Extra Days Worked");

                            If Employee.get(Overtime."Employee No.") then
                                Employee.TestField("Emplymt. Contract Code");

                            SalSetupLine.Reset();
                            SalSetupLine.SetRange("Salary Code", Employee."Emplymt. Contract Code");
                            SalSetupLine.SetRange("Element Code", PayElement."Element Code");
                            If SalSetupLine.FindFirst() then BEGIN
                                SalSetupLine.TestField(Amount);
                                Rec."Overtime Amount" := ROUND((SalSetupLine.Amount / Rec."Days Worked" * (HRSetup."Overtime Rate" * Rec."Extra Days Worked")), 0.01, '>');
                                Overtime.Modify();
                            end;
                        until Overtime.Next() = 0;
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
        Dim: Record "Dimension Value";
        Overtime: Record Overtime;
        SalSetupLine: Record SalarySetupLine;
        PayElement: Record PayrollElement;
        HRSetup: Record "Human Resources Setup";
        EmployeeNo: Code[20];
        GlobalDim1Code: Code[50];
        GlobalDim2Code: Code[50];
        Window: Dialog;
        PayPeriods: Code[10];


}
