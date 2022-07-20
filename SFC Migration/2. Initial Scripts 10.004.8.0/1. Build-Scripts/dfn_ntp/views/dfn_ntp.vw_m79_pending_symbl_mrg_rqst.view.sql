CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m79_pending_symbl_mrg_rqst
(
    m79_id,
    m79_sym_margin_group,
    sym_margin_group_name,
    m79_symbol_id_m20,
    m79_symbol_code_m20,
    m79_institution_m02,
    institution_name,
    m79_mariginability,
    mariginability,
    m79_marginable_per,
    m79_status_id_v01,
    status_description,
    status_description_lang,
    m79_status_changed_by_id_u17,
    status_changed_by_full_name,
    m79_status_changed_date,
    m79_exchange_code_m01,
    m79_exchange_id_m01,
    update_source
)
AS
    SELECT m79.m79_id,
           m79.m79_sym_margin_group,
           m77.m77_name AS sym_margin_group_name,
           m79.m79_symbol_id_m20,
           m79.m79_symbol_code_m20,
           m79.m79_institution_m02,
           m02.m02_name AS institution_name,
           m79.m79_mariginability,
           CASE WHEN m79.m79_mariginability = 0 THEN 'No' ELSE 'Yes' END
               AS mariginability,
           m79.m79_marginable_per,
           m79.m79_status_id_v01,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           m79.m79_status_changed_by_id_u17,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           m79.m79_status_changed_date,
           m79.m79_exchange_code_m01,
           m79.m79_exchange_id_m01,
           CASE WHEN m79.m79_update_source = 1 THEN 'File' ELSE 'App' END
               AS update_source
      FROM m79_pending_symbl_mrg_request m79
           JOIN u17_employee u17_status_changed_by
               ON m79.m79_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           JOIN vw_status_list status_list
               ON m79.m79_status_id_v01 = status_list.v01_id
           JOIN m02_institute m02 ON m79.m79_institution_m02 = m02.m02_id
           JOIN m77_symbol_marginability_grps m77
               ON m79.m79_sym_margin_group = m77.m77_id
/