page 50145 "Document Approval Entries"
{
    //Created by Salaam Azeez

    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Document Approval Entry";
    SourceTableView = SORTING("Document No.") ORDER(Ascending) WHERE(Status = FILTER(<> Approved));
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = All;

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;

                }
                field(Sender; Rec.Sender)
                {
                    ApplicationArea = All;

                }
                field(Approver; Rec.Approver)
                {
                    ApplicationArea = All;

                }
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = All;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(Record)
            {
                ApplicationArea = All;
                Image = Document;
                trigger OnAction();
                begin
                    ShowRecord;
                    // AppEntry.SetRange("Document No.", "Document No.");
                    // if AppEntry.FindFirst() then begin
                    // RecRef.Open(Database::"Payment Requisition");
                    // VarRecRef := RecRef;
                    // Page.Run(0, VarRecRef, AppEntry."Document No.");
                    // end;
                end;
            }
        }
    }
    var
        //h:re
        DocAppEntries: Record "Document Approval Entry";
        AppEntry: Record "Approval Entry";
        RecRef: RecordRef;
        VarRecRef: variant;
        PageManagement: Codeunit "Page Management";

    trigger OnOpenPage()
    begin

        //UserIdSplit := DelChr(UserId, '=', 'NOSAK');
        UserIdSplit := DelStr(UserId, 1, 6);
        UserIdCombine := 'NOSAK\' + UserIdSplit;
        // Message(UserIdCombine);
        Rec.FILTERGROUP(2);
        Rec.SetFilter(Approver, UserIdCombine);
        Rec.FILTERGROUP(0);
    end;

    procedure ShowRecord()

    //   UserIdCombine: code[20];
    begin

        // if DelChr(UserId,'=','Nosak ')=DelChr(UserId,'=','Nosak ')
        // UserIdSplit := DelChr(UserId, '=', 'Nosak ');
        // UserIdCombine := 'Nosak/' + UserIdCombine;

        //Message(UserId);
        IF NOT RecRef.GET(Rec."Record ID to Approve") THEN
            EXIT;
        RecRef.SETRECFILTER;
        PageManagement.PageRun(RecRef);

    end;

    trigger OnAfterGetRecord()
    begin
        //  Message(UserIdSplit);
    end;

    var
        UserIdSplit: Code[100];
        UserIdCombine: Code[100];
}