namespace LabelPrinting.LabelPrinting;

using Microsoft.Finance.GeneralLedger.Setup;

tableextension 59101 WPGenProdPostingGroup extends "Gen. Product Posting Group"
{
    fields
    {
        field(59100; "Label Printing Purch. Type"; Text[1])
        {
            Caption = 'Label Printing Purch. Type';
            DataClassification = ToBeClassified;
            Editable = true;
        }
    }
}
