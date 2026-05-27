table 50182 SalarySetupHeader
{
    Caption = 'Salary Setup Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Salary Code"; Code[10])
        {
            Caption = 'Salary Code';
            TableRelation = "Employment Contract".Code;
        }
        field(2; "Employee Cadre Code"; Code[50])
        {
            Caption = 'Employee Cadre Code';
        }

        field(3; "Created By"; Code[50])
        {
            Caption = 'Created By';
        }
        field(4; "Created Date"; Date)
        {
            Caption = 'Created Date';
        }
        field(5; "Created Time"; Time)
        {
            Caption = 'Created Time';
        }
        field(6; "Last Modified By"; Code[50])
        {
            Caption = 'Last Modified By';
        }
        field(7; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
        }
        field(8; "Last Modified Time"; Time)
        {
            Caption = 'Last Modified Time';
        }
        field(9; "Gross Pay"; Decimal)
        {
            Caption = 'Gross Pay';

            trigger OnValidate()
            begin

                if "Gross Pay" = 0 then begin
                    SalSetupLine.SetRange(SalSetupLine."Salary Code", "Salary Code");
                    if SalSetupLine.FindSet() then
                        SalSetupLine.DeleteAll();
                end;

                TestField("Apply to");

                HRSetup.TestField("Office Basic %");
                HRSetup.TestField("Office House %");
                HRSetup.TestField("Office Transport %");

                HRSetup.TestField("Rig Basic %");
                HRSetup.TestField("Rig House %");
                HRSetup.TestField("Rig Transport %");
                HRSetup.TestField("Rig Utility %");

                HRSetup.TestField("Pension Employee %");
                HRSetup.TestField("Pension Employer %");

                Ln := 10;

                PayElement.Setfilter("Appear in Salary Setup", '%1', true);
                IF PayElement.FindSet() then
                    repeat
                        SalSetupLine.Init();
                        SalSetupLine."Salary Code" := "Salary Code";
                        SalSetupLine."Line No." := Ln;
                        SalSetupLine."Element Code" := PayElement."Element Code";
                        SalSetupLine."Element Name" := PayElement."Element Name";

                        if PayElement.Deduction = true then
                            SalSetupLine.Deduction := true;

                        if PayElement.Earning = true then
                            SalSetupLine.Earning := true;

                        if PayElement."Function of Paye" then
                            SalSetupLine.Taxable := true;

                        if PayElement."Is Pension Employee" then
                            SalSetupLine.Amount := HRSetup."Pension Employee %" * (SumForPension);

                        If ("Apply to" = "Apply to"::"Office Staff") then begin
                            If PayElement."Is Basic" then begin
                                SalSetupLine.Amount := HRSetup."Office Basic %" * "Gross Pay";
                                SumForPension += SalSetupLine.Amount;
                            end;
                            If PayElement."Is House" then begin
                                SalSetupLine.Amount := HRSetup."Office House %" * "Gross Pay";
                                SumForPension += SalSetupLine.Amount;
                            end;
                            If PayElement."Is Transport" then begin
                                SalSetupLine.Amount := HRSetup."Office Transport %" * "Gross Pay";
                                SumForPension += SalSetupLine.Amount;
                            end;
                        end;

                        If ("Apply to" = "Apply to"::"Rig Staff") then begin
                            If PayElement."Is Basic" then begin
                                SalSetupLine.Amount := HRSetup."Rig Basic %" * "Gross Pay";
                                SumForPension += SalSetupLine.Amount;
                            end;
                            If PayElement."Is House" then begin
                                SalSetupLine.Amount := HRSetup."Rig House %" * "Gross Pay";
                                SumForPension += SalSetupLine.Amount;
                            end;
                            If PayElement."Is Transport" then begin
                                SalSetupLine.Amount := HRSetup."Rig Transport %" * "Gross Pay";
                                SumForPension += SalSetupLine.Amount;
                            end;
                            If PayElement."Is Utility" then begin
                                SalSetupLine.Amount := HRSetup."Rig Utility %" * "Gross Pay";
                            end;

                        end;
                        ln += 10;
                        if Not (SalSetupLine.Insert()) then;
                    until PayElement.Next = 0;
            end;
        }
        field(10; "Apply to"; Option)
        {
            Caption = 'Apply to';
            OptionMembers = ,"Rig Staff","Office Staff";
        }

        field(15; "Reimbursable Pay"; Decimal)
        {
            Caption = 'Reimbursable Pay';
        }
    }
    keys
    {
        key(PK; "Salary Code")

        {
            Clustered = true;
        }
    }

    var
        SalSetupLine: Record SalarySetupLine;
        HRSetup: Record "Human Resources Setup";
        PayElement: Record PayrollElement;

        ln: Integer;

        SumForPension: Decimal;
}
