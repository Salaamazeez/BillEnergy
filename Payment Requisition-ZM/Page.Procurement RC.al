page 50474 "Procurement Role Center"
{
    PageType = RoleCenter;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Procurement Role Center';

    layout
    {
        area(RoleCenter)
        {
            part(Headline; "Headline RC Business Manager")
            {
                ApplicationArea = All;
            }

            part(Activities; "Purchase Agent Activities")
            {
                ApplicationArea = All;
            }

            part(ApprovalEntries; "Requests to Approve")
            {
                ApplicationArea = Basic;
            }

            part(MyItems; "My Items")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(Procurement)
            {
                Caption = 'Procurement';

                action(PurchaseRequisitions)
                {
                    Caption = 'Purchase Requisitions';
                    ApplicationArea = All;
                    Image = Purchase;
                    RunObject = page "Appr. Purch. Requisition Lists";
                }
                action(storeeRequisitions)
                {
                    Caption = 'Store Requisitions Awaiting PRQ';
                    ApplicationArea = All;
                    Image = Purchase;
                    RunObject = page "Apprd Store Awaiting PRQ List";
                }
                action(storeeRequisitionsAwaitingISSUE)
                {
                    Caption = 'Store Requisitions Awaiting ISSUE';
                    ApplicationArea = All;
                    Image = Purchase;
                    RunObject = page "Apprvd SRQ Awaiting ISSUE List";
                }

                action(PurchaseQuotes)
                {
                    Caption = 'Purchase Quotes';
                    ApplicationArea = Basic;
                    Image = Quote;
                    RunObject = page "Purchase Quotes";
                }

                action(PurchaseOrders)
                {
                    Caption = 'Purchase Orders';
                    ApplicationArea = Basic;
                    Image = Order;
                    RunObject = page "Purchase Orders";
                }

                action(BlanketOrders)
                {
                    Caption = 'Blanket Purchase Orders';
                    ApplicationArea = Basic;
                    Image = BlanketOrder;
                    RunObject = page "Blanket Purchase Orders";
                }

                action(PurchaseInvoices)
                {
                    Caption = 'Purchase Invoices';
                    ApplicationArea = Basic;
                    Image = Invoice;
                    RunObject = page "Purchase Invoices";
                }

                action(PurchaseReturnOrders)
                {
                    Caption = 'Purchase Return Orders';
                    ApplicationArea = Basic;
                    Image = ReturnOrder;
                    RunObject = page "Purchase Return Orders";
                }
            }

            group(Vendors)
            {
                Caption = 'Vendors';

                action(VendorList)
                {
                    Caption = 'Vendors';
                    ApplicationArea = All;
                    Image = Vendor;
                    RunObject = page "Vendor List";
                }

                action(VendorLedgerEntries)
                {
                    Caption = 'Vendor Ledger Entries';
                    ApplicationArea = All;
                    Image = VendorLedger;
                    RunObject = page "Vendor Ledger Entries";
                }

                action(VendorCatalog)
                {
                    Caption = 'Vendor Item Catalog';
                    ApplicationArea = Basic;
                    Image = Item;
                    RunObject = page "Vendor Item Catalog";
                }
            }

            group(Inventory)
            {
                Caption = 'Inventory';

                action(Items)
                {
                    Caption = 'Items';
                    ApplicationArea = All;
                    Image = Item;
                    RunObject = page "Item List";
                }

                action(ItemAvailability)
                {
                    Caption = 'Item Availability';
                    ApplicationArea = All;
                    Image = ItemAvailability;
                    RunObject = page "Item Availability by Event";
                }

                action(RequisitionWorksheet)
                {
                    Caption = 'Requisition Worksheet';
                    ApplicationArea = Basic;
                    Image = Worksheet;
                    RunObject = page "Req. Worksheet";
                }
            }
        }
    }
}