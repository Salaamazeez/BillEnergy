codeunit 50200 "Document Approval Workflow"
{
    //Created by Salaam Azeez
    trigger OnRun()
    begin

    end;

    var
        DocumentWorkflow: Record "Document Workflow";
        SentBy: Record "User Setup";
        Apprv1: Record "User Setup";
        Apprv2: Record "User Setup";
        Apprv3: Record "User Setup";
        Apprv4: Record "User Setup";
        Recipients: List of [Text];
        Recepient: Text[250];
        DocumentApprovalEntry: Record "Document Approval Entry";
        DocumentApprovalEntry2: Record "Document Approval Entry";
        DocumentApprovalEntry3: Record "Document Approval Entry";
        DocumentApprovalEntry4: Record "Document Approval Entry";
        DocumentApprovalEntry5: Record "Document Approval Entry";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        // EmailMessage: Codeunit "SMTP Mail";
        User2: Record "User Setup";
        UserSetup: Record "User Setup";

        Text001: TextConst ENU = 'Approval request has been sent.';
        Text002: TextConst ENU = 'The approval cannot be cancelled because it has been treated by your approver.';
        Text003: TextConst ENU = 'Please hold on. This document requires a prior approval.';
        Text004: TextConst ENU = 'The document has been approved.';
        Text005: TextConst ENU = 'The document has been rejected.';
        Text006: TextConst ENU = 'Dear';
        Text007: TextConst ENU = '%1 requires your approval.';
        Text008: TextConst ENU = '%1 requires your approval. Please click on the link below to approve or reject the document.';
        Text009: TextConst ENU = 'This is a system generated mail.';
        Text010: TextConst ENU = '%1 has been approved.';
        Text011: TextConst ENU = 'Please note that transaction %1 has been approved.';
        Text012: TextConst ENU = '%1 has been rejected.';

        Text013: TextConst ENU = 'Please note that transaction %1 has been rejected.';
        Subject: Text[100];
        Body: Text[100];
        DocApprv: Record "User Setup";
        WebLink: Text[100];
        Seq: Integer;
        i: Integer;
    // DocumentApprovalEntry: Record "Document Approval Entry";


    procedure SendApprovalRequest(TableID: Integer; DocNo: Code[40]; RecID: RecordID; Limit: Decimal)
    var
        Recepients: List of [Text];
    begin
        DocumentWorkflow.SETCURRENTKEY("User ID", "Table No.", "Approval Limit");
        DocumentWorkflow.SETRANGE("User ID", USERID);
        DocumentWorkflow.SETRANGE("Table No.", TableID);
        DocumentWorkflow.SETFILTER("Approval Limit", '>=%1', Limit);
        IF DocumentWorkflow.FINDFIRST THEN BEGIN
            IF SentBy.GET(DocumentWorkflow."User ID") THEN;
            IF Apprv1.GET(DocumentWorkflow."1st Approver") THEN;
            IF Apprv2.GET(DocumentWorkflow."2nd Approver") THEN;
            IF Apprv3.GET(DocumentWorkflow."3rd Approver") THEN;
            IF Apprv4.GET(DocumentWorkflow."4th Approver") THEN;

            Recepient := '';

            IF (DocumentWorkflow."1st Approver" <> '') AND (DocumentWorkflow."2nd Approver" = '')
              AND (DocumentWorkflow."3rd Approver" = '') AND (DocumentWorkflow."4th Approver" = '') THEN BEGIN
                LevelsApproval1(TableID, DocNo, RecID, Limit);
                Recepient := Apprv1."E-Mail";
            END;

            IF (DocumentWorkflow."1st Approver" <> '') AND (DocumentWorkflow."2nd Approver" <> '')
              AND (DocumentWorkflow."3rd Approver" = '') AND (DocumentWorkflow."4th Approver" = '') THEN BEGIN
                LevelsApproval2(TableID, DocNo, RecID, Limit);
                Recepient := Apprv1."E-Mail" + ';' + Apprv2."E-Mail";
            END;

            IF (DocumentWorkflow."1st Approver" <> '') AND (DocumentWorkflow."2nd Approver" <> '')
              AND (DocumentWorkflow."3rd Approver" <> '') AND (DocumentWorkflow."4th Approver" = '') THEN BEGIN
                LevelsApproval3(TableID, DocNo, RecID, Limit);
                Recepient := Apprv1."E-Mail" + ';' + Apprv2."E-Mail" + ';' + Apprv3."E-Mail";
            END;

            IF (DocumentWorkflow."1st Approver" <> '') AND (DocumentWorkflow."2nd Approver" <> '')
              AND (DocumentWorkflow."3rd Approver" <> '') AND (DocumentWorkflow."4th Approver" <> '') THEN BEGIN
                LevelsApproval4(TableID, DocNo, RecID, Limit);//
                Recepient := Apprv1."E-Mail" + ';' + Apprv2."E-Mail" + ';' + Apprv3."E-Mail" + ';' + Apprv4."E-Mail";
            END;
            Recepients := Recepient.Split(';');
            for i := 1 to Recepients.Count() do begin

                Subject := STRSUBSTNO(Text007, RecID);
                // EmailMessage.CreateMessage(SentBy."User ID", SentBy."E-Mail", Recepients.Get(i), Subject, '', TRUE);
                EmailMessage.Create(Recepients, Subject, Body, true);
                if i = 1 then
                    EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text006 + ' ' + Apprv1."User ID" + ',')));
                if i = 2 then
                    EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text006 + ' ' + Apprv2."User ID" + ',')));
                if i = 3 then
                    EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text006 + ' ' + Apprv3."User ID" + ',')));
                if i = 4 then
                    EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text006 + ' ' + Apprv4."User ID" + ',')));
                EmailMessage.AppendToBody('<br><br>');
                EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text008, RecID)));
                EmailMessage.AppendToBody('<br><br>');
                //  EmailMessage.AppendToBody(GETURL(CLIENTTYPE::Web, COMPANYNAME, OBJECTTYPE::Page, PAGE::"Document Approval Entries",
                EmailMessage.AppendToBody(GETURL(CLIENTTYPE::Web, COMPANYNAME, OBJECTTYPE::Page, PAGE::"Document Approval Entries",
                DocumentApprovalEntry, TRUE));
                EmailMessage.AppendToBody('<br><br>');
                EmailMessage.AppendToBody('Regards');
                EmailMessage.AppendToBody('<br><br>');
                EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(SentBy."User ID")));
                EmailMessage.AppendToBody('<HR>');
                EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text009)));
                // EmailMessage.TrySend();
                Email.Send(EmailMessage);
            END;
        end;
    end;

    procedure LevelsApproval1(TableID: Integer; DocNo: Code[40]; RecID: RecordID; Limit: Decimal)
    begin
        DocumentWorkflow.SETCURRENTKEY("User ID", "Table No.", "Approval Limit");
        DocumentWorkflow.SETRANGE("User ID", USERID);
        DocumentWorkflow.SETRANGE("Table No.", TableID);
        DocumentWorkflow.SETFILTER("Approval Limit", '>=%1', Limit);
        IF DocumentWorkflow.FINDFIRST THEN BEGIN
            DocumentApprovalEntry.INIT;
            DocumentApprovalEntry.Sequence := 1;
            DocumentApprovalEntry."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry."Document No." := DocNo;
            DocumentApprovalEntry."Record ID to Approve" := RecID;
            DocumentApprovalEntry.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry.Approver := DocumentWorkflow."1st Approver";
            DocumentApprovalEntry.Status := DocumentApprovalEntry.Status::"Pending Approval";
            DocumentApprovalEntry.INSERT;
        END;
        MESSAGE(Text001);
        exit
    end;

    procedure LevelsApproval2(TableID: Integer; DocNo: Code[40]; RecID: RecordID; Limit: Decimal)
    begin
        DocumentWorkflow.SETCURRENTKEY("User ID", "Table No.", "Approval Limit");
        DocumentWorkflow.SETRANGE("User ID", USERID);
        DocumentWorkflow.SETRANGE("Table No.", TableID);
        DocumentWorkflow.SETFILTER("Approval Limit", '>=%1', Limit);
        IF DocumentWorkflow.FINDFIRST THEN BEGIN
            DocumentApprovalEntry.INIT;
            DocumentApprovalEntry.Sequence := 1;
            DocumentApprovalEntry."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry."Document No." := DocNo;
            DocumentApprovalEntry."Record ID to Approve" := RecID;
            DocumentApprovalEntry.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry.Approver := DocumentWorkflow."1st Approver";
            DocumentApprovalEntry.Status := DocumentApprovalEntry.Status::"Pending Approval";
            DocumentApprovalEntry.INSERT;

            DocumentApprovalEntry2.INIT;
            DocumentApprovalEntry2.Sequence := 2;
            DocumentApprovalEntry2."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry2."Document No." := DocNo;
            DocumentApprovalEntry2."Record ID to Approve" := RecID;
            DocumentApprovalEntry2.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry2.Approver := DocumentWorkflow."2nd Approver";
            DocumentApprovalEntry2.Status := DocumentApprovalEntry2.Status::"Pending Approval";
            DocumentApprovalEntry2.INSERT;
        END;
        MESSAGE(Text001);
    end;

    procedure LevelsApproval3(TableID: Integer; DocNo: Code[40]; RecID: RecordID; Limit: Decimal)
    begin
        DocumentWorkflow.SETCURRENTKEY("User ID", "Table No.", "Approval Limit");
        DocumentWorkflow.SETRANGE("User ID", USERID);
        DocumentWorkflow.SETRANGE("Table No.", TableID);
        DocumentWorkflow.SETFILTER("Approval Limit", '>=%1', Limit);
        IF DocumentWorkflow.FINDFIRST THEN BEGIN
            DocumentApprovalEntry.INIT;
            DocumentApprovalEntry.Sequence := 1;
            DocumentApprovalEntry."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry."Document No." := DocNo;
            DocumentApprovalEntry."Record ID to Approve" := RecID;
            DocumentApprovalEntry.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry.Approver := DocumentWorkflow."1st Approver";
            DocumentApprovalEntry.Status := DocumentApprovalEntry.Status::"Pending Approval";
            DocumentApprovalEntry.INSERT;

            DocumentApprovalEntry2.INIT;
            DocumentApprovalEntry2.Sequence := 2;
            DocumentApprovalEntry2."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry2."Document No." := DocNo;
            DocumentApprovalEntry2."Record ID to Approve" := RecID;
            DocumentApprovalEntry2.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry2.Approver := DocumentWorkflow."2nd Approver";
            DocumentApprovalEntry2.Status := DocumentApprovalEntry2.Status::"Pending Approval";
            DocumentApprovalEntry2.INSERT;

            DocumentApprovalEntry3.INIT;
            DocumentApprovalEntry3.Sequence := 3;
            DocumentApprovalEntry3."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry3."Document No." := DocNo;
            DocumentApprovalEntry3."Record ID to Approve" := RecID;
            DocumentApprovalEntry3.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry3.Approver := DocumentWorkflow."3rd Approver";
            DocumentApprovalEntry3.Status := DocumentApprovalEntry3.Status::"Pending Approval";
            DocumentApprovalEntry3.Status := DocumentApprovalEntry3.Status::"Pending Approval";
            DocumentApprovalEntry3.INSERT;
        END;
        MESSAGE(Text001);

    end;

    procedure LevelsApproval4(TableID: Integer; DocNo: Code[40]; RecID: RecordID; Limit: Decimal)
    begin
        DocumentWorkflow.SETCURRENTKEY("User ID", "Table No.", "Approval Limit");
        DocumentWorkflow.SETRANGE("User ID", USERID);
        DocumentWorkflow.SETRANGE("Table No.", TableID);
        DocumentWorkflow.SETFILTER("Approval Limit", '>=%1', Limit);
        IF DocumentWorkflow.FINDFIRST THEN BEGIN
            DocumentApprovalEntry.INIT;
            DocumentApprovalEntry.Sequence := 1;
            DocumentApprovalEntry."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry."Document No." := DocNo;
            DocumentApprovalEntry."Record ID to Approve" := RecID;
            DocumentApprovalEntry.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry.Approver := DocumentWorkflow."1st Approver";
            DocumentApprovalEntry.Status := DocumentApprovalEntry.Status::"Pending Approval";
            DocumentApprovalEntry.INSERT;

            DocumentApprovalEntry2.INIT;
            DocumentApprovalEntry2.Sequence := 2;
            DocumentApprovalEntry2."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry2."Document No." := DocNo;
            DocumentApprovalEntry2."Record ID to Approve" := RecID;
            DocumentApprovalEntry2.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry2.Approver := DocumentWorkflow."2nd Approver";
            DocumentApprovalEntry2.Status := DocumentApprovalEntry2.Status::"Pending Approval";
            DocumentApprovalEntry2.INSERT;

            DocumentApprovalEntry3.INIT;
            DocumentApprovalEntry3.Sequence := 3;
            DocumentApprovalEntry3."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry3."Document No." := DocNo;
            DocumentApprovalEntry3."Record ID to Approve" := RecID;
            DocumentApprovalEntry3.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry3.Approver := DocumentWorkflow."3rd Approver";
            DocumentApprovalEntry3.Status := DocumentApprovalEntry3.Status::"Pending Approval";
            DocumentApprovalEntry3.INSERT;

            DocumentApprovalEntry4.INIT;
            DocumentApprovalEntry4.Sequence := 4;
            DocumentApprovalEntry4."Table No." := DocumentWorkflow."Table No.";
            DocumentApprovalEntry4."Document No." := DocNo;
            DocumentApprovalEntry4."Record ID to Approve" := RecID;
            DocumentApprovalEntry4.Sender := DocumentWorkflow."User ID";
            DocumentApprovalEntry4.Approver := DocumentWorkflow."4th Approver";
            DocumentApprovalEntry4.Status := DocumentApprovalEntry4.Status::"Pending Approval";
            DocumentApprovalEntry4.INSERT;
        END;
        MESSAGE(Text001);
    end;

    procedure CancelApprovalRequest(TableID: Integer; DocNo: Code[40])
    begin
        DocumentApprovalEntry.SETCURRENTKEY(Sequence, "Document No.");
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        IF DocumentApprovalEntry.FINDFIRST THEN
            IF (DocumentApprovalEntry.Status = DocumentApprovalEntry.Status::"Pending Approval") THEN
                DocumentApprovalEntry.DELETEALL;
        IF DocumentApprovalEntry.Status <> DocumentApprovalEntry.Status::"Pending Approval" THEN
            ERROR(Text002);
    end;

    procedure CancelApprovalRequestJnl(TableID: Integer; DocNo: Code[40])
    begin
        DocumentApprovalEntry.SETCURRENTKEY(Sequence, "Document No.");
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        IF DocumentApprovalEntry.FINDFIRST THEN begin
            IF (DocumentApprovalEntry.Status = DocumentApprovalEntry.Status::"Pending Approval") then begin
                DocumentApprovalEntry.DELETEALL;
                exit
            end;
            if (DocumentApprovalEntry.Status = DocumentApprovalEntry.Status::Rejected) THEN begin
                DocumentApprovalEntry.DELETEALL;
                exit
            end;
            IF (DocumentApprovalEntry.Status <> DocumentApprovalEntry.Status::"Pending Approval") then begin
                ERROR(Text002);
            end;
            if (DocumentApprovalEntry.Status <> DocumentApprovalEntry.Status::Rejected) THEN begin
                ERROR(Text002);
            end;
        end;
    end;

    procedure ApproveDocument(DocNo: Code[40])
    //to test if predecessor has approved
    begin
        Seq := 0;
        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY("Document No.", Status, Approver);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry.SETRANGE(Approver, USERID);
        IF DocumentApprovalEntry.FINDFIRST THEN BEGIN
            Seq := DocumentApprovalEntry.Sequence;
            IF Seq > 1 THEN BEGIN
                DocumentApprovalEntry2.SETCURRENTKEY(Sequence, "Document No.");
                DocumentApprovalEntry2.SETRANGE(Sequence, Seq - 1);
                DocumentApprovalEntry2.SETRANGE("Document No.", DocNo);
                IF DocumentApprovalEntry2.FINDFIRST THEN
                    IF DocumentApprovalEntry2.Status = DocumentApprovalEntry2.Status::"Pending Approval" THEN
                        ERROR(Text003);
            END;
        END;

        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY("Document No.", Status, Approver);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry.SETRANGE(Approver, USERID);
        DocumentApprovalEntry.SETRANGE(Status, DocumentApprovalEntry.Status::Rejected);
        IF DocumentApprovalEntry.FINDFIRST THEN BEGIN
            Message('Document has already been rejected');
            exit
        END;

        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY("Document No.", Status, Approver);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry.SETRANGE(Approver, USERID);
        DocumentApprovalEntry.SETRANGE(Status, DocumentApprovalEntry.Status::"Pending Approval");
        IF DocumentApprovalEntry.FINDFIRST THEN BEGIN
            DocumentApprovalEntry.Status := DocumentApprovalEntry.Status::Approved;
            DocumentApprovalEntry.MODIFY;
            MESSAGE(Text004);
        END ELSE
            ERROR('There is no pending approval entry for the document!');
        //DocumentApprovalEntry.VALIDATE(Status);
    end;


    procedure RejectDocument(DocNo: Code[40])
    begin
        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY("Document No.", Status, Approver);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry.SETRANGE(Approver, USERID);
        IF DocumentApprovalEntry.FINDFIRST THEN BEGIN
            Seq := DocumentApprovalEntry.Sequence;
            IF Seq > 1 THEN BEGIN
                DocumentApprovalEntry2.SETCURRENTKEY(Sequence, "Document No.");
                DocumentApprovalEntry2.SETRANGE(Sequence, Seq - 1);
                DocumentApprovalEntry2.SETRANGE("Document No.", DocNo);
                IF DocumentApprovalEntry2.FINDFIRST THEN
                    IF DocumentApprovalEntry2.Status = DocumentApprovalEntry2.Status::Open THEN
                        ERROR(Text003);
            END;
        END;

        DocumentApprovalEntry.RESET;
        DocumentApprovalEntry.SETCURRENTKEY("Document No.", Status, Approver);
        DocumentApprovalEntry.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry.SETRANGE(Approver, USERID);
        IF DocumentApprovalEntry.FINDFIRST THEN BEGIN
            DocumentApprovalEntry.Status := DocumentApprovalEntry.Status::Rejected;
            DocumentApprovalEntry.MODIFY;
        END;
        MESSAGE(Text005);
    end;

    procedure ApprovalStatusCheck(TableID: Integer; DocNo: Code[40]; RecID: RecordID): Boolean
    begin
        DocumentApprovalEntry5.SETCURRENTKEY(Sequence, "Document No.");
        DocumentApprovalEntry5.SETRANGE("Document No.", DocNo);
        DocumentApprovalEntry5.FINDLAST;
        IF DocumentApprovalEntry5.Status = DocumentApprovalEntry5.Status::Approved THEN BEGIN
            SentBy.RESET;
            SentBy.GET(DocumentApprovalEntry5.Sender);  //originator
            DocApprv.GET(DocumentApprovalEntry5.Approver); //doc. aprrover
            Subject := STRSUBSTNO(Text010, DocumentApprovalEntry5."Record ID to Approve");
            // Recepient := SentBy."E-Mail";
            Recipients.Add(SentBy."E-Mail");
            // EmailMessage.CreateMessage(DocApprv."User ID", DocApprv."E-Mail", Recepient, Subject, '', TRUE);
            EmailMessage.Create(Recipients, Subject, Body, true);
            EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text006 + SentBy."User ID" + ',')));
            EmailMessage.AppendToBody('<br><br>');
            EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text011, DocumentApprovalEntry5."Record ID to Approve")));
            EmailMessage.AppendToBody('<br><br>');
            EmailMessage.AppendToBody('Regards');
            EmailMessage.AppendToBody('<br><br>');
            EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(DocApprv."User ID")));
            EmailMessage.AppendToBody('<HR>');
            EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text009)));
            // EmailMessage.Send;
            Email.Send(EmailMessage);
            EXIT(TRUE)
        END ELSE
            IF DocumentApprovalEntry5.Status = DocumentApprovalEntry5.Status::Rejected THEN BEGIN
                SentBy.RESET;
                SentBy.GET(DocumentApprovalEntry5.Sender);  //originator
                DocApprv.GET(DocumentApprovalEntry5.Approver); //doc. aprrover
                Subject := STRSUBSTNO(Text012, DocumentApprovalEntry5."Record ID to Approve");
                // Recepient := SentBy."E-Mail";
                Recipients.Add(SentBy."E-Mail");
                // EmailMessage.CreateMessage(DocApprv."User ID", DocApprv."E-Mail", Recepient, Subject, '', TRUE);
                EmailMessage.Create(Recipients, Subject, Body, true);
                EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text006 + SentBy."User ID" + ',')));
                EmailMessage.AppendToBody('<br><br>');
                EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text013, DocumentApprovalEntry5."Record ID to Approve")));
                EmailMessage.AppendToBody('<br><br>');
                EmailMessage.AppendToBody('Regards');
                EmailMessage.AppendToBody('<br><br>');
                EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(DocApprv."User ID")));
                EmailMessage.AppendToBody('<HR>');
                EmailMessage.AppendToBody(FORMAT(STRSUBSTNO(Text009)));
                // EmailMessage.Send;
                Email.Send(EmailMessage);
                EXIT(FALSE)
            END;
    end;

}