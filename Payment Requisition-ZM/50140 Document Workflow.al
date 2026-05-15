table 50140 "Document Workflow"
{
    //Created by Salaam Azeez

    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User ID"; Code[100])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Table No."; Integer)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF AllObj.GET(AllObj."Object Type"::Table, "Table No.") THEN
                    "Table Name" := AllObj."Object Name"
                ELSE
                    "Table Name" := '';
            end;
        }
        field(3; "Table Name"; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "1st Approver"; Code[100])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "2nd Approver"; Code[100])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "3rd Approver"; Code[100])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "4th Approver"; Code[100])
        {
            DataClassification = ToBeClassified;

        }
        field(8; Enable; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Process Name"; Text[250])
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Approval Limit"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Created By"; Code[100])
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Last Date Modified"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(14; "Modified By"; Code[100])
        {
            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(PK; "User ID", "Table No.")
        {
            Clustered = true;
        }
    }

    var
        //  myInt: Record "Web Service";
        AllObj: Record AllObjWithCaption;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}