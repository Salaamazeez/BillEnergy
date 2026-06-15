namespace BILLENERGY.BILLENERGY;

page 50163 PayrollTax
{
    ApplicationArea = All;
    Caption = 'Payroll Tax';
    PageType = Document;
    SourceTable = PayrollTaxHeader;
    UsageCategory = Tasks;
    InsertAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            group(General)
            {

                Caption = 'General';

                field("Tax Code"; Rec."Tax Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Code field.', Comment = '%';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';

                }
                field("Rent Relief Cap"; Rec."Rent Relief Cap")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rent Relief Cap field.', Comment = '%';

                }
                field("Rent Relief%"; Rec."Rent Relief%")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rent Relief% field.', Comment = '%';

                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Open field.', Comment = '%';

                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';

                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';

                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';

                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
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
