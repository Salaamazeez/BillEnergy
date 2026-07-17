namespace BILLENERGY.BILLENERGY;
using Microsoft.HumanResources.Employee;
using Microsoft.Finance.Dimension;
using System.Security.User;

page 50168 PayrollOthervariables
{
    ApplicationArea = All;
    Caption = 'Payroll Other Variables';
    PageType = List;
    SourceTable = PayrollOthervariables;
    UsageCategory = Tasks;

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
                        ApplyPayrollPeriodFilter();
                    end;
                }
                field(EmployeeNo; EmployeeNo)
                {
                    ApplicationArea = All;
                    Caption = 'Employee No. Filter';
                    ToolTip = 'look up to pick the employee No.';
                    TableRelation = employee."No.";

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
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Element Code"; Rec."Element Code")
                {
                    ToolTip = 'Specifies the value of the Element Code field.', Comment = '%';
                }
                field("Element Name"; Rec."Element Name")
                {
                    ToolTip = 'Specifies the value of the Element Name field.', Comment = '%';
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.', Comment = '%';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.', Comment = '%';
                }
                field("Maximum Working Hour"; Rec."Maximum Working Hour")
                {
                    ToolTip = 'Specifies the value of the Maximum working Hour field.', Comment = '%';
                }
                field("Days in the Month"; Rec."Days in the Month")
                {
                    ToolTip = 'Specifies the value of the Days in the Month field.', Comment = '%';
                }
                field("No. of Working Hour"; Rec."No. of Working Hour")
                {
                    ToolTip = 'Specifies the value of the No. of working Hour field.', Comment = '%';
                }
                /*
                field("Hourly Rate"; Rec."Hourly Rate")
                {
                    ToolTip = 'Specifies the value of the Hourly Rate field.', Comment = '%';
                }
                */
                field("Hours/Days Late"; Rec."Hours/Days Late")
                {
                    ToolTip = 'Specifies the value of the Hours Late/Days Absent field.', Comment = '%';
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


            action(UploadPayrollOtherVariables)
            {
                ApplicationArea = All;
                Caption = 'Upload Payroll Other Variables';
                ToolTip = 'upload  the Payroll Other Variables for rig staff ';
                Image = ImportLog;

                // 3. Make the action easy to find in the action bar
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                // 4. Run your custom logic when clicked
                trigger OnAction()

                begin
                    Report.Run(Report::ImportPayrollOtherVar);
                end;

            }
        }
    }
    trigger OnOpenPage()
    begin
        If UserSteup.Get(UserId) then;
        IF (UserSteup."Global Dimension 1 Code" <> '') then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Global Dimension 1 Code", UserSteup."Global Dimension 1 Code");
            Rec.FilterGroup(0);
        end;

        ApplyPayrollPeriodFilter();

    end;

    trigger OnAfterGetRecord()
    begin

    end;

    local procedure ApplyPayrollPeriodFilter()

    begin
        // FilterGroup(2) hides the code-applied filter from the user's manual filter pane 
        // to prevent them from accidentally clearing it out.
        Rec.FilterGroup(2);

        if (PayPeriods <> '') then
            Rec.SetRange("Payroll Period", PayPeriods) // Replace with your actual table field
        else
            Rec.SetRange("Payroll Period"); // Clears filter if global variable is deleted

        Rec.FilterGroup(0); // Return back to standard UI filter group

        // 4. Forces the Business Central UI layout grid to instantly refresh data
        CurrPage.Update(false);
    end;

    var
        UserSteup: Record "User Setup";
        ErrorPeriod: Label 'Period Filter cannot be empty';
        ErrorBranch: Label 'Branch Filter cannot be empty';
        Text003: Label 'Gross Pay Element code is not setup in the Payroll Element page';
        SalSetupLine: Record SalarySetupLine;
        PayElement: Record PayrollElement;

        EmployeeRec: Record Employee;
        DimensionValue: Record "Dimension Value";
        PayrollPeriod: Record PayrollPeriods;
        EmployeeNo: Code[20];
        GlobalDim1Code: Code[50];
        GlobalDim2Code: Code[50];
        Window: Dialog;
        PayPeriods: Code[10];
}
