// page 50505 "Document Approval Entries"
// {
//     PageType = List;
//     ApplicationArea = All;
//     UsageCategory = Lists;
//     SourceTable = "Document Approval Entry";
//     SourceTableView = SORTING(Sequence, "Document No.") ORDER(Ascending) WHERE(Status = filter(Pending));
//     // WHERE(Status=CONST(Approved));
//     layout
//     {
//         area(Content)
//         {
//             repeater(GroupName)
//             {
//                 field("Table No."; "Table No.")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field("Document No."; "Document No.")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field(Sender; Sender)
//                 {
//                     ApplicationArea = All;

//                 }
//                 field(Approver; Approver)
//                 {
//                     ApplicationArea = All;

//                 }
//                 field(Sequence; Sequence)
//                 {
//                     ApplicationArea = All;

//                 }
//                 field(Status; Status)
//                 {
//                     ApplicationArea = All;

//                 }
//             }
//         }
//         area(Factboxes)
//         {

//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action("View Request")
//             {
//                 ApplicationArea = All;

//                 trigger OnAction();
//                 begin
//                     ShowRecord;
//                 end;
//             }

//             action(Comments)
//             {
//                 ApplicationArea = All;

//                 trigger OnAction();
//                 begin
//                     SETFILTER(Status, '%1|%2', Status::Pending, Status::" ");
//                 end;
//             }//O&verdue Entries
//             action("O&verdue Entries")
//             {
//                 ApplicationArea = All;

//                 trigger OnAction();
//                 begin
//                     CurrPage.SETSELECTIONFILTER(ApprovalEntry);
//                     ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
//                 end;
//             }
//         }
//     }
//     var
//         ApprovalEntry: Record "Approval Entry";
//         ApprovalsMgmt: Codeunit "Approvals Mgmt.";
// }