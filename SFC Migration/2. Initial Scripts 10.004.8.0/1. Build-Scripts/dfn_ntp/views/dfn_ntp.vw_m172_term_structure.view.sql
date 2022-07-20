CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m172_term_structure
(
    m172_id,
    m172_bond_issue_config_id_m171,
    m172_coupon_no,
    m172_coupon_start_date,
    m172_no_of_days,
    m172_end_date,
    m172_principal_amount,
    m172_interest_pct,
    m172_daily_interest_amnt,
    m172_interest_amount,
    m172_principal_redemption,
    m172_remaining_principal,
    m172_institute_id_m02,
    m172_status_id_v01,
    m172_created_by_id_u17,
    m172_created_date,
    m172_modified_by_id_u17,
    m172_modified_date,
    m172_status_changed_by_id_u17,
    m172_status_changed_date,
    m172_custom_type,
    created_by_name,
    modified_by_name,
    status_changed_by_name,
    status
)
AS
    SELECT a.m172_id,
           a.m172_bond_issue_config_id_m171,
           a.m172_coupon_no,
           a.m172_coupon_start_date,
           a.m172_no_of_days,
           a.m172_end_date,
           a.m172_principal_amount,
           a.m172_interest_pct,
           a.m172_daily_interest_amnt,
           a.m172_interest_amount,
           a.m172_principal_redemption,
           a.m172_remaining_principal,
           a.m172_institute_id_m02,
           a.m172_status_id_v01,
           a.m172_created_by_id_u17,
           a.m172_created_date,
           a.m172_modified_by_id_u17,
           a.m172_modified_date,
           a.m172_status_changed_by_id_u17,
           a.m172_status_changed_date,
           a.m172_custom_type,
           u17_created.u17_full_name AS created_by_name,
           u17_modified.u17_full_name AS modified_by_name,
           u17_status_changed.u17_full_name AS status_changed_by_name,
           status_list.v01_description AS status
      FROM m172_bond_issue_term_structure a,
           vw_status_list status_list,
           u17_employee u17_created,
           u17_employee u17_modified,
           u17_employee u17_status_changed
     WHERE     a.m172_status_id_v01 = status_list.v01_id(+)
           AND a.m172_created_by_id_u17 = u17_created.u17_id(+)
           AND a.m172_modified_by_id_u17 = u17_modified.u17_id(+)
           AND a.m172_status_changed_by_id_u17 = u17_status_changed.u17_id(+)
/