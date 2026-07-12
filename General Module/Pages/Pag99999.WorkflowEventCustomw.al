namespace BILLENERGY.BILLENERGY;

using System.Automation;

page 99999 "Workflow Event Customw"
{
    ApplicationArea = All;
    Caption = 'Workflow Event Custom';
    PageType = List;
    SourceTable = "Workflow Event";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the workflow event that comes before the workflow event in the workflow sequence.';
                }
                field("Dynamic Req. Page Entity Name"; Rec."Dynamic Req. Page Entity Name")
                {
                    ToolTip = 'Specifies the value of the Dynamic Req. Page Entity Name field.', Comment = '%';
                }
                field("Function Name"; Rec."Function Name")
                {
                    ToolTip = 'Specifies the value of the Function Name field.', Comment = '%';
                }
                field("Table ID";Rec."Table ID")
                {
                    ToolTip = 'Specifies the value of the Function Name field.', Comment = '%';
                }
                field(Independent; Rec.Independent)
                {
                    ToolTip = 'Specifies the value of the Independent field.', Comment = '%';
                }
                field("Request Page ID"; Rec."Request Page ID")
                {
                    ToolTip = 'Specifies the value of the Request Page ID field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
               
                field("Used for Record Change"; Rec."Used for Record Change")
                {
                    ToolTip = 'Specifies the value of the Used for Record Change field.', Comment = '%';
                }
            }
        }
    }
}
