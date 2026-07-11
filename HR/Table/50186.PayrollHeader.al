table 50186 PayrollHeader
{
    Caption = 'Payroll Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Payroll Period"; Code[10])
        {
            Caption = 'Payroll Period';
            TableRelation = PayrollPeriods."Period Code";
        }
        field(2; Description; Text[80])
        {
            Caption = 'Description';
        }

        field(4; "Payroll Creation Date"; Date)
        {
            Caption = 'Payroll Creation Date';
        }
        field(5; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            OptionMembers = Open,"Approved","Pending Approval",Closed;
            
        }
        field(6; "Employee Filter"; Code[20])
        {
            Caption = 'Employee Filter';
            TableRelation = Employee."No.";
        }
        field(7; "Shortcut Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(8; "Shortcut Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }

        field(10; "Salary Code Filter"; Code[10])
        {
            Caption = 'Salary Code Filter';
            TableRelation = "Employment Contract".Code;
        }
        field(11; "Created By"; Code[50])
        {
            Caption = 'Created By';
        }
        field(12; "Created Time"; Time)
        {
            Caption = 'Created Time';
        }
        field(13; "Last Modified By"; Code[50])
        {
            Caption = 'Last Modified By';
        }
        field(14; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
        }
        field(15; "Last Modified Time"; Time)
        {
            Caption = 'Last Modified Time';
        }
        field(16; "Closed By"; Code[50])
        {
            Caption = 'Closed By';
        }
        field(17; "Closed Date"; Date)
        {
            Caption = 'Closed Date';
        }
        field(18; "Closed Time"; Time)
        {
            Caption = 'Closed Time';
        }
        field(19; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum(PayrollDetailLine."Payable Amount" where("Payroll Period" = field("Payroll Period"), "Part of Payable Value" = filter(true)));
        }
    }
    keys
    {
        key(PK; "Payroll Period")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        PayrollLines.Reset();
        PayrollLines.SetRange("Payroll Period", "Payroll Period");
        If PayrollLines.FindSet() then
            PayrollLines.DeleteAll();

        PayrollDetailLine.Reset();
        PayrollDetailLine.SetRange("Payroll Period", "Payroll Period");
        If PayrollDetailLine.FindSet() then
            PayrollDetailLine.DeleteAll();
    end;

    trigger OnInsert()
    begin
        "Payroll Creation Date" := Today;
    end;

    var

        PayrollLines: Record PayrollLine;
        PayrollDetailLine: Record PayrollDetailLine;
}
