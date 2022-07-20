CREATE OR REPLACE PROCEDURE dfn_ntp.sp_db_function_approvals (
    p_view                OUT SYS_REFCURSOR,
    prows                 OUT NUMBER,
    p_institution_id   IN     NUMBER)
IS
BEGIN
    OPEN p_view FOR
        SELECT 'T04_DISABLE_EXCHANGE_ACC_REQ' AS approval_table,
               COUNT (*) AS approval_count
          FROM t04_disable_exchange_acc_req t04
         WHERE     t04.t04_is_approval_completed = 0
               AND t04.t04_institute_id_m02 = p_institution_id
        UNION
        SELECT 'T06_CASH_TRANSACTION' AS approval_table,
               COUNT (*) AS approval_count
          FROM t06_cash_transaction t06
         WHERE     t06.t06_code IN ('DEPOST', 'WITHDR', 'CSHTRN')
               AND t06.t06_status_id NOT IN (2, 3)
               AND t06.t06_institute_id_m02 = p_institution_id
        UNION
        SELECT 'T08_OD_WITHDRAW_LIMIT' AS approval_table,
               COUNT (*) AS approval_count
          FROM t08_od_withdraw_limit t08
         WHERE     t08.t08_is_approval_completed = 0
               AND t08.t08_institute_id_m02 = p_institution_id
        UNION
        SELECT 'T10_CASH_BLOCK_REQUEST' AS approval_table,
               COUNT (*) AS approval_count
          FROM t10_cash_block_request t10
         WHERE     t10.t10_is_approval_completed = 0
               AND t10.t10_institute_id_m02 = p_institution_id
        UNION
        SELECT 'T12_SHARE_TRANSACTION' AS approval_table,
               COUNT (*) AS approval_count
          FROM t12_share_transaction t12
         WHERE     t12.t12_status_id_v01 NOT IN (2, 3)
               AND t12.t12_inst_id_m02 = p_institution_id
        UNION
        SELECT 'T15_AUTHORIZATION_REQUEST' AS approval_table,
               COUNT (*) AS approval_count
          FROM t15_authorization_request t15, u07_trading_account u07
         WHERE     t15.t15_is_approval_completed = 0
               AND t15.t15_trading_account_id_u07 = u07.u07_id
               AND u07.u07_institute_id_m02 = p_institution_id
        UNION
        SELECT 'T17_TRADE_PROCESSING_REQUESTS' AS approval_table,
               COUNT (*) AS approval_count
          FROM t17_trade_processing_requests t17
         WHERE     t17.t17_status_id_v01 NOT IN (2, 3)
               AND t17.t17_institution_id_m02 = p_institution_id
        UNION
        SELECT 'T20_PENDING_PLEDGE' AS approval_table,
               COUNT (*) AS approval_count
          FROM t20_pending_pledge t20
         WHERE     t20.t20_status_id_v01 NOT IN (2, 3)
               AND t20.t20_institution_id = p_institution_id
        UNION
        SELECT 'T23_SHARE_TXN_REQUESTS' AS approval_table,
               COUNT (*) AS approval_count
          FROM t23_share_txn_requests t23, u07_trading_account u07
         WHERE     t23.t23_is_approval_completed = 0
               AND t23.t23_trading_acc_id_u07 = u07.u07_id
               AND u07.u07_institute_id_m02 = p_institution_id
        UNION
        SELECT 'T24_CUSTOMER_MARGIN_REQUEST' AS approval_table,
               COUNT (*) AS approval_count
          FROM t24_customer_margin_request t24
         WHERE     t24.t24_is_approval_completed = 0
               AND t24.t24_institute_id_m02 = p_institution_id
        UNION
        SELECT 'T44_PENDING_CUST_CA_ADJUST' AS approval_table,
               COUNT (*) AS approval_count
          FROM t44_pending_cust_ca_adjust t44
         WHERE     t44.t44_is_approval_completed = 0
               AND t44.t44_institute_id_m02 = p_institution_id;
END;
/