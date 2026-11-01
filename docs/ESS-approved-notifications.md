# ESS approval emails

ESS imports that set a document to Approved (Released for purchase invoices) queue an email using the supplied
subject and body, with the actual document number in place of `001` and the
transaction type in place of `Voucher` in both the subject and body. For example:
`Approved Payment Request Awaiting Processing` and `The approved Payment Request
(Doc. PAY-000046) is ready and awaiting your processing in Business Central.`
The reference includes the saved header description when present, for example
`(Doc. PAY-000047: Office supplies)`. A blank description leaves only the number.
Retirements use Purpose, stores documents use Project/Job Description, purchase
invoices use Posting Description, and appraisals use Employee Name.

Recipients are selected in **User Setup**, using the existing fields:

| Portal transaction | Recipient field |
| --- | --- |
| Payment request, cash advance, retirement | Finance Admin |
| Purchase invoice, purchase requisition, store requisition, stores return | Procurement Admin |
| Leave application, performance appraisal | HR Admin |

Enable the relevant field and populate **E-Mail** for each manager. All matching
users with an email address receive a separate email. Duplicate addresses are
collapsed within each notification. These fields select recipients; existing BC
permission sets still control access to documents and setup.

Configure a BC email account for the **Default** email scenario and ensure
background email processing is running. The ESS integration user needs access to
read User Setup and create/queue email through the standard email codeunits.
After publishing the extension, assign **ESS EMAIL NOTIFY** to the identity used
by the ESS web service in the target company, alongside its existing integration
permissions. For user authentication, assign it on **Users**; for service-to-service
authentication, assign it to the calling application on **Microsoft Entra
Applications**. This grants the direct Read, Insert, Modify and Delete permissions
on **Sent Email** and **Email Outbox** that BC checks before sending email.
It also grants indirect Insert on **Email Related Record** (table 8909), used by
the standard email codeunits while creating the queued message.
Read access to the system **User** table supports user lookups during email processing.
Indirect Read on **Workflow** (1501) allows standard BC routines to read workflow
configuration when processing ESS transactions, including purchase invoice release.
Indirect Read on **Workflow Step Instance** (1504) supports the corresponding
workflow instance checks during processing.
Related workflow checks also have indirect Read on Workflow Step, Workflow Step
Argument, Workflow Event, Workflow Response, Workflow Event Queue,
Workflow - Table Relation, Workflow - Record Change, Approval Entry and Restricted
Record. Execute access is included for Release Purchase Document, Workflow
Management and Approvals Mgmt. These additions support checks; they do not grant
workflow setup editing or approval bypass permissions.
**Workflow Rule** (1524) has direct Read (`R`), because processing also reads this
table outside an indirectly privileged codeunit context.
For **SMTP Account** (4511), add a tenant permission entry in BC with Read = Yes
and Insert = Indirect, leaving Modify and Delete blank. Assign it to the ESS
caller. This connector table is not available in this project's installed symbols,
so it cannot currently be declared in the extension permission set.
**Email Recipient** (8903) and **Email Message** (8900) are internal System
Application tables and cannot be referenced directly by this extension's AL
permission set. For explicit tenant permission entries, use BC's **Permission
Sets** page to grant Read = Yes, Insert = Indirect and Modify = Indirect for both
tables, leaving Delete blank. Assign that tenant permission set to the ESS caller.
**ESS EMAIL NOTIFY** also includes Microsoft's **Email - Edit** permission set,
so standard email table and codeunit dependencies are inherited from BC. The
explicit permissions above remain part of the set for the checks encountered by
the ESS integration. Republish the extension to apply this inclusion; callers
already assigned **ESS EMAIL NOTIFY** inherit its updated permissions.
Selecting a recipient's admin field does not grant these permissions to the caller.
Queued messages can be monitored in **Email Outbox** and **Sent Emails**.
No email is queued when no matching recipient has an email address.

Emails are queued after the header, lines and attachments have been saved, within
the same transaction. Failed imports roll back their queued mail. Updates to a
document already marked Approved do not queue another email; a document reopened
and subsequently approved through ESS does queue another email.

Leave register imports create absence
entries without an approval transition and are also excluded.

## Validation in a BC sandbox

1. Configure recipient users for each role and a Default email account.
2. Import a new approved transaction for each supported type; verify one email per
   distinct matching address, the document number and the supplied wording.
3. Import an edit to the same Approved document; verify no additional email.
4. Reopen and approve through ESS; verify a new notification.
5. Submit invalid lines or attachment data; verify no document changes or queued mail.
6. Verify users without the matching role or without an email receive nothing.

Purchase invoices use the standard BC release routine. Standard validation and
approval requirements must pass before notification. Edits to invoices already
Released do not queue another notification.
