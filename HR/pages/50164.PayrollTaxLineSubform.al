namespace BILLENERGY.BILLENERGY;

page 50164 PayrollTaxLineSubform
{
    //ApplicationArea = All;
    Caption = 'Payroll TaxLine Subform';
    PageType = ListPart;
    SourceTable = PayrollTaxLine;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Tax Code"; Rec."Tax Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Code field.', Comment = '%';
                    Editable = false;
                    Visible = false;
                }

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    Editable = false;
                    Visible = false;
                }
                field("Lower Limit"; Rec."Lower Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lower Limit field.', Comment = '%';

                }
                field("Upper Limit"; Rec."Upper Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Upper Limit field.', Comment = '%';

                }
                field("Tax Slab%"; Rec."Tax Slab%")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Slab% field.', Comment = '%';

                }
                field("Limit Amount"; Rec."Limit Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Limit Amount field.', Comment = '%';

                }

            }
        }
    }
}
