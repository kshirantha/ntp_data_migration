CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_holding_summary (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2,
    pfromrownumber        NUMBER,
    ptorownumber          NUMBER,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE,
    ptodate               DATE)
IS
    l_qry   VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT
    h01.h01_date, u07.u07_customer_id_u01, u01.u01_customer_no, u01.u01_display_name, u01.u01_display_name_lang, h01.h01_exchange_code_m01,
    h01.h01_symbol_code_m20, m20.m20_short_description, m20.m20_long_description, m20.m20_long_description_lang,
    m20.m20_short_description_lang,v09.v09_description AS v09_inst_type,
    u07.u07_exchange_account_no, u07.u07_display_name,
    (h01.h01_net_holding + h01.h01_payable_holding - h01.h01_receivable_holding) AS h01_net_holding,
    h01.h01_avg_cost, h01.h01_vwap, h01.h01_sell_pending, h01.h01_buy_pending,
    ((h01.h01_net_holding + h01.h01_payable_holding - h01.h01_receivable_holding) * m20.m20_lasttradeprice * m20.m20_lot_size * m20.m20_price_ratio)AS total_value,
    ((h01.h01_net_holding + h01.h01_payable_holding - h01.h01_receivable_holding)
        - h01.h01_sell_pending
        - h01.h01_pledge_qty) AS available_qty
FROM
    vw_h01_holding_summary h01,
    m20_symbol m20,
    u07_trading_account u07,
    u01_customer u01,
    v09_instrument_types v09
WHERE   h01.h01_date BETWEEN
    TO_DATE('''
        || TO_CHAR (pfromdate, ' DD - MM - YYYY ')
        || ''', '' DD - MM - YYYY '') AND
    TO_DATE('''
        || TO_CHAR (ptodate, ' DD - MM - YYYY ')
        || ''', '' DD - MM - YYYY '') + 0.99999 AND
        h01.h01_symbol_id_m20 = m20.m20_id AND
        h01.h01_trading_acnt_id_u07 = u07.u07_id AND
        u07.u07_customer_id_u01 = u01.u01_id AND
        h01.h01_price_inst_type = v09.v09_id(+)';

    IF (pfromrownumber = 1)
    THEN
        EXECUTE IMMEDIATE
               'SELECT COUNT ( * ) FROM ('
            || l_qry
            || ')'
            || CASE
                   WHEN psearchcriteria IS NOT NULL
                   THEN
                       ' WHERE ' || psearchcriteria
                   ELSE
                       ''
               END
            INTO prows;
    ELSE
        prows := -2;
    END IF;

    OPEN p_view FOR
           'SELECT t2.* FROM (SELECT t1.*, ROWNUM rnum FROM (SELECT t3.* '
        || CASE
               WHEN psortby IS NOT NULL
               THEN
                   ', ROW_NUMBER() OVER(ORDER BY ' || psortby || ') runm'
               ELSE
                   ''
           END
        || ' FROM ('
        || l_qry
        || ') t3'
        || CASE
               WHEN psearchcriteria IS NOT NULL
               THEN
                   ' WHERE ' || psearchcriteria
               ELSE
                   ''
           END
        || ') t1 WHERE ROWNUM <= '
        || ptorownumber
        || ') t2 WHERE RNUM >= '
        || pfromrownumber;
END;
/
/
