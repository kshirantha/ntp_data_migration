CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t08_od_withdr_limit_rqsts
(
    t08_id,
    t08_cash_account_id_u06,
    t08_primary_od_limit,
    t08_primary_start,
    t08_primary_expiry,
    t08_secondary_od_limit,
    t08_secondary_start,
    t08_secondary_expiry,
    t08_no_of_approval,
    t08_is_approval_completed,
    t08_current_approval_level,
    t08_next_status,
    t08_created_date,
    t08_last_updated_date,
    t08_status_id_v01,
    t08_comment,
    t08_created_by_id_u17,
    t08_last_updated_by_id_u17,
    u06_display_name_u01,
    u06_customer_id_u01,
    u06_institute_id_m02,
    status_description,
    status_description_lang,
    cash_account_name,
    customer_no,
    created_by_full_name,
    modified_by_full_name,
    external_ref_no,
    investment_account_no,
    currency,
    current_primary_od_limit,
    current_secondary_od_limit,
    current_primary_start,
    current_primary_expiry,
    current_secondary_start,
    current_secondary_expiry,
    current_daily_withdraw_limit
)
AS
    SELECT t08_id,
           t08_cash_account_id_u06,
           t08_primary_od_limit,
           t08_primary_start,
           t08_primary_expiry,
           t08_secondary_od_limit,
           t08_secondary_start,
           t08_secondary_expiry,
           t08_no_of_approval,
           t08_is_approval_completed,
           t08_current_approval_level,
           t08_next_status,
           t08_created_date,
           t08_last_updated_date,
           t08_status_id_v01,
           t08_comment,
           t08_created_by_id_u17,
           t08_last_updated_by_id_u17,
           u06.u06_display_name_u01,
           u06.u06_customer_id_u01,
           u06.u06_institute_id_m02,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           u06.u06_display_name AS cash_account_name,
           u06.u06_customer_no_u01 AS customer_no,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           u06.u06_external_ref_no AS external_ref_no,
           u06.u06_investment_account_no AS investment_account_no,
           u06.u06_currency_code_m03 AS currency,
           u06.u06_primary_od_limit AS current_primary_od_limit,
           u06.u06_secondary_od_limit AS current_secondary_od_limit,
           u06.u06_primary_start AS current_primary_start,
           u06.u06_primary_expiry AS current_primary_expiry,
           u06.u06_secondary_start AS current_secondary_start,
           u06.u06_secondary_expiry AS current_secondary_expiry,
           m177.m177_cash_transfer_limit AS current_daily_withdraw_limit
      FROM t08_od_withdraw_limit t08
           JOIN u06_cash_account u06
               ON t08.t08_cash_account_id_u06 = u06.u06_id
           LEFT JOIN u17_employee u17_created_by
               ON t08.t08_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON t08.t08_last_updated_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON t08.t08_status_id_v01 = status_list.v01_id
           LEFT JOIN m177_cash_transfer_limit_group m177
               ON u06.u06_transfer_limit_grp_id_m177 = m177.m177_id
/