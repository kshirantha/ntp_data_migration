CREATE OR REPLACE PROCEDURE dfn_ntp.get_customer_wise_commission (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE,
    puserfilter           VARCHAR2 DEFAULT NULL,
    pinstitute            NUMBER)
IS
    l_qry                  VARCHAR2 (15000);
    s1                     VARCHAR2 (15000);
    s2                     VARCHAR2 (15000);
    l_computation_method   NUMBER (5, 0);
    l_check_buy_pending    NUMBER (5, 0);
    l_check_pledgedqty     NUMBER (5, 0);
BEGIN
    prows := 0;

    SELECT m02_price_type_for_margin,
           m02_add_buy_pending_for_margin,
           m02_add_pledge_for_bp
      INTO l_computation_method, l_check_buy_pending, l_check_pledgedqty
      FROM m02_institute m02
     WHERE m02_id = pinstitute;

    l_qry :=
           'SELECT
                  a.region,
                  a.location,
                  a.u01_customer_no,
                  a.u01_display_name,
                  a.u01_external_ref_no,
                  a.cash_balance,
                  a.u06_blocked,
                  a.portfolio_value,
                  a.cash_balance + a.portfolio_value AS total_asset_value,
                  a.no_of_trades,
                  a.total_traded_value,
                  a.gross_commission,
                  a.t02_exg_commission               AS exchange_commission,
                  a.commission                       AS charged_commission,
                  a.discount_comission,
                  a.disc_perc,
                  a.net_commission,
                  a.u02_mobile                       AS mobile,
                  a.u02_email                        AS email,
                  a.u02_telephone                    AS telephone,
                  a.u02_po_box                       AS po_box,
                  a.u02_zip_code                     AS zip_code,
                  a.birth_city,
                  a.u01_gender,
                  a.u06_institute_id_m02,
                  a.investment_account_no,
                  a.u01_id,
                  a.m10_name,
                  a.broker_vat,
                  a.exchange_vat,
                  a.t02_date,
                  case when turn_over <> 0
                    then
                      a.t02_amnt_in_txn_currency
                      / turn_over
                  else null end                      as market_share
                FROM (SELECT
                        m90.m90_name                                AS region,
                        m07.m07_name                                AS location,
                        u01.u01_customer_no,
                        u01.u01_display_name,
                        u01.u01_external_ref_no,
                        (u06.u06_balance
                         + u06.u06_payable_blocked
                         - u06.u06_receivable_amount) AS cash_balance,
                        u06.u06_blocked,
                        get_pfolio_val_by_cash_ac(
                            p_cash_ac_id           => u06.u06_id,
                            p_institution          => u06.u06_institute_id_m02,
                            p_computation_method   => '
        || l_computation_method
        || ',
                            p_check_buy_pending    => '
        || l_check_buy_pending
        || ',
                            p_check_pledgedqty     => '
        || l_check_pledgedqty
        || ',
                            p_check_sym_margin     => 0,
                            p_date                 => TO_DATE('''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY''))
                                                                    AS portfolio_value,
                        t02.order_cnt                               AS no_of_trades,
                        t02.t02_amnt_in_stl_currency                AS total_traded_value_old,
                        T02_ORD_VALUE_ADJST                         AS total_traded_value,
                        fn_get_market_turnover(
                            pexchange           => t02.t02_exchange_code_m01,
                            pfrom_date          => TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY''),
                                           pto_date            => TO_DATE('''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY''),
                            pdefault_turnover   => 1)
                                                                    as turn_over,
                        t02.t02_commission_adjst                    AS gross_commission,
                        t02.t02_exg_commission,
                        t02.t02_commission_adjst + t02.t02_discount AS commission,
                        t02.t02_discount                            AS discount_comission,
                        CASE default_commission WHEN 0 THEN 0
                        ELSE ROUND((t02.t02_discount / default_commission) * 100) END AS disc_perc,
                        t02.t02_commission_adjst - t02.t02_exg_commission
                                                                    AS net_commission,
                        u02.u02_mobile,
                        u02.u02_email,
                        u02.u02_telephone,
                        u02.u02_po_box,
                        u02.u02_zip_code,
                        m06.m06_name                                AS birth_city,
                        u01.u01_gender,
                        u06.u06_institute_id_m02,
                        u06.u06_investment_account_no               AS investment_account_no,
                        u01.u01_id,
                        m10.m10_name,
                        broker_vat,
                        exchange_vat,
                        t02.t02_amnt_in_txn_currency,
                        TO_DATE('''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'') AS t02_date
                      FROM (SELECT
                              COUNT(t02_order_no)        AS order_cnt,
                              t02_cash_acnt_id_u06,
                              t02_exchange_code_m01,
                              SUM(t02_commission_adjst)  AS t02_commission_adjst,
                              SUM (t02.t02_commission_adjst - t02.t02_exg_commission) AS t02_broker_commission,
                              SUM(t02_exg_commission)    AS t02_exg_commission,
                              SUM(t02_amnt_in_txn_currency)
                                                         AS t02_amnt_in_txn_currency,
                              SUM(t02_amnt_in_stl_currency)
                                                         AS t02_amnt_in_stl_currency,
                              SUM(t02_discount)          AS t02_discount,
                              SUM(t02_commission_adjst) + SUM(t02_discount)
                                                         AS default_commission,
                                 SUM (t02_broker_tax)       AS broker_vat,
                              SUM (t02_exchange_tax)     AS exchange_vat,
                              SUM (t02_ord_value_adjst) AS T02_ORD_VALUE_ADJST
                              FROM t02_transaction_log_order_all t02
                                  WHERE t02_inst_id_m02 = '
        || pinstitute
        || ' AND t02.t02_create_date BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')

                          AND  TO_DATE('''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'') '
        || CASE
               WHEN puserfilter IS NOT NULL THEN ' AND ' || puserfilter
               ELSE ''
           END
        || '

                            GROUP BY t02_cash_acnt_id_u06, t02_exchange_code_m01) t02
                        JOIN u06_cash_account u06
                          ON t02.t02_cash_acnt_id_u06 = u06.u06_id
                        JOIN u01_customer u01
                          ON u06.u06_customer_id_u01 = u01.u01_id
                        LEFT JOIN m07_location m07
                          ON u01.u01_signup_location_id_m07 = m07.m07_id
                        LEFT JOIN m90_region m90
                          ON m07.m07_region_id_m90 = m90.m90_id
                        LEFT JOIN m10_relationship_manager m10
                          ON u01.u01_relationship_mngr_id_m10 = m10.m10_id
                        LEFT JOIN u02_customer_contact_info u02
                          ON u01.u01_id = u02.u02_customer_id_u01
                        LEFT JOIN m06_city m06
                          ON u01.u01_birth_city_id_m06 = m06.m06_id
                      WHERE u02.u02_is_default = 1) a';

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