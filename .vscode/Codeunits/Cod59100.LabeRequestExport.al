namespace LabelPrinting.LabelPrinting;
using Microsoft.Finance.GeneralLedger.Setup;

codeunit 59100 "Label Request Export"
{
    trigger OnRun()
    var
        pPostedLabelReq: Record "WP Posted Label Request Header";
    begin
        pPostedLabelReq.SetRange("No. Of Times Printed", 0);
        if pPostedLabelReq.FindSet(false) then begin
            repeat begin
                ExportDocumentJobQueue(pPostedLabelReq."No.");
            end until pPostedLabelReq.Next() = 0;
        end;

    end;


    //new procedures for export doc
    var
        tmpBlob: Codeunit System.Utilities."Temp Blob";
        HttpClient: HttpClient;
        Httpcontent: HttpContent;
        HttpHeadersContent: HttpHeaders;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        OutStr: OutStream;
        InStr: InStream;
        DateTimeFormat: Text;
        fileName: Text;
        filePath: Text;
        txtcontain: Text;

    internal procedure ExportDocumentByOriDoc(pDocumentNo: Text)
    var
        pLscRetailSetup: Record "LSC Retail Setup";
        pPostedLabelReqHeader: Record "WP Posted Label Request Header";
    begin
        pLscRetailSetup.Get();

        //check if file export is enabled
        //check if there is URL for file export
        if pLscRetailSetup.Get() then begin
            if (not pLscRetailSetup."Enable File Export") or (pLscRetailSetup."File Extension Service URL" = '') then
                exit;
        end;
        //check if file exist
        // pPostedLabelReqHeader.LockTable(false, true);
        // pPostedLabelReqHeader.ReadIsolation := IsolationLevel::ReadUncommitted;
        pPostedLabelReqHeader.SetRange("Original Document No.", pDocumentNo);
        if not pPostedLabelReqHeader.FindFirst() then exit;

        //1. init windows service
        InitWindowService(pLscRetailSetup);

        //2. export file header
        ExportFileHeader(pPostedLabelReqHeader);

        //3. export label request 
        ExportLabelRequest(pPostedLabelReqHeader);

        //4. post to windows service
        PostToWindowsService(pPostedLabelReqHeader, pLscRetailSetup);

        pPostedLabelReqHeader."No. Of Times Printed" := pPostedLabelReqHeader."No. Of Times Printed" + 1;
        pPostedLabelReqHeader.Modify();
    end;

    internal procedure ExportDocument(pDocumentNo: Text)
    var
        pLscRetailSetup: Record "LSC Retail Setup";
        pPostedLabelReqHeader: Record "WP Posted Label Request Header";
    begin
        pLscRetailSetup.Get();

        //check if file export is enabled
        //check if there is URL for file export
        if pLscRetailSetup.Get() then begin
            if (not pLscRetailSetup."Enable File Export") or (pLscRetailSetup."File Extension Service URL" = '') then
                exit;
        end;
        //check if file exist
        if not pPostedLabelReqHeader.Get(pDocumentNo) then exit;

        //1. init windows service
        InitWindowService(pLscRetailSetup);

        //2. export file header
        ExportFileHeader(pPostedLabelReqHeader);

        //3. export label request 
        ExportLabelRequest(pPostedLabelReqHeader);

        //4. post to windows service
        PostToWindowsService(pPostedLabelReqHeader, pLscRetailSetup);

        pPostedLabelReqHeader."No. Of Times Printed" := pPostedLabelReqHeader."No. Of Times Printed" + 1;
        pPostedLabelReqHeader.Modify();
    end;

    internal procedure ExportDocumentJobQueue(pDocumentNo: Text)
    var
        pLscRetailSetup: Record "LSC Retail Setup";
        pPostedLabelReqHeader: Record "WP Posted Label Request Header";
    begin
        pLscRetailSetup.Get();

        //check if file export is enabled
        //check if there is URL for file export
        if pLscRetailSetup.Get() then begin
            if (pLscRetailSetup."File Extension Service URL" = '') then
                exit;
        end;
        //check if file exist
        if not pPostedLabelReqHeader.Get(pDocumentNo) then exit;

        //1. init windows service
        InitWindowService(pLscRetailSetup);

        //2. export file header
        ExportFileHeader(pPostedLabelReqHeader);

        //3. export label request 
        ExportLabelRequest(pPostedLabelReqHeader);

        //4. post to windows service
        PostToWindowsService(pPostedLabelReqHeader, pLscRetailSetup);

        pPostedLabelReqHeader."No. Of Times Printed" := pPostedLabelReqHeader."No. Of Times Printed" + 1;
        pPostedLabelReqHeader.Modify();
    end;

    internal procedure InitWindowService(pLscRetailSetup: Record "LSC Retail Setup" temporary)
    begin
        Clear(HttpClient);
        Clear(Httpcontent);
        Clear(HttpHeadersContent);
        Clear(tmpBlob);
        Clear(HttpRequestMessage);

        HttpClient.SetBaseAddress(pLscRetailSetup."File Extension Service URL");
        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri(HttpClient.GetBaseAddress + 'api/File/WriteFile');

        tmpBlob.CreateOutStream(OutStr, TextEncoding::UTF8);
        OutStr.WriteText('"');
    end;

    internal procedure ExportFileHeader(pPostedLabelReqHeader: Record "WP Posted Label Request Header" temporary)
    var
        headers: List of [Text];
        header: Text;
        headerRow: Text;
    begin
        exit;
        headerRow := '';

        headers.AddRange(
            //format for purchase order
            'Price Tag Identification',
            'Printer Destination',
            'Vendor Code',
            'Class Code',
            'Item Code',
            'Tran Condition Code',
            'SKU Code 1',
            'SKU Code 2',
            'Purchase Type',
            'Aging',
            'Part No.',
            'Color Code',
            'Size Code',
            'Unit Price',
            'Number Of Copies',
            'Tax Pattern',
            'Item Description',
            'Brand'
            );

        foreach header in headers do begin
            headerRow := AppendStr(headerRow, header);
        end;
        headerRow := headerRow + '\n';

        OutStr.WriteText(headerRow);

    end;

    internal procedure ExportLabelRequest(LabelReqHdr: Record "WP Posted Label Request Header" temporary)
    var
        QueryPostedLabelPrinting: Query "WP Posted Label Request";
        lineRow: Text;
        lbrand: Record "LSC Item Special Groups";
        ldesc: Text;
        lgenPostingGroup: Record "Gen. Product Posting Group";


    begin
        lineRow := '';
        QueryPostedLabelPrinting.SetRange(QueryPostedLabelPrinting.No_Filter, LabelReqHdr."No.");
        QueryPostedLabelPrinting.SetRange(QueryPostedLabelPrinting.Document_Type_Filter, LabelReqHdr."Document Type");
        QueryPostedLabelPrinting.SetRange(QueryPostedLabelPrinting.Original_Document_No_Filter, LabelReqHdr."Original Document No.");
        QueryPostedLabelPrinting.Open();
        while QueryPostedLabelPrinting.Read() do begin

            lineRow := CopyStr(Format(QueryPostedLabelPrinting.PriceTagType), 1, 1) + CopyStr(Format(QueryPostedLabelPrinting.PriceType), 1, 1) + CopyStr(Format(QueryPostedLabelPrinting.CodeType), 1, 1);//Format(QueryPostedLabelPrinting.PriceTagType);
            lineRow := AppendStr(lineRow, Format(QueryPostedLabelPrinting.PrinterNo));
            lineRow := AppendStr(lineRow, Format(QueryPostedLabelPrinting.Vendor_No_));
            lineRow := AppendStr(lineRow, '');
            lineRow := AppendStr(lineRow, QueryPostedLabelPrinting.Short_Item_No_);
            lineRow := AppendStr(lineRow, '');
            lineRow := AppendStr(lineRow, QueryPostedLabelPrinting.Barcode);
            lineRow := AppendStr(lineRow, '');

            //find gen prod posting group
            Clear(lgenPostingGroup);
            lgenPostingGroup.SetFilter(Code, QueryPostedLabelPrinting.Product_Posting_Group);
            if lgenPostingGroup.FindFirst() then begin
                lineRow := AppendStr(lineRow, lgenPostingGroup."Label Printing Purch. Type");
            end
            else begin
                lineRow := AppendStr(lineRow, '');
            end;

            // lineRow := AppendStr(lineRow, QueryPostedLabelPrinting.Product_Posting_Group);
            lineRow := AppendStr(lineRow, Format(QueryPostedLabelPrinting.LineAging));
            lineRow := AppendStr(lineRow, '');
            lineRow := AppendStr(lineRow, QueryPostedLabelPrinting.Color_Code);
            lineRow := AppendStr(lineRow, QueryPostedLabelPrinting.Size_Code);
            lineRow := AppendStr(lineRow, Format(QueryPostedLabelPrinting.Unit_Price, 0, '<Integer>'));
            lineRow := AppendStr(lineRow, Format(QueryPostedLabelPrinting.Quantity));
            lineRow := AppendStr(lineRow, '');

            //filter description
            ldesc := QueryPostedLabelPrinting.Description.Replace('\n', ' ');
            ldesc := ldesc.Replace(',', ' ');
            ldesc := ldesc.Replace('''', ' ');
            ldesc := ldesc.Replace('\', ' ');
            ldesc := ldesc.Replace(';', ' ');
            ldesc := ldesc.Replace('"', ' ');

            lineRow := AppendStr(lineRow, ldesc);
            // lineRow := AppendStr(lineRow, QueryPostedLabelPrinting.Description);

            //find brand
            Clear(lbrand);
            lbrand.SetFilter(Code, 'B*');

            if lbrand.FindFirst() then begin
                lineRow := AppendStr(lineRow, lbrand.Description);
            end
            else begin
                lineRow := AppendStr(lineRow, '');
            end;

            lineRow := lineRow + '\n';
            // lineRow := AppendStr(lineRow, '\n');


            OutStr.WriteText(lineRow);
        end;
        QueryPostedLabelPrinting.Close();
    end;

    internal procedure PostToWindowsService(pLabelReqHdr: Record "WP Posted Label Request Header" temporary; pLscRetailSetup: Record "LSC Retail Setup" temporary)
    var
        pDocType: Option "PO","TO","MD","LP","C";
    begin
        OutStr.WriteText('"');
        tmpBlob.CreateInStream(InStr, TextEncoding::UTF8);
        Httpcontent.WriteFrom(InStr);
        HttpContent.GetHeaders(HttpHeadersContent);
        if HttpHeadersContent.Contains('Content-Type') then
            HttpHeadersContent.Remove('Content-Type');

        fileName := pLabelReqHdr."File Name" + '.csv';

        pDocType := pLabelReqHdr."Document Type";
        if (pDocType = pdoctype::PO) or (pDocType = pDocType::"TO") then begin
            filePath := pLscRetailSetup."Purchase Order File Path";
        end
        else if (pDocType = pDocType::MD) then begin
            filePath := pLscRetailSetup."Markdown Entry File Path";
        end
        else if (pDocType = pDocType::LP) or (pDocType = pDocType::C) then begin
            filePath := pLscRetailSetup."Transfer Order File Path";
        end;

        HttpHeadersContent.Add('Content-Type', 'text/json');
        HttpHeadersContent.Add('directoryPath', filePath);
        HttpHeadersContent.Add('fileName', filename);

        HttpRequestMessage.Content := Httpcontent;
        HttpRequestMessage.Content.ReadAs(txtcontain);
        HttpClient.Send(HttpRequestMessage, HttpResponseMessage);

        if GuiAllowed then begin
            if HttpResponseMessage.HttpStatusCode = 200 then begin
                if GuiAllowed then Message('Export Complete.' + Format(filePath + fileName));
            end else begin
                if GuiAllowed then begin
                    Message(HttpResponseMessage.ReasonPhrase);
                    Error('%1', txtcontain);
                end;
            end;
        end;
    end;

    internal procedure AppendStr(currStr: Text; addStr: Text): Text
    begin
        if (currStr = '') then begin
            exit(addStr);
        end
        else begin
            exit(currStr + ',' + addStr);
        end;
    end;

}
