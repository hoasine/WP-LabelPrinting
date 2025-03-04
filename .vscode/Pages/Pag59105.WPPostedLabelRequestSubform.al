namespace LabelPrinting.LabelPrinting;

page 59105 "WP Posted Label Req Subform"
{
    ApplicationArea = All;
    Caption = 'WP Posted Label Request Subform';
    PageType = ListPart;
    SourceTable = "WP Posted Label Request Lines";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Barcode; Rec.Barcode)
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field(Aging; Rec.Aging)
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Division Code"; Rec."Division Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item Category"; Rec."Item Category")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Product Group Code"; Rec."Product Group Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Special Group Code"; Rec."Special Group Code")
                {
                    ApplicationArea = All;
                }
                field("Product Posting Group"; Rec."Product Posting Group")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Port No."; Rec."Port No.")
                {
                    ApplicationArea = All;
                }
                field("Color Code"; Rec."Color Code")
                {
                    ApplicationArea = All;
                }
                field("Size Code"; Rec."Size Code")
                {
                    ApplicationArea = All;
                }
                field("Original Document No."; Rec."Original Document No.")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}
