permissionset 50001 "ESS EMAIL NOTIFY"
{
    Assignable = true;
    Caption = 'ESS approval email notifications';
    // Include Microsoft's email permissions and their related table dependencies.
    IncludedPermissionSets = "Email - Edit";

    Permissions =
        tabledata "Sent Email" = RIMD,
        tabledata "Email Outbox" = RIMD,
        // SMTP Account (4511): configure Read = Yes, Insert = Indirect in BC.
        // The SMTP connector table is not available in this project's symbols.
        // Internal tables: configure these entries in a BC tenant permission set.
        // Email Recipient (8903): Read = Yes, Insert/Modify = Indirect.
        // Email Message (8900): Read = Yes, Insert/Modify = Indirect.
        tabledata "Email Related Record" = i,
        tabledata "User Setup" = R,
        tabledata Workflow = r,
        tabledata "Workflow Step Instance" = r,
        tabledata "Workflow Step" = r,
        tabledata "Workflow Step Argument" = r,
        tabledata "Workflow Event" = r,
        tabledata "Workflow Response" = r,
        tabledata "Workflow Event Queue" = r,
        tabledata "Workflow Rule" = R,
        tabledata "Workflow - Table Relation" = r,
        tabledata "Workflow - Record Change" = r,
        tabledata "Approval Entry" = r,
        tabledata "Restricted Record" = r,
        tabledata User = R,
        codeunit "ESS Management" = X,
        codeunit "Release Purchase Document" = X,
        codeunit "Workflow Management" = X,
        codeunit "Approvals Mgmt." = X,
        codeunit Email = X,
        codeunit "Email Message" = X;
}
