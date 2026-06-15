// pageextension 50364 VendorExt extends "Vendor Card"
// {
//     layout
//     {
//         // Add changes to page layout here
//     }

//     actions
//     {
//         addafter("Ledger E&ntries")
//         {
//             action("Sync Vendor To HMRS")
//             {
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 Caption = 'Sync Vendor To HMRS';
//                 ApplicationArea = Basic;
//                 trigger OnAction()
//                 var
//                     PortalMgt: Codeunit "Portal Mgt";
//                 begin
//                     PortalMgt.SendVendorToHRMS(Rec);
//                 end;
//             }
//         }
//     }
// }