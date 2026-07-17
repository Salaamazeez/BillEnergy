report 50114 ImportOvertimeVariables
{
    //Excel to have two column EMPLOYEE NO, LEAVE ENTITLED
    //ApplicationArea = All;
    Caption = 'Import Overtime Variables';
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
                WindowDialog.Update(1, OvertimeRec."Period Code");
                WindowDialog.Update(2, OvertimeRec."Employee No.");

                if Overtime.Get(format(ColText[1])) then begin
                    OvertimeRec.Init();
                    Evaluate(OvertimeRec."Period Code", ColText[1]);
                    OvertimeRec.VALIDATE("Employee No.", ColText[2]);
                    //Evaluate(OvertimeRec."Days Worked", ColText[3]);
                    Evaluate(OvertimeRec."Extra Days Worked", ColText[3]);


                    OvertimeRec.Validate("Element Code", PayElement."Element Code");
                    IF (NOT OvertimeRec.INSERT(True)) then
                        OvertimeRec.Modify();
                end else
                    error('The Period Code specify in the excel %1 is not thesame as the Period Code %2 in the Overtime', ColText[1], Overtime."Period Code");

            end;

            trigger OnPreDataItem()
            begin
                PayElement.Reset();
                PayElement.SetFilter("Is Overtime", '%1', true);
                if Not (PayElement.FindFirst()) then
                    error('You did not setup Overtime in Payroll Element');

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
        WindowDialog.Open(TextDisplay, OvertimeRec."Period Code", OvertimeRec."Employee No.");
    end;

    trigger OnPostReport()
    begin
        Message(msgfinishUpdate);
    end;

    var

        ExcelBuf: Record "Excel Buffer" temporary;
        ColText: array[100] of Text[250];
        FileMgt: Codeunit "File Management";
        OvertimeRec: Record OvertimeLine;
        Overtime: Record OvertimeHeader;

        PayElement: Record PayrollElement;

        FileName: Text[250];
        ServerFileName: Text[250];
        SheetName: Text[250];
        instrm: instream;

        Text005: Label 'Imported from Excel';
        Text006: Label 'Import Excel File';
        msgfinishUpdate: label 'Overtime Variables successfully updated';
        WindowDialog: Dialog;
        TextDisplay: Label 'import Record ###########1 with transaction Date ##########2:';
        ConfirmDuplicate: label 'Record with %1 %2 %3 already exist do you want to modify and continue the import?';
        RecordCount: Integer;
        RecordModified: Integer;
        confirmMgt: Codeunit "Confirm Management";
        UserSetup: Record "User Setup";
        ErrormodifyData: label 'You do not have the Overtime Permission Admin to modify the data';

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