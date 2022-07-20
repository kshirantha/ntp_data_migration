CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m154_subscriptn_waveof_list
(
    m154_id,
    m154_name,
    m154_name_lang,
    m154_institution_id_m02,
    m154_created_by_id_u17,
    m154_created_date,
    m154_status_id_v01,
    m154_modified_by_id_u17,
    m154_modified_date,
    m154_status_changed_by_id_u17,
    m154_status_changed_date,
    m154_custom_type,
    created_by,
    modified_by,
    status_changed_by,
    status,
    m505_product_id_v35
)
AS
    SELECT a.m154_id,
           a.m154_name,
           a.m154_name_lang,
           a.m154_institution_id_m02,
           a.m154_created_by_id_u17,
           a.m154_created_date,
           a.m154_status_id_v01,
           a.m154_modified_by_id_u17,
           a.m154_modified_date,
           a.m154_status_changed_by_id_u17,
           a.m154_status_changed_date,
           a.m154_custom_type,
           u17.u17_full_name created_by,
           u17e.u17_full_name modified_by,
           u17s.u17_full_name status_changed_by,
           status_list.v01_description AS status,
           m505.m505_product_id_v35
      FROM m154_subscription_waiveoff_grp a
           JOIN u17_employee u17
               ON a.m154_created_by_id_u17 = u17.u17_id
           LEFT JOIN u17_employee u17e
               ON a.m154_modified_by_id_u17 = u17e.u17_id
           JOIN u17_employee u17s
               ON a.m154_status_changed_by_id_u17 = u17s.u17_id
           LEFT JOIN vw_status_list status_list
               ON m154_status_id_v01 = status_list.v01_id
           LEFT JOIN (  SELECT m505_waive_off_grp_id_m154,
                               fn_aggregate_list (m505_product_id_v35)
                                   AS m505_product_id_v35
                          FROM m505_product_wise_waiveoff_c
                      GROUP BY m505_waive_off_grp_id_m154) m505
               ON a.m154_id = m505.m505_waive_off_grp_id_m154
/
