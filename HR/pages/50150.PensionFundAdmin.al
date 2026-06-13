namespace BILLENERGY.BILLENERGY;

page 50150 PensionFundAdmin
{
    ApplicationArea = All;
    Caption = 'Pension Fund Administrator';
    PageType = List;
    SourceTable = PensionFundAdmin;
    UsageCategory = Lists;
    Editable = true;
    InsertAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("PFA Code"; Rec."PFA Code")
                {
                    ToolTip = 'Specifies the value of the PFA Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
