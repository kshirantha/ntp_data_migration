CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m170_institute_cash_account
(
    m170_id,
    m170_institute_id_m02,
    m170_currency_id_m03,
    m170_currency_code_m03,
    m170_cash_account_id_u06,
    m170_status_id_v01,
    m170_created_by_id_u17,
    m170_created_date,
    m170_modified_by_id_u17,
    m170_modified_date,
    m170_status_changed_by_id_u17,
    m170_status_changed_date,
    customer_display_name,
    cash_account_display_name,
    created_by_name,
    status,
    modified_by_name,
    status_changed_by_name
)
AS
    (SELECT m170_id,
            m170_institute_id_m02,
            m170_currency_id_m03,
            m170_currency_code_m03,
            m170_cash_account_id_u06,
            m170.m170_status_id_v01,
            m170.m170_created_by_id_u17,
            m170.m170_created_date,
            m170.m170_modified_by_id_u17,
            m170.m170_modified_date,
            m170.m170_status_changed_by_id_u17,
            m170.m170_status_changed_date,
            u06.u06_display_name_u01 AS customer_display_name,
            u06.u06_display_name AS cash_account_display_name,
            created_by.u17_full_name AS created_by_name,
            status.v01_description AS status,
            modified_by.u17_full_name AS modified_by_name,
            status_changed_by.u17_full_name AS status_changed_by_name
       FROM m170_institute_cash_acc_config m170
            INNER JOIN u06_cash_account u06
                ON m170.m170_cash_account_id_u06 = u06.u06_id
            INNER JOIN u17_employee created_by
                ON m170.m170_created_by_id_u17 = created_by.u17_id
            LEFT JOIN u17_employee modified_by
                ON m170.m170_modified_by_id_u17 = modified_by.u17_id
            LEFT JOIN u17_employee status_changed_by
                ON m170.m170_status_changed_by_id_u17 =
                       status_changed_by.u17_id
            LEFT JOIN vw_status_list status
                ON m170.m170_status_id_v01 = status.v01_id)
/
