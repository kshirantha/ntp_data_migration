CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_symbol_marginability_groups
(
    m77_id,
    m77_name,
    m77_additional_details,
    m77_global_marginable_per,
    m77_category_percentage_a,
    m77_category_percentage_b,
    m77_category_percentage_c,
    m77_category_percentage_d,
    m77_category_percentage_e,
    m77_category_percentage_f,
    m77_status_id_v01,
    m77_status_changed_by_id_u17,
    status_changed_by,
    m77_status_changed_date,
    m77_created_by_id_u17,
    created_by,
    m77_created_date,
    m77_last_updated_by_id_u17,
    last_modified_by,
    m77_last_updated_date,
    m77_institution_m02,
    m77_allow_online_cash_out,
    allow_online_cash_out,
    approval_status,
    m77_is_default,
    is_default,
    m77_mrg_call_notify_lvl,
    m77_mrg_call_remind_lvl,
    m77_mrg_call_liquid_lvl
)
AS
    SELECT m77.m77_id,
           m77.m77_name,
           m77.m77_additional_details,
           m77.m77_global_marginable_per,
           m77.m77_category_percentage_a,
           m77.m77_category_percentage_b,
           m77.m77_category_percentage_c,
           m77.m77_category_percentage_d,
           m77.m77_category_percentage_e,
           m77.m77_category_percentage_f,
           m77.m77_status_id_v01,
           m77.m77_status_changed_by_id_u17,
           u17_created.u17_full_name AS status_changed_by,
           m77.m77_status_changed_date,
           m77.m77_created_by_id_u17,
           u17_created.u17_full_name AS created_by,
           m77.m77_created_date,
           m77.m77_last_updated_by_id_u17,
           u17_modified.u17_full_name AS last_modified_by,
           m77.m77_last_updated_date,
           m77.m77_institution_m02,
           m77.m77_allow_online_cash_out,
           CASE
               WHEN m77.m77_allow_online_cash_out = 0 THEN 'No'
               ELSE 'Yes'
           END
               AS allow_online_cash_out,
           NVL (status.v01_description, '') AS approval_status,
           m77.m77_is_default,
           DECODE (m77_is_default, 1, 'Yes', 'No') AS is_default,
           m77.m77_mrg_call_notify_lvl,
           m77.m77_mrg_call_remind_lvl,
           m77.m77_mrg_call_liquid_lvl
      FROM m77_symbol_marginability_grps m77,
           u17_employee u17_created,
           u17_employee u17_modified,
           u17_employee u17_sts_chngd_by,
           vw_status_list status
     WHERE     m77.m77_created_by_id_u17 = u17_created.u17_id
           AND m77.m77_last_updated_by_id_u17 = u17_modified.u17_id(+)
           AND m77.m77_status_changed_by_id_u17 = u17_sts_chngd_by.u17_id(+)
           AND m77.m77_status_id_v01 = status.v01_id
/