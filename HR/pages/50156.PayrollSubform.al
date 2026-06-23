namespace BILLENERGY.BILLENERGY;

page 50156 PayrollSubform
{
    //ApplicationArea = All;
    Caption = 'Payroll Subform';
    PageType = ListPart;
    SourceTable = PayrollLine;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ToolTip = 'Specifies the value of the Employment Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Book Amount"; Rec."Book Amount")
                {
                    ToolTip = 'Specifies the value of the Book Amount field.', Comment = '%';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        SalarySetup: Record SalarySetupLine;
                        SalarySetupList: Page SalarySetupList;
                    begin

                        SalarySetup.SetRange("Salary Code", rec."Employment Contract Code");
                        //SalarySetupLine.SetFilter("Element Code", '%1', '600');
                        SalarySetupList.SetTableView(SalarySetup);
                        SalarySetupList.Run();
                    end;
                }
                field("Payable Amount"; Rec."Payable Amount")
                {
                    ToolTip = 'Specifies the value of the Payable Amount field.', Comment = '%';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        PayrollDetailLine: Record PayrollDetailLine;
                        PayrollDetailList: Page PayrollDetailLines;
                    begin

                        PayrollDetailLine.SetRange("Payroll Period", Rec."Payroll Period");
                        PayrollDetailLine.SetRange("Employee No.", rec."Employee Code");
                        PayrollDetailLine.SetFilter("Part of Payable Value", '%1', true);
                        PayrollDetailList.SetTableView(PayrollDetailLine);
                        PayrollDetailList.Run();
                    end;
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Salary Code"; Rec."Salary Code")
                {
                    ToolTip = 'Specifies the value of the Salary Code field.', Comment = '%';
                    ApplicationArea = All;

                }

                field("Working Days"; Rec."Working Days")
                {
                    ToolTip = 'Specifies the value of the Working Days field.', Comment = '%';
                    ApplicationArea = All;
                }

                field("No. of Worked Days"; Rec."No. of Worked Days")
                {
                    ToolTip = 'Specifies the value of the No. of Worked Days field.', Comment = '%';
                    ApplicationArea = All;
                }

                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    ApplicationArea = All;
                    Visible = false;
                }
            }

        }

    }

    trigger OnDeleteRecord(): Boolean
    begin
        PayrollDetLines.Reset();
        PayrollDetLines.SetRange("Payroll Period", rec."Payroll Period");
        if PayrollDetLines.FindSet() then
            PayrollDetLines.DeleteAll();
    end;

    var
        PayrollDetLines: Record PayrollDetailLine;

}
