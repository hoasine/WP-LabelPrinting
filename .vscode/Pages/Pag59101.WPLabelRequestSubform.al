namespace LabelPrinting.LabelPrinting;

page 59101 "WP Label Request Subform"
{
    ApplicationArea = All;
    DelayedInsert = true;
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "WP Label Request Lines";
    MultipleNewLines = true;
    //PromotedActionCategoriesML= 'New,Process,Report';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Barcode; Rec.Barcode)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ShowMandatory = true;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ShowMandatory = true;
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
                //UAT-037:add special group description
                field("Special Group Name"; Rec."Special Group Name")
                {
                    ApplicationArea = All;
                }
                //END
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
            }
        }
    }
}
