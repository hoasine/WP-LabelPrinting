namespace LabelPrinting.LabelPrinting;

page 59103 "WP Posted Label Requests"
{
    ApplicationArea = All;
    Caption = 'WP Posted Label Requests';
    PageType = List;
    SourceTable = "WP Posted Label Request Header";
    UsageCategory = Lists;
    CardPageId = "WP Posted Label Request";
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {

                }
                field("Document Type"; Rec."Document Type")
                {

                }
                field("Printer No."; Rec."Printer No.")
                {

                }
                field("Price Tag Type"; Rec."Price Tag Type")
                {

                }
                field("Price Type"; Rec."Price Type")
                {

                }
                field("Code Type"; Rec."Code Type")
                {

                }
                field("Status"; Rec.Status)
                {

                }
                field(Aging; Rec.Status)
                {

                }
                field("Document Date"; Rec."Document Date")
                {

                }
                field("Original Order No."; Rec."Original Order No.")
                {

                }
                field("Original Order Type"; Rec."Original Order Type")
                {

                }
                field("Original Document No."; Rec."Original Document No.")
                {

                }
                field("Posting Date"; Rec."Posting Date")
                {

                }
                field("Posting Time"; Rec."Posting Time")
                {

                }
                field("Posted By"; Rec."Posted By")
                {

                }
                field("No. Of Times Printed"; Rec."No. Of Times Printed")
                {

                }
            }
        }
    }
}
