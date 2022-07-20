CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_outstand_pledg_position (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;

    l_qry :=
        'SELECT u06.u06_display_name,
                   u01.u01_display_name,
                   u07.u07_display_name,
                   u24.u24_symbol_code_m20,
                   m20.m20_symbol_code,
                   m20.m20_short_description,
                   u24.u24_exchange_code_m01,
                   u24.u24_trading_acnt_id_u07,
                   (  u24.u24_net_holding
                    + u24.u24_payable_holding
                    - u24.u24_receivable_holding
                    - u24.u24_manual_block)
                       AS u24_net_holdings,
                     (  u24.u24_net_holding
                      + u24.u24_payable_holding
                      - u24.u24_receivable_holding
                      - u24.u24_manual_block)
                   - u24.u24_pledge_qty
                       AS available_qty,
                   (  u24.u24_receivable_holding
                    + u24.u24_manual_block
                    + u24.u24_pledge_qty)
                       AS block_qty,
                   t20.t20_qty,
                   t20.t20_remaining_qty,
                   t20.t20_last_changed_date,
                   t20.t20_narration,
                   t20_pledge_call_ac_no,
                   t20_transaction_number,
                   u01.u01_institute_id_m02,
                   CASE
                       WHEN t20.t20_send_to_exchange = 0 THEN ''Internal''
                       WHEN t20.t20_send_to_exchange = 1 THEN ''Exchange''
                   END
                       AS sent_to_exchange
              FROM u24_holdings u24
                   JOIN m20_symbol m20
                       ON u24.u24_symbol_id_m20 = m20.m20_id AND u24.u24_pledge_qty <> 0
                   JOIN u07_trading_account u07
                       ON u24.u24_trading_acnt_id_u07 = u07.u07_id
                   JOIN u06_cash_account u06 ON u07.u07_cash_account_id_u06 = u06.u06_id
                   JOIN u01_customer u01 ON u06.u06_customer_id_u01 = u01.u01_id
                   LEFT JOIN t20_pending_pledge t20
                       ON     t20_pledge_type = 8
                          AND t20_status_id_v01 = 2
                          AND t20_remaining_qty <> 0
                          AND u24.u24_trading_acnt_id_u07 = t20.t20_trading_acc_id_u07
                          AND u24.u24_exchange_code_m01 = t20.t20_exchange
                          AND u24.u24_symbol_code_m20 = t20.t20_symbol';


    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              psortby,
                              ptorownumber,
                              pfromrownumber);
    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/