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


        field(9; "Gross Pay"; Decimal)
        {
            Caption = 'Gross Pay';

            trigger OnValidate()
            begin
                BasicAmt := 0;
                HouseAAmt := 0;
                TransportAmt := 0;
                UtilityAmt := 0;
                TotalDedAmt := 0;
                SumForPension := 0;

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

                //Ln := 10;

                PayElement.Setfilter("Appear in Salary Setup", '%1', true);
                IF PayElement.FindSet() then
                    repeat
                        SalSetupLine.Init();
                        SalSetupLine."Salary Code" := "Salary Code";
                        Evaluate(SalSetupLine."Line No.", Format(PayElement."Element Code"));
                        SalSetupLine."Element Code" := PayElement."Element Code";
                        SalSetupLine."Element Name" := PayElement."Element Name";

                        if PayElement.Deduction = true then
                            SalSetupLine.Deduction := true;

                        if PayElement.Earning = true then
                            SalSetupLine.Earning := true;

                        if PayElement."Function of Paye" then
                            SalSetupLine.Taxable := true;

                        If ("Apply to" = "Apply to"::"Office Staff") then begin
                            If PayElement."Is Basic" then begin
                                SalSetupLine."Calculation formula" := '60% of Gross Pay';
                                SalSetupLine.Amount := HRSetup."Office Basic %" * "Gross Pay";
                                BasicAmt := HRSetup."Office Basic %" * "Gross Pay";
                                SumForPension += BasicAmt;
                            end;
                            If PayElement."Is House" then begin
                                SalSetupLine."Calculation formula" := '20% of Gross Pay';
                                SalSetupLine.Amount := HRSetup."Office House %" * "Gross Pay";
                                HouseAAmt := HRSetup."Office House %" * "Gross Pay";
                                SumForPension += HouseAAmt;
                            end;
                            If PayElement."Is Transport" then begin
                                SalSetupLine."Calculation formula" := '20% of Gross Pay';
                                SalSetupLine.Amount := HRSetup."Office Transport %" * "Gross Pay";
                                TransportAmt := HRSetup."Office Transport %" * "Gross Pay";
                                SumForPension += TransportAmt;
                            end;
                        end;

                        If ("Apply to" = "Apply to"::"Rig Staff") then begin
                            If PayElement."Is Basic" then begin
                                SalSetupLine."Calculation formula" := '40% of Gross Pay';
                                SalSetupLine.Amount := HRSetup."Rig Basic %" * "Gross Pay";
                                BasicAmt := HRSetup."Rig Basic %" * "Gross Pay";
                                SumForPension += BasicAmt;
                            end;

                            If PayElement."Is House" then begin
                                SalSetupLine."Calculation formula" := '14% of Gross Pay';
                                SalSetupLine.Amount := HRSetup."Rig House %" * "Gross Pay";
                                HouseAAmt := HRSetup."Rig House %" * "Gross Pay";
                                SumForPension += HouseAAmt;
                            end;
                            If PayElement."Is Transport" then begin
                                SalSetupLine."Calculation formula" := '9% of Gross Pay';
                                SalSetupLine.Amount := HRSetup."Rig Transport %" * "Gross Pay";
                                TransportAmt := HRSetup."Rig Transport %" * "Gross Pay";
                                SumForPension += TransportAmt;
                            end;
                            If PayElement."Is Utility" then begin
                                SalSetupLine."Calculation formula" := '37% of Gross Pay';
                                SalSetupLine.Amount := HRSetup."Rig Utility %" * "Gross Pay";
                                UtilityAmt := HRSetup."Rig Utility %" * "Gross Pay";
                                SumForPension += UtilityAmt;
                            end;

                        end;

                        if PayElement."Is Pension Employee" then begin
                            SalSetupLine."Calculation formula" := '8% of Basic + House + Transport';
                            SalSetupLine.Amount := HRSetup."Pension Employee %" * (SumForPension);
                            TotalDedAmt += SalSetupLine.Amount;
                        end;

                        if PayElement."Is Pension Employer" then begin
                            SalSetupLine."Calculation formula" := '10% of Basic + House + Transport';
                            SalSetupLine.Amount := HRSetup."Pension Employer %" * (SumForPension);
                        end;

                        if PayElement."Is Paye" then begin
                            //SalSetupLine."Calculation formula" := '10% of Basic + House + Transport';
                            SalSetupLine.Amount := 0;
                            TotalDedAmt += SalSetupLine.Amount;
                        end;

                        if PayElement."Is Gross" then begin
                            SalSetupLine."Calculation formula" := 'Basic + House + Transport + Utility';
                            SalSetupLine.Amount := "Gross Pay";
                        end;

                        if PayElement."Is Total Deduction" then begin
                            SalSetupLine."Calculation formula" := 'Pension + PAYE + Absent/Late';
                            SalSetupLine.Amount := TotalDedAmt;
                        end;

                        if PayElement."Is Net" then begin
                            SalSetupLine."Calculation formula" := 'Gross Pay - Total Deduction';
                            SalSetupLine.Amount := "Gross Pay" - TotalDedAmt;
                        end;

                        ln += 10;
                        if Not (SalSetupLine.Insert()) then
                            SalSetupLine.Modify();
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
        BasicAmt: Decimal;
        HouseAAmt: Decimal;
        TransportAmt: Decimal;
        UtilityAmt: Decimal;
        TotalDedAmt: Decimal;

        SumForPension: Decimal;
}
