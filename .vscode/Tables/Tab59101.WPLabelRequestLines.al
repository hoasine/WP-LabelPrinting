table 59101 "WP Label Request Lines"
{
    Caption = 'Label Request Lines';
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
            TableRelation = Item."No.";

            trigger OnValidate()
            var
                lrecItem: Record Item;
                llabelReqHdr: record "WP Label Request Header";
                lrecPpg: record "Gen. Product Posting Group";
                lrecSpecialGroup: Record "LSC Item Special Groups";
            begin
                //if ("Item No."<>'' AND "Unit of Measure Code"<>'') then begin -- Fix bug: remove UOM code 
                if ("Item No." <> '') or ("Barcode" <> '') or ("Unit of Measure Code" <> '') then begin
                    clear(lrecItem);
                    lrecItem.setrange("No.", rec."Item No.");

                    if lrecItem.FindFirst() then begin
                        //UAT-036 : If ItemNo is blocked at Retail Item Card, then can not input it to lable printing
                        if lrecItem.Blocked = True Then begin
                            Error('Item "%1" is blocked and cannot be inserted into the line.', rec."Item No.");
                        end;
                        //END
                        lrecItem.CalcFields("LSC Special Group Code");
                        "Division Code" := lrecItem."LSC Division Code";
                        "Item Category" := lrecItem."Item Category Code";
                        "Product Group Code" := lrecItem."LSC Retail Product Code";
                        clear(lrecPpg);
                        if lrecPpg.Get(lrecItem."Gen. Prod. Posting Group") then
                            "Product Posting Group" := lrecPpg."Label Printing Purch. Type";
                        // Description := lrecItem.Description + ' ' + lrecItem."Description 2";
                        "Special Group Code" := lrecitem."LSC Special Group Code";
                        //UAT-037:add special group description
                        Clear(lrecSpecialGroup);
                        lrecSpecialGroup.SetRange(Code, lrecitem."LSC Special Group Code"); // Match the correct field name
                        if lrecSpecialGroup.FindFirst() then
                            "Special Group Name" := lrecSpecialGroup.Description // Assuming "Description" holds the name
                        else
                            "Special Group Name" := ''; // Empty if no match found
                        //END
                        "Vendor No." := lrecItem."Vendor No.";
                        "Unit of Measure Code" := '';

                        if strlen(rec."Item No.") > 4 then
                            "Short Item No." := copystr(rec."Item No.", strlen(rec."Item No.") - 3, 4)
                        else
                            "Short Item No." := rec."Item No.";
                    end;

                    Barcode := getbarcodes("Item No.", "Unit of Measure Code");

                    if rec."Document No." <> '' then begin
                        llabelReqHdr.Get(rec."Document No.");
                        Aging := llabelReqHdr.Aging;
                        "Unit Price" := getSalesPrice(Barcode, llabelReqHdr."Effective Date");
                    end;
                end;
            end;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(5; "Barcode"; Code[22])
        {
            Caption = 'Barcode';
            DataClassification = ToBeClassified;
            TableRelation = if ("Item No." = filter('''''')) "LSC Barcodes"."Barcode No."
            else
            "LSC Barcodes"."Barcode No." where("Item No." = field("Item No."));

            trigger OnValidate()
            var
                lbarcode: Integer;
                lrecbarc: Record "LSC Barcodes";
                lrecItem: Record "Item";
                llabelReqHdr: record "WP Label Request Header";
                lrecSpecialGroup: Record "LSC Item Special Groups";
            begin
                if ("Item No." <> '') or ("Barcode" <> '') or ("Unit of Measure Code" <> '') then begin
                    clear(lrecbarc);
                    if lrecbarc.get(Barcode) then begin
                        rec."Item No." := lrecbarc."Item No.";
                        rec."Unit of Measure Code" := lrecbarc."Unit of Measure Code";
                        rec.Description := lrecbarc.Description;

                        Clear(lrecItem);
                        lrecItem.SetRange("No.", lrecbarc."Item No.");
                        lrecItem.SetRange("Base Unit of Measure", lrecbarc."Unit of Measure Code");
                        if lrecItem.FindFirst() then begin
                            //UAT-036 : If ItemNo is blocked at Retail Item Card, then can not input it to lable printing
                            if lrecItem.Blocked = True Then begin
                                Error('Item "%1" is blocked and cannot be inserted into the line.', rec."Item No.");
                            end;
                            //END
                            lrecItem.CalcFields("LSC Special Group Code");
                            "Division Code" := lrecItem."LSC Division Code";
                            "Item Category" := lrecItem."Item Category Code";
                            "Product Group Code" := lrecItem."LSC Retail Product Code";
                            "Product Posting Group" := lrecItem."Gen. Prod. Posting Group";
                            "Special Group Code" := lrecItem."LSC Special Group Code";
                            //UAT-037:add special group description
                            Clear(lrecSpecialGroup);
                            lrecSpecialGroup.SetRange(Code, lrecitem."LSC Special Group Code"); // Match the correct field name
                            if lrecSpecialGroup.FindFirst() then
                                "Special Group Name" := lrecSpecialGroup.Description // Assuming "Description" holds the name
                            else
                                "Special Group Name" := ''; // Empty if no match found
                            //END
                            "Vendor No." := lrecItem."Vendor No.";

                            Clear(llabelReqHdr);
                            if rec."Document No." <> '' then begin
                                llabelReqHdr.Get(rec."Document No.");
                                Aging := llabelReqHdr.Aging;
                                "Unit Price" := getSalesPrice(Barcode, llabelReqHdr."Effective Date");
                            end;
                        end;
                    end;
                end;
            end;
        }
        field(6; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                lrecItem: Record Item;
                llabelReqHdr: Record "WP Label Request Header";
                lrecSpecialGroup: Record "LSC Item Special Groups";
            begin
                if ("Item No." <> '') or ("Barcode" <> '') or ("Unit of Measure Code" <> '') then begin
                    clear(lrecItem);
                    lrecItem.setrange("No.", rec."Item No.");
                    if lrecItem.FindFirst() then begin
                        lrecItem.CalcFields("LSC Special Group Code");
                        "Division Code" := lrecItem."LSC Division Code";
                        "Item Category" := lrecItem."Item Category Code";
                        "Product Group Code" := lrecItem."LSC Retail Product Code";
                        "Product Posting Group" := lrecItem."Gen. Prod. Posting Group";
                        // Description := lrecItem.Description + ' ' + lrecItem."Description 2";
                        "Special Group Code" := lrecitem."LSC Special Group Code";
                        //UAT-037:add special group description
                        Clear(lrecSpecialGroup);
                        lrecSpecialGroup.SetRange(Code, lrecitem."LSC Special Group Code"); // Match the correct field name
                        if lrecSpecialGroup.FindFirst() then
                            "Special Group Name" := lrecSpecialGroup.Description // Assuming "Description" holds the name
                        else
                            "Special Group Name" := ''; // Empty if no match found
                        // END
                        "Vendor No." := lrecItem."Vendor No.";
                    end;

                    Barcode := getbarcodes("Item No.", "Unit of Measure Code");

                    Clear(llabelReqHdr);
                    if rec."Document No." <> '' then begin
                        llabelReqHdr.Get(rec."Document No.");
                        Aging := llabelReqHdr.Aging;
                        "Unit Price" := getSalesPrice(Barcode, llabelReqHdr."Effective Date");
                    end;
                end;

                UpdateBarcodeForConsign();
            end;
        }
        field(7; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;
            trigger OnValidate()
            begin
                if Quantity < 1 then begin
                    Message('The Quantity must be 1 or greater.');
                end
                else
                    UpdateBarcodeForConsign();
            end;
        }
        //UAT-038 Change the "Aging" field from a number to text “MMY”. When a user keys in "015", it will display as "015" instead of "15”.
        // field(8; "Aging"; Integer)
        // {
        //     Caption = 'Aging';
        //     DataClassification = ToBeClassified;
        // }
        field(8; "Aging"; Text[3])
        {
            Caption = 'Aging';
            DataClassification = ToBeClassified;
        }
        //END
        field(9; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdateBarcodeForConsign();
            end;
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
        field(23; "Short Item No."; Code[4])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Special Group Name"; Text[30])
        {
            Caption = 'Special Group Name';
            Editable = false; // Prevents manual entry, auto-filled from Special Groups table
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

    var
        PromotionNo: Code[20];
        PromoDesc: Text;
        PromoStartDt: Date;
        PromoEndDt: Date;

    // Insert trigger for data not visible to the user
    trigger OnInsert()
    var
        header: Record "WP Label Request Header";
        lines2: Record "WP Label Request Lines";
        lineno: Integer;
        item: Record Item;
        lscBarcode: Record "LSC Barcodes";
        lretailPriceutil: Codeunit "LSC Retail Price Utils";

    begin
        TestField(Barcode);
        TestField("Unit of Measure Code");

        if "Document No." <> '' then begin
            clear(lines2);
            lines2.setrange("Document No.", rec."Document No.");
            if lines2.FindLast() then begin
                lineno := lines2."Line No.";
            end else begin
                lineno := 0;
            end;
            rec."Line No." := lineno + 1;

            // header.SetRange("No.", rec."Document No.");
            // if header.FindFirst() then begin
            //     rec.Aging := header.Aging;
            // end;
        end;

        // when barcode selected
        // if Rec.Barcode <> '' then begin

        //     Clear(item);
        //     Clear(lscBarcode);

        //     lscBarcode.SetRange("Barcode No.", rec.Barcode);

        //     if lscBarcode.FindFirst() then begin
        //         "Item No." := lscBarcode."Item No.";

        //         item.SetRange("No.", lscBarcode."Barcode No.");

        //         if item.FindFirst() then begin
        //             "Unit of Measure Code" := item."Base Unit of Measure";
        //             "Division Code" := item."LSC Division Code";
        //             "Item Category" := item."Item Category Code";
        //             "Product Group Code" := item."LSC Retail Product Code";
        //             "Special Group Code" := item."LSC Special Group Code";
        //             "Vendor No." := item."Vendor No.";
        //             "Product Posting Group" := item."Gen. Prod. Posting Group";
        //         end;
        //     end;

        // end;

        // wben item selected
        // if Rec."Item No." <> '' then begin

        //     Clear(item);
        //     Clear(lscBarcode);

        //     item.SetRange("No.", rec."Item No.");

        //     if item.FindFirst() then begin
        //         "Unit of Measure Code" := item."Base Unit of Measure";
        //         "Division Code" := item."LSC Division Code";
        //         "Item Category" := item."Item Category Code";
        //         "Product Group Code" := item."LSC Retail Product Code";
        //         "Special Group Code" := item."LSC Special Group Code";
        //         "Vendor No." := item."Vendor No.";
        //         "Product Posting Group" := item."Gen. Prod. Posting Group";
        //     end;
        // end;
    end;

    local procedure UpdateBarcodeForConsign()
    var
        item: Record Item;
        lscBarcode: Record "LSC Barcodes";
        retailSetup: Record "LSC Retail Setup";
        formatUnitPriceTxt: Text[20];
        formatItemNoTxt: Text[20];
    begin
        retailSetup.Reset();

        // 0. Check if barcode exist for the item.
        lscBarcode.SetRange("Item No.", rec."Item No.");
        if lscBarcode.FindFirst() then begin

            //1. Get config of retail setup
            if retailSetup.Get() then begin

                //2. Check if retail setup has filter
                if (retailSetup."Cons. Item Gen. Prod Filter" <> '') and ("Unit Price" > 0) and ("Unit of Measure Code" <> '') then begin

                    //3. Check if item is consignment
                    item.SetFilter("No.", rec."Item No.");
                    item.SetFilter("Base Unit of Measure", rec."Unit of Measure Code");
                    item.SetFilter("Gen. Prod. Posting Group", retailSetup."Cons. Item Gen. Prod Filter");
                    if item.FindFirst() then begin

                        //4. Generate consignment barcode for item
                        //Barcode := lscBarcode."Barcode No.";
                        formatUnitPriceTxt := DelChr(Format(Round("Unit Price", 1, '<')), '=', ',').PadLeft(10, '0');
                        // formatItemNoTxt := Format(rec."Item No.").PadLeft(8, '0');


                        // genBarcode := '';
                        // for i := StrLen(Barcode) downto 1 do begin
                        //     if (CopyStr(Barcode, i, 1) = retailSetup."Cons. Barcode Item Prefix") then begin
                        //         if (StrLen(Barcode) - i < StrLen(Barcode)) and (StrLen(formatUnitPriceTxt) - (StrLen(Barcode) - i) > 0) then begin
                        //             genBarcode := CopyStr(formatUnitPriceTxt, StrLen(Barcode) - i, 1) + genBarcode;
                        //         end
                        //         else
                        //             genBarcode := '0' + genBarcode;
                        //     end
                        //     else begin
                        //         genBarcode := CopyStr(Barcode, i, 1) + genBarcode;
                        //     end;
                        // end;

                        //5. Check if length of barcode is 20
                        if StrLen(Barcode) = 20 then begin

                            //6. Generate the barcode with item no. and price
                            Barcode := CopyStr(Barcode, 1, 10) + formatUnitPriceTxt;

                        end;
                    end;
                end;
            end;
        end;
    end;

    trigger OnModify()
    var
        tLabelReqHdr: Record "WP Label Request Header";
    begin

        // if (Barcode <> '') and ("Item No." <> '') then begin
        //     UpdateBarcodeForConsign();
        // end;

        TestField(Barcode);
        TestField("Unit of Measure Code");
        tLabelReqHdr.Get(Rec."Document No.");
        if (tLabelReqHdr.Status = tLabelReqHdr.Status::Released) then begin
            Error('Unable to modify when in Released status.');
        end else
            if (Barcode = '') and ("Item No." <> '') then
                UpdateBarcodeForConsign();
    end;


    local procedure getbarcodes(itemno: code[20]; uomcode: code[20]): code[22]
    var
        lrecBarc: Record "LSC Barcodes";
    begin

        if itemno <> '' then begin
            clear(lrecBarc);
            lrecBarc.setrange("Item No.", itemno);
            lrecBarc.SetRange("Unit of Measure Code", uomcode);
            if lrecBarc.FindFirst() then begin
                Description := lrecBarc.Description;
                exit(lrecBarc."Barcode No.");
            end
            else
                exit('');
        end;
    end;

    local procedure getSalesPrice(barcode: code[22]; itemDt: Date): decimal
    var
        retailSetup: Record "LSC Retail Setup";
        store: Record "LSC Store";
        lscBarcode: Record "LSC Barcodes";
        cuRetailPriceUtil: Codeunit "LSC Retail Price Utils";
        boUtils: Codeunit "LSC BO Utils";
        itemStatusLink: Record "LSC Item Status Link";
        salesPrice: decimal;
    begin
        if barcode = '' then
            exit;
        retailsetup.SetLoadFields("Local Store No.");
        retailSetup.Get();
        store.Reset();
        store.SetLoadFields("Store VAT Bus. Post. Gr.", "Currency Code");
        if store.Get(retailSetup."Local Store No.") then;

        lscBarcode.Reset();
        lscBarcode.SetCurrentKey("Item No.", "Barcode No.");
        lscBarcode.SetFilter("Barcode No.", barcode);
        lscbarcode.SetLoadFields("Barcode No.", "Item No.", "Unit of Measure Code", "Variant Code");
        if lscBarcode.FindSet() then
            repeat
                Clear(boUtils);
                if not boUtils.IsBlockPromotionDiscount(lscBarcode."Item No.", '', lscbarcode."Variant Code", retailSetup."Local Store No.", store."Location Code", itemDt, itemStatusLink) then begin
                    FindPromotion(retailSetup."Local Store No.", lscBarcode."Barcode No.");
                    CheckPromotion(PromotionNo);

                    clear(cuRetailPriceUtil);
                    salesPrice := cuRetailPriceUtil.GetValidRetailPrice2(retailSetup."Local Store No.", lscBarcode."Item No.", itemDt, 0T, lscBarcode."Unit of Measure Code", lscBarcode."Variant Code", store."Store VAT Bus. Post. Gr.", store."Currency Code", '', '', '');
                end;
            until lscBarcode.Next() = 0;
        exit(salesPrice);
    end;

    local procedure FindPromotion(pStoreNo: Code[10]; pBarcodes: Code[20])
    var
        cuRetailPriceUtils: Codeunit "LSC Retail Price Utils";
        recStorePriceGrp: Record "LSC Store Price Group";
        StorePriceGrp: Text;
        recBarc: Record "LSC Barcodes";
        recItem: Record Item;
        recSpecialGrp: Record "LSC Item/Special Group Link";
        recOffer: Record "LSC Offer";
        recOfferLine: Record "LSC Offer Line";
    begin
        clear(StorePriceGrp);
        recStorePriceGrp.Reset();
        recStorePriceGrp.setrange(Store, pStoreNo);
        if recStorePriceGrp.FindSet() then
            repeat
                if StorePriceGrp <> '' then
                    StorePriceGrp := StorePriceGrp + '|' + recStorePriceGrp."Price Group Code"
                else
                    StorePriceGrp := recStorePriceGrp."Price Group Code";
            until recStorePriceGrp.Next = 0;

        Clear(PromotionNo);
        recOffer.Reset();
        recOffer.SetCurrentKey(Status, Type);
        recOffer.setrange(Status, recOffer.status::Enabled);
        recOffer.setrange(Type, recOffer.Type::Promotion);
        recOffer.Setfilter("Price Group", StorePriceGrp);
        recOffer.SetFilter("Coupon Code", '''''');
        recOffer.SetLoadFields("Price Group", Status, "Block Periodic Discount", "Validation Period ID");
        if recOffer.FindSet() then
            repeat
                if cuRetailPriceUtils.DiscValPerValid(recOffer."Validation Period ID", Today, 0T) = true then begin
                    recOfferLine.Reset();
                    recOfferLine.SetCurrentKey("Offer No.", Type, "No.", "Variant Code", "Unit of Measure", "Currency Code");
                    recOfferLine.setrange("Offer No.", recOffer."No.");
                    recOfferLine.setrange(Exclude, false);
                    recOfferLine.SetLoadFields(Exclude, Type, "No.", "Variant Code", "Unit of Measure");
                    if recOfferLine.FindSet() then begin
                        repeat
                            case recOfferLine.Type of
                                recOfferLine.Type::All:
                                    begin
                                        PromotionNo := recOfferLine."Offer No.";
                                    end;
                                recOfferLine.Type::"Special Group":
                                    begin
                                        recSpecialGrp.Reset();
                                        recSpecialGrp.SetCurrentKey("Special Group Code", "Item No.");
                                        recSpecialGrp.setrange("Special Group Code", recOfferLine."No.");
                                        recSpecialGrp.SetLoadFields("Special Group Code", "Item No.");
                                        if recSpecialGrp.FindSet() then begin
                                            repeat
                                                recBarc.Reset();
                                                recBarc.SetCurrentKey("Item No.", "Barcode No.");
                                                recBarc.setrange("Item No.", recSpecialGrp."Item No.");
                                                recBarc.SetRange("Barcode No.", pBarcodes);
                                                recBarc.SetLoadFields("Barcode No.", "Item No.");
                                                if recBarc.FindSet() then begin
                                                    repeat
                                                        PromotionNo := recOfferLine."Offer No.";
                                                    until recBarc.next = 0;
                                                end;
                                            until recSpecialGrp.next = 0;
                                        end;
                                    end;
                                recOfferLine.Type::"Item Category":
                                    begin
                                        recItem.Reset();
                                        recItem.setrange("Item Category Code", recOfferLine."No.");
                                        recItem.SetLoadFields("Item Category Code");
                                        if recItem.FindSet() then begin
                                            repeat
                                                recBarc.Reset();
                                                recBarc.SetCurrentKey("Item No.", "Barcode No.");
                                                recBarc.setrange("Item No.", recItem."No.");
                                                recBarc.SetRange("Barcode No.", pBarcodes);
                                                if recBarc.findset() then begin
                                                    repeat
                                                        PromotionNo := recOfferLine."Offer No.";
                                                    until recBarc.next = 0;
                                                end;
                                            until recItem.next = 0;
                                        end;
                                    end;
                                recOfferLine.Type::"Product Group":
                                    begin
                                        recItem.Reset();
                                        recItem.SetCurrentKey("LSC Retail Product Code");
                                        recItem.setrange("LSC Retail Product Code", recOfferLine."No.");
                                        recItem.SetLoadFields("LSC Retail Product Code");
                                        if recItem.FindSet() then begin
                                            repeat
                                                recBarc.Reset();
                                                recBarc.SetCurrentKey("Item No.", "Barcode No.");
                                                recBarc.setrange("Item No.", recItem."No.");
                                                recBarc.SetRange("Barcode No.", pBarcodes);
                                                if recBarc.FindSet() then begin
                                                    repeat
                                                        PromotionNo := recOfferLine."Offer No.";
                                                    until recBarc.next = 0;
                                                end;
                                            until recItem.Next() = 0;
                                        end;
                                    end;
                                recOfferLine.Type::Item:
                                    begin
                                        recBarc.Reset();
                                        recBarc.SetCurrentKey("Item No.", "Variant Code", "Unit of Measure Code");
                                        recBarc.setrange("Item No.", recOfferLine."No.");
                                        recBarc.SetRange("Barcode No.", pBarcodes);
                                        recBarc.SetLoadFields("Barcode No.", "Item No.", "Variant Code", "Unit of Measure Code");
                                        if recOfferLine."Variant Code" <> '' then
                                            recBarc.setrange("Variant Code", recOfferLine."Variant Code")
                                        else
                                            recBarc.SetRange("Variant Code");

                                        if recOfferLine."Unit of Measure" <> '' then
                                            recBarc.SetRange("Unit of Measure Code", recOfferLine."Unit of Measure")
                                        else
                                            recBarc.SetRange("Unit of Measure Code");
                                        if recBarc.FindSet() then
                                            repeat
                                                PromotionNo := recOfferLine."Offer No.";
                                            until recBarc.next = 0;

                                    end;
                            end;
                        until recOfferLine.Next() = 0;
                    end;
                end;
            until recOffer.next = 0;
    end;

    local procedure CheckPromotion(pPromoNo: Code[20])
    var
        Promotion: Record "LSC Offer";
        DiscOffer: Record "LSC Periodic Discount";
        ValidationPeriod: Record "LSC Validation Period";
    begin
        Clear(PromoDesc);
        Clear(PromoStartDt);
        Clear(PromoEndDt);

        if pPromoNo <> '' then begin
            Promotion.Reset();
            Promotion.SetRange("No.", pPromoNo);
            Promotion.SetLoadFields("Validation Description", Description);
            if Promotion.FindFirst() then begin
                PromoDesc := Promotion.Description;

                ValidationPeriod.Reset();
                ValidationPeriod.SetLoadFields("Starting Date", "Ending Date");
                if ValidationPeriod.Get(Promotion."Validation Period ID") then begin
                    PromoStartDt := ValidationPeriod."Starting Date";
                    PromoEndDt := ValidationPeriod."Ending Date";
                end;
            end;
        end;
    end;
}
