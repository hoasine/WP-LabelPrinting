namespace LabelPrinting.LabelPrinting;

page 59102 "WP Label Requests"
{
    ApplicationArea = All;
    Caption = 'WP Label Requests';
    PageType = List;
    SourceTable = "WP Label Request Header";
    UsageCategory = Lists;
    CardPageId = "WP Label Request";
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
                field(Aging; Rec.Aging)
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
            }
        }
    }
}
