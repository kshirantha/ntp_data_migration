CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_ex_clearing_account
(
    m86_id,
    m86_account_type,
    m86_account_number,
    m86_is_default,
    m86_institute_id_m02,
    m86_exchange_code_m01,
    m86_exchange_id_m01,
    m86_status_id_v01,
    status,
    is_default,
    created_by_full_name,
    m86_created_by_id_u17,
    m86_created_date,
    modified_by_full_name,
    m86_modified_by_id_u17,
    m86_modified_date,
    status_changed_by_full_name,
    m86_status_changed_date
)
AS
    (SELECT m86_id,
            m86_account_type,
            m86_account_number,
            m86_is_default,
            m86_institute_id_m02,
            m86_exchange_code_m01,
            m86_exchange_id_m01,
            m86_status_id_v01,
            status_list.v01_description AS status,
            CASE m86.m86_is_default WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
                AS is_default,
            u17_created_by.u17_full_name AS created_by_full_name,
            m86_created_by_id_u17,
            m86.m86_created_date,
            u17_modified_by.u17_full_name AS modified_by_full_name,
            m86_modified_by_id_u17,
            m86.m86_modified_date,
            u17_status_changed_by.u17_full_name
                AS status_changed_by_full_name,
            m86.m86_status_changed_date
       FROM m86_ex_clearing_accounts m86
            LEFT JOIN u17_employee u17_created_by
                ON m86.m86_created_by_id_u17 = u17_created_by.u17_id
            LEFT JOIN u17_employee u17_modified_by
                ON m86.m86_modified_by_id_u17 = u17_modified_by.u17_id
            LEFT JOIN u17_employee u17_status_changed_by
                ON m86.m86_status_changed_by_id_u17 =
                       u17_status_changed_by.u17_id
            LEFT JOIN vw_status_list status_list
                ON m86.m86_status_id_v01 = status_list.v01_id)
/