reportextension 50123 "Standard Sales - Invoice Ext" extends "Standard Sales - Invoice"
{
    dataset
    {
        // Add changes to dataitems and columns here
        add(Header)
        {
            column(External_Document_No_; "External Document No.") { }
            column(CustName; CustName) { }
            column(CustAddress; CustAddress) { }
            column(CustPhoneNo; CustPhoneNo) { }
            column(CompanyInfo_Picture;CompanyInfo.Picture) { }
            column(CompanyInfo_HomePage;CompanyInfo."Home Page") { }
        }

        add(Line)
        {
            column(Description_2; "Description 2") { }
        }

        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            var
                Cust: Record Customer;
            begin
                Cust.Get("Bill-to Customer No.");
                CustName := Cust.Name;
                CustAddress := Cust.Address;
                CustPhoneNo := Cust."Phone No.";
            end;
        }
    }

    rendering
    {
        layout(SalesInvoiceBillEnergy)
        {
            Type = RDLC;
            LayoutFile = 'SalesInvoiceBillEnergy.rdl';
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CustName: Text;
        CustAddress: Text;
        CustPhoneNo: Text;
}