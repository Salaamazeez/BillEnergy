namespace BILLENERGY.BILLENERGY;
using System.Security.User;

page 50178 PayrollList
{
    ApplicationArea = All;
    Caption = 'Payroll List';
    PageType = List;
    SourceTable = PayrollHeader;
    UsageCategory = Tasks;
    CardPageId = PayrollHeader;
    Editable = false;
    SourceTableView = sorting("Payroll Period") where("Approval Status" = filter(<> Closed));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Filter"; Rec."Shortcut Dimension 1 Filter")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Filter field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Closed By"; Rec."Closed By")
                {
                    ToolTip = 'Specifies the value of the Closed By field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Closed Date"; Rec."Closed Date")
                {
                    ToolTip = 'Specifies the value of the Closed Date field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        If UserSteup.Get(UserId) then
            if (UserSteup."Global Dimension 1 Code" <> '') then begin
                //UserSteup.TestField("Global Dimension 1 Code");

                Rec.FilterGroup(2);
                Rec.SetRange("Shortcut Dimension 1 Filter", UserSteup."Global Dimension 1 Code");
                Rec.FilterGroup(0);
            end;
    end;

    var
        UserSteup: Record "User Setup";
}
