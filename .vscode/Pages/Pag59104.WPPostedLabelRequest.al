namespace LabelPrinting.LabelPrinting;
using Microsoft.Inventory.Transfer;
using Microsoft.Foundation.NoSeries;

page 59104 "WP Posted Label Request"
{
    ApplicationArea = All;
    Caption = 'WP Posted Label Request';
    PageType = Card;
    SourceTable = "WP Posted Label Request Header";
    Editable = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Aging; Rec.Aging)
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Original Order No."; Rec."Original Order No.")
                {
                    ApplicationArea = All;
                }
                field("Original Order Type"; Rec."Original Order Type")
                {
                    ApplicationArea = All;
                }
                field("Original Document No."; Rec."Original Document No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Posting Time"; Rec."Posting Time")
                {
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                }
                field("No. Of Times Printed"; Rec."No. Of Times Printed")
                {
                    ApplicationArea = All;
                }

            }
            group(Lines)
            {
                Caption = 'Lines';
                part(labellines; "WP Posted Label Req Subform")
                {
                    SubPageLink = "Document No." = field("No.");
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Export")
            {
                Image = Export;
                Promoted = true;
                ApplicationArea = All;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                var
                    cLabelReqExport: Codeunit "Label Request Export";
                begin
                    cLabelReqExport.ExportDocument(Rec."No.");
                end;
            }
        }
    }


}
