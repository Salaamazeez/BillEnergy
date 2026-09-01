pageextension 50021 "Chart of Accounts Ext" extends "Chart of Accounts"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        modify("Trial Balance")
        {
            Visible = false;
        }
        addbefore("Detail Trial Balance")
        {
            action("Trial Balance - New")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Trial Balance';
                Image = "Report";
                RunObject = Report "Trial Balance - New";
                ToolTip = 'View a detail trial balance for the general ledger accounts that you specify.';
            }
        }
        addlast(Category_Report)
        {
            actionref(TrialBalanceNew_Promoted; "Trial Balance - New")
            {
            }
        }
    }

}