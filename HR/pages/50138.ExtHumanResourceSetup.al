pageextension 50138 ExtHumanResourceSetup extends "Human Resources Setup"
{
    layout
    {


        addafter("Base Unit of Measure")
        {
            field("Leave Nos"; Rec."Leave Nos")
            {
                Caption = 'Leave Nos.';
                ApplicationArea = ALL;
            }
            field("Leave Adjustment Nos"; Rec."Leave Adjustment Nos")
            {
                Caption = 'Leave Adjustment Nos.';
                ApplicationArea = ALL;
            }
        }
        addafter(Numbering)
        {

            group(LeaveCode)
            {
                Caption = 'Leave Code';
                field("Annaul Leave Code"; Rec."Annaul Leave Code")
                {
                    Caption = 'Annual Leave Code';
                    ApplicationArea = ALL;
                }
                field("Maternity Leave Code"; Rec."Maternity Leave Code")
                {
                    Caption = 'Maternity Leave Code';
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Paternity Leave Code"; Rec."Paternity Leave Code")
                {
                    Caption = 'Paternity Leave Code';
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Company Leave Code"; Rec."Compasonate Leave Code")
                {
                    Caption = 'Compasonate Leave Code';
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Exam Leave Code"; Rec."Exam Leave Code")
                {
                    Caption = 'Exam Leave Code';
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Sick Leave Code"; Rec."Sick Leave Code")
                {
                    Caption = 'Sick Leave Code';
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Day-Off Leave Code"; Rec."Day-Off Leave Code")
                {
                    Caption = 'Day-Off Leave Code';
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Out-Duty Leave Code"; Rec."Out-Duty Leave Code")
                {
                    Caption = 'Out-Duty Leave Code';
                    ApplicationArea = ALL;
                    Visible = false;
                }

            }
            group(PerformanceAppraiser)
            {
                Caption = 'Performance Appraiser Window';
                Visible = false;
                field("Appraisal Year"; Rec."Appraisal Year")
                {
                    Caption = 'Appraiser Year';
                    ApplicationArea = All;
                }
                field("Objective Setting Start Date"; Rec."Objective Setting Start Date")
                {
                    Caption = 'Objective Setting Start Date';
                    ApplicationArea = All;
                }
                field("Objective Setting End Date"; Rec."Objective Setting End Date")
                {
                    Caption = 'Objective Setting End Date';
                    ApplicationArea = All;
                }
                field("Mid-Year Review Start Date"; Rec."Mid-Year Review Start Date")
                {
                    Caption = 'Mid-Year Review Start Date';
                    ApplicationArea = All;
                }
                field("Mid-Year Review End Date"; Rec."Mid-Year review End Date")
                {
                    Caption = 'Mid-Year Review End Date';
                    ApplicationArea = All;
                }
                field("Year End Evaluation Start Date"; Rec."Year End Evaluation Start Date")
                {
                    Caption = 'Year End Evaluation Start Date';
                    ApplicationArea = All;
                }
                field("Year End Evaluation End Date"; Rec."Year End Evaluation End Date")
                {
                    Caption = 'Year End Evaluation End Date';
                    ApplicationArea = All;
                }
            }
            group(Payroll)
            {
                Caption = 'Payroll';

                field("Working Hours"; Rec."Working Hours")
                {
                    Caption = 'Working Hours';
                    ApplicationArea = All;
                }
                field("Rig Basic %"; Rec."Rig Basic %")
                {
                    Caption = 'Rig Basic %';
                    ApplicationArea = All;
                }
                field("Rig House %"; Rec."Rig House %")
                {
                    Caption = 'Rig House %';
                    ApplicationArea = All;
                }
                field("Rig Transport %"; Rec."Rig Transport %")
                {
                    Caption = 'Rig Transport %';
                    ApplicationArea = All;
                }

                field("Rig Utility %"; Rec."Rig Utility %")
                {
                    Caption = 'Rig Utility %';
                    ApplicationArea = All;
                }
                field("Office Basic %"; Rec."Office Basic %")
                {
                    Caption = 'Office Basic %';
                    ApplicationArea = All;
                }
                field("Office House %"; Rec."Office House %")
                {
                    Caption = 'Office House %';
                    ApplicationArea = All;
                }
                field("Office Transport %"; Rec."Office Transport %")
                {
                    Caption = 'Office Transport %';
                    ApplicationArea = All;
                }

                field("Overtime Rate"; Rec."Overtime Rate")
                {
                    Caption = 'Overtime Rate';
                    ApplicationArea = All;
                }

                field("PH-WK Overtime Rate"; Rec."PH-WK Overtime Rate")
                {
                    Caption = 'PH-Wk Overtime Rate';
                    ApplicationArea = All;
                }
                field("NHF %"; Rec."NHF %")
                {
                    Caption = 'NHF %';
                    ApplicationArea = All;
                }
                field("NSITF %"; Rec."NSITF % ")
                {
                    Caption = 'NSITF %';
                    ApplicationArea = All;
                }
                field("ITF %"; Rec."ITF % ")
                {
                    Caption = 'ITF %';
                    ApplicationArea = All;
                }

                field("Pension Employee %"; Rec."Pension Employee %")
                {
                    Caption = 'Pension Employee %';
                    ApplicationArea = All;
                }

                field("Pension Employer %"; Rec."Pension Employer %")
                {
                    Caption = 'Pension Employer';
                    ApplicationArea = all;
                }

            }

        }
    }
}