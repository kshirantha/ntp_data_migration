CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_stock_block_request_list
(
    t67_id,
    t67_trading_account_id_u07,
    t67_qty_blocked,
    t67_from_date,
    t67_to_date,
    is_active,
    t67_reason_for_block,
    t67_status_id_v01,
    t67_delete_status_id_v01,
    t67_created_date,
    t67_created_by_id_u17,
    t67_last_updated_date,
    t67_last_updated_by_id_u17,
    t67_institute_id_m02,
    t67_symbol_id_m20,
    t67_symbol_code_m20,
    t67_exchange_code_m01,
    t67_custodian_id_m26,
    t67_current_approval_level,
    created_by_full_name,
    last_updated_by_full_name,
    u07_display_name,
    u07_display_name_u01,
    m20_short_description,
    status_description,
    delete_status_description
)
AS
    SELECT t67.t67_id,
           t67.t67_trading_account_id_u07,
           t67.t67_qty_blocked,
           t67.t67_from_date,
           t67.t67_to_date,
           CASE
               WHEN     t67.t67_from_date IS NOT NULL
                    AND t67.t67_to_date IS NOT NULL
                    AND t67.t67_from_date <= TRUNC (SYSDATE)
                    AND t67.t67_to_date >= TRUNC (SYSDATE)
                    AND t67.t67_status_id_v01 = 2
               THEN
                   'Yes'
               WHEN     t67.t67_from_date IS NULL
                    AND t67.t67_to_date IS NULL
                    AND t67.t67_status_id_v01 = 2
               THEN
                   'Yes'
               WHEN     t67.t67_from_date IS NOT NULL
                    AND t67.t67_to_date IS NULL
                    AND t67.t67_from_date <= TRUNC (SYSDATE)
                    AND t67.t67_status_id_v01 = 2
               THEN
                   'Yes'
               WHEN     t67.t67_from_date IS NULL
                    AND t67.t67_to_date IS NOT NULL
                    AND t67.t67_to_date >= TRUNC (SYSDATE)
                    AND t67.t67_status_id_v01 = 2
               THEN
                   'Yes'
               ELSE
                   'No'
           END
               AS is_active,
           t67.t67_reason_for_block,
           t67.t67_status_id_v01,
           t67.t67_delete_status_id_v01,
           t67.t67_created_date,
           t67.t67_created_by_id_u17,
           t67.t67_last_updated_date,
           t67.t67_last_updated_by_id_u17,
           t67.t67_institute_id_m02,
           t67.t67_symbol_id_m20,
           t67.t67_symbol_code_m20,
           t67.t67_exchange_code_m01,
           t67.t67_custodian_id_m26,
           t67.t67_current_approval_level,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_last_updated_by.u17_full_name AS last_updated_by_full_name,
           u07.u07_display_name,
           u07.u07_display_name_u01,
           m20.m20_short_description,
           status.v01_description AS status_description,
           delete_status.v01_description AS delete_status_description
      FROM t67_stock_block_request t67
           LEFT JOIN u17_employee u17_created_by
               ON t67.t67_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_last_updated_by
               ON t67.t67_last_updated_by_id_u17 = u17_last_updated_by.u17_id
           LEFT JOIN u07_trading_account u07
               ON t67.t67_trading_account_id_u07 = u07.u07_id
           JOIN m20_symbol m20 ON t67.t67_symbol_id_m20 = m20.m20_id
           LEFT JOIN v01_system_master_data status
               ON     t67.t67_status_id_v01 = status.v01_id
                  AND status.v01_type = 4
           LEFT JOIN v01_system_master_data delete_status
               ON     t67.t67_delete_status_id_v01 = delete_status.v01_id
                  AND delete_status.v01_type = 4
/