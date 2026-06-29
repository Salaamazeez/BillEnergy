report 50162 "Purchase Requisition"
{
    //Created by Salaam Azeez
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Purchase Requisition.rdl';

    dataset
    {
        dataitem("Purch. Requistion"; "Purch. Requistion")
        {
            column(Requester; Requester)
            {

            }
            column(Request_Description; "Request Description")
            {

            }
            column(Date; Date)
            {

            }
            column(Requisition_No_; "Requisition No.")
            {

            }
            column(Requester_No_; "Requester No.")
            {

            }
            column(No_; "No.")
            {

            }
            dataitem("Purchase Requisition Line"; "Purchase Requisition Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Document_No_; "Document No.")
                {

                }
                column(Unit_Cost; "Unit Cost")
                {

                }
                column(Unit_of_Measure; "Unit of Measure")
                {

                }
                column(Description; Description)
                {

                }
                column(Amount; Amount)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(ItemNo_; "No.")
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
}