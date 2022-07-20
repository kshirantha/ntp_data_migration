CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_bond_contracts_list (
    p_view             OUT SYS_REFCURSOR,
    prows              OUT NUMBER,
    psortby                VARCHAR2 DEFAULT NULL,
    pfromrownumber         NUMBER DEFAULT NULL,
    ptorownumber           NUMBER DEFAULT NULL,
    psearchcriteria        VARCHAR2 DEFAULT NULL,
    pfilterdatefield       NUMBER DEFAULT 1, -- 1 - Maturity date | 2 - Next coupon Date
    pfromdate              DATE DEFAULT SYSDATE,
    ptodate                DATE DEFAULT SYSDATE)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT u24_exchange_code_m01,
               u24_symbol_code_m20,
               m20_isincode,
               m20_short_description,
               m20_short_description_lang,
               m20_instrument_type_code_v09,
               m20_currency_code_m03,
               u24_avg_price,
               u24_net_holding,
               gross_amount,
               commission,
               total,
               m20_issue_date,
               next_coupon_date,
               m20_maturity_date,
               u07_institute_id_m02,
               m20_issuer_name,
               m05_name,
               m20_interest_rate,
               coupon_amount,
               m20_lasttradeprice,
               accured_interest,
               u24_avg_price + accured_interest as dirty_price
          FROM (SELECT u24.u24_exchange_code_m01,
                       u24.u24_symbol_code_m20,
                       m20.m20_isincode,
                       m20.m20_short_description,
                       m20.m20_short_description_lang,
                       m20.m20_instrument_type_code_v09,
                       m20.m20_currency_code_m03,
                       u24.u24_avg_price,
                         u24.u24_net_holding
                       - u24.u24_receivable_holding
                       + u24.u24_payable_holding
                           AS u24_net_holding,
                         (  u24.u24_net_holding
                          - u24.u24_receivable_holding
                          + u24.u24_payable_holding)
                       * u24.u24_avg_price
                           AS gross_amount,
                         (  u24.u24_net_holding
                          - u24.u24_receivable_holding
                          + u24.u24_payable_holding)
                       * (u24.u24_avg_cost - u24.u24_avg_price)
                           AS commission,
                         (  u24.u24_net_holding
                          - u24.u24_receivable_holding
                          + u24.u24_payable_holding)
                       * u24.u24_avg_cost
                           AS total,
                       m20e.m20_issue_date,
                       ADD_MONTHS (m20e.m20_int_payment_date, v25.v25_duration)
                           AS next_coupon_date,
                       m20e.m20_maturity_date,
                       u07.u07_institute_id_m02,
                       m20e.m20_issuer_name,
                       m05.m05_name,
                       m20e.m20_interest_rate,
                       (ADD_MONTHS (m20e.m20_int_payment_date, v25.v25_duration)- m20e.m20_int_payment_date)* m20e.m20_interest_rate
                        AS coupon_amount,
                        m20.m20_lasttradeprice,
                  (  TRUNC (TO_DATE ('''
        || TO_CHAR (ptodate, 'DD/MM/YYYY')
        || ''', ''DD/MM/YYYY''))
                  - TRUNC (m20e.m20_int_payment_date))
               * (  (  u24.u24_net_holding
                     * m20.m20_strike_price
                     * m20e.m20_interest_rate)
                  / (v26.v26_upper_value * 100)) as accured_interest
                  FROM u24_holdings u24
                       JOIN u07_trading_account u07
                           ON u24.u24_trading_acnt_id_u07 = u07.u07_id
                       JOIN m20_symbol m20
                           ON u24.u24_symbol_id_m20 = m20.m20_id
                       JOIN m20_symbol_extended m20e
                           ON m20.m20_id = m20e.m20_id
                       LEFT JOIN m05_country m05
                            ON m05.m05_id = m20e.m20_security_domicile_id_m05
                       JOIN v25_payment_types v25
                           ON m20e.m20_no_of_payment_v25 = v25.v25_id
                       JOIN v26_interest_day_basis v26
                           ON m20e.m20_interest_day_basis_id_v26 = v26.v26_id
                 WHERE     (u24.u24_net_holding - u24.u24_receivable_holding + u24.u24_payable_holding) <>
                               0
                       AND m20_instrument_type_code_v09 = ''BN'')
         WHERE '
        || CASE
               WHEN pfilterdatefield = 1 THEN 'm20_maturity_date'
               ELSE 'next_coupon_date'
           END
        || ' BETWEEN TO_DATE ('''
        || TO_CHAR (pfromdate, 'DD/MM/YYYY')
        || ''', ''DD/MM/YYYY'') AND TO_DATE ('''
        || TO_CHAR (ptodate, 'DD/MM/YYYY')
        || ''', ''DD/MM/YYYY'') + 0.99999';

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