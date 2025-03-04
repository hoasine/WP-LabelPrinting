table 59103 "WP Posted Label Request Lines"
{
    Caption = 'Posted Label Request Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5; "Barcode"; Code[22])
        {
            Caption = 'Barcode';
            DataClassification = ToBeClassified;
        }
        field(6; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = ToBeClassified;
        }
        field(7; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(8; "Aging"; Text[3])
        {
            Caption = 'Aging';
            DataClassification = ToBeClassified;
        }
        field(9; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
        }
        field(10; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = ToBeClassified;
        }
        field(11; "Division Code"; Code[20])
        {
            Caption = 'Division Code';
            DataClassification = ToBeClassified;
        }
        field(12; "Item Category"; Code[20])
        {
            Caption = 'Item Category';
            DataClassification = ToBeClassified;
        }
        field(13; "Product Group Code"; Code[20])
        {
            Caption = 'Product Group Code';
            DataClassification = ToBeClassified;
        }
        field(14; "Special Group Code"; Code[20])
        {
            Caption = 'Special Group Code';
            DataClassification = ToBeClassified;
        }
        field(15; "Product Posting Group"; Code[20])
        {
            Caption = 'Product Posting Group';
            DataClassification = ToBeClassified;
        }
        field(16; "Port No."; Code[10])
        {
            Caption = 'Port No.';
            DataClassification = ToBeClassified;
        }
        field(17; "Color Code"; Code[5])
        {
            Caption = 'Color Code';
            DataClassification = ToBeClassified;
        }
        field(18; "Size Code"; Code[5])
        {
            Caption = 'Size Code';
            DataClassification = ToBeClassified;
        }
        field(19; "Original Document No."; Code[20])
        {
            Caption = 'Original Document No.';
            DataClassification = ToBeClassified;
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(21; "Posted By"; Code[80])
        {
            Caption = 'Posted By';
            DataClassification = ToBeClassified;
        }
        field(22; "Posting Time"; Time)
        {
            Caption = 'Posting Time';
            DataClassification = ToBeClassified;
        }
        field(23; "Short Item No."; Code[4])
        {
            DataClassification = ToBeClassified;
        }



    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
