namespace LabelPrinting.LabelPrinting;

query 59100 "WP Posted Label Request"
{
    Caption = 'WP Posted Label Request';
    QueryType = Normal;

    ReadState = ReadUncommitted;
    OrderBy = ascending("No", Document_No_);

    elements
    {
        dataitem(WPPostedLabelRequestHeader; "WP Posted Label Request Header")
        {
            filter(Original_Document_No_Filter; "Original Document No.") { }
            filter(No_Filter; "No.") { }
            filter(Document_Type_Filter; "Document Type") { }


            column(Aging; Aging)
            {
            }
            column(CodeType; "Code Type")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(FileName; "File Name")
            {
            }
            column(No; "No.")
            {
            }
            column(NoOfTimesPrinted; "No. Of Times Printed")
            {
            }
            column(OriginalDocumentNo; "Original Document No.")
            {
            }
            column(OriginalOrderNo; "Original Order No.")
            {
            }
            column(OriginalOrderType; "Original Order Type")
            {
            }
            column(PostedBy; "Posted By")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(PostingTime; "Posting Time")
            {
            }
            column(PriceTagType; "Price Tag Type")
            {
            }
            column(PriceType; "Price Type")
            {
            }
            column(PrinterNo; "Printer No.")
            {
            }
            column(Status; Status)
            {
            }

            dataitem(WPPostedLabelRequestLine; "WP Posted Label Request Lines")
            {
                DataItemLink = "Document No." = WPPostedLabelRequestHeader."No.";
                SqlJoinType = InnerJoin;

                column(Document_No_; "Document No.") { }
                column(Line_No_; "Line No.") { }
                column(Item_No_; "Item No.") { }
                column(Description; Description) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Barcode; Barcode) { }
                column(Quantity; Quantity) { }
                column(LineAging; Aging) { }
                column(Unit_Price; "Unit Price") { }
                column(Vendor_No_; "Vendor No.") { }
                column(Division_Code; "Division Code") { }
                column(Item_Category; "Item Category") { }
                column(Product_Group_Code; "Product Group Code") { }
                column(Special_Group_Code; "Special Group Code") { }
                column(Product_Posting_Group; "Product Posting Group") { }
                column(Port_No_; "Port No.") { }
                column(Color_Code; "Color Code") { }
                column(Size_Code; "Size Code") { }
                column(LineOriginal_Document_No_; "Original Document No.") { }
                column(Short_Item_No_; "Short Item No.") { }

            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
