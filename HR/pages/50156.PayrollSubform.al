namespace BILLENERGY.BILLENERGY;

page 50156 PayrollSubform
{
    ApplicationArea = All;
    Caption = 'PayrollSubform';
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
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.', Comment = '%';
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ToolTip = 'Specifies the value of the Employment Date field.', Comment = '%';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.', Comment = '%';
                }
                field("Book Amount"; Rec."Book Amount")
                {
                    ToolTip = 'Specifies the value of the Book Amount field.', Comment = '%';
                }
                field("Payable Amount"; Rec."Payable Amount")
                {
                    ToolTip = 'Specifies the value of the Payable Amount field.', Comment = '%';

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
                }
                field("Salary Code"; Rec."Salary Code")
                {
                    ToolTip = 'Specifies the value of the Salary Code field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Employee Type"; Rec."Employee Type")
                {
                    ToolTip = 'Specifies the value of the Employee Type field.', Comment = '%';
                }
                field("Absent  (Days)"; Rec."Absent  (Days)")
                {
                    ToolTip = 'Specifies the value of the Absent  (Days) field.', Comment = '%';
                }
                field("Late Days"; Rec."Late Days")
                {
                    ToolTip = 'Specifies the value of the Late Days field.', Comment = '%';
                }
                field("Extra Days Worked"; Rec."Extra Days Worked")
                {
                    ToolTip = 'Specifies the value of the Extra Days Worked field.', Comment = '%';
                }
            }
        }
    }
}
