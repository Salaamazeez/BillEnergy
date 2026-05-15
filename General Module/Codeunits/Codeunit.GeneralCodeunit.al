codeunit 50102 GeneralCodeunit
{
    var
        PurchaseLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        SaleLine: Record "Sales Line";
        PDocType: Enum "Purchase Document Type";
        SDocType: Enum "Sales Document Type";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", OnPostLinesOnBeforeGenJnlLinePost, '', false, false)]
    local procedure "Sales Post Invoice Events_OnPostLinesOnBeforeGenJnlLinePost"(var GenJnlLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header"; TempInvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; SuppressCommit: Boolean)
    begin
        GenJnlLine."Description 2" := TempInvoicePostingBuffer."Description 2"
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", OnPrepareLineOnAfterFillInvoicePostingBuffer, '', false, false)]
    local procedure "Sales Post Invoice Events_OnPrepareLineOnAfterFillInvoicePostingBuffer"(var InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; SalesLine: Record "Sales Line")
    begin
        InvoicePostingBuffer."Description 2" := SaleLine."Description 2"
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", OnAfterCopyGLEntryFromGenJnlLine, '', false, false)]
    local procedure "G/L Entry_OnAfterCopyGLEntryFromGenJnlLine"(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry."Description 2" := GenJournalLine."Description 2"
    end;

}