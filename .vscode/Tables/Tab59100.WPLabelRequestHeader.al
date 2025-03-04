table 59100 "WP Label Request Header"
{
    Caption = 'WP Label Request Header';
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
            //UAT-35: Remove Transfer Order out of Document Type
            //OptionMembers = "PO","TO","MD","LP","C";
            OptionMembers = "PO","MD","LP","C";

            //OptionCaption = 'Purchase Order,Transfer Order,Markdown,Label Printing,Consignment';
            OptionCaption = 'Purchase Order,Markdown,Label Printing,Consignment';
            //END
            trigger OnValidate()
            var
                lLabelReqLines: Record "WP Label Request Lines";
            begin
                lLabelReqLines.SetRange("Document No.", "No.");

                if lLabelReqLines.FindFirst() then begin
                    Error('Unable to modify when line has record(s).');
                end;

                if "Document Type" = "Document Type"::PO then begin
                    "Original Order Type" := "Original Order Type"::"Purchase Order";
                    "Effective Date" := "Document Date";
                    "Code Type" := "Code Type"::"1";
                end
                //UAT-35: Remove Transfer Order out of Document Type
                // else if "Document Type" = "Document Type"::"TO" then begin
                //     "Original Order Type" := "Original Order Type"::"Transfer Order";
                //     "Effective Date" := "Document Date";
                //     "Code Type" := "Code Type"::"1";
                // end
                //END
                else if "Document Type" = "Document Type"::MD then begin
                    "Original Order Type" := "Original Order Type"::" ";
                    "Code Type" := "Code Type"::"1";
                end
                else if "Document Type" = "Document Type"::LP then begin
                    "Original Order Type" := "Original Order Type"::" ";
                    "Effective Date" := "Document Date";
                    //"Code Type" := "Code Type"::"0";
                end
                else if "Document Type" = "Document Type"::C then begin
                    "Original Order Type" := "Original Order Type"::" ";
                    "Effective Date" := "Document Date";
                    "Code Type" := "Code Type"::"0";
                end
                else
                    "Original Order Type" := "Original Order Type"::" ";

            end;
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
        //UAT-038 Change the "Aging" field from a number to text “MMY”. When a user keys in "015", it will display as "015" instead of "15”.
        // field(8; Aging; Integer)
        // {
        //     Caption = 'Aging';
        //     DataClassification = ToBeClassified;
        // }
        field(8; Aging; Text[3])
        {
            Caption = 'Aging';
            Description = 'Format text : MMY';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                formattedAging: Text[3];
            begin
                formattedAging := CopyStr(Rec."Aging", 1, 3); // Ensure max length of 3 characters
                Rec."Aging" := formattedAging;
            end;
        }
        //END 
        field(9; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                lrecLines: record "WP Label Request Lines";
                lbarcode: Code[22];
            begin
                if "Document Type" = "Document Type"::MD then begin

                end
                else begin
                    "Effective Date" := "Document Date";

                    lrecLines.SetRange("Document No.", rec."No.");

                    if lrecLines.FindSet() then begin
                        repeat begin
                            lbarcode := getbarcodes(lrecLines."Item No.", lrecLines."Unit of Measure Code");
                            lrecLines."Unit Price" := getSalesPrice(lbarcode, "Effective Date");
                            lrecLines.Modify();
                        end until lrecLines.Next() = 0;
                    end;
                end;
            end;
        }
        field(10; "Original Order No."; Code[20])
        {
            Caption = 'Original Order No.';
            DataClassification = ToBeClassified;

            TableRelation =
            //UAT-35: Remove Transfer Order out of Document Type
            // IF ("Original Order Type" = CONST("Purchase Order")) "Purchase Header"."No." where("Document Type" = Const("Purchase Document Type"::Order))

            // ELSE
            // IF ("Original Order Type" = CONST("Transfer Order")) "Transfer Header"."No.";
            IF ("Original Order Type" = CONST("Purchase Order"))
                "Purchase Header"."No." where("Document Type" = Const("Purchase Document Type"::Order));
            //END
            trigger OnValidate()
            begin
                //UAT-35: Remove Transfer Order out of Document Type
                // if "Original Order Type" = "Original Order Type"::"Purchase Order" then
                //     PopulatePurchaseOrder()
                // else if "Original Order Type" = "Original Order Type"::"Transfer Order" then
                //     PopulateTransferOrder();

                if "Original Order Type" = "Original Order Type"::"Purchase Order" then
                    PopulatePurchaseOrder();
                //END 
            end;
        }
        field(11; "Original Order Type"; Option)
        {
            Caption = 'Original Order Type';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Purchase Order","Transfer Order";
        }

        field(18; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                lrecLines: record "WP Label Request Lines";
                lbarcode: Code[22];
            begin
                if "Document Type" = "Document Type"::MD then begin
                    lrecLines.SetRange("Document No.", rec."No.");

                    if lrecLines.FindSet() then begin
                        repeat begin
                            lbarcode := getbarcodes(lrecLines."Item No.", lrecLines."Unit of Measure Code");
                            lrecLines."Unit Price" := getSalesPrice(lbarcode, "Effective Date");
                            lrecLines.Modify();
                        end until lrecLines.Next() = 0;
                    end;
                end;
            end;
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
        PromotionNo: Code[20];
        PromoDesc: Text;
        PromoStartDt: Date;
        PromoEndDt: Date;

    local procedure GetNoSeriesCode(): code[20]
    var
        RetailSetup: Record "LSC Retail Setup";
    begin
        RetailSetup.Reset();
        if RetailSetup.Get() then
            RetailSetup.TestField("Label Request Nos.");
        exit(RetailSetup."Label Request Nos.");
    end;

    trigger OnInsert()
    begin
        "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode());
    end;

    trigger OnModify()
    begin
        if (Rec.Status = Rec.Status::Released) then begin
            Error('Unable to modify when in Released status.');
        end;
    end;

    local procedure PopulatePurchaseOrder()
    var
        lpurchaseOrderSrc: Record "Purchase Line";
        llblReqLines: Record "WP Label Request Lines";
        lineNo: Integer;
        litem: Record Item;
    begin
        lpurchaseOrderSrc.SetRange("Document No.", rec."Original Order No.");
        lpurchaseOrderSrc.SetRange("Document Type", lpurchaseOrderSrc."Document Type"::Order);
        lpurchaseOrderSrc.SetRange(Type, lpurchaseOrderSrc.Type::Item);
        lineNo := 0;
        if lpurchaseOrderSrc.FindSet() then begin
            repeat
                lineNo := lineNo + 1;
                llblReqLines.Init();
                llblReqLines."Document No." := rec."No.";
                llblReqLines."Line No." := lineNo;
                llblReqLines.Description := lpurchaseOrderSrc.Description;
                llblReqLines."Unit of Measure Code" := lpurchaseOrderSrc."Unit of Measure Code";
                llblReqLines."Item No." := lpurchaseOrderSrc."No.";
                llblReqLines.Quantity := lpurchaseOrderSrc.Quantity;
                llblReqLines.Barcode := getbarcodes(lpurchaseOrderSrc."No.", lpurchaseOrderSrc."Unit of Measure Code");
                llblReqLines."Unit Price" := getSalesPrice(llblReqLines.Barcode, rec."Effective Date");
                llblReqLines.Aging := rec.Aging;

                if litem.FindFirst() then begin
                    litem.CalcFields("LSC Special Group Code");
                    llblReqLines."Vendor No." := litem."Vendor No.";
                    llblReqLines."Division Code" := litem."LSC Division Code";
                    llblReqLines."Item Category" := litem."Item Category Code";
                    llblReqLines."Product Group Code" := litem."LSC Retail Product Code";
                    llblReqLines."Special Group Code" := litem."LSC Special Group Code";
                    llblReqLines."Product Posting Group" := litem."Gen. Prod. Posting Group";

                end;

                llblReqLines.Insert();
            until lpurchaseOrderSrc.Next() = 0;
        end;
    end;

    local procedure PopulateTransferOrder()
    var
        ltransferOrderSrc: Record "Transfer Line";
        llblReqLines: Record "WP Label Request Lines";
        lineNo: Integer;
        litem: Record Item;
    begin
        ltransferOrderSrc.SetRange("Document No.", rec."Original Order No.");

        lineNo := 0;
        if ltransferOrderSrc.FindSet() then begin
            repeat
                litem.Reset();
                litem.SetRange("No.", ltransferOrderSrc."Item No.");
                litem.SetRange("Base Unit of Measure", ltransferOrderSrc."Unit of Measure Code");

                lineNo := lineNo + 1;
                llblReqLines.Init();
                llblReqLines."Document No." := rec."No.";
                llblReqLines."Line No." := lineNo;
                llblReqLines.Description := ltransferOrderSrc.Description;
                llblReqLines."Unit of Measure Code" := ltransferOrderSrc."Unit of Measure Code";
                llblReqLines."Item No." := ltransferOrderSrc."Item No.";
                llblReqLines.Quantity := ltransferOrderSrc.Quantity;
                llblReqLines.Barcode := getbarcodes(ltransferOrderSrc."Item No.", ltransferOrderSrc."Unit of Measure Code");
                llblReqLines."Unit Price" := getSalesPrice(llblReqLines.Barcode, rec."Effective Date");
                llblReqLines.Aging := rec.Aging;

                if litem.FindFirst() then begin
                    litem.CalcFields("LSC Special Group Code");
                    llblReqLines."Vendor No." := litem."Vendor No.";
                    llblReqLines."Division Code" := litem."LSC Division Code";
                    llblReqLines."Item Category" := litem."Item Category Code";
                    llblReqLines."Product Group Code" := litem."LSC Retail Product Code";
                    llblReqLines."Special Group Code" := litem."LSC Special Group Code";
                    llblReqLines."Product Posting Group" := litem."Gen. Prod. Posting Group";

                end;

                llblReqLines.Insert();

            until ltransferOrderSrc.Next() = 0;
        end;

    end;

    local procedure getbarcodes(itemno: code[20]; uomcode: code[20]): code[22]
    var
        lrecBarc: Record "LSC Barcodes";
    begin

        if itemno <> '' then begin
            clear(lrecBarc);
            lrecBarc.setrange("Item No.", itemno);
            lrecBarc.SetRange("Unit of Measure Code", uomcode);
            if lrecBarc.FindFirst() then
                exit(lrecBarc."Barcode No.")
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
                    // FindPromotion(retailSetup."Local Store No.", lscBarcode."Barcode No.");
                    // CheckPromotion(PromotionNo);

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
