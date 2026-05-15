report 50500 "Store Requisition Report"
{
    //Created by Salaam Azeez
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Store Requisition Report.rdl';

    dataset
    {
        dataitem("Store Requisition"; "Store Requisition")
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            {

            }
            column(Date; Date)
            {

            }
            column(Last_Date_Modified; "Last Date Modified")
            {

            }
            column(Requester; Requester)
            {

            }
            column(Status; Status)
            {

            }
            column(Location; Location)
            {

            }
            column(Project_Job_Description; "Project/Job Description")
            {

            }
            column(Work_Order_No_; "Work Order No.")
            {

            }
            // Expanded	Data Type	Data Source	Name	Include Caption
            Column(StoreRequisitionDateLb; StoreRequisitionDateLb) { }
            Column(BranchLb; BranchLb) { }
            Column(CurrReport_PAGENOCaptionLbl; CurrReport_PAGENOCaptionLbl) { }
            Column(StatusLb; StatusLb) { }
            Column(DepartmentLb; DepartmentLb) { }
            Column(LocationLb; LocationLb) { }
            Column(DateLb; DateLb) { }
            Column(ProjectLb; ProjectLb) { }
            Column(WorkOrderNoLb; WorkOrderNoLb) { }
            Column(RequesterNameLb; RequesterNameLb) { }
            Column(StoreRequisitionNoLb; StoreRequisitionNoLb) { }
            Column(ReportTitleLb; ReportTitleLb) { }
            Column(CompanyNameLb; CompanyNameLb) { }


            //
            Column(DocNo; DocNo) { }
            Column(LineNo; LineNo) { }
            // Column(LineNoLb; LineNoLb) { }
            Column(StockCode; StockCode) { }
            // Column(Description; Description) { }
            Column(UnitOfIssue; UnitOfIssue) { }
            Column(RequestedQty; RequestedQty) { }
            Column(IssuedQty; IssuedQty) { }
            Column(UnitPrice; UnitPrice) { }
            Column(HeadValue; Value) { }
            Column(LocationCode; LocationCode) { }
            Column(QtyInStoreAtRequest; QtyInStoreAtRequest) { }
            Column(QtyInStoreAtTheMoment; QtyInStoreAtTheMoment) { }
            Column(GenPostingGroup; GenPostingGroup) { }
            Column(DocNoLb; DocNoLb) { }
            Column(StockCodeLb; StockCodeLb) { }
            Column(DescriptionLb; DescriptionLb) { }

            Column(UnitOfIssueLb; UnitOfIssueLb) { }
            Column(RequestedQtyLb; RequestedQtyLb) { }
            Column(IssuedQtyLb; IssuedQtyLb) { }
            Column(UnitPriceLb; UnitPriceLb) { }
            Column(ValueLb; ValueLb) { }
            Column(LocationCodeLb; LocationCodeLb) { }
            Column(QtyInStoreAtRequestLb; QtyInStoreAtRequestLb) { }
            Column(QtyInStoreAtTheMomentLb; QtyInStoreAtTheMomentLb) { }
            //	Column(	GenBusPostGroupLb	GenBusPostGroupLb){}


            //
            dataitem("Store Requisition Line"; "Store Requisition Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(Document_No_; "Document No.") { }
                column(Line_No_; "Line No.")
                {

                }
                column(Stock_Code; "Stock Code")
                {

                }
                column(Description; Description)
                {

                }
                column(Unit_of_Issue; "Unit of Issue")
                {

                }
                column(Requested_Qty_; "Requested Qty.")
                {

                }
                column(Issued_Qty_; "Issued Qty.")
                {

                }
                column(Unit_Price; "Unit Price")
                {

                }
                column(Value; Value)
                {

                }
                column(Location_Code; "Location Code")
                {

                }
                column(Qty_in_Store_at_Request; "Qty in Store at Request")
                {

                }
                column(Qty_in_Store_at_the_moment; "Qty in Store at the moment")
                {

                }
                column(Gen_Bus__Posting_Group; "Gen Bus. Posting Group")
                {

                }
                column(Qty__to_Issue; "Qty. to Issue")
                {

                }

                dataitem("Company Information"; "Company Information")
                {
                    column(Picture; Picture)
                    {

                    }
                    column(Name; Name)
                    {

                    }
                    column(Address; Address)
                    {

                    }
                    column(E_Mail; "E-Mail")
                    {

                    }
                    column(Phone_No_; "Phone No.")
                    {

                    }
                    column(Fax_No_; "Fax No.")
                    {

                    }
                }

            }

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        myInt: Integer;
        //Name	ConstValue
        CompanyNameLb: TextConst ENU = 'Zetamind Consulting';
        ReportTitleLb: TextConst ENU = 'SRQ SLIP';
        StoreRequisitionNoLb: TextConst ENU = 'No.';
        StoreRequisitionDateLb: TextConst ENU = 'Requisition Date';
        RequesterNameLb: TextConst ENU = 'Requester Name';
        DepartmentLb: TextConst ENU = 'Department';
        BranchLb: TextConst ENU = 'Branch';
        StatusLb: TextConst ENU = 'Status';
        LocationLb: TextConst ENU = 'Location';
        WorkOrderNoLb: TextConst ENU = 'Work Order No.';
        ProjectLb: TextConst ENU = 'Project/Job Description';
        DateLb: TextConst ENU = 'Creation Date';
        DocNoLb: TextConst ENU = 'Document No.';
        LineNoLb: TextConst ENU = 'Line No.';
        StockCodeLb: TextConst ENU = 'Stock Code';
        DescriptionLb: TextConst ENU = 'Description';
        UnitOfIssueLb: TextConst ENU = 'Unit of Issue';
        RequestedQtyLb: TextConst ENU = 'Requested Qty.';
        IssuedQtyLb: TextConst ENU = 'Issued Qty.';
        UnitPriceLb: TextConst ENU = 'Unit Price';
        ValueLb: TextConst ENU = 'Value';
        LocationCodeLb: TextConst ENU = 'Location Code';
        QtyInStoreAtRequestLb: TextConst ENU = 'Qty in Store at Request';
        QtyInStoreAtTheMomentLb: TextConst ENU = 'Qty in Store at the moment';
        GenBusPostGroupLb: TextConst ENU = 'Gen.Bus.Posting Group';
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page';
        //Name	DataType	Subtype	Length
        StoresRequisitionLine: Record "Store Requisition Line";
        DocNo: Code[60];
        LineNo: Integer;
        StockCode: Code[50];
        Description: Text[50];
        UnitOfIssue: Code[50];
        RequestedQty: Integer;
        IssuedQty: Decimal;
        UnitPrice: Decimal;
        Value: Decimal;
        LocationCode: Code[10];
        QtyInStoreAtRequest: Decimal;
        QtyInStoreAtTheMoment: Decimal;
        GenPostingGroup: Code[30];
}