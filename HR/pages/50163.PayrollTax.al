namespace BILLENERGY.BILLENERGY;

page 50163 PayrollTax
{
    ApplicationArea = All;
    Caption = 'Payroll Tax';
    PageType = Document;
    SourceTable = PayrollTaxHeader;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Tax Code"; Rec."Tax Code")
                {
                    ToolTip = 'Specifies the value of the Tax Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Rent Relief Cap"; Rec."Rent Relief Cap")
                {
                    ToolTip = 'Specifies the value of the Rent Relief Cap field.', Comment = '%';
                }
                field("Rent Relief%"; Rec."Rent Relief%")
                {
                    ToolTip = 'Specifies the value of the Rent Relief% field.', Comment = '%';
                }
                field(Open; Rec.Open)
                {
                    ToolTip = 'Specifies the value of the Open field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }


            }
            part(PayrollTaxlines; PayrollTaxLineSubform)
            {
                ApplicationArea = All;
                SubPageLink = "Tax Code" = field("Tax Code");
            }

        }
    }
}
