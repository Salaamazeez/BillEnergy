codeunit 50001 "DocAttchMgt Extension"
{
    Permissions = tabledata "Record Link" = rim;

    procedure StorePortalLinks(Document: Variant; DocumentURLs: Text)
    var
        DocumentRef: RecordRef;
        URLs: JsonArray;
        URLToken: JsonToken;
        URL: Text;
        Voucher: Record "Payment Voucher Header";
        CashAdvance: Record "Cash Advance";
        VoucherRef: RecordRef;
        NoField: FieldRef;
        DocumentNo: Code[20];
    begin
        if DocumentURLs = '' then
            exit;
        if not URLs.ReadFrom(DocumentURLs) then
            Error('documentURLs must be a JSON array of URL strings.');
        DocumentRef.GetTable(Document);
        foreach URLToken in URLs do begin
            if not URLToken.IsValue() then
                Error('Each documentURLs entry must be a URL string.');
            if URLToken.AsValue().IsNull() or URLToken.AsValue().IsUndefined() then
                Error('Each documentURLs entry must be a URL string.');
            URL := URLToken.AsValue().AsText();
            if (StrPos(LowerCase(URL), 'https://') <> 1) and
               (StrPos(LowerCase(URL), 'http://') <> 1) then
                Error('Each documentURLs entry must be an absolute HTTP or HTTPS URL.');
            AddPortalLink(DocumentRef, URL);
        end;
        // A portal retry can add links after the voucher has already been created.
        case DocumentRef.Number of
            Database::"Payment Requisition":
                begin
                    NoField := DocumentRef.Field(1);
                    DocumentNo := NoField.Value;
                    Voucher.SetRange("Former PR No.", DocumentNo);
                    if Voucher.FindSet() then
                        repeat
                            VoucherRef.GetTable(Voucher);
                            CopyPortalLinks(DocumentRef, VoucherRef);
                        until Voucher.Next() = 0;
                end;
            Database::"Cash Advance":
                begin
                    DocumentRef.SetTable(CashAdvance);
                    if (CashAdvance."Voucher No" <> '') and Voucher.Get(CashAdvance."Voucher No") then begin
                        VoucherRef.GetTable(Voucher);
                        CopyPortalLinks(DocumentRef, VoucherRef);
                    end;
                end;
        end;
    end;

    local procedure AddPortalLink(var DocumentRef: RecordRef; URL: Text)
    var
        RecordLink: Record "Record Link";
    begin
        if DocumentRef.IsTemporary then
            exit;
        if StrLen(URL) > MaxStrLen(RecordLink.URL1) then
            Error('Attachment URL exceeds the supported length of %1 characters.', MaxStrLen(RecordLink.URL1));
        RecordLink.SetRange("Record ID", DocumentRef.RecordId);
        RecordLink.SetRange(Company, CompanyName);
        RecordLink.SetRange(Type, RecordLink.Type::Link);
        RecordLink.SetRange(URL1, URL);
        if RecordLink.IsEmpty then
            DocumentRef.AddLink(URL, 'Portal attachment');
    end;

    local procedure CopyPortalLinks(var FromRecRef: RecordRef; var ToRecRef: RecordRef)
    var
        RecordLink: Record "Record Link";
    begin
        if FromRecRef.IsTemporary or ToRecRef.IsTemporary then
            exit;
        RecordLink.SetRange("Record ID", FromRecRef.RecordId);
        RecordLink.SetRange(Company, CompanyName);
        RecordLink.SetRange(Type, RecordLink.Type::Link);
        RecordLink.SetRange(Description, 'Portal attachment');
        if RecordLink.FindSet() then
            repeat
                AddPortalLink(ToRecRef, RecordLink.URL1);
            until RecordLink.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvHeaderInsert', '', false, false)]
    local procedure CopyLinksToPostedPurchaseInvoice(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; PreviewMode: Boolean)
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
    begin
        if PreviewMode or (PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice) then
            exit;
        FromRecRef.GetTable(PurchHeader);
        ToRecRef.GetTable(PurchInvHeader);
        CopyPortalLinks(FromRecRef, ToRecRef);
    end;

    trigger OnRun()
    begin

    end;

    local procedure CopyAttachments(var FromRecRef: RecordRef; var ToRecRef: RecordRef)
    var
        FromDocumentAttachment: Record "Document Attachment";
        ToDocumentAttachment: Record "Document Attachment";
        FromFieldRef: FieldRef;
        ToFieldRef: FieldRef;
        FromDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        FromLineNo: Integer;
        FromNo: Code[20];
        ToNo: Code[20];
        RecNo: Code[20];
        ToDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        ToLineNo: Integer;
    begin
        FromDocumentAttachment.SetRange("Table ID", FromRecRef.Number);
        if FromDocumentAttachment.IsEmpty then
            exit;
        case FromRecRef.Number of
            Database::"Cash Advance",
            Database::"Payment Requisition":
                begin
                    FromFieldRef := FromRecRef.Field(1);
                    FromNo := FromFieldRef.Value;
                    FromDocumentAttachment.SetRange("No.", FromNo);
                end;

        end;

        if FromDocumentAttachment.FindSet
        then begin
            repeat
                Clear(ToDocumentAttachment);
                ToDocumentAttachment.Init;
                ToDocumentAttachment.TransferFields(FromDocumentAttachment);
                ToDocumentAttachment.Validate("Table ID", ToRecRef.Number);

                case ToRecRef.Number of
                    Database::"Payment Voucher Header",
                     Database::Retirement:
                        begin
                            ToFieldRef := ToRecRef.Field(1);
                            ToNo := ToFieldRef.Value;
                            ToDocumentAttachment.Validate("No.", ToNo);
                        end;

                end;
                if not ToDocumentAttachment.Insert(true) then;

            until FromDocumentAttachment.Next = 0;
        end;
    end;

    local procedure DeleteAttachedDocuments(RecRef: RecordRef)
    var
        DocumentAttachment: Record "Document Attachment";
        FieldRef: FieldRef;
        RecNo: Code[20];
        RecNo1: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LineNo: Integer;
    begin
        if RecRef.IsTemporary then
            exit;
        if DocumentAttachment.IsEmpty then
            exit;
        DocumentAttachment.SetRange("Table ID", RecRef.Number);
        case RecRef.Number of
            Database::"Cash Advance",
            Database::"Payment Voucher Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
        DocumentAttachment.DeleteAll;
    end;


    [EventSubscriber(Objecttype::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnOpenDocAttach(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option "Payment Voucher","Cash Advance",Retirement;
        LineNo: Integer;
    begin
        case RecRef.Number of
            Database::"Cash Advance",
            Database::"Payment Voucher Header",
            Database::"Payment Requisition",
            Database::Retirement:
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnBeforeInsertAttachment', '', false, false)]
    local procedure OnSaveAttachment(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LineNo: Integer;
    begin
        case RecRef.Number of
            Database::"Cash Advance",
           Database::"Payment Voucher Header",
           Database::"Payment Requisition",
           Database::Retirement:
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cash Advance", 'OnMoveDocAttachFromCashAdvanceToVoucher', '', false, false)]
    local procedure OnMoveDocAttachFromCashAdvanceToVoucher(var Rec1: Record "Cash Advance"; var Rec2: Record "Payment Voucher Header");
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
    begin
        FromRecRef.Open(Database::"Cash Advance");
        FromRecRef.GetTable(Rec1);

        ToRecRef.Open(Database::"Payment Voucher Header");
        ToRecRef.GetTable(Rec2);

        CopyPortalLinks(FromRecRef, ToRecRef);
        CopyAttachments(FromRecRef, ToRecRef);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Payment Requisition", 'OnMoveDocAttachFromPaymentReqToVoucher', '', false, false)]
    local procedure OnMoveDocAttachFromPaymentReqToVoucher(var Rec1: Record "Payment Requisition"; var Rec2: Record "Payment Voucher Header");
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
    begin
        FromRecRef.Open(Database::"Payment Requisition");
        FromRecRef.GetTable(Rec1);

        ToRecRef.Open(Database::"Payment Voucher Header");
        ToRecRef.GetTable(Rec2);

        CopyPortalLinks(FromRecRef, ToRecRef);
        CopyAttachments(FromRecRef, ToRecRef);
    end;

    [EventSubscriber(ObjectType::Table, Database::Retirement, 'OnMoveDocAttachFromCashAdvanceToRetirement', '', false, false)]
    local procedure OnMoveDocAttachFromCashAdvanceToRetirement(var Rec1: Record "Cash Advance"; var Rec2: Record Retirement);
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
    begin
        FromRecRef.Open(Database::"Cash Advance");
        FromRecRef.GetTable(Rec1);

        ToRecRef.Open(Database::Retirement);
        ToRecRef.GetTable(Rec2);

        CopyPortalLinks(FromRecRef, ToRecRef);
        CopyAttachments(FromRecRef, ToRecRef);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cash Advance", 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteAttachedDocumentsOnAfterDeleteCashAdv(var Rec: Record "Cash Advance"; RunTrigger: Boolean)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        DeleteAttachedDocuments(RecRef);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Doc. Attachment List Factbox", 'OnAfterGetRecRefFail', '', false, false)]
    local procedure OnAfterGetRecRefFail(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        CashAdvance: Record "Cash Advance";
        PaymentReq: Record "Payment Requisition";
        Retirement: Record Retirement;
        PmntVoucher: Record "Payment Voucher Header";
    begin
        CASE DocumentAttachment."Table ID" OF
            DATABASE::"Cash Advance":
                begin
                    CashAdvance.Get(DocumentAttachment."No.");
                        RecRef.GetTable(CashAdvance);
                end;
            DATABASE::"Payment Requisition":
                begin
                    PaymentReq.Get(DocumentAttachment."No.");
                        RecRef.GetTable(PaymentReq);
                end;
            DATABASE::Retirement:
                begin
                    Retirement.Get(DocumentAttachment."No.");
                        RecRef.GetTable(Retirement);
                end;
            DATABASE::"Payment Voucher Header":
                begin
                    PmntVoucher.Get(DocumentAttachment."No.");
                        RecRef.GetTable(PmntVoucher);
                end;
        end;
    end;



}
