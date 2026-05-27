namespace BILLENERGY.BILLENERGY;

page 50157 PayrollDetailLines
{
    ApplicationArea = All;
    Caption = 'PayrollDetailLines';
    PageType = List;
    SourceTable = PayrollDetailLine;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
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
                field("Element Name"; Rec."Element Name")
                {
                    ToolTip = 'Specifies the value of the Element Name field.', Comment = '%';
                }
                field("Element Code"; Rec."Element Code")
                {
                    ToolTip = 'Specifies the value of the Element Code field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Book Amount"; Rec."Book Amount")
                {
                    ToolTip = 'Specifies the value of the Book Amount field.', Comment = '%';
                }
                field("Payable Amount"; Rec."Payable Amount")
                {
                    ToolTip = 'Specifies the value of the Payable Amount field.', Comment = '%';
                }

                field("Salalry Code"; Rec."Salary Code")
                {
                    ToolTip = 'Specifies the value of the Salalry Code field.', Comment = '%';
                }


            }
        }
    }
}
