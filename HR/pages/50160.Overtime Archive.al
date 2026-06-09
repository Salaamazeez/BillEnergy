namespace BILLENERGY.BILLENERGY;

page 50160 OvertimeArchive
{
    ApplicationArea = All;
    Caption = 'Overtime Archive';
    PageType = List;
    SourceTable = Overtime;
    UsageCategory = Tasks;
    SourceTableView = where("Overtime Closed" = filter(true));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Period Code"; Rec."Period Code")
                {
                    ToolTip = 'Specifies the value of the Period Code field.', Comment = '%';
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
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.', Comment = '%';
                }
                field("Department code"; Rec."Department code")
                {
                    ToolTip = 'Specifies the value of the Department code field.', Comment = '%';
                }
                field("Days Worked"; Rec."Days Worked")
                {
                    ToolTip = 'Specifies the value of the Days Worked field.', Comment = '%';
                }
                field("Extra Days Worked"; Rec."Extra Days Worked")
                {
                    ToolTip = 'Specifies the value of the Extra Days Worked field.', Comment = '%';
                }
                field("Gross Pay"; Rec."Gross Pay")
                {
                    ToolTip = 'Specifies the value of the Gross Pay field.', Comment = '%';
                }
                field("Overtime Amount"; Rec."Overtime Amount")
                {
                    ToolTip = 'Specifies the value of the Overtime Amount field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Overtime Paid"; Rec."Overtime Paid")
                {
                    ToolTip = 'Specifies the value of the Overtime Paid field.', Comment = '%';
                }
                field("Overtime Closed"; Rec."Overtime Closed")
                {
                    ToolTip = 'Specifies the value of the Overtime Closed field.', Comment = '%';
                    Visible = false;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                    Visible = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    Visible = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                    Visible = false;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                    Visible = false;
                }
            }
        }

    }

}
