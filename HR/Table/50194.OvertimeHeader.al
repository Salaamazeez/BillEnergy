table 50194 OvertimeHeader
{
    Caption = 'OvertimeHeader';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Period Code"; Code[10])
        {
            Caption = 'Period Code';
            TableRelation = PayrollPeriods."Period Code";
        }
        field(2; Description; Text[200])
        {
            Caption = 'Description';
        }
        field(3; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            OptionMembers = ,Open,"Pending Approval",Approved,Closed;
        }
        field(4; "Global Dimension 1 Filter"; Code[50])
        {
            Caption = 'Global Dimension 1 Filter';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(5; "Global Dimension 2 Filter"; Code[50])
        {
            Caption = 'Global Dimension 2 Filter';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(6; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(7; "Employee Filter"; Code[50])
        {
            Caption = 'Employee Filter';
            TableRelation = Employee."No.";
        }

        field(8; "Paid Document No."; Code[50])
        {
            ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';

        }
        field(9; "Overtime Paid"; Boolean)
        {
            ToolTip = 'Specifies the value of the Overtime Paid field.', Comment = '%';

        }
    }


    keys
    {
        key(PK;
        "Period Code")
        {
            Clustered = true;
        }
    }

    var
        Overtimeline: Record OvertimeLine;

    trigger OnDelete()

    begin
        Overtimeline.reset;
        Overtimeline.setrange("Period Code", "Period Code");
        if Overtimeline.FindSet() then
            Overtimeline.reset;
        Overtimeline.setrange(Overtimeline."Period Code", "Period Code");
        Overtimeline.DeleteAll();
    end;

    procedure PerformManualClose()
    var
        Overtime: Record OvertimeHeader;
    begin
        Overtime.SetRange("Period Code", "Period Code");
        Overtime.Setrange("Approval Status", Overtime."Approval Status"::Approved);
        if Overtime.FindFirst() then begin
            Overtime."Approval Status" := Overtime."Approval Status"::Closed;
        end;
    end;

}
