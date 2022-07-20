CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m78_symbol_marginability
(
    m78_id,
    m78_symbol_id_m20,
    m78_symbol_code_m20,
    m78_institution_id_m02,
    m78_mariginability,
    mariginability,
    m78_marginable_per,
    m78_sym_margin_group_m77,
    m78_status_id_v01,
    status_description,
    status_description_lang,
    m78_status_changed_date,
    m78_status_changed_by_id_u17,
    status_changed_by_full_name,
    m78_created_date,
    m78_created_by_id_u17,
    created_by_full_name,
    m78_last_updated_date,
    m78_last_updated_by_id_u17,
    last_updated_by_full_name,
    m78_exchange_code_m01,
    m20_short_description
)
AS
    SELECT m78.m78_id,
           m78.m78_symbol_id_m20,
           m78.m78_symbol_code_m20,
           m78.m78_institution_id_m02,
           m78.m78_mariginability,
           CASE WHEN m78.m78_mariginability = 0 THEN 'No' ELSE 'Yes' END
               AS mariginability,
           m78.m78_marginable_per,
           m78.m78_sym_margin_group_m77,
           m78.m78_status_id_v01,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           m78.m78_status_changed_date,
           m78.m78_status_changed_by_id_u17,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           m78.m78_created_date,
           m78.m78_created_by_id_u17,
           u17_created_by.u17_full_name AS created_by_full_name,
           m78.m78_last_updated_date,
           m78.m78_last_updated_by_id_u17,
           u17_last_updated_by.u17_full_name AS last_updated_by_full_name,
           m20.m20_exchange_code_m01 AS m78_exchange_code_m01,
           m20.m20_short_description
      FROM m78_symbol_marginability m78
           JOIN u17_employee u17_created_by
               ON m78.m78_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_last_updated_by
               ON m78.m78_last_updated_by_id_u17 = u17_last_updated_by.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON m78.m78_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON m78.m78_status_id_v01 = status_list.v01_id
           JOIN m20_symbol m20
               ON m78.m78_symbol_id_m20 = m20.m20_id
/