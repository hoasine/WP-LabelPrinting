namespace LabelPrinting.LabelPrinting;
using Microsoft.Inventory.Transfer;
using Microsoft.Foundation.NoSeries;

page 59100 "WP Label Request"
{
    ApplicationArea = All;
    Caption = 'WP Label Request';
    PageType = Card;
    SourceTable = "WP Label Request Header";
    PromotedActionCategories = 'New,Process,Report,Navigation';
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = isEditable;

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
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = All;
                    Editable = (Rec."Document Type" = Rec."Document Type"::MD);
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
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
                    Visible = false;
                }

            }
            group(Lines)
            {
                //Caption = 'Lines';
                part(labellines; "WP Label Request Subform")
                {
                    Editable = isEditable;
                    SubPageLink = "Document No." = field("No.");
                    UpdatePropagation = Both;

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Release")
            {
                Image = ReleaseDoc;
                Promoted = true;
                ApplicationArea = All;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = (rec.Status = rec.Status::Open);

                trigger OnAction()
                begin
                    DoRelease();
                end;
            }
            action("Reopen")
            {
                Image = ReOpen;
                Promoted = true;
                ApplicationArea = All;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = (rec.status = rec.status::Released);

                trigger OnAction()
                begin
                    DoReopen();
                end;
            }
            action("Post")
            {
                Image = Post;
                Promoted = true;
                ApplicationArea = All;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = (rec.Status = rec.Status::Released);

                trigger OnAction()
                var
                    CodePostedLabelReq: Codeunit "Label Request Export";
                    documentNo: Text;
                begin
                    documentNo := rec."No.";
                    DoPostedLabelRequest();

                    //get posted record header
                    CodePostedLabelReq.ExportDocumentByOriDoc(documentNo);
                end;
            }
        }
    }

    var
        NoSeriesMgt: Codeunit "No. Series";
        isEditable: Boolean;
        isMD: Boolean;

    // local procedure initDocType()
    // begin
    //     case rec."Document Type" of
    //         rec."Document type"::MD:
    //             begin
    //                 rec."Code Type" := rec."Code Type"::"1";
    //             end;
    //         rec."Document Type"::PO:
    //             begin
    //                 rec."Code Type" := rec."Code Type"::"1";
    //                 Clear(rec."Effective Date");
    //             end;
    //         rec."Document Type"::"TO":
    //             begin
    //                 rec."Code Type" := rec."Code Type"::"1";
    //                 Clear(rec."Effective Date");
    //             end;
    //         rec."Document Type"::C:
    //             begin
    //                 rec."Code Type" := rec."Code Type"::"2";
    //                 Clear(rec."Effective Date");
    //             end;
    //         else begin
    //             Clear(rec."Effective Date");
    //         end;
    //     end;
    // end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        lrequestHeader: Record "WP Label Request Header";
    begin
        isEditable := true;
        rec."Document Type" := rec."Document Type"::PO;
        rec."Code Type" := rec."Code Type"::"1";
        rec."Document Date" := System.WorkDate;
        rec."Original Order Type" := rec."Original Order Type"::"Purchase Order";
        rec."Effective Date" := System.WorkDate;
    end;

    trigger OnAfterGetRecord()
    begin
        if rec.Status = rec.Status::Released then
            isEditable := false
        else
            isEditable := true
    end;

    local procedure DoReopen()
    begin
        rec.TestField(Status, rec.Status::Released);
        rec.Status := rec.Status::Open;
        isEditable := true;
        rec.Modify();
        CurrPage.Update(false);
    end;

    local procedure DoRelease()
    var
        lines: Record "WP Label Request Lines";
        errorMsg: TextConst ENU = 'Youre not allowed to release document without lines.\n do you want to delete the current document %1 ?';
        errorCancelled: TextConst ENU = 'Release action cancelled.';
    begin
        lines.Reset();
        lines.SetRange("Document No.", rec."No.");
        if lines.Count = 0 then begin
            if Confirm(StrSubstNo(errorMsg, rec."No.")) = true then begin
                rec.Delete();
                CurrPage.Update(false);
                exit;
            end else begin
                error(errorCancelled);
                exit;
            end;
        end;
        rec.Status := rec.status::Released;
        isEditable := false;
        rec.Modify();
        CurrPage.Update(false);
    end;

    local procedure GetPostedNoSeriesCode(): Code[20]
    var
        RetailSetup: Record "LSC Retail Setup";
    begin
        RetailSetup.Reset();
        if RetailSetup.Get() then
            RetailSetup.TestField("Posted Label Req. Nos.");
        exit(RetailSetup."Posted Label Req. Nos.");
    end;

    local procedure DoPostedLabelRequest()
    var
        curRecord: Record "WP Label Request Header";
        documentNo: Text;
        // printerNo: Text;
        postingDate: Date;
        postingTime: Time;
    begin
        curRecord := Rec;
        documentNo := rec."No.";
        // printerNo := Format(rec."Printer No.");
        postingDate := Today;
        postingTime := Time;
        DoPostedLabelRequestHeader(curRecord, postingDate, postingTime);
    end;

    local procedure DoPostedLabelRequestHeader(lrec: Record "WP Label Request Header"; lpostingDate: Date; lpostingTime: Time): Record "WP Label Request Header"
    var
        srcTable: Record "WP Label Request Header";
        destTable: Record "WP Posted Label Request Header";
        printerNo: Text;
        textLength: Integer;
        newDocNo: Text;
        fileDocType: Text;
    begin
        Clear(srcTable);
        srcTable.SetRange("No.", lrec."No.");
        if srcTable.FindSet() then begin
            repeat begin
                newDocNo := NoSeriesMgt.GetNextNo(GetPostedNoSeriesCode());
                printerNo := Format(srcTable."Printer No.");
                textLength := StrLen(printerNo);
                Clear(destTable);
                destTable.Init();
                destTable.TransferFields(srcTable);
                destTable."Effective Date" := srcTable."Effective Date";
                destTable."Original Document No." := srcTable."No.";
                destTable."No." := newDocNo;
                destTable."Posting Date" := Today;
                destTable."Posting Time" := Time;
                destTable."Posted By" := UserId;

                case lrec."Document Type" of
                    destTable."Document Type"::PO, destTable."Document Type"::"TO":
                        fileDocType := 'PO';
                    destTable."Document Type"::MD:
                        fileDocType := 'MD';
                    destTable."Document Type"::LP, destTable."Document Type"::C:
                        fileDocType := 'LP';
                end;

                destTable."File Name" := CopyStr(printerNo, textLength - 1, 2) + '_' + CopyStr(Format(srcTable."Price Tag Type"), 1, 1) + CopyStr(Format(srcTable."Price Type"), 1, 1) + CopyStr(Format(srcTable."Code Type"), 1, 1) + '_' + fileDocType + '_' + destTable."No.";
                if destTable.Insert() then begin
                    DoPostedLabelRequestLines(srcTable, lpostingDate, lpostingTime, newDocNo);
                end;
            end until srcTable.Next() = 0;
            srcTable.DeleteAll();
        end;
    end;

    local procedure DoPostedLabelRequestLines(lrec: Record "WP Label Request Header"; postingDate: Date; postingTime: Time; documentNo: Text)
    var
        srcTable: Record "WP Label Request Lines";
        destTable: Record "WP Posted Label Request Lines";
    begin
        Clear(srcTable);
        srcTable.SetRange("Document No.", lrec."No.");
        if srcTable.FindSet() then begin
            repeat begin
                Clear(destTable);
                destTable.Init();
                destTable.TransferFields(srcTable);
                destTable."Document No." := documentNo;
                destTable."Original Document No." := srcTable."Document No.";
                destTable."Posting Date" := postingDate;
                destTable."Posting Time" := postingTime;
                destTable.Insert();
            end until srcTable.Next() = 0;
            srcTable.DeleteAll();
        end;
    end;



}
