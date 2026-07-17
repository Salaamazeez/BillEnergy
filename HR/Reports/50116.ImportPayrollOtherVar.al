report 50116 ImportPayrollOtherVar
{
    //Excel to have two column EMPLOYEE NO, LEAVE ENTITLED
    //ApplicationArea = All;
    Caption = 'Import Payroll Other Variables';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    ApplicationArea = All;

    //DefaultLayout = RDLC;
    //RDLCLayout = 'Import Employee Data.rdl';
    dataset
    {
        dataitem(Integer; "Integer")
        {

            trigger OnAfterGetRecord()

            begin

                ImportSheet(Number);

                IF (LoopCount = False) then begin
                    LoopCount := true;
                    PayPeriods2 := Format(ColText[2]);
                end;

                IF (PayPeriods2 <> ColText[2]) then
                    Error('The Payroll Period are inconsistent please review your excel file and ensure all Payroll Period are thesame for all the employee');

                WindowDialog.Update(1, PayrollOtherVar."Payroll Period");
                WindowDialog.Update(2, PayrollOtherVar."Employee No.");

                PayrollOtherVar.Init();
                PayrollOtherVar.VALIDATE("Employee No.", ColText[1]);
                PayrollOtherVar.Validate("Payroll Period", ColText[2]);
                PayrollOtherVar.Validate("Element Code", ColText[3]);
                Evaluate(PayrollOtherVar."Hours/Days Late", ColText[4]);
                IF (NOT PayrollOtherVar.INSERT(True)) then
                    PayrollOtherVar.Modify();
            end;

            trigger OnPreDataItem()
            begin
                LoopCount := False;

                //PayElement.Reset();
                //PayElement.SetFilter("Is Late", '%1', true);
                //if Not (PayElement.FindFirst()) then
                // error('You did not setup Late in Payroll Element');

                ExcelBuf.RESET;
                ExcelBuf.DELETEALL;
                //ExcelBuf.OpenBook(ServerFileName, SheetName);
                ExcelBuf.OpenBookStream(instrm, SheetName);
                ExcelBuf.ReadSheet;
                IF ExcelBuf.FINDLAST THEN
                    SETRANGE(Number, 2, ExcelBuf."Row No.");
            end;

            trigger OnPostDataItem()

            begin
                WindowDialog.Close();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Option)
                {
                    group("Import From")
                    {
                        field(FileName; FileName)
                        {
                            Caption = 'Workbook Filename';
                            ApplicationArea = All;
                            trigger OnAssistEdit()
                            begin
                                RequestFile;
                                SheetName := ExcelBuf.SelectSheetsNameStream(instrm);
                            end;
                        }
                        field(SheetName; SheetName)
                        {
                            Caption = 'Sheet Name';
                            ApplicationArea = All;
                            trigger OnAssistEdit()
                            begin
                                IF ServerFileName = '' THEN BEGIN
                                    RequestFile;
                                END;

                                SheetName := ExcelBuf.SelectSheetsNameStream(instrm);

                            end;
                        }
                    }

                }

            }

        }
        actions
        {
            area(processing)
            {
            }
        }
        trigger OnInit()
        begin

        end;

        trigger OnOpenPage()
        begin
        end;
    }
    trigger OnInitReport()
    begin
    end;

    trigger OnPreReport()
    begin
        WindowDialog.Open(TextDisplay, PayrollOtherVar."Payroll Period", PayrollOtherVar."Employee No.");
    end;

    trigger OnPostReport()
    begin
        Message(msgfinishUpdate);
    end;

    var
        TextDisplay: Label 'importing payroll other variables for employee ###########1 for Period ##########2:';
        ExcelBuf: Record "Excel Buffer" temporary;
        ColText: array[100] of Text[250];
        FileMgt: Codeunit "File Management";
        PayrollOtherVar: Record PayrollOthervariables;

        FileName: Text[250];
        ServerFileName: Text[250];
        SheetName: Text[250];
        instrm: instream;

        Text005: Label 'Imported from Excel';
        Text006: Label 'Import Excel File';
        msgfinishUpdate: label 'Employee Reimbursable sucessfully updated';
        WindowDialog: Dialog;

        PayPeriods2: code[20];
        LoopCount: Boolean;
        PayElement: Record PayrollElement;

    Procedure ImportSheet(RowNumber: Integer)
    var
    begin
        CLEAR(ColText);
        ExcelBuf.SETRANGE(ExcelBuf."Row No.", RowNumber);
        IF ExcelBuf.FINDFIRST THEN BEGIN
            REPEAT
                ColText[ExcelBuf."Column No."] := ExcelBuf."Cell Value as Text";
            UNTIL ExcelBuf.NEXT = 0;
        END;
    end;

    procedure RequestFile()
    begin
        /*
        IF FileName <> '' THEN
            ServerFileName := FileMgt.UploadFile(Text006, FileName)

        ELSE
            ServerFileName := FileMgt.UploadFile(Text006, '.xlsx');

        FileName := FileMgt.GetFileName(ServerFileName);
        */
        UploadIntoStream(Text006, '', 'Excel(.xlsx)|*.xlsx', FileName, instrm);
    end;
}