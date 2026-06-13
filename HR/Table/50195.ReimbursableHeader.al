table 50195 ReimbursableHeader
{
    Caption = 'ReimbursableHeader';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Period Code"; Code[50])
        {
            Caption = 'Period Code';
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
        field(4; "Global Dimension 1 Code Filter"; Code[50])
        {
            Caption = 'Global Dimension 1 Code Filter';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(5; "Global Dimension 2 Code Filter"; Code[50])
        {
            Caption = 'Global Dimension 2 Code Filter';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(6; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(7; "Employee Code Filter"; Code[50])
        {
            Caption = 'Employee Code Filter';
            TableRelation = Employee."No.";
        }

        field(8; "Paid Document No."; Code[50])
        {
            ToolTip = 'Specifies the value of the Paid Document No. field.', Comment = '%';

        }
        field(9; "Reimbursable Paid"; Boolean)
        {
            ToolTip = 'Specifies the value of the Reimbursable Paid field.', Comment = '%';

        }
    }

    keys
    {
        key(PK; "Period Code")
        {
            Clustered = true;
        }
    }


    procedure PerformManualClose()
    var
        Reimbursable: Record ReimbursableHeader;
    begin
        Reimbursable.SetRange("Period Code", "Period Code");
        Reimbursable.Setrange("Approval Status", Reimbursable."Approval Status"::Approved);
        if Reimbursable.FindFirst() then begin
            Reimbursable."Approval Status" := Reimbursable."Approval Status"::Closed;
        end;
    end;
}
