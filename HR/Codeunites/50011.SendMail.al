namespace BILLENERGY.BILLENERGY;
using Microsoft.HumanResources.Setup;
using Microsoft.Finance.Payroll;
using Microsoft.Foundation.Company;
using System.Environment.Configuration;
using System.Security.User;
using Microsoft.HumanResources.Employee;
using Microsoft.Finance.GeneralLedger.Journal;

codeunit 50011 SendEmail
{
    var
        //SMTPSetup: Record smtp;
        PayrollLine: Record PayrollLine;
        //SMTPMail : Codeunit 400;
        CompInfo: Record "Company Information";
        PayPeriod: Code[50];
        Paysliptext: Label 'PAYSLIP FOR';
        //FileAttach: "{420B2830-E718-11CF-893D-00A0C9054228} 1.0:{0D43FE01-F093-11CF-8940-00A0C9054228}:'Microsoft Scripting Runtime'.FileSystemObject";
        FilenameAttach: Text[250];
        Employee: Record Employee;
        MailSendingError: Label 'Payslip cannot be send as mail sending is disable in SMTP Setup. Contact IT to continue this process';
        Month: Integer;
        Year: Integer;
        PayMonth: Code[20];
        NotifEntry: Record "Notification Entry";
        UserSetup: Record "User Setup";
        MailSendingErrors: Label 'Mail cannot be send at this time as mail sending is disable in SMTP Setup. Contact IT to continue this process';



    trigger OnRun()
    begin

    end;



}
