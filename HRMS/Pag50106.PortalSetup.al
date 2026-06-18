page 50106 "Portal Setup"
{
    ApplicationArea = All;
    Caption = 'Portal Setup';
    PageType = Card;
    SourceTable = "Portal Mgt";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Base Url"; Rec."Base Url")
                {
                    ToolTip = 'Specifies the value of the Base Url field.', Comment = '%';
                }
                field("Employee Url"; Rec."Employee Url")
                {
                    ToolTip = 'Specifies the value of the Employee Url field.', Comment = '%';
                }
                field("Vendor Url"; Rec."Vendor Url")
                {
                    ToolTip = 'Specifies the value of the Vendor Url field.', Comment = '%';
                }
                field("Authorization Key"; Rec."Authorization Key")
                {
                    ToolTip = 'Specifies the value of the Authorization Key field.', Comment = '%';
                }
                  field("Update Employee Status Url";Rec."Update Employee Status Url")
                {
                    ToolTip = 'Specifies the value of the Update Employee Status Url field.', Comment = '%';
                }
            }
        }
    }
}
