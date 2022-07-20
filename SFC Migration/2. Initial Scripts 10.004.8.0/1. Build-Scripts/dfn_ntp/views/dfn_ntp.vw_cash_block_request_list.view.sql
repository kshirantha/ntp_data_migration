CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_cash_block_request_list
(
    t10_id,
    t10_cash_account_id_u06,
    t10_amount_blocked,
    t10_from_date,
    t10_to_date,
    is_active,
    t10_reason_for_block,
    t10_type,
    t10_no_of_approval,
    t10_is_approval_completed,
    t10_current_approval_level,
    t10_next_status,
    t10_status,
    t10_delete_status,
    t10_created_date,
    t10_created_by,
    created_by_full_name,
    t10_last_updated_date,
    t10_last_updated_by,
    t10_institute_id_m02,
    last_updated_by_full_name,
    u06_display_name,
    u06_investment_account_no,
    u06_external_ref_no,
    u06_customer_no_u01,
    u06_display_name_u01,
    u06_default_id_no_u01,
    status_description,
    delete_status_description
)
AS
    (SELECT t10.t10_id,
            t10.t10_cash_account_id_u06,
            t10.t10_amount_blocked,
            t10.t10_from_date,
            t10.t10_to_date,
            CASE
                WHEN     t10.t10_from_date <= TRUNC (SYSDATE)
                     AND t10.t10_to_date >= TRUNC (SYSDATE)
                THEN
                    'Yes'
                ELSE
                    'No'
            END
                AS is_active,
            t10.t10_reason_for_block,
            t10.t10_type,
            t10.t10_no_of_approval,
            t10.t10_is_approval_completed,
            t10.t10_current_approval_level,
            t10.t10_next_status,
            t10.t10_status,
            t10.t10_delete_status,
            t10.t10_created_date,
            t10.t10_created_by,
            u17_created_by.u17_full_name AS created_by_full_name,
            t10.t10_last_updated_date,
            t10.t10_last_updated_by,
            t10.t10_institute_id_m02,
            u17_last_updated_by.u17_full_name AS last_updated_by_full_name,
            u06.u06_display_name,
            u06.u06_investment_account_no,
            u06.u06_external_ref_no,
            u06.u06_customer_no_u01,
            u06.u06_display_name_u01,
            u06.u06_default_id_no_u01,
            status.v01_description AS status_description,
            delete_status.v01_description AS delete_status_description
       FROM t10_cash_block_request t10
            LEFT JOIN u06_cash_account u06
                ON t10.t10_cash_account_id_u06 = u06.u06_id
            LEFT JOIN u17_employee u17_created_by
                ON t10.t10_created_by = u17_created_by.u17_id
            LEFT JOIN u17_employee u17_last_updated_by
                ON t10.t10_last_updated_by = u17_last_updated_by.u17_id
            LEFT JOIN v01_system_master_data status
                ON t10.t10_status = status.v01_id AND status.v01_type = 4
            LEFT JOIN v01_system_master_data delete_status
                ON     t10.t10_delete_status = delete_status.v01_id
                   AND delete_status.v01_type = 4);
/
