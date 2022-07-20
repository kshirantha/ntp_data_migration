CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_custody_execb_cash_account
(
    m185_id,
    m185_institute_id_m02,
    m185_accountno,
    m185_custody_execbroker_id_m26,
    m185_balance,
    m185_currency_code_m03,
    m185_currency_id_m03,
    m185_created_by_id_u17,
    m185_created_date,
    m185_lastupdated_by_id_u17,
    m185_lastupdated_date,
    m185_status_id_v01,
    m185_status_changed_by_id_u17,
    m185_status_changed_date,
    m185_custom_type,
    created_by_full_name,
    last_updated_by_full_name,
    status,
    status_changed_by_full_name
)
AS
    SELECT a.m185_id,
           a.m185_institute_id_m02,
           a.m185_accountno,
           a.m185_custody_execbroker_id_m26,
           a.m185_balance,
           a.m185_currency_code_m03,
           a.m185_currency_id_m03,
           a.m185_created_by_id_u17,
           a.m185_created_date,
           a.m185_lastupdated_by_id_u17,
           a.m185_lastupdated_date,
           a.m185_status_id_v01,
           a.m185_status_changed_by_id_u17,
           a.m185_status_changed_date,
           a.m185_custom_type,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_last_updated_by.u17_full_name AS last_updated_by_full_name,
           status_list.v01_description AS status,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name
      FROM m185_custody_excb_cash_account a
           LEFT JOIN u17_employee u17_created_by
               ON a.m185_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_last_updated_by
               ON a.m185_lastupdated_by_id_u17 = u17_last_updated_by.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON a.m185_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON a.m185_status_id_v01 = status_list.v01_id
/