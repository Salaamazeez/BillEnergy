codeunit 50500 "ESS Management"
{
    Permissions =
     tabledata "Item Ledger Entry" = RIMD;
    trigger OnRun()
    begin

    end;

    procedure CreateorEditPaymentRequest(DocumentNo: Code[20]; PostingDate: Text; Requester: Code[20]; Beneficiary: Code[20]; BalAccType: Option "G/L Account",Vendor,Staff,"Bank Account"; BalAccNo: Code[20]; CurrencyCode: Code[10]; Description: Text; PurchReqNo: Code[20]; ReqAmount: Decimal; ShortcutDim1: Code[20]; ShortcutDim2: Code[20]; VoucherCreated: Boolean; TransactionType: Option " ",Loan,"Staff Adv"; LoanId: Code[20]; PaymentReqLines: Text): Text
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
            Header.Validate("Bal Account No.", BalAccNo);
            Header.Validate("Currency Code", CurrencyCode);
            Header.Validate("Request Description", Description);
            Header.Validate("Purchase Requisition No.", PurchReqNo);
            Header.Validate("Shortcut Dimension 1 Code", ShortcutDim1);
            Header.Validate("Shortcut Dimension 2 Code", ShortcutDim2);
            Header."Voucher Created?" := VoucherCreated;
            Header."Transaction type" := TransactionType;
            Header."Loan ID" := LoanId;
            Header.Modify(true);

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
            Header.Validate("Bal Account No.", BalAccNo);
            Header.Validate("Currency Code", CurrencyCode);
            Header.Validate("Request Description", Description);
            Header.Validate("Purchase Requisition No.", PurchReqNo);
            Header.Validate("Shortcut Dimension 1 Code", ShortcutDim1);
            Header.Validate("Shortcut Dimension 2 Code", ShortcutDim2);
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
            Line.Validate("Account Type", AccType);
            Line.Validate("Account No.", AccountNo);
            Line.Validate(Amount, Amount);
            Line.Validate("Shortcut Dimension 1 Code", ShortcutDimCode1);
            Line.Validate("Shortcut Dimension 2 Code", ShortcutDimCode2);
            Line.Insert(true);
        end;

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

    procedure CreateOrEditCashAdvance(DocumentNo: Code[20]; DocumentDate: Text; Requester: Code[50]; Description: Text[100]; DueDate: Text; DebitAccountType: Option "G/L Account",Vendor,Staff,"Bank Account"; DebitAccountNo: Code[20]; CurrencyCode: Code[10]; ShortcutDim1: Code[20]; ShortcutDim2: Code[20]; TransactionType: Option " ",Loan,"Staff Adv"; LoanID: Code[20]; CashAdvanceLines: Text): Text
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
            Header.Validate(Requester, Requester);
            Header.Validate(Description, Description);
            Header.Validate("Debit  Account Type", DebitAccountType);
            Header.Validate("Debit Account No.", DebitAccountNo);
            Header.Validate("Currency Code", CurrencyCode);
            Header.Validate("Shortcut Dimension 1 Code", ShortcutDim1);
            Header.Validate("Shortcut Dimension 2 Code", ShortcutDim2);
            Header.Validate("Transaction type", TransactionType);
            Header.Validate("Loan ID", LoanID);
            Header.Modify(true);

            Line.Reset();
            Line.SetRange("Document No.", Header."No.");
            Line.DeleteAll();
        end else begin
            Header.Init();
            Header.Validate("No.", '');
            Header.Insert(true);
            Evaluate(Header.Date, DocumentDate);
            Evaluate(Header."Due Date", DueDate);
            Header.Validate(Requester, Requester);
            Header.Validate(Description, Description);
            Header.Validate("Debit  Account Type", DebitAccountType);
            Header.Validate("Debit Account No.", DebitAccountNo);
            Header.Validate("Currency Code", CurrencyCode);
            Header.Validate("Shortcut Dimension 1 Code", ShortcutDim1);
            Header.Validate("Shortcut Dimension 2 Code", ShortcutDim2);
            Header.Validate("Transaction type", TransactionType);

            if LoanID <> '' then
                Header.Validate("Loan ID", LoanID);
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

            if JsonObject.Get('ShortcutDimension1Code', JsonToken) then
                Dim1 := JsonToken.AsValue().AsCode();

            if JsonObject.Get('ShortcutDimension2Code', JsonToken) then
                Dim2 := JsonToken.AsValue().AsCode();

            Clear(Line);
            Line.Init();

            Line."Document No." := Header."No.";
            Line."Line No." := LineNo;
            Line.Validate("Expense Code", ExpenseCode);
            Line.Validate("Payment Details", PaymentDetails);
            Line.Validate("Account No.", AccountNo);
            Line.Validate("Bal. Account No.", BalAccountNo);
            Line.Validate("Shortcut Dimension 1 Code", Dim1);
            Line.Validate("Shortcut Dimension 2 Code", Dim2);
            Line.Validate(Amount, Amount);
            Line.Insert(true);
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


    procedure CreateOrEditStoreRequisition(DocumentNo: Code[20]; DocumentDate: Text; Requester: Code[50]; Location: Code[20]; ProjectJobDescription: Text[100]; WorkOrderNo: Code[20]; StoreReqLines: Text): Text
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
            Line.Validate(Description, Description);
            Line.Validate("Unit of Issue", UnitOfIssue);
            Line.Validate("Location Code", LocationCode);
            Line.Validate("Requested Qty.", RequestedQty);
            Line.Validate("Unit Price", UnitPrice);
            Line.Validate("Gen Bus. Posting Group", GenBusPostingGroup);
            Line.Insert(true);
        end;

        DataObject.Add('No', Header."No.");
        DataObject.Add('processedLines', LineCount);
        ResponseObject.Add('success', true);
        ResponseObject.Add('message', StrSubstNo(ResponseLbl, LineCount));
        ResponseObject.Add('documentNo', Header."No.");
        ResponseObject.Add('data', DataObject);
        ResponseObject.WriteTo(ResponseText);
        exit(ResponseText);
    end;

    procedure CreateOrEditStoresReturn(DocumentNo: Code[20]; DocumentDate: Text; Requester: Code[50]; Location: Code[20]; IssueNo: Code[20]; ProjectJobDescription: Text[100]; WorkOrderNo: Code[20]; StoreReturnLines: Text): Text
    var
        Header: Record "Stores Return";
        Line: Record "Stores Return Line";
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

            if JsonObject.Get('Description', JsonToken) then
                Description := JsonToken.AsValue().AsText();

            if JsonObject.Get('UnitOfIssue', JsonToken) then
                UnitOfIssue := JsonToken.AsValue().AsCode();

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

            // if JsonObject.Get('IssuedQty', JsonToken) then
            //     IssuedQty := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('UnitPrice', JsonToken) then
                UnitPrice := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('GenBusPostingGroup', JsonToken) then
                GenBusPostingGroup := JsonToken.AsValue().AsCode();

            Line.Init();

            Line."Document No." := Header."No.";
            Line."Line No." := LineNo;

            Line.Validate("Stock Code", StockCode);
            Line.Validate(Description, Description);
            Line.Validate("Unit of Issue", UnitOfIssue);
            Line.Validate("Location Code", LocationCode);
            Line.Validate("Requested Qty.", RequestedQty);
            Line.Validate("Returned Qty.", ReturnedQty);
            Line.Validate("Qty to Return", QtyToReturn);
            Line.Validate("Qty Returned", QtyReturned);
            Line.Validate("Issued Qty", IssuedQty);
            Line.Validate("Unit Price", UnitPrice);
            Line.Validate("Gen Bus. Posting Group", GenBusPostingGroup);
            Line.Insert(true);
        end;

        DataObject.Add('No', Header."No.");
        DataObject.Add('processedLines', LineCount);

        ResponseObject.Add('success', true);
        ResponseObject.Add('message', StrSubstNo(ResponseLbl, LineCount));
        ResponseObject.Add('documentNo', Header."No.");
        ResponseObject.Add('data', DataObject);
        ResponseObject.WriteTo(ResponseText);
        exit(ResponseText);
    end;


    procedure CreateOrEditRetirement(DocumentNo: Code[20]; TransType: Option " ",Loan,"Staff Adv"; LoanID: Code[20]; RetirementDate: Text; RetiringOfficer: Code[50]; RetirementRef: Code[50]; DebitAccountType: Option "G/L Account",Vendor,Staff,"Bank Account"; DebitAccountNo: Code[20]; Dim1: Code[20]; Dim2: Code[20]; CurrencyCode: Code[10]; Purpose: Text[250]; CashReceiptNo: Code[50]; RetirementLines: Text): Text
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

            Header.Validate("Transaction type", TransType);
            Header.Validate("Loan ID", LoanID);
            Evaluate(Header.Date, RetirementDate);
            Header.Validate("Retiring Officer", RetiringOfficer);
            Header.Validate("Retirement Ref.", RetirementRef);
            Header.Validate("Debit  Account Type", DebitAccountType);
            Header.Validate("Debit Account No.", DebitAccountNo);
            Header.Validate("Shortcut Dimension 1 Code", Dim1);
            Header.Validate("Shortcut Dimension 2 Code", Dim2);
            Header.Validate("Currency Code", CurrencyCode);
            Header.Validate(Purpose, Purpose);
            Header.Validate("Cash Recpt No./Pmt Voucher", CashReceiptNo);
            Header.Modify(true);

            Line.Reset();
            Line.SetRange("Document No.", Header."No.");
            Line.DeleteAll();
        end else begin
            Header.Init();
            Header.Validate("No.", '');
            Header.Insert(true);
            Header.Validate("Transaction type", TransType);
            Header.Validate("Loan ID", LoanID);
            Evaluate(Header.Date, RetirementDate);
            Header.Validate("Retiring Officer", RetiringOfficer);
            Header.Validate("Retirement Ref.", RetirementRef);
            Header.Validate("Debit  Account Type", DebitAccountType);
            Header.Validate("Debit Account No.", DebitAccountNo);
            Header.Validate("Shortcut Dimension 1 Code", Dim1);
            Header.Validate("Shortcut Dimension 2 Code", Dim2);
            Header.Validate("Currency Code", CurrencyCode);
            Header.Validate(Purpose, Purpose);
            Header.Validate("Cash Recpt No./Pmt Voucher", CashReceiptNo);
            Header.Modify(true);
        end;

        if not JsonArray.ReadFrom(RetirementLines) then
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

            if JsonObject.Get('AmountLCY', JsonToken) then
                LineAmountLCY := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('ShortcutDim1', JsonToken) then
                ShortcutDim1 := JsonToken.AsValue().AsCode();

            if JsonObject.Get('ShortcutDim2', JsonToken) then
                ShortcutDim2 := JsonToken.AsValue().AsCode();

            if JsonObject.Get('CurrencyCode', JsonToken) then
                LineCurrency := JsonToken.AsValue().AsCode();

            Line.Init();

            Line."Document No." := Header."No.";
            Line."Line No." := LineNo;

            Line.Validate("Expense Code", ExpenseCode);
            Line.Validate("Transaction Details", TransactionDetails);
            Line.Validate("Account Type", AccountType);
            Line.Validate("Account No.", AccountNo);
            Line.Validate("Account Name", AccountName);
            Line.Validate(Amount, LineAmount);
            Line.Validate("Amount (LCY)", LineAmountLCY);
            Line.Validate("Shortcut Dimension 1 Code", ShortcutDim1);
            Line.Validate("Shortcut Dimension 2 Code", ShortcutDim2);
            Line.Validate("Currency Code", LineCurrency);

            Line.Insert(true);
        end;

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
            Header.Validate("Leave Code", '');
            Header.Insert(true);
            Header.Validate("Applying Type", ApplyingType);
            Header.Validate("Employee No.", EmployeeNo);
            Header.Validate(Description, Description);
            Evaluate(Header."First Day of Vacation", StartDate);
            Evaluate(Header."Leave End Date", EndDate);
            Header.Validate("Leave Type", LeaveType);
            Header.Modify(true);
        end;

        DataObject.Add('LeaveCode', Header."Leave Code");
        ResponseObject.Add('success', true);
        ResponseObject.Add('message', 'Leave Application processed successfully');
        ResponseObject.Add('data', DataObject);
        ResponseObject.WriteTo(ResponseText);
        exit(ResponseText);
    end;

    procedure CreateOrEditPerformanceAppraisal(EmployeeNo: Code[20]; LineManagerNo: Code[20]; AppraisalYear: Integer; JobTitle: Text[100]; StatusValue: Text[30]; NoOfObjectives: Integer; Dim1: Code[20]; Dim2: Code[20]; Closed: Boolean; EmpArea: Text[100]; LeaveActions: Text[250]; ExpectedCompletionDate: Text; EmpProgressUpdate: Text; EmpDevPlanUpdate: Text; MgrProgressUpdate: Text; MgrDevPlanUpdate: Text; EmpRatingPct: Decimal; EmpFinalRating: Decimal; EmpFinalComment: Text[250]; EmpSignOff: Option ,Accepted,Rejected; MgrRatingPct: Decimal; MgrFinalRating: Decimal; MgrFinalComment: Text[250]; AppraisalLines: Text): Text
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
        if EmployeeNo <> '' then begin
            if not Header.Get(EmployeeNo, AppraisalYear) then
                Error('Performance Appraisal %1 (%2) not found', EmployeeNo, AppraisalYear);

            Evaluate(Header.Status, StatusValue);

            Header.Validate("Line Manager No.", LineManagerNo);
            Header.Validate("Job Title", JobTitle);
            Header.Validate("No. of Objectives", NoOfObjectives);
            Header.Validate("Shortcut Dimension 1 Code", Dim1);
            Header.Validate("Shortcut Dimension 2 Code", Dim2);
            Header.Validate(Closed, Closed);

            Header.Validate("Area", EmpArea);
            Header.Validate("Actions", LeaveActions);
            Evaluate(Header."Expected Completon Date", ExpectedCompletionDate);

            Header.Validate("Employee Progress update", EmpProgressUpdate);
            Header.Validate("Emp. Mid-Year Dev. Plan Update", EmpDevPlanUpdate);
            Header.Validate("Manager Progress Update", MgrProgressUpdate);
            Header.Validate("Mgr. Mid-Year Dev. Plan Update", MgrDevPlanUpdate);

            Header.Validate("Employee Rating%", EmpRatingPct);
            Header.Validate("Employee Final Rating", EmpFinalRating);
            Header.Validate("Employee Final Comment", EmpFinalComment);
            Header.Validate("Employee Sign-off", EmpSignOff);

            Header.Validate("Manager Rating%", MgrRatingPct);
            Header.Validate("Manager Final Rating", MgrFinalRating);
            Header.Validate("Manager Final Comment", MgrFinalComment);

            Header.Modify(true);

        end else begin
            Header.Init();
            Header.Validate("Employee No.", EmployeeNo);
            Header.Validate("Appraisal Year", AppraisalYear);
            Header.Insert(true);

            Evaluate(Header.Status, StatusValue);

            Header.Validate("Line Manager No.", LineManagerNo);
            Header.Validate("Job Title", JobTitle);
            Header.Validate("No. of Objectives", NoOfObjectives);
            Header.Validate("Shortcut Dimension 1 Code", Dim1);
            Header.Validate("Shortcut Dimension 2 Code", Dim2);
            Header.Validate(Closed, Closed);

            Header.Validate("Area", EmpArea);
            Header.Validate("Actions", LeaveActions);
            Evaluate(Header."Expected Completon Date", ExpectedCompletionDate);

            Header.Validate("Employee Progress update", EmpProgressUpdate);
            Header.Validate("Emp. Mid-Year Dev. Plan Update", EmpDevPlanUpdate);
            Header.Validate("Manager Progress Update", MgrProgressUpdate);
            Header.Validate("Mgr. Mid-Year Dev. Plan Update", MgrDevPlanUpdate);

            Header.Validate("Employee Rating%", EmpRatingPct);
            Header.Validate("Employee Final Rating", EmpFinalRating);
            Header.Validate("Employee Final Comment", EmpFinalComment);
            Header.Validate("Employee Sign-off", EmpSignOff);

            Header.Validate("Manager Rating%", MgrRatingPct);
            Header.Validate("Manager Final Rating", MgrFinalRating);
            Header.Validate("Manager Final Comment", MgrFinalComment);

            Header.Modify(true);
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

        DataObject.Add('EmployeeNo', EmployeeNo);
        DataObject.Add('AppraisalYear', AppraisalYear);
        DataObject.Add('processedLines', LineCount);

        ResponseObject.Add('success', true);
        ResponseObject.Add('message', StrSubstNo(ResponseLbl, LineCount));
        ResponseObject.Add('data', DataObject);

        ResponseObject.WriteTo(ResponseText);
        exit(ResponseText);
    end;

    procedure CreateOrEditPurchaseRequisition(DocumentNo: Code[20]; DocumentDate: Text; Requester: Code[50]; RequestDescription: Text[250]; RequisitionAmount: Decimal; StatusValue: Text; PurchOrderCreated: Boolean; PurchOrderPosted: Boolean; SRQRefNo: Code[50]; PurchaseReqLines: Text): Text
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

            Evaluate(Header.Date, DocumentDate);
            Header.Validate(Requester, Requester);
            Header.Validate("Request Description", RequestDescription);
            Header.Validate("Requisition Amount", RequisitionAmount);
            Evaluate(Header.Status, StatusValue);
            Header.Validate("Purch. Order Created?", PurchOrderCreated);
            Header.Validate("Purchase Order Posted", PurchOrderPosted);
            Header.Validate("SRQ Ref.No.", SRQRefNo);
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
            Header.Validate("Request Description", RequestDescription);
            Header.Validate("Requisition Amount", RequisitionAmount);
            Evaluate(Header.Status, StatusValue);
            Header.Validate("Purch. Order Created?", PurchOrderCreated);
            Header.Validate("Purchase Order Posted", PurchOrderPosted);
            Header.Validate("SRQ Ref.No.", SRQRefNo);

            Header.Modify(true);
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

            if JsonObject.Get('ShortcutDimension1', JsonToken) then
                ShortcutDim1 := JsonToken.AsValue().AsCode();

            if JsonObject.Get('Amount', JsonToken) then
                Amount := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('AmountLCY', JsonToken) then
                AmountLCY := JsonToken.AsValue().AsDecimal();

            if JsonObject.Get('VendorNo', JsonToken) then
                VendorNo := JsonToken.AsValue().AsCode();

            if JsonObject.Get('VendorName', JsonToken) then
                VendorName := JsonToken.AsValue().AsText();

            Clear(Line);
            Line.Init();

            Line."Document No." := Header."No.";
            Line."Line No." := LineNo;

            Line.Validate(Type, LineType);
            Line.Validate("No.", ItemNo);
            Line.Validate(Description, Description);
            Evaluate(Line."Requisition Date", RequisitionDate);
            Line.Validate("Required Item/Service", RequiredItemService);
            Line.Validate(Quantity, Quantity);
            Line.Validate("Unit Cost", UnitCost);
            Line.Validate("Shortcut Dimension 1 Code", ShortcutDim1);
            Line.Validate(Amount, Amount);
            Line.Validate("Amount (LCY)", AmountLCY);
            Line.Validate("Vendor No.", VendorNo);
            Line.Validate("Vendor Name", VendorName);
            Line.Insert(true);
        end;

        DataObject.Add('No', Header."No.");
        DataObject.Add('processedLines', LineCount);

        ResponseObject.Add('success', true);
        ResponseObject.Add('message', StrSubstNo(ResponseLbl, LineCount));
        ResponseObject.Add('data', DataObject);

        ResponseObject.WriteTo(ResponseText);
        exit(ResponseText);
    end;




    var
        myInt: Integer;
}