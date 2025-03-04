namespace LabelPrinting.LabelPrinting;
using Microsoft.Foundation.NoSeries;

tableextension 59100 WPRetailSetupExt extends "LSC Retail Setup"
{
    fields
    {
        field(59100; "Label Request Nos."; Code[20])
        {
            Caption = 'Label Request Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(59101; "Posted Label Req. Nos."; Code[20])
        {
            Caption = 'Posted Label Req. Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(59102; "Enable File Export"; Boolean)
        {

        }
        field(59103; "File Extension Service URL"; Text[250])
        {

        }
        field(59104; "Purchase Order File Path"; Text[250])
        {

        }
        field(59105; "Transfer Order File Path"; Text[250])
        {

        }
        field(59106; "Markdown Entry File Path"; Text[250])
        {

        }
        field(59107; "File Posted Label Req. Nos."; Code[20])
        {
            Caption = 'File Posted Label Req. Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(59108; "Cons. Item Gen. Prod Filter"; Text[100])
        {
            Caption = 'Cons. Item Gen. Prod Filter';
            DataClassification = ToBeClassified;
        }

    }
}
