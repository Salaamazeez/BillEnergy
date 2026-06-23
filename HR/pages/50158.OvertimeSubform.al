namespace BILLENERGY.BILLENERGY;
using Microsoft.HumanResources.Employee;
using Microsoft.Finance.Dimension;
using Microsoft.HumanResources.Setup;

page 50159 OvertimeSubform
{
    ApplicationArea = All;
    Caption = 'Overtime Subform';
    PageType = ListPart;
    SourceTable = Overtimeline;
    AutoSplitKey = true;
    //UsageCategory = Tasks;
    //SourceTableView = where("Overtime Closed" = filter(false));

    layout
    {
        area(Content)
        {
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
                field(PAYE; Rec.PAYE)
                {
                    ToolTip = 'Specifies the value of the PAYE field.', Comment = '%';
                    ApplicationArea = All;
                }

                field(Pension; Rec.Pension)
                {
                    ToolTip = 'Specifies the value of the Pension field.', Comment = '%';
                    ApplicationArea = All;
                }

                field("Net Pay"; Rec."Net Pay")
                {
                    ToolTip = 'Specifies the value of the Net Pay field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Overtime Amount"; Rec."Overtime Amount")
                {
                    ToolTip = 'Specifies the value of the Overtime Amount field.', Comment = '%';
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

    var
        Text001: Label 'Processing overtime for Rig Employee No. #1######\';
        Text002: Label 'Period Filter cannot be empty';
        Text003: Label 'Gross Pay Element code is not setup in the Payroll Element page';
        Employee: Record Employee;
        Dim: Record "Dimension Value";
        Overtime: Record Overtimeline;
        SalSetupLine: Record SalarySetupLine;
        PayElement: Record PayrollElement;
        HRSetup: Record "Human Resources Setup";
        EmployeeNo: Code[20];
        GlobalDim1Code: Code[50];
        GlobalDim2Code: Code[50];
        Window: Dialog;
        PayPeriods: Code[10];


}
