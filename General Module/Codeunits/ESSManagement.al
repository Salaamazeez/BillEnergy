codeunit 50500 "ESS Management"
{
    Permissions =
     tabledata "Item Ledger Entry" = RIMD;
    trigger OnRun()
    begin

    end;

    procedure CreateorEditPaymentRequest(DocumentNo: Code[20]; PostingDate: Text; Requester: Code[20]; Beneficiary: Code[20]; BalAccType: Option "G/L Account",Vendor,Staff,"Bank Account"; CurrencyCode: Code[10]; Description: Text; PurchReqNo: Code[20]; ReqAmount: Decimal; VoucherCreated: Boolean; TransactionType: Option " ",Loan,"Staff Adv"; LoanId: Code[20]; PaymentReqLines: Text): Text
    var
        Header: Record "Payment Requisition";
        Line: Record "Payment Requisition Line";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        ResponseObject: JsonObject;
        DataObject: JsonObject;
        ResponseText: Text;
        LineNo: Integer;
        LineCount: Integer;
        ExpenseCode: Code[50];
        AccType: Option "G/L Account",Staff,Vendor,"Bank Account","Fixed Asset";
        PaymentDetails: Text[150];
        Amount: Decimal;
        AccountNo: Code[20];
        ShortcutDimCode1: Code[20];
        ShortcutDimCode2: Code[20];
    begin
        if DocumentNo <> '' then begin
            if not Header.Get(DocumentNo) then
                Error('Payment Requisition %1 not found', DocumentNo);
            Evaluate(Header.Date, PostingDate);
            Header.Validate(Requester, Requester);
            Header.Validate(Beneficiary, Beneficiary);
            Header.Validate("Bal Account Type", BalAccType);
            //Header.Validate("Bal Account No.", BalAccNo);
            Header.Validate("Currency Code", CurrencyCode);
            Header.Validate("Request Description", Description);
            Header.Validate("Purchase Requisition No.", PurchReqNo);
            // Header.Validate("Shortcut Dimension 1 Code", ShortcutDim1);
            // Header.Validate("Shortcut Dimension 2 Code", ShortcutDim2);
            Header."Voucher Created?" := VoucherCreated;
            Header."Transaction type" := TransactionType;
            Header."Loan ID" := LoanId;
            //Header.Modify(true);

            // DELETE OLD LINES
            Line.Reset();
            Line.SetRange("Document No.", Header."No.");
            Line.DeleteAll();
        end else begin
            Header.Init();
            Header.Validate("No.", '');
            Evaluate(Header.Date, PostingDate);
            Header.Validate(Requester, Requester);
            Header.Validate(Beneficiary, Beneficiary);
            Header.Validate("Bal Account Type", BalAccType);
            //Header.Validate("Bal Account No.", BalAccNo);
            Header.Validate("Currency Code", CurrencyCode);
            Header.Validate("Request Description", Description);
            Header.Validate("Purchase Requisition No.", PurchReqNo);
            // Header.Validate("Shortcut Dimension 1 Code", ShortcutDim1);
            // Header.Validate("Shortcut Dimension 2 Code", ShortcutDim2);
            Header."Voucher Created?" := VoucherCreated;
            Header."Transaction type" := TransactionType;
            Header."Loan ID" := LoanId;
            Header.Insert(true);
        end;

        if not JsonArray.ReadFrom(PaymentReqLines) then
            Error('Invalid JSON format');

        if JsonArray.Count = 0 then
            Error('No Lines Provided');

        LineNo := 0;
        LineCount := 0;

        foreach JsonToken in JsonArray do begin
            JsonObject := JsonToken.AsObject();
            Clear(ExpenseCode);
            Clear(PaymentDetails);
            Clear(Amount);
            Clear(AccountNo);
            Clear(ShortcutDimCode1);
            Clear(ShortcutDimCode2);
            Clear(AccType);

            if JsonObject.Get('AccType', JsonToken) then
                AccType := JsonToken.AsValue().AsInteger();


            if JsonObject.Get('ExpenseCode', JsonToken) then
                ExpenseCode := JsonToken.AsValue().AsCode();

            if JsonObject.Get('PaymentDetails', JsonToken) then
                PaymentDetails := JsonToken.AsValue().AsText();

            if JsonObject.Get('Amount', JsonToken) then
                Amount := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('AccountNo', JsonToken) then
                AccountNo := JsonToken.AsValue().AsCode();

            if JsonObject.Get('ShortcutDimension1Code', JsonToken) then
                ShortcutDimCode1 := JsonToken.AsValue().AsCode();

            if JsonObject.Get('ShortcutDimension2Code', JsonToken) then
                ShortcutDimCode2 := JsonToken.AsValue().AsCode();

            LineNo += 10000;
            LineCount += 1;
            Clear(Line);
            Line.Init();
            Line."Document No." := Header."No.";
            Line."Line No." := LineNo;
            Line.Validate("Expense Code", ExpenseCode);
            Line.Validate("Payment Details", PaymentDetails);
            // Line.Validate("Account Type", AccType);
            // Line.Validate("Account No.", AccountNo);
            Line.Validate(Amount, Amount);
            //Line.Validate("Shortcut Dimension 1 Code", ShortcutDimCode1);
            //Line.Validate("Shortcut Dimension 2 Code", ShortcutDimCode2);
            Line.Insert(true);
        end;
        Header.Validate(Status, Header.Status::Approved);
        Header.Modify();


        Clear(DataObject);
        Clear(ResponseObject);

        DataObject.Add('No', Header."No.");
        DataObject.Add('processedLines', LineCount);

        ResponseObject.Add('success', true);
        ResponseObject.Add('message', StrSubstNo('Payment Request processed successfully with %1 lines', LineCount));
        ResponseObject.Add('data', DataObject);

        ResponseObject.WriteTo(ResponseText);

        exit(ResponseText);
    end;




    procedure CreateOrEditCashAdvance(DocumentNo: Code[20]; DocumentDate: Text; requester: Text[50]; Description: Text[100]; DueDate: Text; DebitAccountNo: Code[20]; CurrencyCode: Code[10]; CashAdvanceLines: Text): Text
    var
        Header: Record "Cash Advance";
        Line: Record "Cash Advance Line";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        ResponseObject: JsonObject;
        DataObject: JsonObject;
        ResponseText: Text;
        LineNo: Integer;
        LineCount: Integer;
        ExpenseCode: Code[50];
        PaymentDetails: Text[150];
        Amount: Decimal;
        AccountNo: Code[20];
        BalAccountNo: Code[20];
        Dim1: Code[20];
        Dim2: Code[20];
        ResponseLbl: Label 'Cash Advance processed successfully with %1 lines';
        ErrorNoLines: Label 'No lines provided';
        ErrorInvalidJson: Label 'Invalid JSON format';
    begin
        if CashAdvanceLines = '' then
            Error(ErrorNoLines);

        if DocumentNo <> '' then begin
            if not Header.Get(DocumentNo) then
                Error('Cash Advance %1 not found', DocumentNo);

            Evaluate(Header.Date, DocumentDate);
            Evaluate(Header."Due Date", DueDate);
            //Header.Validate("Payee No.", beneficiary);
            Header.Validate(Description, Description);
            Header."Debit  Account Type" := 2;
            //Header.Validate("Debit  Account Type", DebitAccountType);
            Header.Validate("Debit Account No.", DebitAccountNo);
            Header.Validate("Currency Code", CurrencyCode);
            // Header.Validate("Shortcut Dimension 1 Code", ShortcutDim1);
            // Header.Validate("Shortcut Dimension 2 Code", ShortcutDim2);
            //Header.Validate("Transaction type", TransactionType);
            //Header.Validate("Loan ID", LoanID);
            Header.Modify(true);

            Line.Reset();
            Line.SetRange("Document No.", Header."No.");
            Line.DeleteAll();
        end else begin
            Header.Init();
            Header."No." := '';
            Header.Insert(true);
            Evaluate(Header.Date, DocumentDate);
            Evaluate(Header."Due Date", DueDate);
            // Header.Validate(Beneficiary, beneficiary);
            Header.Validate(Description, Description);
            Header."Debit  Account Type" := 2;
            Header.Validate("Debit Account No.", DebitAccountNo);
            Header.Validate("Currency Code", CurrencyCode);
            // Header.Validate("Shortcut Dimension 1 Code", ShortcutDim1);
            // Header.Validate("Shortcut Dimension 2 Code", ShortcutDim2);
            // Header.Validate("Transaction type", TransactionType);

            // if LoanID <> '' then
            //     Header.Validate("Loan ID", LoanID);
            Header.Modify(true);
        end;

        if not JsonArray.ReadFrom(CashAdvanceLines) then
            Error(ErrorInvalidJson);

        if JsonArray.Count = 0 then
            Error(ErrorNoLines);

        LineNo := 0;
        LineCount := 0;

        foreach JsonToken in JsonArray do begin
            JsonObject := JsonToken.AsObject();
            LineNo += 10000;
            LineCount += 1;

            Clear(ExpenseCode);
            Clear(PaymentDetails);
            Clear(Amount);
            Clear(AccountNo);
            Clear(BalAccountNo);
            Clear(Dim1);
            Clear(Dim2);

            if JsonObject.Get('ExpenseCode', JsonToken) then
                ExpenseCode := JsonToken.AsValue().AsCode();

            if JsonObject.Get('PaymentDetails', JsonToken) then
                PaymentDetails := JsonToken.AsValue().AsText();

            if JsonObject.Get('Amount', JsonToken) then
                Amount := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('AccountNo', JsonToken) then
                AccountNo := JsonToken.AsValue().AsCode();

            if JsonObject.Get('BalAccountNo', JsonToken) then
                BalAccountNo := JsonToken.AsValue().AsCode();

            // if JsonObject.Get('ShortcutDimension1Code', JsonToken) then
            //     Dim1 := JsonToken.AsValue().AsCode();

            // if JsonObject.Get('ShortcutDimension2Code', JsonToken) then
            //     Dim2 := JsonToken.AsValue().AsCode();
            Header.Validate(Status, Header.Status::Approved);
            Header.Modify();

            Clear(Line);
            Line.Init();

            Line."Document No." := Header."No.";
            Line."Line No." := LineNo;
            Line.Insert();
            Line.Validate("Expense Code", ExpenseCode);
            Line.Validate("Payment Details", PaymentDetails);
            //Line.Validate("Account No.", AccountNo);
            //Line.Validate("Bal. Account No.", BalAccountNo);
            // Line.Validate("Shortcut Dimension 1 Code", Dim1);
            // Line.Validate("Shortcut Dimension 2 Code", Dim2);
            Line.Validate(Amount, Amount);
            Line.Modify(true);
        end;


        Clear(DataObject);
        Clear(ResponseObject);

        DataObject.Add('No', Header."No.");
        DataObject.Add('processedLines', LineCount);
        ResponseObject.Add('success', true);
        ResponseObject.Add('message', StrSubstNo(ResponseLbl, LineCount));
        ResponseObject.Add('data', DataObject);
        ResponseObject.WriteTo(ResponseText);
        exit(ResponseText);
    end;


    procedure CreateOrEditStoreRequisition(DocumentNo: Code[20]; DocumentDate: Text; Requester: Code[50]; Beneficiary: Code[20]; Location: Code[20]; ProjectJobDescription: Text[100]; WorkOrderNo: Code[20]; StoreReqLines: Text): Text
    var
        Header: Record "Store Requisition";
        Line: Record "Store Requisition Line";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        ResponseObject: JsonObject;
        DataObject: JsonObject;
        ResponseText: Text;
        LineNo: Integer;
        LineCount: Integer;
        LineType: Option Item,"G/L Account";
        StockCode: Code[20];
        Description: Text[100];
        UnitOfIssue: Code[20];
        LocationCode: Code[20];
        RequestedQty: Decimal;
        UnitPrice: Decimal;
        GenBusPostingGroup: Code[20];
        ResponseLbl: Label 'Store Requisition processed successfully with %1 lines';
        ErrorNoLines: Label 'No lines provided';
        ErrorInvalidJson: Label 'Invalid JSON format';
    begin
        if StoreReqLines = '' then
            Error(ErrorNoLines);

        if DocumentNo <> '' then begin
            if not Header.Get(DocumentNo) then
                Error('Store Requisition %1 not found', DocumentNo);
            Evaluate(Header.Date, DocumentDate);
            Header.Validate(Requester, Requester);
            Header.Validate("Staff No.", Beneficiary);
            Header.Validate(Location, Location);
            Header.Validate("Project/Job Description", ProjectJobDescription);
            Header.Validate("Work Order No.", WorkOrderNo);
            Header.Modify(true);
            Line.Reset();
            Line.SetRange("Document No.", Header."No.");
            Line.DeleteAll();
        end else begin
            Header.Init();
            Header.Validate("No.", '');
            Header.Insert(true);
            Evaluate(Header.Date, DocumentDate);
            Header.Validate(Requester, Requester);
            Header.Validate("Staff No.", Beneficiary);
            Header.Validate(Location, Location);
            Header.Validate("Project/Job Description", ProjectJobDescription);
            Header.Validate("Work Order No.", WorkOrderNo);
            Header.Modify(true);
        end;
        if not JsonArray.ReadFrom(StoreReqLines) then
            Error(ErrorInvalidJson);

        if JsonArray.Count = 0 then
            Error(ErrorNoLines);

        LineNo := 0;
        LineCount := 0;

        foreach JsonToken in JsonArray do begin
            JsonObject := JsonToken.AsObject();

            LineNo += 10000;
            LineCount += 1;

            Clear(LineType);
            Clear(StockCode);
            Clear(Description);
            Clear(UnitOfIssue);
            Clear(LocationCode);
            Clear(RequestedQty);
            Clear(UnitPrice);
            Clear(GenBusPostingGroup);

            if JsonObject.Get('Type', JsonToken) then
                Evaluate(LineType, JsonToken.AsValue().AsText());

            if JsonObject.Get('StockCode', JsonToken) then
                StockCode := JsonToken.AsValue().AsCode();

            if JsonObject.Get('Description', JsonToken) then
                Description := JsonToken.AsValue().AsText();

            if JsonObject.Get('UnitOfIssue', JsonToken) then
                UnitOfIssue := JsonToken.AsValue().AsCode();

            if JsonObject.Get('LocationCode', JsonToken) then
                LocationCode := JsonToken.AsValue().AsCode();

            if JsonObject.Get('RequestedQty', JsonToken) then
                RequestedQty := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('UnitPrice', JsonToken) then
                UnitPrice := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('GenBusPostingGroup', JsonToken) then
                GenBusPostingGroup := JsonToken.AsValue().AsCode();

            Clear(Line);
            Line.Init();

            Line."Document No." := Header."No.";
            Line."Line No." := LineNo;
            Line.Validate(Type, LineType);
            Line.Validate("Stock Code", StockCode);
            if ProjectJobDescription <> '' then
                Line.Validate(Description, ProjectJobDescription)
            else
                Line.Validate(Description, Description);
            // Line.Validate("Unit of Issue", UnitOfIssue);
            Line.Validate("Location Code", LocationCode);
            Line.Validate("Requested Qty.", RequestedQty);
            Line.Validate("Unit Price", UnitPrice);
            Line.Validate("Gen Bus. Posting Group", GenBusPostingGroup);
            Line.Insert(true);
        end;
        Header.Validate(Status, Header.Status::Approved);
        Header.Modify();

        DataObject.Add('No', Header."No.");
        DataObject.Add('processedLines', LineCount);
        ResponseObject.Add('success', true);
        ResponseObject.Add('message', StrSubstNo(ResponseLbl, LineCount));
        ResponseObject.Add('documentNo', Header."No.");
        ResponseObject.Add('data', DataObject);
        ResponseObject.WriteTo(ResponseText);
        exit(ResponseText);
    end;

    procedure CreateOrEditStoresReturn(DocumentNo: Code[20]; DocumentDate: Text; Requester: Code[50]; Beneficiary: Code[20]; Location: Code[20]; IssueNo: Code[20]; ProjectJobDescription: Text[100]; WorkOrderNo: Code[20]; StoreReturnLines: Text): Text
    var
        Header: Record "Stores Return";
        Line: Record "Stores Return Line";
        StoreReqLine: Record "Store Requisition Line";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        ResponseObject: JsonObject;
        DataObject: JsonObject;
        ResponseText: Text;
        LineNo: Integer;
        LineCount: Integer;
        StockCode: Code[20];
        Description: Text[100];
        UnitOfIssue: Code[20];
        LocationCode: Code[20];
        RequestedQty: Decimal;
        ReturnedQty: Decimal;
        QtyToReturn: Decimal;
        QtyReturned: Decimal;
        IssuedQty: Decimal;
        UnitPrice: Decimal;
        GenBusPostingGroup: Code[20];
        ResponseLbl: Label 'Stores Return processed successfully with %1 lines';
        ErrorNoLines: Label 'No lines provided';
        ErrorInvalidJson: Label 'Invalid JSON format';
    begin
        if StoreReturnLines = '' then
            Error(ErrorNoLines);

        if DocumentNo <> '' then begin
            if not Header.Get(DocumentNo) then
                Error('Stores Return %1 not found', DocumentNo);

            Evaluate(Header.Date, DocumentDate);
            Header.Validate(Requester, Requester);
            Header.Validate("Staff No.", Beneficiary);
            Header.Validate(Location, Location);
            Header.Validate("Issue No.", IssueNo);
            Header.Validate("Project/Job Description", ProjectJobDescription);
            Header.Validate("Work Order No.", WorkOrderNo);
            Header.Modify(true);

            Line.Reset();
            Line.SetRange("Document No.", Header."No.");
            Line.DeleteAll();
        end else begin
            Header.Init();
            Header.Validate("No.", '');
            Header.Insert(true);
            Evaluate(Header.Date, DocumentDate);
            Header.Validate(Requester, Requester);
            Header.Validate(Location, Location);
            Header.Validate("Issue No.", IssueNo);
            Header.Validate("Project/Job Description", ProjectJobDescription);
            Header.Validate("Work Order No.", WorkOrderNo);
            Header.Modify(true);
        end;

        if not JsonArray.ReadFrom(StoreReturnLines) then
            Error(ErrorInvalidJson);

        if JsonArray.Count = 0 then
            Error(ErrorNoLines);

        LineNo := 0;
        LineCount := 0;

        foreach JsonToken in JsonArray do begin
            JsonObject := JsonToken.AsObject();

            LineNo += 10000;
            LineCount += 1;

            Clear(StockCode);
            Clear(Description);
            Clear(UnitOfIssue);
            Clear(LocationCode);
            Clear(RequestedQty);
            Clear(ReturnedQty);
            Clear(QtyToReturn);
            Clear(QtyReturned);
            Clear(IssuedQty);
            Clear(UnitPrice);
            Clear(GenBusPostingGroup);

            if JsonObject.Get('StockCode', JsonToken) then
                StockCode := JsonToken.AsValue().AsCode();

            // if JsonObject.Get('Description', JsonToken) then
            //     Description := JsonToken.AsValue().AsText();

            // if JsonObject.Get('UnitOfIssue', JsonToken) then
            //     UnitOfIssue := JsonToken.AsValue().AsCode();

            if JsonObject.Get('LocationCode', JsonToken) then
                LocationCode := JsonToken.AsValue().AsCode();

            if JsonObject.Get('RequestedQty', JsonToken) then
                RequestedQty := JsonToken.AsValue().AsDecimal();

            // if JsonObject.Get('ReturnedQty', JsonToken) then
            //     ReturnedQty := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('QtyToReturn', JsonToken) then
                QtyToReturn := JsonToken.AsValue().AsDecimal();

            // if JsonObject.Get('QtyReturned', JsonToken) then
            //     QtyReturned := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('IssuedQty', JsonToken) then
                IssuedQty := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('UnitPrice', JsonToken) then
                UnitPrice := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('GenBusPostingGroup', JsonToken) then
                GenBusPostingGroup := JsonToken.AsValue().AsCode();
            StoreReqLine.Reset();
            StoreReqLine.SetRange("Document No.", IssueNo);
            StoreReqLine.SetRange("Stock Code", StockCode);
            StoreReqLine.SetFilter("Issued Qty.", '<=%1', QtyToReturn);
            if not StoreReqLine.FindFirst() then
                Error('Wrong line details not allowed! %1', QtyToReturn);
            Line.Init();

            Line."Document No." := Header."No.";
            Line."Line No." := LineNo;

            Line.Validate("Stock Code", StockCode);

            //Error('%1',Line."Requested Qty.");
            //Line.Validate(Description, Description);
            //Line.Validate("Unit of Issue", UnitOfIssue);
            Line.Validate("Location Code", LocationCode);
            Line.Validate("Requested Qty.", RequestedQty);
            //Line.Validate("Returned Qty.", ReturnedQty);


            //Line.Validate("Qty Returned", QtyReturned);
            Line.Validate("Issued Qty", IssuedQty);
            Line.Insert(true);
            Line.Validate("Qty to Return", QtyToReturn);
            Line.Validate("Unit Price", UnitPrice);
            Line.Validate("Gen Bus. Posting Group", GenBusPostingGroup);
            Line.Modify(true);
        end;
        Header.Validate(Status, Header.Status::Approved);
        Header.Modify();

        DataObject.Add('No', Header."No.");
        DataObject.Add('processedLines', LineCount);

        ResponseObject.Add('success', true);
        ResponseObject.Add('message', StrSubstNo(ResponseLbl, LineCount));
        ResponseObject.Add('documentNo', Header."No.");
        ResponseObject.Add('data', DataObject);
        ResponseObject.WriteTo(ResponseText);
        exit(ResponseText);
    end;


    procedure CreateOrEditRetirement(DocumentNo: Code[20]; retirementDate: Text; Beneficiary: Code[20]; RetirementRef: Code[50]; CurrencyCode: Code[10]; Purpose: Text[250]; RetirementLines: Text): Text
    var
        Header: Record Retirement;
        Line: Record "Retirement Line";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        ResponseObject: JsonObject;
        DataObject: JsonObject;
        ResponseText: Text;
        LineNo: Integer;
        LineCount: Integer;
        ExpenseCode: Code[20];
        TransactionDetails: Text[250];
        AccountType: Option "G/L Account",Staff,Vendor,"Bank Account","Fixed Asset";
        AccountNo: Code[20];
        AccountName: Text[100];
        LineAmount: Decimal;
        LineAmountLCY: Decimal;
        ShortcutDim1: Code[20];
        ShortcutDim2: Code[20];
        LineCurrency: Code[10];
        ResponseLbl: Label 'Retirement processed successfully with %1 lines';
        ErrorNoLines: Label 'No lines provided';
        ErrorInvalidJson: Label 'Invalid JSON format';
    begin
        if RetirementLines = '' then
            Error(ErrorNoLines);

        if DocumentNo <> '' then begin
            if not Header.Get(DocumentNo) then
                Error('Retirement %1 not found', DocumentNo);

            // Header.Validate("Transaction type", TransType);
            // Header.Validate("Loan ID", LoanID);
            Evaluate(Header.Date, RetirementDate);
            Header.Validate(Beneficiary, Beneficiary);
            Header.Validate("Retirement Ref.", RetirementRef);
            // Header.Validate("Debit  Account Type", DebitAccountType);
            // Header.Validate("Debit Account No.", DebitAccountNo);
            // Header.Validate("Shortcut Dimension 1 Code", Dim1);
            // Header.Validate("Shortcut Dimension 2 Code", Dim2);
            // Header.Validate("Currency Code", CurrencyCode);
            Header.Validate(Purpose, Purpose);
            //Header.Validate("Cash Recpt No./Pmt Voucher", CashReceiptNo);
            //Header.Modify(true);

            Line.Reset();
            Line.SetRange("Document No.", Header."No.");
            Line.DeleteAll();
        end else begin
            Header.Init();
            Header.Validate("No.", '');
            Header.Insert(true);
            // Header.Validate("Transaction type", TransType);
            // Header.Validate("Loan ID", LoanID);
            // Evaluate(Header.Date, RetirementDate);
            Evaluate(Header.Date, RetirementDate);
            Header.Validate(Beneficiary, Beneficiary);
            Header.Validate("Retirement Ref.", RetirementRef);
            // Header.Validate("Debit  Account Type", DebitAccountType);
            // Header.Validate("Debit Account No.", DebitAccountNo);
            // Header.Validate("Shortcut Dimension 1 Code", Dim1);
            // Header.Validate("Shortcut Dimension 2 Code", Dim2);
            Header.Validate("Currency Code", CurrencyCode);
            Header.Validate(Purpose, Purpose);
            //Header.Validate("Cash Recpt No./Pmt Voucher", CashReceiptNo);
            //Header.Modify(true);
        end;

        if not JsonArray.ReadFrom(RetirementLines) then
            Error(ErrorInvalidJson);

        if JsonArray.Count = 0 then
            Error(ErrorNoLines);

        LineNo := 0;
        LineCount := 0;
        Line.Reset();
        Line.SetRange("Document No.", Header."No.");
        Line.DeleteAll();
        foreach JsonToken in JsonArray do begin
            JsonObject := JsonToken.AsObject();

            LineNo += 10000;
            LineCount += 1;

            Clear(ExpenseCode);
            Clear(TransactionDetails);
            Clear(AccountType);
            Clear(AccountNo);
            Clear(AccountName);
            Clear(LineAmount);
            Clear(LineAmountLCY);
            Clear(ShortcutDim1);
            Clear(ShortcutDim2);
            Clear(LineCurrency);

            if JsonObject.Get('ExpenseCode', JsonToken) then
                ExpenseCode := JsonToken.AsValue().AsCode();

            if JsonObject.Get('TransactionDetails', JsonToken) then
                TransactionDetails := JsonToken.AsValue().AsText();

            if JsonObject.Get('AccountType', JsonToken) then
                AccountType := JsonToken.AsValue().AsInteger();

            if JsonObject.Get('AccountNo', JsonToken) then
                AccountNo := JsonToken.AsValue().AsCode();

            if JsonObject.Get('AccountName', JsonToken) then
                AccountName := JsonToken.AsValue().AsText();

            if JsonObject.Get('Amount', JsonToken) then
                LineAmount := JsonToken.AsValue().AsDecimal();

            // if JsonObject.Get('AmountLCY', JsonToken) then
            //     LineAmountLCY := JsonToken.AsValue().AsDecimal();

            // if JsonObject.Get('ShortcutDim1', JsonToken) then
            //     ShortcutDim1 := JsonToken.AsValue().AsCode();

            // if JsonObject.Get('ShortcutDim2', JsonToken) then
            //     ShortcutDim2 := JsonToken.AsValue().AsCode();

            if JsonObject.Get('CurrencyCode', JsonToken) then
                LineCurrency := JsonToken.AsValue().AsCode();

            Line.Init();

            Line."Document No." := Header."No.";
            Line."Line No." := LineNo;

            Line.Validate("Expense Code", ExpenseCode);
            Line.Validate("Transaction Details", TransactionDetails);
            // Line.Validate("Account Type", AccountType);
            // Line.Validate("Account No.", AccountNo);
            // Line.Validate("Account Name", AccountName);
            //Line.Validate("Amount (LCY)", LineAmountLCY);
            // Line.Validate("Shortcut Dimension 1 Code", ShortcutDim1);
            // Line.Validate("Shortcut Dimension 2 Code", ShortcutDim2);
            Line.Validate("Currency Code", LineCurrency);
            Line.Insert(true);
            Line.Validate(Amount, LineAmount);
            Line.Modify(true);
        end;
        Header.Validate(Status, Header.Status::Approved);
        Header.Modify();


        DataObject.Add('No', Header."No.");
        DataObject.Add('processedLines', LineCount);

        ResponseObject.Add('success', true);
        ResponseObject.Add('message', StrSubstNo(ResponseLbl, LineCount));
        ResponseObject.Add('documentNo', Header."No.");
        ResponseObject.Add('data', DataObject);
        ResponseObject.WriteTo(ResponseText);
        exit(ResponseText);
    end;

    procedure CreateOrEditLeaveApplication(LeaveCode: Code[20]; ApplyingType: Option " ",Self,Surbodinate; EmployeeNo: Code[20]; Description: Text[250]; StartDate: Text; EndDate: Text; LeaveType: Code[20]): Text
    var
        Header: Record LeaveApplication;
        ResponseObject: JsonObject;
        DataObject: JsonObject;
        ResponseText: Text;
    begin
        if LeaveCode <> '' then begin
            if not Header.Get(LeaveCode) then
                Error('Leave Application %1 not found', LeaveCode);
            Header.Validate("Applying Type", ApplyingType);
            Header.Validate("Employee No.", EmployeeNo);
            Header.Validate(Description, Description);
            Evaluate(Header."First Day of Vacation", StartDate);
            Evaluate(Header."Leave End Date", EndDate);
            Header.Validate("Leave Type", LeaveType);
            Header.Modify(true);
        end else begin
            Header.Init();
            Header."Leave Code" := '';
            Header.Insert(true);
            Header.Validate("Applying Type", ApplyingType);
            Header.Validate("Employee No.", EmployeeNo);
            Header.Validate(Description, Description);
            Evaluate(Header."First Day of Vacation", StartDate);
            Evaluate(Header."Leave End Date", EndDate);
            Header.Validate("Leave Type", LeaveType);
            Header.Modify(true);
        end;
        Header.Validate(Status, Header.Status::Approved);
        Header.Modify();

        DataObject.Add('LeaveCode', Header."Leave Code");
        ResponseObject.Add('success', true);
        ResponseObject.Add('message', 'Leave Application processed successfully');
        ResponseObject.Add('data', DataObject);
        ResponseObject.WriteTo(ResponseText);
        exit(ResponseText);
    end;

    procedure CreateOrEditLeaveRegister(leaveCode: Code[20]; EmployeeNo: Code[20]; Description: Text[250]; StartDate: Text; EndDate: Text; LeaveType: Code[20]; Quantity: Integer; UoM: Code[20]/* ; AdjustmentType: Option " ","Positive Adjustment","Negative Adjustment"; LeaveAdjustment: Boolean */): Text
    var
        Header: Record "Employee Absence";
        ResponseObject: JsonObject;
        DataObject: JsonObject;
        ResponseText: Text;
        Year: Integer;
        EntryNo: Integer;
    begin
        EntryNo := 0;
        if EntryNo <> 0 then begin
            if not Header.Get(EntryNo) then
                Error('Leave Application %1 not found', EntryNo);
            Header."Entry No." := EntryNo;
            Header.Validate("Employee No.", EmployeeNo);
            Header.Validate(Description, Description);
            Evaluate(Header."From Date", StartDate);
            Evaluate(Header."To Date", EndDate);
            Header.Validate("Cause of Absence Code", LeaveType);
            //Header.Validate("Cause of Absence Code", LeaveType);
            Header.Validate(Quantity, Quantity);
            Header.Validate("Unit of Measure Code", UoM);
            Year := Date2DMY(Header."From Date", 3);//leaveCode
            Header."Leave Code" := leaveCode;//
            Header."Adjustment Type" := 0;//
            Header."Leave Adjustment" := false;//
            if Year > 2000 then
                Header."Leave Year" := Year;
            Header.Modify(true);
        end else begin
            Header.Init();
            //Header."Leave Code" := '';
            Header.Insert(true);

            Header.Validate("Employee No.", EmployeeNo);
            Header.Validate(Description, Description);
            Evaluate(Header."From Date", StartDate);
            Evaluate(Header."To Date", EndDate);
            Header.Validate("Cause of Absence Code", LeaveType);
            //Header.Validate("Cause of Absence Code", LeaveType);
            Header.Validate(Quantity, Quantity);
            Header.Validate("Unit of Measure Code", UoM);
            //exit(StrSubstNo('Reachable %1', Header, EntryNo));
            Year := Date2DMY(Header."From Date", 3);//leaveCode
            Header."Leave Code" := leaveCode;//
            Header."Adjustment Type" := 0;//
            Header."Leave Adjustment" := false;//
            if Year > 2000 then
                Header."Leave Year" := Year;
            Header.Modify(true);
        end;

        DataObject.Add('LeaveCode', Header."Leave Code");
        ResponseObject.Add('success', true);
        ResponseObject.Add('entryNo', Header."Entry No.");
        ResponseObject.Add('employeeNo', Header."Employee No.");
        ResponseObject.Add('message', 'Leave Application processed successfully');
        ResponseObject.Add('data', DataObject);
        ResponseObject.WriteTo(ResponseText);
        exit(ResponseText);
    end;


    procedure CreateOrEditPerformanceAppraisal(EmployeeNo: Code[20]; AppraisalYear: Integer; AppraisalLines: Text): Text
    var
        Header: Record PerformanceAppraisalHeader;
        Line: Record PerformanceAppraiserLine;
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        ResponseObject: JsonObject;
        DataObject: JsonObject;
        ResponseText: Text;
        LineNo: Integer;
        LineCount: Integer;
        ObjectiveSettings: Text;
        ObjectiveSummary: Text;
        Measure: Text;
        Weight: Decimal;
        ByWhen: Text;
        EmployeeScore: Decimal;
        ManagerScore: Decimal;
        ErrorNoLines: Label 'No lines provided';
        ErrorInvalidJson: Label 'Invalid JSON format';
        ResponseLbl: Label 'Performance Appraisal processed successfully with %1 lines';
    begin
        if not Header.Get(EmployeeNo, AppraisalYear) then begin
            Header.Init();
            Header.Validate("Employee No.", EmployeeNo);
            Header.Validate("Appraisal Year", AppraisalYear);
            Header.Insert(true);
        end;

        if AppraisalLines <> '' then begin

            if not JsonArray.ReadFrom(AppraisalLines) then
                Error(ErrorInvalidJson);

            Line.Reset();
            Line.SetRange("Employee No.", EmployeeNo);
            Line.SetRange("Appraisaer Year", AppraisalYear);
            Line.DeleteAll();

            LineNo := 0;
            LineCount := 0;

            foreach JsonToken in JsonArray do begin
                JsonObject := JsonToken.AsObject();

                LineNo += 10000;
                LineCount += 1;

                Clear(ObjectiveSettings);
                Clear(ObjectiveSummary);
                Clear(Measure);
                Clear(Weight);
                Clear(ByWhen);
                Clear(EmployeeScore);
                Clear(ManagerScore);

                if JsonObject.Get('ObjectiveSettings', JsonToken) then
                    ObjectiveSettings := JsonToken.AsValue().AsText();

                if JsonObject.Get('ObjectiveSummary', JsonToken) then
                    ObjectiveSummary := JsonToken.AsValue().AsText();

                if JsonObject.Get('Measure', JsonToken) then
                    Measure := JsonToken.AsValue().AsText();

                if JsonObject.Get('Weight', JsonToken) then
                    Weight := JsonToken.AsValue().AsDecimal();

                if JsonObject.Get('ByWhen', JsonToken) then
                    ByWhen := JsonToken.AsValue().AsText();

                if JsonObject.Get('EmployeeScore', JsonToken) then
                    EmployeeScore := JsonToken.AsValue().AsDecimal();

                if JsonObject.Get('ManagerScore', JsonToken) then
                    ManagerScore := JsonToken.AsValue().AsDecimal();

                Line.Init();

                Line."Employee No." := EmployeeNo;
                Line."Appraisaer Year" := AppraisalYear;
                Line."Line No." := LineNo;

                Line.Validate("Objective Settings", ObjectiveSettings);
                Line.Validate("Objective Summary", ObjectiveSummary);
                Line.Validate(Measure, Measure);
                Line.Validate(Weight, Weight);
                Evaluate(Line."By When", ByWhen);
                Line.Validate("Employee Score", EmployeeScore);
                Line.Validate("Manager Score", ManagerScore);

                Line.Insert(true);
            end;
        end;
        Header.Validate(Status, Header.Status::Approved);
        Header.Modify();

        DataObject.Add('EmployeeNo', EmployeeNo);
        DataObject.Add('AppraisalYear', AppraisalYear);
        DataObject.Add('processedLines', LineCount);

        ResponseObject.Add('success', true);
        ResponseObject.Add('message', StrSubstNo(ResponseLbl, LineCount));
        ResponseObject.Add('data', DataObject);

        ResponseObject.WriteTo(ResponseText);
        exit(ResponseText);
    end;

    procedure CreateOrEditPurchaseRequisition(DocumentNo: Code[20]; Beneficiary: Code[20]; RequestDescription: Text[250]; PurchaseReqLines: Text): Text
    var
        Header: Record "Purch. Requistion";
        Line: Record "Purchase Requisition Line";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        ResponseObject: JsonObject;
        DataObject: JsonObject;
        ResponseText: Text;
        LineNo: Integer;
        LineCount: Integer;
        LineType: Option Item,"G/L Account";
        ItemNo: Code[20];
        Description: Text[100];
        RequisitionDate: Text;
        RequiredItemService: Text[100];
        Quantity: Decimal;
        UnitCost: Decimal;
        ShortcutDim1: Code[20];
        ShortcutDim2: Code[20];
        Amount: Decimal;
        AmountLCY: Decimal;
        VendorNo: Code[20];
        VendorName: Text[100];
        ResponseLbl: Label 'Purchase Requisition processed successfully with %1 lines';
        ErrorNoLines: Label 'No lines provided';
        ErrorInvalidJson: Label 'Invalid JSON format';
    begin
        if DocumentNo <> '' then begin
            if not Header.Get(DocumentNo) then
                Error('Purchase Requisition %1 not found', DocumentNo);

            //Evaluate(Header.Date, DocumentDate);
            if Beneficiary <> '' then
                Header.Validate(Beneficiary, Beneficiary);
            Header.Validate("Request Description", RequestDescription);
            Header.Modify(true);

            Line.Reset();
            Line.SetRange("Document No.", Header."No.");
            Line.DeleteAll();
        end else begin
            Header.Init();
            Header.Validate("No.", '');
            Header.Insert(true);
            //Evaluate(Header.Date, DocumentDate);
            //if Requester <> '' then
            Header.Validate(Requester, UserId);

            Header.Validate("Request Description", RequestDescription);
            //Header.Modify(true);
        end;

        if PurchaseReqLines = '' then
            Error(ErrorNoLines);

        if not JsonArray.ReadFrom(PurchaseReqLines) then
            Error(ErrorInvalidJson);

        if JsonArray.Count = 0 then
            Error(ErrorNoLines);

        LineNo := 0;
        LineCount := 0;

        foreach JsonToken in JsonArray do begin
            JsonObject := JsonToken.AsObject();

            LineNo += 10000;
            LineCount += 1;

            Clear(LineType);
            Clear(ItemNo);
            Clear(Description);
            Clear(RequisitionDate);
            Clear(RequiredItemService);
            Clear(Quantity);
            Clear(UnitCost);
            Clear(ShortcutDim1);
            Clear(Amount);
            Clear(AmountLCY);
            Clear(VendorNo);
            Clear(VendorName);

            if JsonObject.Get('Type', JsonToken) then
                Evaluate(LineType, JsonToken.AsValue().AsText());

            if JsonObject.Get('No', JsonToken) then
                ItemNo := JsonToken.AsValue().AsCode();

            if JsonObject.Get('Description', JsonToken) then
                Description := JsonToken.AsValue().AsText();

            if JsonObject.Get('RequisitionDate', JsonToken) then
                RequisitionDate := JsonToken.AsValue().AsText();

            if JsonObject.Get('RequiredItemService', JsonToken) then
                RequiredItemService := JsonToken.AsValue().AsText();

            if JsonObject.Get('Quantity', JsonToken) then
                Quantity := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('UnitCost', JsonToken) then
                UnitCost := JsonToken.AsValue().AsDecimal();

            // if JsonObject.Get('ShortcutDimension1', JsonToken) then
            //     ShortcutDim1 := JsonToken.AsValue().AsCode();

            // if JsonObject.Get('ShortcutDimension2', JsonToken) then
            //     ShortcutDim2 := JsonToken.AsValue().AsCode();

            if JsonObject.Get('Amount', JsonToken) then
                Amount := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('VendorNo', JsonToken) then
                VendorNo := JsonToken.AsValue().AsCode();

            if JsonObject.Get('VendorName', JsonToken) then
                VendorName := JsonToken.AsValue().AsText();

            Clear(Line);
            Line.Init();

            Line."Document No." := Header."No.";
            Line."Line No." := LineNo;

            Line.Validate(Type, Line.Type::Stock);
            Line.Validate("No.", ItemNo);
            //Line.Validate(Description, Description);
            Evaluate(Line."Requisition Date", RequisitionDate);
            Line.Validate("Required Item/Service", RequiredItemService);
            Line.Validate(Quantity, Quantity);
            Line.Validate("Unit Cost", UnitCost);
            // if ShortcutDim1 <> '' then
            //     Line.Validate("Shortcut Dimension 1 Code", ShortcutDim1);
            // if ShortcutDim2 <> '' then
            //     Line.Validate("Shortcut Dimension 2 Code", ShortcutDim2);
            Line.Validate(Amount, Amount);
            if VendorNo <> '' then
                Line.Validate("Vendor No.", VendorNo);
            if VendorName <> '' then
                Line.Validate("Vendor Name", VendorName);
            Line.Insert(true);
        end;
        Header.Validate(Status, Header.Status::Approved);
        Header.Modify();

        DataObject.Add('No', Header."No.");
        DataObject.Add('processedLines', LineCount);

        ResponseObject.Add('success', true);
        ResponseObject.Add('message', StrSubstNo(ResponseLbl, LineCount));
        ResponseObject.Add('data', DataObject);

        ResponseObject.WriteTo(ResponseText);
        exit(ResponseText);
    end;

    procedure GetPaymentRequests(DocumentNo: Code[20]; Beneficiary: Code[20]): Text
    var
        Header: Record "Payment Requisition";
        Line: Record "Payment Requisition Line";
        ResponseObject: JsonObject;
        HeaderObject: JsonObject;
        LineObject: JsonObject;
        JsonArray: JsonArray;
        LinesArray: JsonArray;
        ResponseText: Text;
        JsonText: Text;
    begin
        if Beneficiary <> '' then
            Header.SetRange(Beneficiary, Beneficiary);
        if DocumentNo <> '' then
            Header.SetRange("No.", DocumentNo);

        if Header.FindSet() then
            repeat
                Clear(HeaderObject);
                Clear(LinesArray);
                HeaderObject.Add('documentNo', Header."No.");
                HeaderObject.Add('postingDate', Format(Header.Date));
                HeaderObject.Add('requester', Header.Requester);
                HeaderObject.Add('beneficiary', Header.Beneficiary);
                HeaderObject.Add('currencyCode', Header."Currency Code");
                HeaderObject.Add('description', Header."Request Description");

                Line.Reset();
                Line.SetRange("Document No.", Header."No.");
                if Line.FindSet() then
                    repeat
                        Clear(LineObject);
                        LineObject.Add('expenseCode', Line."Expense Code");
                        LineObject.Add('paymentDetails', Line."Payment Details");
                        LineObject.Add('amount', Line.Amount);
                        LineObject.Add('accountNo', Line."Account No.");
                        LinesArray.Add(LineObject);
                    until Line.Next() = 0;
                HeaderObject.Add('lines', LinesArray);
                JsonArray.Add(HeaderObject);
            until Header.Next() = 0;
        JsonArray.WriteTo(JsonText);
        exit(JsonText);
    end;

    procedure GetCashAdvances(DocumentNo: Code[20]; Requester: code[20]; Paid: boolean): Text
    var
        Header: Record "Cash Advance";
        Line: Record "Cash Advance Line";
        ResponseObject: JsonObject;
        HeaderObject: JsonObject;
        LineObject: JsonObject;
        JsonArray: JsonArray;
        LinesArray: JsonArray;
        ResponseText: Text;
        JsonText: Text;
    begin
        if Requester <> '' then
            Header.SetRange("Debit Account No.", Requester);
        if DocumentNo <> '' then
            Header.SetRange("No.", DocumentNo);
        if Paid then
            Header.SetRange(Posted, Paid);
        if Header.FindSet() then
            repeat
                Clear(HeaderObject);
                Clear(LinesArray);
                HeaderObject.Add('documentNo', Header."No.");
                HeaderObject.Add('documentDate', Format(Header.Date));
                HeaderObject.Add('requester', Header."Debit Account No.");
                HeaderObject.Add('description', Header.Description);

                Line.Reset();
                Line.SetRange("Document No.", Header."No.");
                if Line.FindSet() then
                    repeat
                        Clear(LineObject);
                        LineObject.Add('LineNo', Line."Line No.");
                        LineObject.Add('expenseCode', Line."Expense Code");
                        LineObject.Add('paymentDetails', Line."Payment Details");
                        LineObject.Add('amount', Line.Amount);
                        LinesArray.Add(LineObject);
                    until Line.Next() = 0;
                HeaderObject.Add('lines', LinesArray);
                JsonArray.Add(HeaderObject);
            until Header.Next() = 0;
        JsonArray.WriteTo(JsonText);
        exit(JsonText);
    end;

    procedure GetStoreRequisitions(DocumentNo: Code[20]; Requester: Code[20]): Text
    var
        Header: Record "Store Requisition";
        Line: Record "Store Requisition Line";
        ResponseObject: JsonObject;
        HeaderObject: JsonObject;
        LineObject: JsonObject;
        JsonArray: JsonArray;
        LinesArray: JsonArray;
        JsonText: Text;
    begin
        if Requester <> '' then
            Header.SetRange("Staff No.", Requester);
        if DocumentNo <> '' then
            Header.SetRange("No.", DocumentNo);

        if Header.FindSet() then
            repeat
                Clear(HeaderObject);
                Clear(LinesArray);
                HeaderObject.Add('documentNo', Header."No.");
                HeaderObject.Add('documentDate', Format(Header.Date));
                HeaderObject.Add('requester', Header.Requester);
                HeaderObject.Add('location', Header.Location);

                Line.Reset();
                Line.SetRange("Document No.", Header."No.");
                if Line.FindSet() then
                    repeat
                        Clear(LineObject);
                        LineObject.Add('stockCode', Line."Stock Code");
                        LineObject.Add('description', Line.Description);
                        LineObject.Add('requestedQty', Line."Requested Qty.");
                        LineObject.Add('unitPrice', Line."Unit Price");
                        LinesArray.Add(LineObject);
                    until Line.Next() = 0;
                HeaderObject.Add('lines', LinesArray);
                JsonArray.Add(HeaderObject);
            until Header.Next() = 0;
        JsonArray.WriteTo(JsonText);
        exit(JsonText);
    end;

    procedure GetStoresReturns(DocumentNo: Code[20]; Requester: Code[20]): Text
    var
        Header: Record "Stores Return";
        Line: Record "Stores Return Line";
        ResponseObject: JsonObject;
        HeaderObject: JsonObject;
        LineObject: JsonObject;
        JsonArray: JsonArray;
        LinesArray: JsonArray;
        JsonText: Text;
    begin
        if Requester <> '' then
            Header.SetRange("Staff No.", Requester);
        if DocumentNo <> '' then
            Header.SetRange("No.", DocumentNo);

        if Header.FindSet() then
            repeat
                Clear(HeaderObject);
                Clear(LinesArray);
                HeaderObject.Add('documentNo', Header."No.");
                HeaderObject.Add('documentDate', Format(Header.Date));
                HeaderObject.Add('requester', Header."Staff No.");

                Line.Reset();
                Line.SetRange("Document No.", Header."No.");
                if Line.FindSet() then
                    repeat
                        Clear(LineObject);
                        LineObject.Add('stockCode', Line."Stock Code");
                        LineObject.Add('description', Line.Description);
                        LineObject.Add('qtyToReturn', Line."Qty to Return");
                        LinesArray.Add(LineObject);
                    until Line.Next() = 0;
                HeaderObject.Add('lines', LinesArray);
                JsonArray.Add(HeaderObject);
            until Header.Next() = 0;
        JsonArray.WriteTo(JsonText);
        exit(JsonText);
    end;

    procedure GetRetirements(DocumentNo: Code[20]): Text
    var
        Header: Record Retirement;
        Line: Record "Retirement Line";
        ResponseObject: JsonObject;
        HeaderObject: JsonObject;
        LineObject: JsonObject;
        JsonArray: JsonArray;
        LinesArray: JsonArray;
        JsonText: Text;
    begin
        if DocumentNo <> '' then
            Header.SetRange("No.", DocumentNo);

        if Header.FindSet() then
            repeat
                Clear(HeaderObject);
                Clear(LinesArray);
                HeaderObject.Add('documentNo', Header."No.");
                HeaderObject.Add('retirementDate', Format(Header.Date));
                HeaderObject.Add('retiringOfficer', Header."Retiring Officer");
                HeaderObject.Add('purpose', Header.Purpose);

                Line.Reset();
                Line.SetRange("Document No.", Header."No.");

                if Line.FindSet() then
                    repeat
                        Clear(LineObject);
                        LineObject.Add('expenseCode', Line."Expense Code");
                        LineObject.Add('transactionDetails', Line."Transaction Details");
                        LineObject.Add('amount', Line.Amount);
                        LinesArray.Add(LineObject);
                    until Line.Next() = 0;
                HeaderObject.Add('lines', LinesArray);
                JsonArray.Add(HeaderObject);
            until Header.Next() = 0;
        JsonArray.WriteTo(JsonText);
        exit(JsonText);
    end;

    procedure GetLeaveApplications(LeaveCode: Code[20]; EmployeeNo: Code[20]): Text
    var
        Header: Record LeaveApplication;
        ResponseObject: JsonObject;
        DataObject: JsonObject;
        JsonArray: JsonArray;
        ResponseText: Text;
    begin
        if LeaveCode <> '' then
            Header.SetRange("Leave Code", LeaveCode);

        if EmployeeNo <> '' then
            Header.SetRange("Employee No.", EmployeeNo);

        if Header.FindSet() then
            repeat
                Clear(DataObject);

                DataObject.Add('leaveCode', Header."Leave Code");
                DataObject.Add('employeeNo', Header."Employee No.");
                DataObject.Add('description', Header.Description);
                DataObject.Add('startDate', Format(Header."First Day of Vacation"));
                DataObject.Add('endDate', Format(Header."Leave End Date"));
                DataObject.Add('leaveType', Header."Leave Type");

                JsonArray.Add(DataObject);

            until Header.Next() = 0;

        ResponseObject.Add('success', true);
        ResponseObject.Add('data', JsonArray);

        ResponseObject.WriteTo(ResponseText);

        exit(ResponseText);
    end;

    procedure GetPerformanceAppraisals(EmployeeNo: Code[20]; AppraisalYear: Integer): Text
    var
        Header: Record PerformanceAppraisalHeader;
        Line: Record PerformanceAppraiserLine;
        ResponseObject: JsonObject;
        HeaderObject: JsonObject;
        LineObject: JsonObject;
        JsonArray: JsonArray;
        LinesArray: JsonArray;
        JsonText: Text;
    begin
        if EmployeeNo <> '' then
            Header.SetRange("Employee No.");
        if AppraisalYear <> 0 then
            Header.SetRange("Appraisal Year", AppraisalYear);

        if Header.FindSet() then
            repeat
                Clear(HeaderObject);
                Clear(LinesArray);
                HeaderObject.Add('employeeNo', Header."Employee No.");
                HeaderObject.Add('appraisalYear', Header."Appraisal Year");

                Line.Reset();
                Line.SetRange("Employee No.", EmployeeNo);
                Line.SetRange("Appraisaer Year", AppraisalYear);
                if Line.FindSet() then
                    repeat
                        Clear(LineObject);
                        LineObject.Add('objectiveSettings', Line."Objective Settings");
                        LineObject.Add('objectiveSummary', Line."Objective Summary");
                        LineObject.Add('measure', Line.Measure);
                        LineObject.Add('weight', Line.Weight);
                        LineObject.Add('employeeScore', Line."Employee Score");
                        LineObject.Add('managerScore', Line."Manager Score");
                        LinesArray.Add(LineObject);
                    until Line.Next() = 0;
                HeaderObject.Add('lines', LinesArray);
                JsonArray.Add(HeaderObject);
            until Header.Next() = 0;
        JsonArray.WriteTo(JsonText);
        exit(JsonText);
    end;

    procedure GetPurchaseRequisitions(DocumentNo: Code[20]; Requester: Code[20]): Text
    var
        Header: Record "Purch. Requistion";
        Line: Record "Purchase Requisition Line";
        ResponseObject: JsonObject;
        HeaderObject: JsonObject;
        LineObject: JsonObject;
        JsonArray: JsonArray;
        LinesArray: JsonArray;
        JsonText: Text;
    begin
        if Requester <> '' then
            Header.SetRange(Requester, Requester);
        if DocumentNo <> '' then
            Header.SetRange("No.", DocumentNo);

        if Header.FindSet() then
            repeat
                Clear(HeaderObject);
                Clear(LinesArray);
                HeaderObject.Add('documentNo', Header."No.");
                HeaderObject.Add('documentDate', Format(Header.Date));
                HeaderObject.Add('requester', Header.Requester);
                HeaderObject.Add('requestDescription', Header."Request Description");

                Line.Reset();
                Line.SetRange("Document No.", Header."No.");
                if Line.FindSet() then
                    repeat
                        Clear(LineObject);
                        LineObject.Add('type', Format(Line.Type));
                        LineObject.Add('no', Line."No.");
                        LineObject.Add('description', Line.Description);
                        LineObject.Add('quantity', Line.Quantity);
                        LineObject.Add('unitCost', Line."Unit Cost");
                        LinesArray.Add(LineObject);
                    until Line.Next() = 0;
                HeaderObject.Add('lines', LinesArray);
                JsonArray.Add(HeaderObject);
            until Header.Next() = 0;
        JsonArray.WriteTo(JsonText);
        exit(JsonText);
    end;

    procedure CreateOrEditPurchaseInvoice(DocumentNo: Code[20]; VendorNo: Code[20]; Beneficiary: Code[20]; VendorInvoiceNo: Code[35]; LocationCode: Code[20]; Description: Text[250]; PurchaseLines: Text): Text
    var
        Header: Record "Purchase Header";
        Line: Record "Purchase Line";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        ResponseObject: JsonObject;
        DataObject: JsonObject;
        ResponseText: Text;
        LineNo: Integer;
        LineCount: Integer;
        LineType: Option Item,"G/L Account";
        ItemNo: Code[20];
        //Description: Text[100];
        //RequisitionDate: Text;
        //RequiredItemService: Text[100];
        Quantity: Decimal;
        UnitCost: Decimal;
        // ShortcutDim1: Code[20];
        // ShortcutDim2: Code[20];
        Amount: Decimal;
        AmountLCY: Decimal;
        //LocationNo: Code[20];
        VendorName: Text[100];
        ResponseLbl: Label 'Purchase Requisition processed successfully with %1 lines';
        ErrorNoLines: Label 'No lines provided';
        ErrorInvalidJson: Label 'Invalid JSON format';

    begin
        if DocumentNo <> '' then begin
            if not Header.Get(DocumentNo) then
                Error('Purchase Invoice %1 not found', DocumentNo);

            Line.Reset();
            Line.SetRange("Document No.", Header."No.");
            Line.DeleteAll();
            //Evaluate(Header.Date, DocumentDate);
            if Beneficiary <> '' then
                Header.Validate(Beneficiary, Beneficiary);
            //Header.Validate(, RequestDescription);
            Header.Modify(true);

        end else begin
            Header.Init();
            Header.Validate("Document Type", Header."Document Type"::Invoice);
            // Header.Validate("No.", '');
            Header.Insert(true);
            Header.Validate("Buy-from Vendor No.", VendorNo);
            Header.Validate("Document Date", Today);
            //Evaluate(Header.Date, DocumentDate);
            //if Requester <> '' then
            Header.Validate(Beneficiary, Beneficiary);

            Header.Validate("Vendor Invoice No.", VendorInvoiceNo);
            Header.Validate("Location Code", LocationCode);
            Header.Validate(Description, Description);

        end;

        if PurchaseLines = '' then
            Error(ErrorNoLines);

        if not JsonArray.ReadFrom(PurchaseLines) then
            Error(ErrorInvalidJson);

        if JsonArray.Count = 0 then
            Error(ErrorNoLines);

        LineNo := 0;
        LineCount := 0;

        foreach JsonToken in JsonArray do begin
            JsonObject := JsonToken.AsObject();

            LineNo += 10000;
            LineCount += 1;

            Clear(LineType);
            Clear(ItemNo);
            Clear(Description);
            Clear(Quantity);
            Clear(Amount);
            Clear(AmountLCY);
            Clear(VendorNo);
            //Clear(VendorName);
            Clear(UnitCost);

            if JsonObject.Get('Type', JsonToken) then
                Evaluate(LineType, JsonToken.AsValue().AsText());

            if JsonObject.Get('ItemNo', JsonToken) then
                ItemNo := JsonToken.AsValue().AsCode();

            if JsonObject.Get('Description', JsonToken) then
                Description := JsonToken.AsValue().AsText();

            // if JsonObject.Get('LocationCode', JsonToken) then
            //     LocationNo := JsonToken.AsValue().AsText();

            if JsonObject.Get('Quantity', JsonToken) then
                Quantity := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('UnitCost', JsonToken) then
                UnitCost := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('Amount', JsonToken) then
                Amount := JsonToken.AsValue().AsDecimal();

            Clear(Line);
            Line.Init();

            Line.Validate("Document Type", Line."Document Type"::Invoice);
            Line."Document No." := Header."No.";
            Line."Line No." := LineNo;
            Line.Insert(true);

            Line.Validate(Type, Line.Type::Item);
            Line.Validate("No.", ItemNo);
            //Line.Validate(Description, Description);
            // Evaluate(Line."Requisition Date", RequisitionDate);
            // Line.Validate("Required Item/Service", RequiredItemService);
            Line.Validate("Location Code", LocationCode);
            Line.Validate(Quantity, Quantity);
            Line.Validate("Direct Unit Cost", UnitCost);
            // if ShortcutDim1 <> '' then
            //     Line.Validate("Shortcut Dimension 1 Code", ShortcutDim1);
            // if ShortcutDim2 <> '' then
            //     Line.Validate("Shortcut Dimension 2 Code", ShortcutDim2);
            //Line.Validate(Amount, Amount);
            // if VendorNo <> '' then
            //     Line.Validate("Vendor No.", VendorNo);
            // if VendorName <> '' then
            //     Line.Validate("Vendor Name", VendorName);
            // Line.Insert(true);
            Line.Modify(true);
        end;
        //Header.Validate(Status, Header.Status::Released);
        Header.Modify(true);
        DataObject.Add('No', Header."No.");
        DataObject.Add('processedLines', LineCount);

        ResponseObject.Add('success', true);
        ResponseObject.Add('message', StrSubstNo(ResponseLbl, LineCount));
        ResponseObject.Add('data', DataObject);

        ResponseObject.WriteTo(ResponseText);
        exit(ResponseText);
    end;

    // procedure GetPayrolls(PayrollPeriod: Code[10]; EmployeeNo: Code[20]): Text
    // var
    //     PayrollHeader: Record PayrollHeader;
    //     PayrollLine: Record PayrollLine;
    //     HeaderObject: JsonObject;
    //     LineObject: JsonObject;
    //     JsonArray: JsonArray;
    //     LinesArray: JsonArray;
    //     JsonText: Text;
    // begin
    //     if PayrollPeriod <> '' then
    //         PayrollHeader.SetRange("Payroll Period", PayrollPeriod);

    //     if PayrollHeader.FindSet() then
    //         repeat
    //             //Clear(HeaderObject);
    //             Clear(LinesArray);

    //             // Header Information
    //             // HeaderObject.Add('payrollPeriod', PayrollHeader."Payroll Period");
    //             // HeaderObject.Add('description', PayrollHeader.Description);
    //             // HeaderObject.Add('payrollCreationDate', Format(PayrollHeader."Payroll Creation Date"));
    //             // HeaderObject.Add('approvalStatus', Format(PayrollHeader."Approval Status"));
    //             // HeaderObject.Add('employeeFilter', PayrollHeader."Employee Filter");
    //             // HeaderObject.Add('dimension1Filter', PayrollHeader."Shortcut Dimension 1 Filter");
    //             // HeaderObject.Add('dimension2Filter', PayrollHeader."Shortcut Dimension 2 Filter");
    //             // HeaderObject.Add('salaryCodeFilter', PayrollHeader."Salary Code Filter");
    //             // HeaderObject.Add('createdBy', PayrollHeader."Created By");
    //             // HeaderObject.Add('createdTime', Format(PayrollHeader."Created Time"));
    //             // HeaderObject.Add('lastModifiedBy', PayrollHeader."Last Modified By");
    //             // HeaderObject.Add('lastModifiedDate', Format(PayrollHeader."Last Modified Date"));
    //             // HeaderObject.Add('lastModifiedTime', Format(PayrollHeader."Last Modified Time"));

    //             // Lines
    //             PayrollLine.Reset();
    //             PayrollLine.SetRange("Payroll Period", PayrollHeader."Payroll Period");
    //             if EmployeeNo <> '' then
    //                 PayrollLine.SetRange("Employee Code", EmployeeNo);
    //             if PayrollLine.FindSet() then
    //                 repeat
    //                     Clear(LineObject);
    //                     LineObject.Add('payrollPeriod', PayrollLine."Payroll Period");
    //                     LineObject.Add('employeeCode', PayrollLine."Employee Code");
    //                     LineObject.Add('employeeName', PayrollLine."Employee Name");
    //                     LineObject.Add('jobTitle', PayrollLine."Job Title");
    //                     LineObject.Add('salaryCode', PayrollLine."Salary Code");
    //                     LineObject.Add('dimension1Code', PayrollLine."Global Dimension 1 Code");
    //                     LineObject.Add('dimension2Code', PayrollLine."Global Dimension 2 Code");
    //                     LineObject.Add('bookAmount', PayrollLine."Book Amount");
    //                     LineObject.Add('payableAmount', PayrollLine."Payable Amount");
    //                     LineObject.Add('lateDays', PayrollLine."Late Days");
    //                     LineObject.Add('extraDaysWorked', PayrollLine."Extra Days Worked");
    //                     LineObject.Add('absentDays', PayrollLine."Absent  (Days)");
    //                     LineObject.Add('employeeType', Format(PayrollLine."Employee Type"));
    //                     LineObject.Add('employmentDate', Format(PayrollLine."Employment Date"));
    //                     LineObject.Add('employmentContractCode', PayrollLine."Employment Contract Code");

    //                     LinesArray.Add(LineObject);
    //                 until PayrollLine.Next() = 0;

    //             HeaderObject.Add('lines', LinesArray);
    //         //JsonArray.Add(HeaderObject);

    //         until PayrollHeader.Next() = 0;

    //     LinesArray.WriteTo(JsonText);
    //     //JsonArray.WriteTo(JsonText);
    //     exit(JsonText);
    // end;



    procedure GetPayrolls(PayrollPeriod: Code[10]; EmployeeNo: Code[20]): Text
    var
        PayrollHeader: Record PayrollHeader;
        PayrollLine: Record PayrollDetailLine;
        HeaderObject: JsonObject;
        LineObject: JsonObject;
        JsonArray: JsonArray;
        LinesArray: JsonArray;
        JsonText: Text;
    begin
        if PayrollPeriod <> '' then
            PayrollHeader.SetRange("Payroll Period", PayrollPeriod);

        if PayrollHeader.FindSet() then
            repeat
                //Clear(HeaderObject);
                Clear(LinesArray);



                // Lines
                PayrollLine.Reset();
                PayrollLine.SetRange("Payroll Period", PayrollHeader."Payroll Period");
                if EmployeeNo <> '' then
                    PayrollLine.SetRange("Employee No.", EmployeeNo);
                if PayrollLine.FindSet() then
                    repeat
                        Clear(LineObject);
                        LineObject.Add('employeeNo', PayrollLine."Employee No.");
                        LineObject.Add('employeeName', PayrollLine."Employee Name");
                        LineObject.Add('elementCode', PayrollLine."Element Code");
                        LineObject.Add('elementName', PayrollLine."Element Name");
                        LineObject.Add('payrollPeriod', PayrollLine."Payroll Period");
                        LineObject.Add('bookAmount', PayrollLine."Book Amount");
                        LineObject.Add('payableAmount', PayrollLine."Payable Amount");
                        LineObject.Add('noOfWorkedDays', PayrollLine."No of Worked Days");
                        LineObject.Add('noOfDaysInTheMonth', PayrollLine."No of Days In the Month");
                        LinesArray.Add(LineObject);
                    until PayrollLine.Next() = 0;

                HeaderObject.Add('lines', LinesArray);
            //JsonArray.Add(HeaderObject);

            until PayrollHeader.Next() = 0;

        LinesArray.WriteTo(JsonText);
        //JsonArray.WriteTo(JsonText);
        exit(JsonText);
    end;



}