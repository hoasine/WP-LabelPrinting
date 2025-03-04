table 59102 "WP Posted Label Request Header"
{
    Caption = 'WP Posted Label Request Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = "PO","TO","MD","LP","C";
            OptionCaption = 'Purchase Order,Transfer Order,Markdown,Label Printing,Consignment';
        }
        field(3; "Printer No."; Option)
        {
            Caption = 'Printer No.';
            OptionMembers = "01","02","03";
        }
        field(4; "Price Tag Type"; Option)
        {
            Caption = 'Price Tag Type';
            OptionMembers = "0","1","2";
            OptionCaption = '0 Tag,1 Label,2 Jewelry';
            DataClassification = ToBeClassified;
        }
        field(5; "Price Type"; Option)
        {
            Caption = 'Price Type';
            OptionMembers = "0","1";
            OptionCaption = '0 Proper,1 Sale';
            DataClassification = ToBeClassified;
        }
        field(6; "Code Type"; Option)
        {
            Caption = 'Çode Type';
            OptionMembers = "0","1","2";
            OptionCaption = '0 DKU,1 SKU,2 QR';
            DataClassification = ToBeClassified;
        }
        field(7; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = "Open","Released";
            DataClassification = ToBeClassified;
        }
        field(8; "Aging"; Text[3])
        {
            Caption = 'Aging';
            DataClassification = ToBeClassified;
        }
        field(9; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        field(10; "Original Order No."; Code[20])
        {
            Caption = 'Original Order No.';
            DataClassification = ToBeClassified;
        }
        field(11; "Original Order Type"; Option)
        {
            Caption = 'Original Order Type';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Purchase Order","Transfer Order";
        }
        field(12; "Original Document No."; Text[20])
        {
            Caption = 'Original Document No.';
            DataClassification = ToBeClassified;
        }
        field(13; "File Name"; Text[50])
        {
            Caption = 'File Name';
            DataClassification = ToBeClassified;
        }
        field(14; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(15; "Posted By"; Code[50])
        {
            Caption = 'Posted By';
            DataClassification = ToBeClassified;
        }
        field(16; "Posting Time"; Time)
        {
            Caption = 'Posting Time';
            DataClassification = ToBeClassified;
        }
        field(17; "No. Of Times Printed"; Integer)
        {
            Caption = 'No. Of Times Printed';
            DataClassification = ToBeClassified;
        }
        field(18; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
            DataClassification = ToBeClassified;
        }


    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    var
        NoSeriesMgt: Codeunit "No. Series";

    local procedure GetNoSeriesCode(): code[20]
    var
        RetailSEtup: Record "LSC Retail Setup";
    begin
        RetailSetup.Reset();
        if RetailSetup.Get() then
            RetailSetup.TestField("Posted Label Req. Nos.");
        exit(RetailSetup."Posted Label Req. Nos.");
    end;

    trigger OnInsert()
    begin
        "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode());
    end;
}
