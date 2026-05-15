// page 50510 "Document Workflow"
// {
//     PageType = Card;
//     ApplicationArea = All;
//     UsageCategory = Administration;
//     SourceTable = "Document Workflow";

//     layout
//     {
//         area(Content)
//         {
//             group(GroupName)
//             {
//                 field("User ID"; "User ID")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field("Table No."; "Table No.")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field("1st Approver"; "1st Approver")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field("2nd Approver"; "2nd Approver")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field("3rd Approver"; "3rd Approver")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field("4th Approver"; "4th Approver")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field(Enable; Enable)
//                 {
//                     ApplicationArea = All;

//                 }

//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(ActionName)
//             {
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin

//                 end;
//             }
//         }
//     }

//     var
//         myInt: Integer;
// }