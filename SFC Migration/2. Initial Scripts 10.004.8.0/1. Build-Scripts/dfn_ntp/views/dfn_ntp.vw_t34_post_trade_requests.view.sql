CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t34_post_trade_requests
(
    t34_id,
    t34_narration,
    t34_action,
    t34_action_desc,
    t34_rollback,
    t34_type,
    t34_symbol,
    t34_exchange,
    t34_no_of_approvals,
    t34_current_approval_level,
    t34_final_approval,
    t34_inst_id_m02,
    created_by_full_name,
    t34_created_by_u17,
    t34_created_date,
    t34_status_id_v01,
    status_description,
    m20_instrument_type_code_v09
)
AS
    SELECT t34.t34_id,
           t34.t34_narration,
           t34.t34_action,
           CASE
               WHEN t34_action = 1 THEN 'Merge & Allocate'
               WHEN t34_action = 2 THEN 'Split'
               WHEN t34_action = 3 THEN 'Merge'
           END
               t34_action_desc,
           t34.t34_rollback,
           CASE
               WHEN t34.t34_rollback = 1 THEN 'Rollback'
               WHEN t34.t34_rollback = 2 THEN 'Allocation'
               ELSE ''
           END
               t34_type,
           t34_symbol,
           t34_exchange,
           t34.t34_no_of_approvals,
           t34.t34_current_approval_level,
           t34.t34_final_approval,
           t34.t34_inst_id_m02,
           u17_created_by.u17_full_name AS created_by_full_name,
           t34.t34_created_by_u17,
           t34.t34_created_date,
           t34.t34_status_id_v01,
           status.v01_description AS status_description,
           m20.m20_instrument_type_code_v09
      FROM t34_post_trade_requests t34
           LEFT JOIN u17_employee u17_created_by
               ON t34.t34_created_by_u17 = u17_created_by.u17_id
           LEFT JOIN v01_system_master_data status
               ON     t34.t34_status_id_v01 = status.v01_id
                  AND status.v01_type = 4
           INNER JOIN m20_symbol m20
               ON     t34.t34_symbol = m20.m20_symbol_code
                  AND t34.t34_exchange = m20.m20_exchange_code_m01
                  AND t34.t34_inst_id_m02 = m20.m20_institute_id_m02
/