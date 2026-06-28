// page 50037 "Business Manager Evaluation"
// {
//     PageType = RoleCenter;

//     layout
//     {
//         area(RoleCenter)
//         {

//         }
//     }

//     actions
//     {
//         // area(Creation)
//         // {
//         //     action(ActionBarAction)
//         //     {
//         //         RunObject = Page ObjectName;
//         //     }
//         // }
//         area(Sections)
//         {
//             group("Pending Documents")
//             {
//                 action("Pending Payment Vouchers")
//                 {
//                     RunObject = Page "Payment Voucher List";
//                 }
//                 action("Purchase Invoices")
//                 {
//                     RunObject = Page "Purchase Invoices";
//                 }
//                 action("Bank Accounts")
//                 {
//                     RunObject = Page "Bank Account List";
//                 }
//                 action("Purchase Orders")
//                 {
//                     RunObject = Page "Purchase Order List";
//                 }
//                 action("Store Requisitioms")
//                 {
//                     RunObject = Page "Store Requisition List";
//                 }
//                 action("Purchase Requisitioms")
//                 {
//                     RunObject = Page "Purchase Requisition List";
//                 }
//                 action("Payment Requests")
//                 {
//                     RunObject = Page "Payment Req. List";
//                 }
//             }

//             group("Approved Documents")
//             {
//                 action("Approved Payment Requests")
//                 {
//                     RunObject = page "Approved Payment Req. List";
//                 }
//                 action("Approved Payment Vouchers")
//                 {
//                     RunObject = page "Approved Payment Voucher List";
//                 }
//                 action("Approved Store Req. Awaiting PRQ")
//                 {
//                     RunObject = page "Apprd Store Awaiting PRQ List";
//                 }
//                 action("Approved Store Req. Awaiting Issue")
//                 {
//                     RunObject = page "Apprvd SRQ Awaiting ISSUE List";
//                 }
//                 action("Apprv. Stores Returns")
//                 {
//                     RunObject = page "Apprv. Stores Returns List";
//                 }
//                 action("Appr. Purch. Requisition Lists")
//                 {
//                     RunObject = page "Appr. Purch. Requisition Lists";
//                 }
//                 action("Approved Leave Application")
//                 {
//                     RunObject = page ApproveLeaveApplicationList;
//                 }
//             }
//         }
//         // area(Embedding)
//         // {
//         //     action(EmbeddingAction)
//         //     {
//         //         RunObject = Page ObjectName;
//         //     }
//         // }
//     }
// }