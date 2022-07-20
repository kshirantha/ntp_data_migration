CREATE OR REPLACE PROCEDURE dfn_ntp.sp_mtm_settlement_report (
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER,
    pcustomerid       IN     NUMBER DEFAULT NULL,
    psearchcriteria   IN     VARCHAR2 DEFAULT NULL,
    pdate             IN     DATE DEFAULT SYSDATE)
IS
    l_qry     VARCHAR2 (20000);
    l_pdate   VARCHAR2 (20000);
    s2        VARCHAR2 (15000);
BEGIN
    l_pdate :=
           ' to_date (
                                                                    '''
        || TO_CHAR (pdate, 'dd-mm-yyyy')
        || ''',
                                                                 ''dd-mm-yyyy'')
                                                         and   to_date (
                                                                      '''
        || TO_CHAR (pdate, 'dd-mm-yyyy')
        || ''',
                                                                   ''dd-mm-yyyy'')
                                                      + 0.99999';

    l_qry :=
           'SELECT t70_symbol_code_m20 AS symbol,
               t70_date AS vdate,
               description,
               orderno,
               t70_exchange_code_m01 AS exchange,
               t70_own_holdings AS qty,
               t70_trading_acc_id_u07 AS security_ac_id,
               fixing_price,
               previous_fixing_trade_price,
               u07_customer_id_u01 AS customer_id,
               u07_customer_no_u01 as m01_external_ref_no,
               u07_display_name_u01  AS custname,
               u07_exchange_account_no as u06_exchange_ac,
               nvl( u06.u06_investment_account_no, u06_display_name) as t03_external_reference
          FROM ( SELECT t70_symbol_code_m20,
                       t70_trading_acc_id_u07 ,
                       u07.u07_customer_id_u01,
                       u07_customer_no_u01,
                       u07.u07_cash_account_id_u06,
                       u07_exchange_account_no,
                       u07_display_name_u01,
                       t70_exchange_code_m01 ,
                       t70_date ,
                       CASE
                           WHEN t70_order_no IS NULL
                           THEN
                               ''Opening Position''
                           ELSE
                                  CASE
                                      WHEN t70_order_side = ''1'' THEN ''Buy to ''
                                      WHEN t70_order_side = ''2'' THEN ''Sell to ''
                                  END
                               || CASE
                                      WHEN t70_position_effect = ''O'' THEN ''Open''
                                      WHEN t70_position_effect = ''C'' THEN ''Close''
                                  END
                            END
                           description,
                       t70_order_no AS orderno,
                       t70_own_holdings ,
                       t70_m2m_gain_loss,
                       t70_vwap AS previous_fixing_trade_price,
                       t70_settle_price AS fixing_price
                  FROM t70_mark_to_market t70, u07_trading_account u07
                 WHERE t70.t70_trading_acc_id_u07 = u07.u07_id
                       AND t70.t70_date between '
        || l_pdate
        || CASE
               WHEN pcustomerid IS NOT NULL
               THEN
                   ' and u07.u07_customer_id_u01 = ' || pcustomerid
           END
        || '
               ) r,


              u06_cash_account u06
         WHERE     r.u07_cash_account_id_u06 = u06.u06_id
            '
        || CASE
               WHEN pcustomerid IS NOT NULL
               THEN
                   ' and r.u07_customer_id_u01 = ' || pcustomerid
           END;

    OPEN p_view FOR l_qry;
END;
/