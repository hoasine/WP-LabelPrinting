namespace LabelPrinting.LabelPrinting;

pageextension 59100 WPRetailSetupExt extends "LSC Retail Setup"
{
    layout
    {

        addafter(Other)
        {
            group("Label Request Setup")
            {
                field("Label Request Nos."; rec."Label Request Nos.") { ApplicationArea = All; }
                field("Posted Label Req. Nos."; rec."Posted Label Req. Nos.") { ApplicationArea = All; }
                // field("File P Lbl Req. Nos."; rec."File Posted Label Req. Nos.") { ApplicationArea = All; }
                field("Enable File Export"; Rec."Enable File Export")
                {
                    ApplicationArea = All;
                }
                field("File Extension Service URL"; Rec."File Extension Service URL")
                {
                    ApplicationArea = All;
                }
                field("Purchase Order File Path"; Rec."Purchase Order File Path")
                {
                    ApplicationArea = All;
                }
                field("Transfer Order File Path"; Rec."Transfer Order File Path")
                {
                    ApplicationArea = All;
                }
                field("Markdown Entry File Path"; Rec."Markdown Entry File Path")
                {
                    ApplicationArea = All;
                }
                field("Cons. Item Gen. Prod Filter"; Rec."Cons. Item Gen. Prod Filter")
                {
                    ApplicationArea = All;
                }





            }
        }

    }
}
