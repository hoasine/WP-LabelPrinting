namespace LabelPrinting.LabelPrinting;

using System.DataAdministration;

codeunit 59101 DataRententionUtils
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        StartInstall();
    end;

    internal procedure StartInstall()
    var
        RetenPolAllowedTables: Codeunit "Reten. Pol. Allowed Tables";
        MandatoryMinimumRetentionDays: Integer;
        TableFilters: JsonArray;
        tPostedLabelReqHdr: Record "WP Posted Label Request Header";
        tPostedLabelReqLines: Record "WP Posted Label Request Lines";
    begin
        MandatoryMinimumRetentionDays := 30;
        RetenPolAllowedTables.AddAllowedTable(Database::"WP Posted Label Request Header", tPostedLabelReqHdr.FieldNo(SystemCreatedAt),
                                                MandatoryMinimumRetentionDays, "Reten. Pol. Filtering"::Default, "Reten. Pol. Deleting"::Default, TableFilters);

        RetenPolAllowedTables.AddAllowedTable(Database::"WP Posted Label Request Lines", tPostedLabelReqLines.FieldNo(SystemCreatedAt),
                                                MandatoryMinimumRetentionDays, "Reten. Pol. Filtering"::Default, "Reten. Pol. Deleting"::Default, TableFilters);
    end;
}
