CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_otc_trd_commission_list
(
    m169_id,
    m169_name,
    m169_additional_details,
    m169_sub_assest_type_id_v08,
    sub_assest_type,
    m169_currency_id_m03,
    m169_currency_code_m03,
    currency,
    m169_commission_percentage,
    m169_flat_commission,
    m169_minimum_commission,
    m169_vat,
    m169_status_id_v01,
    status,
    m169_created_by_id_u17,
    created_by,
    m169_created_date,
    m169_modified_by_id_u17,
    modified_by,
    m169_modified_date,
    m169_status_changed_by_id_u17,
    status_changed_by,
    m169_status_changed_date,
    m169_institute_id_m02
)
AS
    SELECT m169.m169_id,
           m169.m169_name,
           m169.m169_additional_details,
           m169.m169_sub_assest_type_id_v08,
           CASE
               WHEN m169.m169_sub_assest_type_id_v08 >= 0
               THEN
                   v08.v08_description
               WHEN m169.m169_sub_assest_type_id_v08 = -2
               THEN
                   'Money Market'
           END
               AS sub_assest_type,
           m169.m169_currency_id_m03,
           m169.m169_currency_code_m03,
           m03.m03_code AS currency,
           m169.m169_commission_percentage,
           m169.m169_flat_commission,
           m169.m169_minimum_commission,
           m169.m169_vat,
           m169.m169_status_id_v01,
           vw_status_list.v01_description AS status,
           m169.m169_created_by_id_u17,
           createdby.u17_full_name AS created_by,
           m169.m169_created_date,
           m169.m169_modified_by_id_u17,
           modifiedby.u17_full_name AS modified_by,
           m169.m169_modified_date,
           m169.m169_status_changed_by_id_u17,
           statuschangedby.u17_full_name AS status_changed_by,
           m169.m169_status_changed_date,
           m169.m169_institute_id_m02
      FROM m169_otc_trading_commission m169
           LEFT JOIN m03_currency m03
               ON m169.m169_currency_id_m03 = m03.m03_id
           LEFT JOIN vw_status_list
               ON m169.m169_status_id_v01 = vw_status_list.v01_id
           LEFT JOIN u17_employee createdby
               ON m169.m169_created_by_id_u17 = createdby.u17_id
           LEFT JOIN u17_employee modifiedby
               ON m169.m169_status_changed_by_id_u17 = modifiedby.u17_id
           LEFT JOIN u17_employee statuschangedby
               ON m169.m169_status_changed_by_id_u17 = statuschangedby.u17_id
           LEFT JOIN v08_sub_asset_type v08
               ON m169.m169_sub_assest_type_id_v08 = v08.v08_id
/
