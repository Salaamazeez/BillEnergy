// pageextension 50363 EmployeeExt extends "Employee Card"
// {
//     layout
//     {
//         // Add changes to page layout here
//     }

//     actions
//     {
//         addafter(PayEmployee)
//         {
//             action("Sync Employee To HMRS")
//             {
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 Caption = 'Sync Employee To HMRS';
//                 ApplicationArea = Basic;
//                 trigger OnAction()
//                 var
//                     PortalMgt: Codeunit "Portal Mgt";
//                 begin
//                     PortalMgt.SendEmployeeToHRMS(Rec);
//                 end;
//             }
//         }
//     }

//     var
//         myInt: Integer;
// }