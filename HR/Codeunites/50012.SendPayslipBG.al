namespace BILLENERGY.BILLENERGY;
using Microsoft.HumanResources.Employee;
using System.Threading;
using System.Email;
using System.Utilities;

codeunit 50100 "Background Payslip Processor"
{
    // Setting TableNo allows this codeunit to be called directly by the Job Queue Entry
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        //ProcessAndEmailAllPayslips()
    end;

    procedure RunSendPaySlip(PayrollPeriod: Code[10])

    begin
        PayPeriods := PayrollPeriod;
        ProcessAndEmailAllPayslips()
    end;

    local procedure ProcessAndEmailAllPayslips()
    var
        Employee: Record Employee;
    begin
        // Filter for active employees who have an email address populated
        Employee.SetRange(Status, Employee.Status::Active);
        Employee.SetFilter("Company E-Mail", '<>%1', '');

        if Employee.FindSet() then begin
            repeat
                // Process each employee individually
                SendIndividualPayslip(Employee);
            until Employee.Next() = 0;
        end;
    end;

    local procedure SendIndividualPayslip(Employee: Record Employee)
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        PayslipOutStream: OutStream;
        PayslipInStream: InStream;
        RecRef: RecordRef;
        Subject: Text;
        Body: Text;
    begin
        //Subject := 'Your Payslip - ' + Format(WorkDate());
        Subject := 'Your Payslip - ' + Format(PayPeriods);
        Body := 'Dear ' + Employee.FullName() + ',<br><br>Please find attached your payslip for the current pay period.<br><br>Best Regards,<br>HR Team';

        // Initialize the outstream buffer for the custom RDLC PDF layout
        TempBlob.CreateOutStream(PayslipOutStream);

        // Critical for Background/RDLC: Filter the RecordRef to ONLY the loop's current employee
        RecRef.GetTable(Employee);

        // Report.SaveAs parameters: (ReportID, XmlParameters, Format, OutStream, RecordRef)
        // Leaving XmlParameters empty ('') relies entirely on the RecordRef to filter data
        Report.SaveAs(Report::Payslip, '', ReportFormat::Pdf, PayslipOutStream, RecRef);

        // Convert the blob data back to an InStream to attach it
        TempBlob.CreateInStream(PayslipInStream);

        // Construct and attach to the email payload
        EmailMessage.Create(Employee."Company E-Mail", Subject, Body, true);
        EmailMessage.AddAttachment('Payslip_' + Employee."No." + '.pdf', 'PDF', PayslipInStream);

        // Send email silently using the default background scenario setup
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;

    var

        Year: Integer;
        Month: Integer;

        PayPeriods: Code[10];

}
