/* Formatted on 8/5/2020 3:18:47 PM (QP5 v5.206) */
CREATE OR REPLACE PACKAGE dfn_ntp.pkg_sfc_b2b_inquiries
IS
    TYPE refcursor IS REF CURSOR;

    FUNCTION get_buying_power (p_acc_id IN VARCHAR2)
        RETURN NUMBER;

    FUNCTION get_group_buying_power (
        pu06_id                  IN u06_cash_account.u06_id%TYPE,
        pu06_currency_code_m03   IN u06_cash_account.u06_currency_code_m03%TYPE,
        pu01_id                  IN u01_customer.u01_id%TYPE)
        RETURN u06_cash_account.u06_balance%TYPE;

    PROCEDURE account_summary_margin_report (p_srvcid       IN     VARCHAR2,
                                             p_chnl_id      IN     VARCHAR2,
                                             p_subchnl_id   IN     VARCHAR2,
                                             p_user_id      IN     VARCHAR2,
                                             p_lang         IN     VARCHAR2,
                                             p_ip           IN     VARCHAR2,
                                             p_session      IN     VARCHAR2,
                                             p_account      IN     VARCHAR2,
                                             p_ret_cd          OUT NUMBER,
                                             p_retmsg          OUT VARCHAR2,
                                             p_rs              OUT refcursor);

    PROCEDURE account_summary_report (p_srvcid       IN     VARCHAR2,
                                      p_chnl_id      IN     VARCHAR2,
                                      p_subchnl_id   IN     VARCHAR2,
                                      p_user_id      IN     VARCHAR2,
                                      p_lang         IN     VARCHAR2,
                                      p_ip           IN     VARCHAR2,
                                      p_session      IN     VARCHAR2,
                                      p_account      IN     VARCHAR2,
                                      p_ret_cd          OUT NUMBER,
                                      p_retmsg          OUT VARCHAR2,
                                      p_rs              OUT refcursor);

    PROCEDURE customer_holding_report (p_srvcid       IN     VARCHAR2,
                                       p_chnl_id      IN     VARCHAR2,
                                       p_subchnl_id   IN     VARCHAR2,
                                       p_user_id      IN     VARCHAR2,
                                       p_lang         IN     VARCHAR2,
                                       p_ip           IN     VARCHAR2,
                                       p_session      IN     VARCHAR2,
                                       p_mode         IN     VARCHAR2,
                                       p_date         IN     VARCHAR2,
                                       p_portfolio    IN     VARCHAR2,
                                       p_ret_cd          OUT NUMBER,
                                       p_retmsg          OUT VARCHAR2,
                                       p_rs              OUT refcursor);

    PROCEDURE customer_trading_stmnt_report (p_srvcid       IN     VARCHAR2,
                                             p_chnl_id      IN     VARCHAR2,
                                             p_subchnl_id   IN     VARCHAR2,
                                             p_user_id      IN     VARCHAR2,
                                             p_lang         IN     VARCHAR2,
                                             p_ip           IN     VARCHAR2,
                                             p_session      IN     VARCHAR2,
                                             p_mode         IN     VARCHAR2,
                                             pfrom_date     IN     VARCHAR2,
                                             pto_date       IN     VARCHAR2,
                                             p_portfolio    IN     VARCHAR2,
                                             p_ret_cd          OUT NUMBER,
                                             p_retmsg          OUT VARCHAR2,
                                             p_rs              OUT refcursor);

    PROCEDURE daily_settlement_advice_report (
        p_srvcid       IN     VARCHAR2,
        p_chnl_id      IN     VARCHAR2,
        p_subchnl_id   IN     VARCHAR2,
        p_user_id      IN     VARCHAR2,
        p_lang         IN     VARCHAR2,
        p_ip           IN     VARCHAR2,
        p_session      IN     VARCHAR2,
        p_account      IN     VARCHAR2,
        pd1            IN     VARCHAR2,
        p_ret_cd          OUT NUMBER,
        p_retmsg          OUT VARCHAR2,
        p_rs              OUT refcursor);

    PROCEDURE daily_trading_report (p_srvcid       IN     VARCHAR2,
                                    p_chnl_id      IN     VARCHAR2,
                                    p_subchnl_id   IN     VARCHAR2,
                                    p_user_id      IN     VARCHAR2,
                                    p_lang         IN     VARCHAR2,
                                    p_ip           IN     VARCHAR2,
                                    p_session      IN     VARCHAR2,
                                    p_mode         IN     VARCHAR2,
                                    pfrom_date     IN     VARCHAR2,
                                    pto_date       IN     VARCHAR2,
                                    p_portfolio    IN     VARCHAR2,
                                    p_ret_cd          OUT NUMBER,
                                    p_retmsg          OUT VARCHAR2,
                                    p_rs              OUT refcursor);

    PROCEDURE executed_order_report (p_srvcid       IN     VARCHAR2,
                                     p_chnl_id      IN     VARCHAR2,
                                     p_subchnl_id   IN     VARCHAR2,
                                     p_user_id      IN     VARCHAR2,
                                     p_lang         IN     VARCHAR2,
                                     p_ip           IN     VARCHAR2,
                                     p_session      IN     VARCHAR2,
                                     pfrom_date     IN     VARCHAR2,
                                     pto_date       IN     VARCHAR2,
                                     p_portfolio    IN     VARCHAR2,
                                     p_ret_cd          OUT NUMBER,
                                     p_retmsg          OUT VARCHAR2,
                                     p_rs              OUT refcursor);

    PROCEDURE get_cash_trans_by_settlement (p_srvcid       IN     VARCHAR2,
                                            p_chnl_id      IN     VARCHAR2,
                                            p_subchnl_id   IN     VARCHAR2,
                                            p_user_id      IN     VARCHAR2,
                                            p_lang         IN     VARCHAR2,
                                            p_ip           IN     VARCHAR2,
                                            p_session      IN     VARCHAR2,
                                            p_mode         IN     VARCHAR2,
                                            p_from_date    IN     VARCHAR2,
                                            p_to_date      IN     VARCHAR2,
                                            p_acc_no       IN     VARCHAR2,
                                            p_ret_cd          OUT NUMBER,
                                            p_retmsg          OUT VARCHAR2,
                                            p_rs              OUT refcursor);

    PROCEDURE get_cash_trans_by_trans (p_srvcid       IN     VARCHAR2,
                                       p_chnl_id      IN     VARCHAR2,
                                       p_subchnl_id   IN     VARCHAR2,
                                       p_user_id      IN     VARCHAR2,
                                       p_lang         IN     VARCHAR2,
                                       p_ip           IN     VARCHAR2,
                                       p_session      IN     VARCHAR2,
                                       p_mode         IN     VARCHAR2,
                                       p_from_date    IN     VARCHAR2,
                                       p_to_date      IN     VARCHAR2,
                                       p_acc_no       IN     VARCHAR2,
                                       p_ret_cd          OUT NUMBER,
                                       p_retmsg          OUT VARCHAR2,
                                       p_rs              OUT refcursor);

    PROCEDURE get_holding_summary (p_srvcid       IN     VARCHAR2,
                                   p_chnl_id      IN     VARCHAR2,
                                   p_subchnl_id   IN     VARCHAR2,
                                   p_user_id      IN     VARCHAR2,
                                   p_lang         IN     VARCHAR2,
                                   p_ip           IN     VARCHAR2,
                                   p_session      IN     VARCHAR2,
                                   p_mode         IN     VARCHAR2,
                                   pdate          IN     VARCHAR2,
                                   p_cpt          IN     VARCHAR2,
                                   p_ret_cd          OUT NUMBER,
                                   p_retmsg          OUT VARCHAR2,
                                   p_rs              OUT refcursor);

    PROCEDURE get_portfolio_potion_details (p_srvcid       IN     VARCHAR2,
                                            p_chnl_id      IN     VARCHAR2,
                                            p_subchnl_id   IN     VARCHAR2,
                                            p_user_id      IN     VARCHAR2,
                                            p_lang         IN     VARCHAR2,
                                            p_ip           IN     VARCHAR2,
                                            p_session      IN     VARCHAR2,
                                            p_mode         IN     VARCHAR2,
                                            l_date         IN     VARCHAR2,
                                            p_cpt          IN     VARCHAR2,
                                            p_instr        IN     VARCHAR2,
                                            p_port         IN     VARCHAR2,
                                            p_ret_cd          OUT NUMBER,
                                            p_retmsg          OUT VARCHAR2,
                                            p_rs              OUT refcursor);

    PROCEDURE holding_sample_report (p_srvcid       IN     VARCHAR2,
                                     p_chnl_id      IN     VARCHAR2,
                                     p_subchnl_id   IN     VARCHAR2,
                                     p_user_id      IN     VARCHAR2,
                                     p_lang         IN     VARCHAR2,
                                     p_ip           IN     VARCHAR2,
                                     p_session      IN     VARCHAR2,
                                     p_portfolio    IN     VARCHAR2,
                                     p_ret_cd          OUT NUMBER,
                                     p_retmsg          OUT VARCHAR2,
                                     p_rs              OUT refcursor);

    PROCEDURE hsbc_sample_report (p_srvcid       IN     VARCHAR2,
                                  p_chnl_id      IN     VARCHAR2,
                                  p_subchnl_id   IN     VARCHAR2,
                                  p_user_id      IN     VARCHAR2,
                                  p_lang         IN     VARCHAR2,
                                  p_ip           IN     VARCHAR2,
                                  p_session      IN     VARCHAR2,
                                  p_cpt          IN     VARCHAR2,
                                  pfrom_date     IN     VARCHAR2,
                                  pto_date       IN     VARCHAR2,
                                  p_ret_cd          OUT NUMBER,
                                  p_retmsg          OUT VARCHAR2,
                                  p_rs              OUT refcursor);

    PROCEDURE kamko_daily_trade_report (p_srvcid       IN     VARCHAR2,
                                        p_chnl_id      IN     VARCHAR2,
                                        p_subchnl_id   IN     VARCHAR2,
                                        p_user_id      IN     VARCHAR2,
                                        p_lang         IN     VARCHAR2,
                                        p_ip           IN     VARCHAR2,
                                        p_session      IN     VARCHAR2,
                                        p_account      IN     VARCHAR2,
                                        pfrom_date     IN     VARCHAR2,
                                        pto_date       IN     VARCHAR2,
                                        p_ret_cd          OUT NUMBER,
                                        p_retmsg          OUT VARCHAR2,
                                        p_rs              OUT refcursor);

    PROCEDURE trade_notification_report (p_srvcid       IN     VARCHAR2,
                                         p_chnl_id      IN     VARCHAR2,
                                         p_subchnl_id   IN     VARCHAR2,
                                         p_user_id      IN     VARCHAR2,
                                         p_lang         IN     VARCHAR2,
                                         p_ip           IN     VARCHAR2,
                                         p_session      IN     VARCHAR2,
                                         p_fromdate     IN     VARCHAR2,
                                         p_todate       IN     VARCHAR2,
                                         p_portfolio    IN     VARCHAR2,
                                         p_ret_cd          OUT NUMBER,
                                         p_retmsg          OUT VARCHAR2,
                                         p_rs              OUT refcursor);

    PROCEDURE chevurex_trade_confirmation (p_srvcid       IN     VARCHAR2,
                                           p_chnl_id      IN     VARCHAR2,
                                           p_subchnl_id   IN     VARCHAR2,
                                           p_user_id      IN     VARCHAR2,
                                           p_lang         IN     VARCHAR2,
                                           p_ip           IN     VARCHAR2,
                                           p_session      IN     VARCHAR2,
                                           p_mode         IN     VARCHAR2,
                                           p_from_date    IN     VARCHAR2,
                                           p_to_date      IN     VARCHAR2,
                                           p_portfolio    IN     VARCHAR2,
                                           p_ret_cd          OUT NUMBER,
                                           p_retmsg          OUT VARCHAR2,
                                           p_rs              OUT refcursor);

    PROCEDURE gib_trade_confirmation (p_srvcid       IN     VARCHAR2,
                                      p_chnl_id      IN     VARCHAR2,
                                      p_subchnl_id   IN     VARCHAR2,
                                      p_user_id      IN     VARCHAR2,
                                      p_lang         IN     VARCHAR2,
                                      p_ip           IN     VARCHAR2,
                                      p_session      IN     VARCHAR2,
                                      p_cpt          IN     VARCHAR2,
                                      pfrom_date     IN     VARCHAR2,
                                      pto_date       IN     VARCHAR2,
                                      p_ret_cd          OUT NUMBER,
                                      p_retmsg          OUT VARCHAR2,
                                      p_rs              OUT refcursor);
END;
/


CREATE OR REPLACE PACKAGE BODY dfn_ntp.pkg_sfc_b2b_inquiries
IS
    PROCEDURE chevurex_trade_confirmation (p_srvcid       IN     VARCHAR2,
                                           p_chnl_id      IN     VARCHAR2,
                                           p_subchnl_id   IN     VARCHAR2,
                                           p_user_id      IN     VARCHAR2,
                                           p_lang         IN     VARCHAR2,
                                           p_ip           IN     VARCHAR2,
                                           p_session      IN     VARCHAR2,
                                           p_mode         IN     VARCHAR2,
                                           p_from_date    IN     VARCHAR2,
                                           p_to_date      IN     VARCHAR2,
                                           p_portfolio    IN     VARCHAR2,
                                           p_ret_cd          OUT NUMBER,
                                           p_retmsg          OUT VARCHAR2,
                                           p_rs              OUT refcursor)
    IS
        l_min_date_in_t05      DATE;
        e_invalid_account_no   EXCEPTION;
    BEGIN
        /* sec.prc_oms_rpt_access (p_chnl_id,
                                 p_subchnl_id,
                                 p_srvcid,
                                 p_user_id,
                                 p_session,
                                 p_ip,
                                 p_portfolio,
                                 p_ret_cd,
                                 p_retmsg);*/

        IF p_ret_cd != 0
        THEN
            RETURN;
        END IF;

        IF p_mode = 'CDETAILS'
        THEN
            OPEN p_rs FOR
                SELECT portfolio,
                       DECODE (p_lang, 'E', custname, custname_lang)
                           AS custname,
                       address,
                       market,
                       settle_currency,
                       account_name,
                       trade_currency,
                          TO_CHAR (TO_DATE (p_from_date, 'dd/mm/yyyy'),
                                   'dd/mm/yyyy')
                       || ' '
                       || '-'
                       || ' '
                       || TO_CHAR (TO_DATE (p_to_date, 'dd/mm/yyyy'),
                                   'dd/mm/yyyy')
                           AS period
                  FROM dfn_ntp.vw_b2b_cdetails
                 WHERE portfolio = p_portfolio;



            IF SQL%NOTFOUND
            THEN
                RAISE e_invalid_account_no;
            END IF;
        END IF;

        IF p_mode = 'TRANDETAILS'
        THEN
            OPEN p_rs FOR
                SELECT DECODE (p_lang,
                               'E', m20_short_description,
                               m20_short_description_lang)
                           AS stock_name,
                       m20_reuters_code AS ric,
                       m20_isincode AS isin,
                       t02_create_date AS trade_date,
                       t02_cash_settle_date AS settlement_date,
                       t02_side AS side,
                       t02_last_price AS trading_price,
                       t02_last_shares AS quantity,
                       t02_order_value AS gross_amount,
                       t02_commission_adjst AS net_commission,
                       total_vat AS vat,
                       other_charges,
                       t02_amnt_in_txn_currency AS net_amount,
                       t02_amnt_in_stl_currency AS settlement_amount,
                       t02_fx_rate AS fx_rate
                  FROM vw_b2b_trade_confirmation vw
                 WHERE     vw.t02_create_date BETWEEN TO_DATE (p_from_date,
                                                               'dd/mm/yyyy')
                                                  AND   TO_DATE (
                                                            p_to_date,
                                                            'dd/mm/yyyy')
                                                      + 0.99999
                       AND u07_exchange_account_no = p_portfolio;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            IF p_mode = 'CDETAIL'
            THEN
                p_ret_cd := 1;
                p_retmsg := 'Invalid Account No';
            ELSE
                p_ret_cd := 1;
                p_retmsg := 'No Records';
            END IF;
        WHEN e_invalid_account_no
        THEN
            p_ret_cd := 1;
            p_retmsg := 'Invalid Account No';
        WHEN OTHERS
        THEN
            p_ret_cd := 1;
            p_retmsg := 'Error Occured While running query.!';
    END;


    PROCEDURE gib_trade_confirmation (p_srvcid       IN     VARCHAR2,
                                      p_chnl_id      IN     VARCHAR2,
                                      p_subchnl_id   IN     VARCHAR2,
                                      p_user_id      IN     VARCHAR2,
                                      p_lang         IN     VARCHAR2,
                                      p_ip           IN     VARCHAR2,
                                      p_session      IN     VARCHAR2,
                                      p_cpt          IN     VARCHAR2,
                                      pfrom_date     IN     VARCHAR2,
                                      pto_date       IN     VARCHAR2,
                                      p_ret_cd          OUT NUMBER,
                                      p_retmsg          OUT VARCHAR2,
                                      p_rs              OUT refcursor)
    IS
        l_min_date_in_t05   DATE;
    BEGIN
        /*  sec.prc_oms_rpt_access (p_chnl_id,
                                  p_subchnl_id,
                                  p_srvcid,
                                  p_user_id,
                                  p_session,
                                  p_ip,
                                  p_cpt,
                                  p_ret_cd,
                                  p_retmsg);

          IF p_ret_cd != 0
          THEN
              RETURN;
          END IF;
          */


        OPEN p_rs FOR
            SELECT DECODE (p_lang,
                           'E', m20_short_description,
                           m20_short_description_lang)
                       AS stock_name,
                   u07_exchange_account_no AS portfolio_no,
                   u06_investment_account_no AS account_no,
                   m20_reuters_code AS ric,
                   m20_isincode AS isin,
                   t02_create_date AS trade_date,
                   t02_cash_settle_date AS settlement_date,
                   t02_side AS side,
                   t02_last_price AS average_price,
                   t02_last_shares AS quantity,
                   t02_order_value AS VALUE,
                   t02_commission_adjst AS net_commission,
                   total_vat AS vat,
                   other_charges,
                   t02_amnt_in_txn_currency AS net_amount,
                   t02_amnt_in_stl_currency AS settlement_amount,
                   t02_fx_rate AS fx_rate,
                   t02_symbol_code_m20 AS code,
                   (t02_commission_adjst + t02_exg_commission) AS comm,
                   t02_exg_commission AS tdawul_commission,
                   t02_commission_adjst AS customer_commission,
                   t02_exg_commission AS deal,
                   (t02_commission_adjst - t02_exg_commission)
                       AS broker_commission,
                   (t02_order_value + t02_commission_adjst) AS total
              FROM vw_b2b_trade_confirmation vw
             WHERE     vw.t02_create_date BETWEEN TO_DATE (pfrom_date,
                                                           'dd/mm/yyyy')
                                              AND   TO_DATE (pto_date,
                                                             'dd/mm/yyyy')
                                                  + 0.99999
                   AND u01_customer_no = p_cpt;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            p_ret_cd := 1;
            p_retmsg := 'No Records';
        WHEN OTHERS
        THEN
            p_ret_cd := 1;
            p_retmsg := 'Error Occured While running query.!';
    END;


    PROCEDURE account_summary_margin_report (p_srvcid       IN     VARCHAR2,
                                             p_chnl_id      IN     VARCHAR2,
                                             p_subchnl_id   IN     VARCHAR2,
                                             p_user_id      IN     VARCHAR2,
                                             p_lang         IN     VARCHAR2,
                                             p_ip           IN     VARCHAR2,
                                             p_session      IN     VARCHAR2,
                                             p_account      IN     VARCHAR2,
                                             p_ret_cd          OUT NUMBER,
                                             p_retmsg          OUT VARCHAR2,
                                             p_rs              OUT refcursor)
    IS
        p_cash_account   VARCHAR2 (100);
    BEGIN
        /*  sec.prc_oms_rpt_access (p_chnl_id,
                                  p_subchnl_id,
                                  p_srvcid,
                                  p_user_id,
                                  p_session,
                                  p_ip,
                                  p_account,
                                  p_ret_cd,
                                  p_retmsg);

          IF p_ret_cd != 0
          THEN
              RETURN;
          END IF; */



        SELECT DISTINCT u06_investment_account_no
          INTO p_cash_account
          FROM dfn_ntp.vw_b2b_cdetails
         WHERE portfolio = p_account;

        OPEN p_rs FOR
            SELECT customer_no,
                   DECODE (p_lang,
                           'E', u01_display_name,
                           u01_display_name_lang)
                       custname,
                   security_ac_no,
                   cash_ac_no,
                   currency,
                   portfolio_value_ex_pledge,
                   cash_balance,
                   blocked_amount,
                   cash_block,
                   avilable_cash_balance,
                   pending_orders,
                   pending_settlement,
                   pending_transfers,
                   pending_deposits,
                   group_buying_power,
                   margin_type,
                   approve_margin_limit,
                   margin_expiry_date,
                   coverage_ratio,
                   marginalbe_portfolio,
                   mpv_with_pending_orders,
                   limit_utilization,
                   loan_due,
                   loan_currency,
                   loan_account,
                   buying_power
              FROM vw_b2b_margin_portfolio
             WHERE cash_ac_no = p_cash_account AND security_ac_no = p_account;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            p_ret_cd := 1;
            p_retmsg := 'No Records';
        WHEN OTHERS
        THEN
            p_ret_cd := 1;
            p_retmsg := 'Error Occured While running query.!';
    END;


    PROCEDURE account_summary_report (p_srvcid       IN     VARCHAR2,
                                      p_chnl_id      IN     VARCHAR2,
                                      p_subchnl_id   IN     VARCHAR2,
                                      p_user_id      IN     VARCHAR2,
                                      p_lang         IN     VARCHAR2,
                                      p_ip           IN     VARCHAR2,
                                      p_session      IN     VARCHAR2,
                                      p_account      IN     VARCHAR2,
                                      p_ret_cd          OUT NUMBER,
                                      p_retmsg          OUT VARCHAR2,
                                      p_rs              OUT refcursor)
    IS
    BEGIN
        pkg_sfc_b2b_inquiries.account_summary_margin_report (p_srvcid,
                                                             p_chnl_id,
                                                             p_subchnl_id,
                                                             p_user_id,
                                                             p_lang,
                                                             p_ip,
                                                             p_session,
                                                             p_account,
                                                             p_ret_cd,
                                                             p_retmsg,
                                                             p_rs);
    END;


    FUNCTION get_buying_power (p_acc_id IN VARCHAR2)
        RETURN NUMBER
    IS
        v_buy_pow   NUMBER (20, 4) := 0;
    BEGIN
        SELECT (  u06.u06_balance
                + (  (CASE
                          WHEN (    u06.u06_primary_od_limit > 0
                                AND SYSDATE < u06.u06_primary_expiry)
                          THEN
                              u06.u06_primary_od_limit
                          ELSE
                              0
                      END)
                   + (CASE
                          WHEN (    u06.u06_secondary_od_limit > 0
                                AND (   u06.u06_secondary_expiry = NULL
                                     OR SYSDATE < u06.u06_secondary_expiry))
                          THEN
                              u06.u06_secondary_od_limit
                          ELSE
                              0
                      END))
                + u06.u06_blocked
                + u06.u06_pending_deposit
                + u06.u06_manual_full_blocked)
                   AS buying_power
          INTO v_buy_pow
          FROM u06_cash_account u06
         WHERE u06.u06_id = p_acc_id;

        RETURN v_buy_pow;
    END get_buying_power;


    FUNCTION get_group_buying_power (
        pu06_id                  IN u06_cash_account.u06_id%TYPE,
        pu06_currency_code_m03   IN u06_cash_account.u06_currency_code_m03%TYPE,
        pu01_id                  IN u01_customer.u01_id%TYPE)
        RETURN u06_cash_account.u06_balance%TYPE
    IS
        lbuying_power         u06_cash_account.u06_balance%TYPE DEFAULT 0;
        lbuying_power_value   u06_cash_account.u06_balance%TYPE DEFAULT 0;

        CURSOR cash_accounts (
            customer_id NUMBER)
        IS
            SELECT *
              FROM u06_cash_account u06
             WHERE     u06.u06_customer_id_u01 = customer_id
                   AND u06_group_bp_enable = 1;

        rec                   u06_cash_account%ROWTYPE DEFAULT NULL;
    BEGIN
        IF (pu01_id IS NULL)
        THEN
            RETURN '0 NULL';
        END IF;

        OPEN cash_accounts (pu01_id);

        LOOP
            FETCH cash_accounts INTO rec;

            EXIT WHEN cash_accounts%NOTFOUND;
            lbuying_power_value :=
                  rec.u06_balance
                + rec.u06_blocked
                + rec.u06_pending_deposit
                + rec.u06_manual_full_blocked;

            IF (    rec.u06_secondary_od_limit > 0
                AND rec.u06_secondary_expiry IS NOT NULL
                AND SYSDATE <= rec.u06_secondary_expiry)
            THEN
                lbuying_power_value :=
                    lbuying_power_value + rec.u06_secondary_od_limit;
            END IF;

            IF (    rec.u06_primary_od_limit > 0
                AND rec.u06_primary_expiry IS NOT NULL
                AND SYSDATE <= rec.u06_primary_expiry)
            THEN
                lbuying_power_value :=
                    lbuying_power_value + rec.u06_primary_od_limit;
            ELSIF (    rec.u06_primary_od_limit > 0
                   AND rec.u06_primary_expiry IS NULL)
            THEN
                lbuying_power_value :=
                    lbuying_power_value + rec.u06_primary_od_limit;
            END IF;

            lbuying_power :=
                  lbuying_power
                +   lbuying_power_value
                  * get_exchange_rate (rec.u06_institute_id_m02,
                                       rec.u06_currency_code_m03,
                                       pu06_currency_code_m03);
        END LOOP;

        CLOSE cash_accounts;

        RETURN lbuying_power;
    EXCEPTION
        WHEN OTHERS
        THEN
            RETURN -1;
    END;



    PROCEDURE customer_holding_report (p_srvcid       IN     VARCHAR2,
                                       p_chnl_id      IN     VARCHAR2,
                                       p_subchnl_id   IN     VARCHAR2,
                                       p_user_id      IN     VARCHAR2,
                                       p_lang         IN     VARCHAR2,
                                       p_ip           IN     VARCHAR2,
                                       p_session      IN     VARCHAR2,
                                       p_mode         IN     VARCHAR2,
                                       p_date         IN     VARCHAR2,
                                       p_portfolio    IN     VARCHAR2,
                                       p_ret_cd          OUT NUMBER,
                                       p_retmsg          OUT VARCHAR2,
                                       p_rs              OUT refcursor)
    IS
        l_exchange                     VARCHAR2 (20);
        pt04_security_ac_id            NUMBER;
        i_isgetpreviousclose           NUMBER;
        ptemp_date                     DATE;
        e_invalid_account_no           EXCEPTION;
        l_total_cost_trandetails       NUMBER (20, 5);
        l_market_value_trandetails     NUMBER (20, 5);
        l_unrealizes_gl_trandetails    NUMBER (20, 5);
        l_total_cost_trandetails2      NUMBER (20, 5);
        l_market_value_trandetails2    NUMBER (20, 5);
        l_unrealizes_gl_trandetails2   NUMBER (20, 5);
    BEGIN
        /*sec.prc_oms_rpt_access (p_chnl_id,
                                p_subchnl_id,
                                p_srvcid,
                                p_user_id,
                                p_session,
                                p_ip,
                                p_portfolio,
                                p_ret_cd,
                                p_retmsg);

        IF p_ret_cd != 0
        THEN
            RETURN;
        END IF;*/

        IF p_mode = 'CDETAILS'
        THEN
            SELECT NVL (u07.u07_exchange_code_m01, '-1'),
                   NVL (u07.u07_id, -1)
              INTO l_exchange, pt04_security_ac_id
              FROM u07_trading_account u07
             WHERE u07.u07_exchange_account_no = p_portfolio;
        END IF;

        ptemp_date := TO_DATE (p_date, 'dd/mm/yyyy');

        IF TRUNC (ptemp_date) > TRUNC (SYSDATE)
        THEN
            ptemp_date := SYSDATE;
        END IF;

        IF TRUNC (ptemp_date) = TRUNC (SYSDATE)
        THEN
            SELECT SUM (vw.u24_net_holding * vw.u24_avg_cost) cost,
                   SUM (vw.u24_net_holding * vw.market_price) valuation,
                   SUM (
                         SUM (vw.u24_net_holding * vw.u24_avg_cost)
                       - SUM (vw.u24_net_holding * vw.market_price))
                       unrealize_gainloss
              INTO l_total_cost_trandetails,
                   l_market_value_trandetails,
                   l_unrealizes_gl_trandetails
              FROM (SELECT (  u24.u24_net_holding
                            + u24.u24_payable_holding
                            - u24.u24_receivable_holding
                            - u24.u24_manual_block)
                               AS u24_net_holding,
                           u24.u24_avg_cost,
                           CASE
                               WHEN m02.m02_price_type_for_margin = 1 -- Last Trade
                               THEN
                                   esp.lasttradedprice
                               WHEN m02.m02_price_type_for_margin = 2  -- VWAP
                               THEN
                                   NVL (esp.vwap, 0)
                               WHEN m02.m02_price_type_for_margin = 3 -- Previous Closed
                               THEN
                                   NVL (esp.previousclosed, 0)
                               WHEN m02.m02_price_type_for_margin = 4 -- Closing Price
                               THEN
                                   CASE
                                       WHEN NVL (esp.todaysclosed, 0) = 0
                                       THEN
                                           NVL (esp.previousclosed, 0)
                                       ELSE
                                           NVL (esp.todaysclosed, 0)
                                   END
                               ELSE                                 -- Default
                                   esp.lasttradedprice
                           END
                               AS market_price
                      FROM u24_holdings u24
                           INNER JOIN dfn_price.esp_todays_snapshots esp
                               ON     u24.u24_symbol_code_m20 = esp.symbol
                                  AND u24.u24_exchange_code_m01 =
                                          esp.exchangecode
                           INNER JOIN u07_trading_account u07
                               ON u07.u07_id = u24_trading_acnt_id_u07
                           INNER JOIN m02_institute m02
                               ON m02.m02_id = u07.u07_institute_id_m02
                           INNER JOIN m20_symbol m20
                               ON     m20.m20_symbol_code =
                                          u24.u24_symbol_code_m20
                                  AND m20_market_code_m29 =
                                          u24.u24_exchange_code_m01
                                  AND esp.symbol = u24.u24_symbol_code_m20
                                  AND m20_instrument_type_code_v09 != 'BN'
                                  AND esp.exchangecode =
                                          u24.u24_exchange_code_m01
                     WHERE     u24.u24_trading_acnt_id_u07 =
                                   pt04_security_ac_id
                           AND u24.u24_exchange_code_m01 = l_exchange) vw;
        ELSE
            SELECT SUM (vw.h01_net_holding * vw.h01_avg_cost) cost,
                   SUM (vw.h01_net_holding * vw.market_price) valuation,
                   SUM (
                         SUM (vw.h01_net_holding * vw.h01_avg_cost)
                       - SUM (vw.h01_net_holding * vw.market_price))
                       unrealize_gainloss
              INTO l_total_cost_trandetails,
                   l_market_value_trandetails,
                   l_unrealizes_gl_trandetails
              FROM (SELECT (  h01.h01_net_holding
                            + h01.h01_payable_holding
                            - h01.h01_receivable_holding
                            - h01.h01_manual_block)
                               AS h01_net_holding,
                           h01.h01_avg_cost,
                           CASE
                               WHEN m02.m02_price_type_for_margin = 1 -- Last Trade
                               THEN
                                   h01.h01_last_trade_price
                               WHEN m02.m02_price_type_for_margin = 2  -- VWAP
                               THEN
                                   NVL (h01.h01_vwap, 0)
                               WHEN m02.m02_price_type_for_margin = 3 -- Previous Closed
                               THEN
                                   NVL (h01.h01_previous_closed, 0)
                               WHEN m02.m02_price_type_for_margin = 4 -- Closing Price
                               THEN
                                   CASE
                                       WHEN NVL (h01.h01_todays_closed, 0) =
                                                0
                                       THEN
                                           NVL (h01.h01_previous_closed, 0)
                                       ELSE
                                           NVL (h01.h01_todays_closed, 0)
                                   END
                               ELSE                                 -- Default
                                   h01.h01_last_trade_price
                           END
                               AS market_price
                      FROM h01_holding_summary h01
                           INNER JOIN u07_trading_account u07
                               ON u07.u07_id = h01_trading_acnt_id_u07
                           INNER JOIN m02_institute m02
                               ON m02.m02_id = u07.u07_institute_id_m02
                           INNER JOIN m20_symbol m20
                               ON     m20.m20_symbol_code =
                                          h01.h01_symbol_code_m20
                                  AND m20_market_code_m29 =
                                          h01.h01_exchange_code_m01
                                  AND m20_instrument_type_code_v09 != 'BN'
                     WHERE     h01.h01_trading_acnt_id_u07 =
                                   pt04_security_ac_id
                           AND h01.h01_date = TRUNC (ptemp_date)
                           AND h01.h01_exchange_code_m01 = l_exchange) vw;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            IF p_mode = 'CDETAIL'
            THEN
                p_ret_cd := 1;
                p_retmsg := 'Invalid Account No';
            ELSE
                p_ret_cd := 1;
                p_retmsg := 'No Records';
            END IF;
        WHEN e_invalid_account_no
        THEN
            p_ret_cd := 1;
            p_retmsg := 'Invalid Account No';
        WHEN OTHERS
        THEN
            p_ret_cd := 1;
            p_retmsg := 'Error Occured While running query.!';
    END;

    PROCEDURE customer_trading_stmnt_report (p_srvcid       IN     VARCHAR2,
                                             p_chnl_id      IN     VARCHAR2,
                                             p_subchnl_id   IN     VARCHAR2,
                                             p_user_id      IN     VARCHAR2,
                                             p_lang         IN     VARCHAR2,
                                             p_ip           IN     VARCHAR2,
                                             p_session      IN     VARCHAR2,
                                             p_mode         IN     VARCHAR2,
                                             pfrom_date     IN     VARCHAR2,
                                             pto_date       IN     VARCHAR2,
                                             p_portfolio    IN     VARCHAR2,
                                             p_ret_cd          OUT NUMBER,
                                             p_retmsg          OUT VARCHAR2,
                                             p_rs              OUT refcursor)
    IS
        l_cnt   NUMBER := 0;
    BEGIN
        /*
               sec.prc_oms_rpt_access (p_chnl_id,
                                       p_subchnl_id,
                                       p_srvcid,
                                       p_user_id,
                                       p_session,
                                       p_ip,
                                       p_portfolio,
                                       p_ret_cd,
                                       p_retmsg);

               IF p_ret_cd != 0
               THEN
                   RETURN;
               END IF;
               */

        IF (p_mode = 'CDETAILS')
        THEN
            OPEN p_rs FOR
                SELECT MAX (portfolio) portfolio_no,
                       MAX (u06_investment_account_no) account_no,
                       DECODE (p_lang,
                               'E', MAX (custname),
                               MAX (custname_lang))
                           AS portfolio_name,
                       MAX (address) address,
                       NVL (ROUND (SUM (t01.t01_profit_loss), 2), 0)
                           total_profitloss,
                          TO_CHAR (TO_DATE (MAX (pfrom_date), 'dd/mm/yyyy'),
                                   'DD/MM/YYYY')
                       || ' '
                       || '-'
                       || ' '
                       || TO_CHAR (TO_DATE (MAX (pto_date), 'dd/mm/yyyy'),
                                   'DD/MM/YYYY')
                           AS period
                  FROM     vw_b2b_cdetails vw
                       LEFT OUTER JOIN
                           t01_order t01
                       ON     vw.portfolio = t01.t01_trading_acntno_u07
                          AND t01.t01_date BETWEEN TRUNC (
                                                       TO_DATE (pfrom_date,
                                                                'dd/mm/yyyy'))
                                               AND   TRUNC (
                                                         TO_DATE (
                                                             pto_date,
                                                             'dd/mm/yyyy'))
                                                   + 0.99999
                 WHERE vw.portfolio = p_portfolio;
        ELSIF (p_mode = 'TRANDETAILS')
        THEN
            OPEN p_rs FOR
                SELECT CASE WHEN t01.t01_side = 1 THEN 'Buy' ELSE 'Sell' END
                           AS action,
                       t01.t01_ord_no AS orderno,
                       t01.t01_date,
                       m20.m20_short_description AS stockname,
                       t01.t01_settle_currency AS settle_currency,
                       t01.t01_cum_quantity AS filled_quantity,
                       t01.t01_quantity AS total_quantity,
                       t01.t01_avg_price avg_price,
                       t01.t01_cum_ord_value total_amount,
                       t01.t01_cum_commission commission,
                       t01.t01_cum_netstl net_settle,
                       NVL (t01.t01_profit_loss, 0) profit_loss
                  FROM     t01_order t01
                       INNER JOIN
                           m20_symbol m20
                       ON m20.m20_id = t01.t01_symbol_id_m20
                 WHERE     t01.t01_date BETWEEN TRUNC (
                                                    TO_DATE (pfrom_date,
                                                             'dd/mm/yyyy'))
                                            AND   TRUNC (
                                                      TO_DATE (pto_date,
                                                               'dd/mm/yyyy'))
                                                + 0.99999
                       AND t01.t01_status_id_v30 IN
                               ('2', '1', '4', 'C', 'q', 'r', '5')
                       AND t01.t01_cum_quantity > 0
                       AND t01.t01_trading_acntno_u07 = p_portfolio;
        END IF;
    END;

    PROCEDURE daily_settlement_advice_report (
        p_srvcid       IN     VARCHAR2,
        p_chnl_id      IN     VARCHAR2,
        p_subchnl_id   IN     VARCHAR2,
        p_user_id      IN     VARCHAR2,
        p_lang         IN     VARCHAR2,
        p_ip           IN     VARCHAR2,
        p_session      IN     VARCHAR2,
        p_account      IN     VARCHAR2,
        pd1            IN     VARCHAR2,
        p_ret_cd          OUT NUMBER,
        p_retmsg          OUT VARCHAR2,
        p_rs              OUT refcursor)
    IS
        pt05_cash_account_id   NUMBER;
    BEGIN
        /*sec.prc_oms_rpt_access (p_chnl_id,
                                p_subchnl_id,
                                p_srvcid,
                                p_user_id,
                                p_session,
                                p_ip,
                                p_account,
                                p_ret_cd,
                                p_retmsg);

        IF p_ret_cd != 0
        THEN
            RETURN;
        END IF;*/
        SELECT u06.u06_id
          INTO pt05_cash_account_id
          FROM u06_cash_account u06
         WHERE u06.u06_investment_account_no = p_account;


        OPEN p_rs FOR
            SELECT u01.u01_customer_no customer_no,
                   u01.u01_display_name AS custname,
                   u06.u06_investment_account_no AS account_no,
                   CASE
                       WHEN sell.t05_date IS NULL THEN buy.t05_date
                       WHEN buy.t05_date IS NULL THEN sell.t05_date
                       ELSE sell.t05_date
                   END
                       AS trade_date,
                   CASE
                       WHEN sell.t05_settlement_date IS NULL
                       THEN
                           buy.t05_settlement_date
                       WHEN buy.t05_settlement_date IS NULL
                       THEN
                           sell.t05_settlement_date
                       ELSE
                           sell.t05_settlement_date
                   END
                       AS settlementdate,
                   h02.opening_balance AS opening_balance,
                     h02.opening_balance
                   - ABS (NVL (buy.total_buy, 0))
                   + NVL (cash_in.t02_amnt_in_txn_currency, 0)
                   + NVL (sell.total_sell, 0)
                   - ABS (NVL (cash_out.t02_amnt_in_txn_currency, 0))
                       AS utilization_of_settlement,
                   u06.u06_primary_od_limit AS utilize_od,
                   ABS (NVL (buy.total_buy, 0)) AS total_buy,
                   NVL (sell.total_sell, 0) AS total_sell,
                   ABS (NVL (cash_out.t02_amnt_in_txn_currency, 0))
                       AS total_cash_out,
                   NVL (cash_in.t02_amnt_in_txn_currency, 0) AS total_cash_in,
                   NVL (sell.total_sell, 0) - ABS (NVL (buy.total_buy, 0))
                       AS settlement_as_due
              FROM u06_cash_account u06
                   INNER JOIN u01_customer u01
                       ON u06.u06_customer_id_u01 = u01.u01_id
                   INNER JOIN (SELECT h02_date,
                                      h02_cash_account_id_u06,
                                      h02_balance opening_balance,
                                      (  h02_balance
                                       + h02.h02_payable_blocked
                                       - h02.h02_receivable_amount)
                                          available_amount
                                 FROM vw_h02_cash_account_summary h02
                                WHERE h02.h02_date =
                                          TO_DATE (pd1, 'dd/mm/yyyy') - 1) h02
                       ON h02.h02_cash_account_id_u06 = u06.u06_id
                   LEFT OUTER JOIN (  SELECT SUM (t02.t02_amnt_in_txn_currency)
                                                 AS total_buy,
                                             t02_cash_acnt_id_u06,
                                             MAX (t02.t02_cash_settle_date)
                                                 AS t05_settlement_date,
                                             MAX (t02.t02_db_create_date)
                                                 AS t05_date
                                        FROM t02_transaction_log t02
                                       WHERE     t02.t02_txn_code IN
                                                     ('STLBUY', 'REVBUY')
                                             AND t02.t02_cash_acnt_id_u06 =
                                                     pt05_cash_account_id
                                             AND t02.t02_db_create_date BETWEEN TRUNC (
                                                                                    TO_DATE (
                                                                                        pd1,
                                                                                        'dd/mm/yyyy'))
                                                                            AND   TRUNC (
                                                                                      TO_DATE (
                                                                                          pd1,
                                                                                          'dd/mm/yyyy'))
                                                                                + 0.99999
                                    GROUP BY t02_cash_acnt_id_u06) buy
                       ON buy.t02_cash_acnt_id_u06 =
                              h02.h02_cash_account_id_u06
                   LEFT OUTER JOIN (  SELECT SUM (t02.t02_amnt_in_txn_currency)
                                                 AS total_sell,
                                             t02_cash_acnt_id_u06,
                                             MAX (t02.t02_cash_settle_date)
                                                 AS t05_settlement_date,
                                             MAX (t02.t02_db_create_date)
                                                 AS t05_date
                                        FROM t02_transaction_log t02
                                       WHERE     t02.t02_txn_code IN
                                                     ('STLSEL', 'REVSEL')
                                             AND t02.t02_cash_acnt_id_u06 =
                                                     pt05_cash_account_id
                                             AND t02.t02_db_create_date BETWEEN TRUNC (
                                                                                    TO_DATE (
                                                                                        pd1,
                                                                                        'dd/mm/yyyy'))
                                                                            AND   TRUNC (
                                                                                      TO_DATE (
                                                                                          pd1,
                                                                                          'dd/mm/yyyy'))
                                                                                + 0.99999
                                    GROUP BY t02_cash_acnt_id_u06) sell
                       ON sell.t02_cash_acnt_id_u06 =
                              h02.h02_cash_account_id_u06
                   LEFT OUTER JOIN (  SELECT SUM (t02_amnt_in_txn_currency)
                                                 AS t02_amnt_in_txn_currency,
                                             t02_cash_acnt_id_u06
                                        FROM (SELECT CASE
                                                         WHEN t02.t02_amnt_in_txn_currency >
                                                                  0
                                                         THEN
                                                             t02_amnt_in_txn_currency
                                                         ELSE
                                                             0
                                                     END
                                                         AS t02_amnt_in_txn_currency,
                                                     t02_cash_acnt_id_u06
                                                FROM t02_transaction_log t02
                                               WHERE     t02.t02_txn_code NOT IN
                                                             ('STLBUY',
                                                              'STLSEL',
                                                              'BUYRMV',
                                                              'SELRMV',
                                                              'RMVBLK',
                                                              'CRTBLK',
                                                              'REVSEL',
                                                              'REVBUY',
                                                              'CONOPN',
                                                              'CONCLS',
                                                              'MKTMKT')
                                                     AND t02.t02_cash_acnt_id_u06 =
                                                             pt05_cash_account_id
                                                     AND t02.t02_db_create_date BETWEEN TRUNC (
                                                                                            TO_DATE (
                                                                                                pd1,
                                                                                                'dd/mm/yyyy'))
                                                                                    AND   TRUNC (
                                                                                              TO_DATE (
                                                                                                  pd1,
                                                                                                  'dd/mm/yyyy'))
                                                                                        + 0.99999)
                                    GROUP BY t02_cash_acnt_id_u06) cash_in
                       ON cash_in.t02_cash_acnt_id_u06 =
                              h02.h02_cash_account_id_u06
                   LEFT OUTER JOIN (  SELECT SUM (t02_amnt_in_txn_currency)
                                                 AS t02_amnt_in_txn_currency,
                                             t02_cash_acnt_id_u06
                                        FROM (SELECT CASE
                                                         WHEN t02.t02_amnt_in_txn_currency <
                                                                  0
                                                         THEN
                                                             t02_amnt_in_txn_currency
                                                         ELSE
                                                             0
                                                     END
                                                         AS t02_amnt_in_txn_currency,
                                                     t02_cash_acnt_id_u06
                                                FROM t02_transaction_log t02
                                               WHERE     t02.t02_txn_code NOT IN
                                                             ('STLBUY',
                                                              'STLSEL',
                                                              'BUYRMV',
                                                              'SELRMV',
                                                              'RMVBLK',
                                                              'CRTBLK',
                                                              'REVSEL',
                                                              'REVBUY',
                                                              'CONOPN',
                                                              'CONCLS',
                                                              'MKTMKT')
                                                     AND t02.t02_cash_acnt_id_u06 =
                                                             pt05_cash_account_id
                                                     AND t02.t02_db_create_date BETWEEN TRUNC (
                                                                                            TO_DATE (
                                                                                                pd1,
                                                                                                'dd/mm/yyyy'))
                                                                                    AND   TRUNC (
                                                                                              TO_DATE (
                                                                                                  pd1,
                                                                                                  'dd/mm/yyyy'))
                                                                                        + 0.99999)
                                    GROUP BY t02_cash_acnt_id_u06) cash_out
                       ON cash_out.t02_cash_acnt_id_u06 =
                              h02.h02_cash_account_id_u06
             WHERE u06.u06_id = pt05_cash_account_id;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            p_ret_cd := 1;
            p_retmsg := 'No Records';
        WHEN OTHERS
        THEN
            p_ret_cd := 1;
            p_retmsg := 'Error Occured While running query.!';
    END;


    PROCEDURE daily_trading_report (p_srvcid       IN     VARCHAR2,
                                    p_chnl_id      IN     VARCHAR2,
                                    p_subchnl_id   IN     VARCHAR2,
                                    p_user_id      IN     VARCHAR2,
                                    p_lang         IN     VARCHAR2,
                                    p_ip           IN     VARCHAR2,
                                    p_session      IN     VARCHAR2,
                                    p_mode         IN     VARCHAR2,
                                    pfrom_date     IN     VARCHAR2,
                                    pto_date       IN     VARCHAR2,
                                    p_portfolio    IN     VARCHAR2,
                                    p_ret_cd          OUT NUMBER,
                                    p_retmsg          OUT VARCHAR2,
                                    p_rs              OUT refcursor)
    IS
        l_days   VARCHAR2 (20);
    BEGIN
        /* sec.prc_oms_rpt_access (p_chnl_id,
                                 p_subchnl_id,
                                 p_srvcid,
                                 p_user_id,
                                 p_session,
                                 p_ip,
                                 p_portfolio,
                                 p_ret_cd,
                                 p_retmsg);

         IF p_ret_cd != 0
         THEN
             RETURN;
         END IF; */
        IF (p_mode = 'CDETAILS')
        THEN
            OPEN p_rs FOR
                SELECT    TO_CHAR (TO_DATE (pfrom_date, 'dd/mm/yyyy'),
                                   'DD/MM/YYYY')
                       || ' '
                       || '-'
                       || ' '
                       || TO_CHAR (TO_DATE (pto_date, 'dd/mm/yyyy'),
                                   'DD/MM/YYYY')
                           AS period,
                       a.*
                  FROM (SELECT SUM (NVL (t01.t01_cum_ord_value, 0))
                                   AS principal_amount_total,
                               SUM (NVL (t01.t01_cum_net_value, 0))
                                   AS net_settle_total,
                               SUM (NVL (t01.t01_cum_commission, 0))
                                   AS commission_total
                          FROM t01_order t01
                         WHERE     t01.t01_last_updated_date_time BETWEEN TRUNC (
                                                                              TO_DATE (
                                                                                  pfrom_date,
                                                                                  'dd/mm/yyyy'))
                                                                      AND   TRUNC (
                                                                                TO_DATE (
                                                                                    pto_date,
                                                                                    'dd/mm/yyyy'))
                                                                          + 0.99999
                               AND t01.t01_status_id_v30 IN
                                       ('2', '1', '4', 'q', 'r', '5')
                               AND t01.t01_cum_quantity > 0
                               AND t01.t01_trading_acntno_u07 = p_portfolio) a;
        ELSIF (p_mode = 'TRANDETAILS')
        THEN
            OPEN p_rs FOR
                SELECT u01.u01_customer_no AS cutomer_no,
                       u01.u01_display_name AS custname,
                       t01.t01_cl_ord_id AS order_no,
                       t01.t01_exchange_code_m01 AS exchange,
                       t01.t01_symbol_code_m20 AS symbol,
                       m20.m20_short_description AS symbol_descroption,
                       t01.t01_trading_acntno_u07 AS security_ac,
                       t01.t01_trading_acntno_u07 AS t01_routingac,
                       v01.v01_description AS side,
                       v29.v29_description AS chanel,
                       t01.t01_cum_quantity AS filled_qty,
                       t01.t01_price AS price,
                       t01.t01_avg_price AS avg_price,
                       t01.t01_cum_ord_value AS principle_amount,
                       t01.t01_cum_commission AS commission,
                       t01.t01_cum_broker_tax AS t01_cum_broker_vat,
                       t01.t01_cum_exchange_tax AS t01_cum_exchange_vat,
                       t01.t01_cum_net_value AS net_settle,
                       t01.t01_last_updated_date_time AS pdate
                  FROM t01_order t01
                       INNER JOIN u01_customer u01
                           ON t01.t01_customer_id_u01 = u01.u01_id
                       INNER JOIN m20_symbol m20
                           ON m20.m20_id = t01.t01_symbol_id_m20
                       INNER JOIN v01_system_master_data v01
                           ON v01.v01_id = t01.t01_side AND v01_type = 15
                       INNER JOIN v29_order_channel v29
                           ON v29.v29_id = t01.t01_ord_channel_id_v29
                 WHERE     t01.t01_status_id_v30 IN
                               ('2', '1', '4', 'q', 'r', '5')
                       AND t01.t01_cum_quantity > 0
                       AND t01.t01_trading_acntno_u07 = p_portfolio
                       AND t01_last_updated_date_time BETWEEN TRUNC (
                                                                  TO_DATE (
                                                                      pfrom_date,
                                                                      'dd/mm/yyyy'))
                                                          AND   TRUNC (
                                                                    TO_DATE (
                                                                        pto_date,
                                                                        'dd/mm/yyyy'))
                                                              + 0.99999;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            p_ret_cd := 1;
            p_retmsg := 'No Records';
        WHEN OTHERS
        THEN
            p_ret_cd := 1;
            p_retmsg := 'Error Occured While running query.!';
    END;

    PROCEDURE executed_order_report (p_srvcid       IN     VARCHAR2,
                                     p_chnl_id      IN     VARCHAR2,
                                     p_subchnl_id   IN     VARCHAR2,
                                     p_user_id      IN     VARCHAR2,
                                     p_lang         IN     VARCHAR2,
                                     p_ip           IN     VARCHAR2,
                                     p_session      IN     VARCHAR2,
                                     pfrom_date     IN     VARCHAR2,
                                     pto_date       IN     VARCHAR2,
                                     p_portfolio    IN     VARCHAR2,
                                     p_ret_cd          OUT NUMBER,
                                     p_retmsg          OUT VARCHAR2,
                                     p_rs              OUT refcursor)
    IS
    BEGIN
        /* sec.prc_oms_rpt_access (p_chnl_id,
                                 p_subchnl_id,
                                 p_srvcid,
                                 p_user_id,
                                 p_session,
                                 p_ip,
                                 p_portfolio,
                                 p_ret_cd,
                                 p_retmsg);

         IF p_ret_cd != 0
         THEN
             RETURN;
         END IF;*/

        OPEN p_rs FOR
            SELECT t01.t01_cl_ord_id AS order_id,
                   DECODE (p_lang,
                           'E', v30.v30_description,
                           v30.v30_description_lang)
                       AS status,
                   CASE
                       WHEN (    t01.t01_status_id_v30 = '8'
                             AND INSTR (t01.t01_reject_reason, '|') <> 0)
                       THEN
                           SUBSTR (t01.t01_reject_reason,
                                   0,
                                   INSTR (t01.t01_reject_reason, '|') - 1)
                       WHEN t01.t01_status_id_v30 = '8'
                       THEN
                           t01.t01_reject_reason
                   END
                       AS reject_reason,
                   t01.t01_symbol_code_m20 AS symbol,
                   DECODE (p_lang,
                           'E', m20_short_description,
                           m20_short_description_lang)
                       m107_short_description,
                   '' AS order_tag,
                   DECODE (p_lang,
                           'E', v01.v01_description,
                           v01.v01_description_lang)
                       AS side,
                   DECODE (p_lang,
                           'E', v06.v06_description_1,
                           v06.v06_description_2)
                       AS TYPE,
                   v29_description AS chanel,
                   t01.t01_quantity AS quantity,
                   -- t01.t01_n t01_nominal_amount AS nominal,
                   t01.t01_cum_quantity AS filled,
                   t01.t01_price AS price,
                   t01.t01_exchange_code_m01 AS exchnage,
                   t01.t01_avg_price AS average_price,
                   t01.t01_last_price AS last_price,
                   CASE
                       WHEN t01.t01_cum_netstl > 0 THEN t01.t01_cum_netstl
                       ELSE t01.t01_ord_net_settle
                   END
                       AS net_settle,
                   u01.u01_customer_no AS customer_no,
                   u01.u01_id AS mubasher_no,
                   u01.u01_display_name AS custname,
                   t01.t01_date_time AS order_date,
                   t01.t01_last_updated_date_time AS t01_last_updated,
                   TRUNC (t01.t01_expiry_date) AS expriy_date,
                   t01.t01_symbol_currency_code_m03 AS t01_currency,
                   t01.t01_ord_value AS t01_ordvalue,
                   t01.t01_exchange_ord_id AS execution_id,
                   UPPER (u17.u17_full_name) AS dealername,
                   u06.u06_investment_account_no AS cash_ac,
                   t01.t01_remote_cl_ord_id AS remote_order_id,
                   t01.t01_remote_orig_cl_ord_id AS t01_remote_origclorderid,
                   DECODE (p_lang,
                           'E', v10.v10_description,
                           v10.v10_description)
                       AS tif,
                   m02.m02_code AS m05_branch_code,
                   t01.t01_commission - t01.t01_exec_brk_commission
                       AS brokercommission,
                   t01.t01_exec_brk_commission AS t01_exg_commission,
                   t01.t01_commission t01_commission,
                   t01.t01_broker_tax AS t01_broker_vat,
                   t01.t01_exchange_tax AS t01_exchange_vat,
                   (t01.t01_broker_tax + t01.t01_exchange_tax) AS total_vat,
                   t01.t01_trading_acntno_u07 AS t01_routingac,
                   t01.t01_trading_acntno_u07 AS u05_accountno,
                   m26.m26_name AS ex01_name,
                   t01.t01_exchange_ord_id exch_ord_id,
                   t01.t01_instrument_type_code AS instrument_type,
                   t01.t01_cash_settle_date AS settle_date,
                   CASE
                       WHEN p_lang = 'E'
                       THEN
                              t01.t01_symbol_code_m20
                           || ' '
                           || v01.v01_description
                           || ' Order :'
                           || TRIM (
                                  TO_CHAR (t01.t01_cum_quantity,
                                           '999,999,999,999,999'))
                           || ' @ '
                           || TRIM (
                                  TO_CHAR (t01.t01_avg_price,
                                           '999,999,999,999,999.00'))
                       ELSE
                              t01.t01_symbol_code_m20
                           || ' '
                           || v01.v01_description
                           || ' '
                           || ' Order :'
                           || ' : '
                           || TRIM (
                                  TO_CHAR (t01.t01_cum_quantity,
                                           '999,999,999,999,999'))
                           || ' @ '
                           || TRIM (
                                  TO_CHAR (t01.t01_avg_price,
                                           '999,999,999,999,999.00'))
                   END
                       AS narration
              FROM t01_order t01
                   INNER JOIN v30_order_status v30
                       ON v30.v30_status_id = t01.t01_status_id_v30
                   INNER JOIN m20_symbol m20
                       ON m20.m20_id = t01.t01_symbol_id_m20
                   INNER JOIN v01_system_master_data v01
                       ON v01.v01_type = 15 AND v01.v01_id = t01.t01_side
                   INNER JOIN v06_order_type v06
                       ON v06.v06_type_id = t01.t01_ord_type_id_v06
                   INNER JOIN v29_order_channel v29
                       ON v29.v29_id = t01.t01_ord_channel_id_v29
                   INNER JOIN u01_customer u01
                       ON u01.u01_id = t01.t01_customer_id_u01
                   LEFT OUTER JOIN u17_employee u17
                       ON u17.u17_id = t01.t01_dealer_id_u17
                   INNER JOIN u06_cash_account u06
                       ON u06.u06_id = t01.t01_cash_acc_id_u06
                   INNER JOIN v10_tif v10
                       ON v10.v10_id = t01.t01_tif_id_v10
                   INNER JOIN m02_institute m02
                       ON m02.m02_id = u01.u01_institute_id_m02
                   LEFT OUTER JOIN m26_executing_broker m26
                       ON m26.m26_id = t01.t01_exec_broker_id_m26
             WHERE     t01.t01_ord_no IN
                           (SELECT DISTINCT t02_order_no
                              FROM t02_transaction_log t02
                             WHERE     t02_txn_code IN ('STLBUY', 'STLSEL')
                                   AND t02_create_date BETWEEN TRUNC (
                                                                   TO_DATE (
                                                                       pfrom_date,
                                                                       'dd/mm/yyyy'))
                                                           AND   TRUNC (
                                                                     TO_DATE (
                                                                         pto_date,
                                                                         'dd/mm/yyyy'))
                                                               + 0.99999)
                   AND t01.t01_status_id_v30 IN
                           ('1', '2', 'r', 'q', '4', '5', 'C')
                   AND t01.t01_trading_acntno_u07 = p_portfolio;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            p_ret_cd := 1;
            p_retmsg := 'No Records';
        WHEN OTHERS
        THEN
            p_ret_cd := 1;
            p_retmsg := 'Error Occured While running query.!';
    END;

    PROCEDURE get_cash_trans_by_settlement (p_srvcid       IN     VARCHAR2,
                                            p_chnl_id      IN     VARCHAR2,
                                            p_subchnl_id   IN     VARCHAR2,
                                            p_user_id      IN     VARCHAR2,
                                            p_lang         IN     VARCHAR2,
                                            p_ip           IN     VARCHAR2,
                                            p_session      IN     VARCHAR2,
                                            p_mode         IN     VARCHAR2,
                                            p_from_date    IN     VARCHAR2,
                                            p_to_date      IN     VARCHAR2,
                                            p_acc_no       IN     VARCHAR2,
                                            p_ret_cd          OUT NUMBER,
                                            p_retmsg          OUT VARCHAR2,
                                            p_rs              OUT refcursor)
    IS
        l_min_date_in_t05      DATE;
        pt05_cash_account_id   NUMBER;
        e_invalid_account_no   EXCEPTION;
        l_cr                   NUMBER (20, 3) := 0;
        l_dr                   NUMBER (20, 3) := 0;
        l_tot_vat              NUMBER (20, 3) := 0;
    BEGIN
        p_ret_cd := 0;

        /*sec.prc_oms_rpt_access (p_chnl_id,
                                p_subchnl_id,
                                p_srvcid,
                                p_user_id,
                                p_session,
                                p_ip,
                                p_acc_no,
                                p_ret_cd,
                                p_retmsg);*/


        SELECT NVL (u06.u06_id, -1)
          INTO pt05_cash_account_id
          FROM u06_cash_account u06
         WHERE u06.u06_investment_account_no = p_acc_no;

        IF (p_mode = 'CDETAILS')
        THEN
            SELECT NVL (SUM (ABS (dr)), 0) dr,
                   NVL (SUM ( (cr)), 0) cr,
                   NVL (SUM (vat), 0) vat
              INTO l_cr, l_dr, l_tot_vat
              FROM (  SELECT CASE
                                 WHEN t02.t02_amnt_in_stl_currency < 0
                                 THEN
                                     ROUND (
                                           (ABS (t02.t02_amnt_in_stl_currency))
                                         - (  t02.t02_broker_tax
                                            + t02.t02_exchange_tax),
                                         2)
                             END
                                 AS dr,
                             CASE
                                 WHEN t02.t02_amnt_in_stl_currency > 0
                                 THEN
                                     ROUND (
                                           (t02.t02_amnt_in_stl_currency)
                                         + (  t02.t02_broker_tax
                                            + t02.t02_exchange_tax),
                                         2)
                             END
                                 AS cr,
                             t02.t02_broker_tax + t02.t02_exchange_tax AS vat
                        FROM t02_transaction_log t02
                       WHERE     t02.t02_cash_acnt_id_u06 =
                                     pt05_cash_account_id
                             AND t02.t02_txn_code NOT IN
                                     ('REVBTD', 'REVSTD', 'REVADJ', 'FTB')
                             AND (   (    t02.t02_txn_code IN
                                              ('STLBUY', 'STLSEL')
                                      AND (   t02.t02_trade_process_stat_id_v01 IN
                                                  (25, 26)
                                           OR t02.t02_exchange_code_m01 =
                                                  'TDWL'))
                                  OR t02.t02_txn_code NOT IN
                                         ('STLBUY', 'STLSEL'))
                             AND TRUNC (t02.t02_cash_settle_date) >=
                                     TO_DATE (p_from_date, 'dd/mm/yyyy')
                             AND TRUNC (t02.t02_cash_settle_date) <=
                                     TO_DATE (p_to_date, 'dd/mm/yyyy')
                             AND t02.t02_txn_entry_status <> 1
                             AND t02.t02_custodian_type_v01 IN (0, 3)
                    ORDER BY t02.t02_cash_settle_date, t02.t02_create_date);

            OPEN p_rs FOR
                SELECT u01_customer_no AS customer_no,
                       DECODE (p_lang, 'E', custname, custname_lang)
                           AS customer_name,
                       vw.u06_investment_account_no AS account_no,
                       DECODE (p_lang,
                               'E', vw.u06_currency_code_m03,
                               m03.m03_description_lang)
                           AS currency,
                       vw.u06_iban_no AS t03_iban_no,
                       address,
                       l_dr AS dr,
                       l_cr AS cr,
                       l_tot_vat AS tot_vat,
                          TO_CHAR (TO_DATE (p_from_date, 'dd/mm/yyyy'),
                                   'DD/MM/YYYY')
                       || ' '
                       || '-'
                       || ' '
                       || TO_CHAR (TO_DATE (p_from_date, 'dd/mm/yyyy'),
                                   'DD/MM/YYYY')
                           AS period
                  FROM     vw_b2b_cdetails vw
                       INNER JOIN
                           m03_currency m03
                       ON m03.m03_code = vw.u06_currency_code_m03
                 WHERE vw.u06_investment_account_no = p_acc_no;
        END IF;

        IF (p_mode = 'TRANDETAILS')
        THEN
            OPEN p_rs FOR
                SELECT 0 AS rownumber,
                       TO_DATE (SYSDATE, 'dd/mm/yyyy') AS transaction_date,
                       NULL AS settlement_date,
                       NULL AS transaction_type,
                       DECODE (
                           p_lang,
                           'E', 'Opening balance',
                           UNISTR (
                               REPLACE (
                                   '\u0627\u0644\u0631\u0635\u064a\u062f \u0627\u0644\u0627\u0641\u062a\u062a\u0627\u062d\u064a',
                                   'u')))
                           AS description,
                       TO_NUMBER (NULL) AS dr,
                       TO_NUMBER (NULL) AS cr,
                       TO_NUMBER (NULL) AS vat,
                       (  h02_balance
                        + h02.h02_payable_blocked
                        - h02.h02_receivable_amount)
                           balance,
                       NULL AS loan_balance,
                       0 AS total,
                       h02.h02_date - 8 AS t05_settlement_date,
                       h02.h02_date - 8 AS t05_timestamp
                  FROM vw_h02_cash_account_summary h02
                 WHERE h02.h02_date = TO_DATE (p_from_date, 'dd/mm/yyyy') - 1
                UNION ALL
                SELECT ROWNUM AS rownumber,
                       t02.t02_create_date AS transaction_date,
                       TRUNC (t02.t02_cash_settle_date) AS settlement_date,
                       DECODE (p_lang,
                               'E', v01_description,
                               NVL (v01_description_lang, v01_description))
                           AS transaction_type,
                       CASE
                           WHEN t02.t02_txn_code = 'STLBUY' AND 'E' = 'E'
                           THEN
                               TO_CHAR (
                                      t02.t02_symbol_code_m20
                                   || '-'
                                   || m20.m20_short_description
                                   || ','
                                   || ' Qty'
                                   || ' : '
                                   || TRIM (
                                          TO_CHAR (t02.t02_ordqty,
                                                   '999,999,999,999,999'))
                                   || ' shares at '
                                   || TRIM (
                                          TO_CHAR (ABS (t02.t02_last_price),
                                                   '999,999,999,999,999.00'))
                                   || ' '
                                   || t02.t02_txn_currency
                                   || ', Ord: '
                                   || t02.t02_order_no)
                           WHEN t02.t02_txn_code = 'STLBUY' AND p_lang = 'A'
                           THEN
                               TO_CHAR (
                                      t02.t02_order_no
                                   || ' : '
                                   || UNISTR (
                                          REPLACE (
                                              '\u200E\u0623\u0645\u0631\u200E',
                                              'u'))
                                   || UNISTR (REPLACE ('\u060C', 'u'))
                                   || TRIM (
                                          TO_CHAR (t02.t02_last_price,
                                                   '999,999,999,999,999.00'))
                                   || ' '
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || DECODE (p_lang,
                                              'E', t02.t02_txn_currency,
                                              m03.m03_description_lang)
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || ' '
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || UNISTR (
                                          REPLACE (
                                              '\u0628\u0640\u0640\u0640\u0640',
                                              'u'))
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || UNISTR (
                                          REPLACE (
                                              '\u0627\u0644\u0623\u0633\u0647\u0645',
                                              'u'))
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || UNISTR (REPLACE ('\u060C', 'u'))
                                   || TRIM (
                                          TO_CHAR (t02.t02_ordqty,
                                                   '999,999,999,999,999'))
                                   || ' : '
                                   || UNISTR (
                                          REPLACE (
                                              '\u200E\u0627\u0644\u0643\u0645\u064a\u0629\u200E',
                                              'u'))
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || ' '
                                   || NVL (m20.m20_short_description_lang,
                                           m20.m20_short_description)
                                   || '-'
                                   || t02.t02_symbol_code_m20)
                           WHEN t02.t02_txn_code = 'STLSEL' AND p_lang = 'E'
                           THEN
                               TO_CHAR (
                                      t02.t02_symbol_code_m20
                                   || '-'
                                   || m20.m20_short_description
                                   || ','
                                   || ' Qty'
                                   || ' :'
                                   || TRIM (
                                          TO_CHAR (t02.t02_ordqty,
                                                   '999,999,999,999,999'))
                                   || ' shares at '
                                   || TRIM (
                                          TO_CHAR (ABS (t02.t02_last_price),
                                                   '999,999,999,999,999.00'))
                                   || ' '
                                   || t02.t02_txn_currency
                                   || ', Ord: '
                                   || t02.t02_order_no)
                           WHEN t02.t02_txn_code = 'Sell' AND p_lang = 'A'
                           THEN
                               TO_CHAR (
                                      t02.t02_order_no
                                   || ' : '
                                   || UNISTR (
                                          REPLACE (
                                              '\u200E\u0623\u0645\u0631\u200E',
                                              'u'))
                                   || UNISTR (REPLACE ('\u060C', 'u'))
                                   || TRIM (
                                          TO_CHAR (t02.t02_last_price,
                                                   '999,999,999,999,999.00'))
                                   || ' '
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || DECODE (p_lang,
                                              'E', t02.t02_txn_currency,
                                              m03.m03_description_lang)
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || ' '
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || UNISTR (
                                          REPLACE (
                                              '\u0628\u0640\u0640\u0640\u0640',
                                              'u'))
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || UNISTR (
                                          REPLACE (
                                              '\u0627\u0644\u0623\u0633\u0647\u0645',
                                              'u'))
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || UNISTR (REPLACE ('\u060C', 'u'))
                                   || TRIM (
                                          TO_CHAR (t02.t02_ordqty,
                                                   '999,999,999,999,999'))
                                   || ' : '
                                   || UNISTR (
                                          REPLACE (
                                              '\u200E\u0627\u0644\u0643\u0645\u064a\u0629\u200E',
                                              'u'))
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || ' '
                                   || NVL (m20.m20_short_description_lang,
                                           m20.m20_short_description)
                                   || '-'
                                   || t02.t02_symbol_code_m20)
                           ELSE
                               t02.t02_narration
                       END
                           AS description,
                       CASE
                           WHEN t02.t02_amnt_in_stl_currency < 0
                           THEN
                               ROUND (
                                     ABS (t02.t02_amnt_in_stl_currency)
                                   - (  t02.t02_broker_tax
                                      + t02.t02_exchange_tax),
                                   2)
                       END
                           AS dr,
                       CASE
                           WHEN t02.t02_amnt_in_stl_currency > 0
                           THEN
                               ROUND (
                                     t02.t02_amnt_in_stl_currency
                                   + (  t02.t02_broker_tax
                                      + t02.t02_exchange_tax),
                                   2)
                       END
                           AS cr,
                       t02.t02_broker_tax + t02.t02_exchange_tax AS vat,
                         NVL (
                             (  h02_balance
                              + h02.h02_payable_blocked
                              - h02.h02_receivable_amount),
                             0)
                       + SUM (
                             ROUND (t02.t02_amnt_in_stl_currency, 2))
                         OVER (
                             ORDER BY
                                 t02.t02_cash_settle_date,
                                 t02.t02_create_date)
                           AS balance,
                       NVL (0, 0) AS loan_balance,
                         NVL (
                             (  h02_balance
                              + h02.h02_payable_blocked
                              - h02.h02_receivable_amount),
                             0)
                       + SUM (
                             ROUND (t02.t02_amnt_in_stl_currency, 2))
                         OVER (
                             ORDER BY
                                 t02.t02_cash_settle_date,
                                 t02.t02_create_date)
                       + NVL (0, 0)
                           AS total,
                       t02.t02_cash_settle_date t05_settlement_date,
                       t02.t02_create_date t05_timestamp
                  FROM t02_transaction_log t02
                       INNER JOIN m20_symbol m20
                           ON t02.t02_symbol_id_m20 = m20.m20_id
                       INNER JOIN m03_currency m03
                           ON m03.m03_code = t02.t02_txn_currency
                       INNER JOIN v01_system_master_data v01
                           ON v01_type = 15 AND v01.v01_id = t02.t02_side
                       LEFT OUTER JOIN vw_h02_cash_account_summary h02
                           ON     h02.h02_date =
                                      TO_DATE (p_from_date, 'dd/mm/yyyy') - 1
                              AND h02_cash_account_id_u06 =
                                      pt05_cash_account_id
                 WHERE     t02.t02_cash_acnt_id_u06 = pt05_cash_account_id
                       AND t02.t02_txn_code NOT IN
                               ('REVBTD', 'REVSTD', 'REVADJ', 'FTB')
                       AND (   (    t02.t02_txn_code IN ('STLBUY', 'STLSEL')
                                AND (   t02.t02_trade_process_stat_id_v01 IN
                                            (25, 26)
                                     OR t02.t02_exchange_code_m01 = 'TDWL'))
                            OR t02.t02_txn_code NOT IN ('STLBUY', 'STLSEL'))
                       AND TRUNC (t02.t02_cash_settle_date) >=
                               TO_DATE (p_from_date, 'dd/mm/yyyy')
                       AND TRUNC (t02.t02_cash_settle_date) <=
                               TO_DATE (p_to_date, 'dd/mm/yyyy')
                       AND t02.t02_txn_entry_status <> 1
                       AND t02.t02_custodian_type_v01 IN (0, 3)
                UNION ALL
                SELECT 10000 AS rownumber,
                       TO_DATE (p_to_date, 'dd/mm/yyyy') AS transaction_date,
                       NULL AS settlement_date,
                       NULL AS transaction_type,
                       DECODE (
                           p_lang,
                           'E', 'Closing balance',
                           UNISTR (
                               REPLACE (
                                   '\u0627\u0644\u0631\u0635\u064a\u062f \u0627\u0644\u0646\u0647\u0627\u0626\u064a',
                                   'u')))
                           AS description,
                       TO_NUMBER (NULL) AS dr,
                       TO_NUMBER (NULL) AS cr,
                       TO_NUMBER (NULL) AS vat,
                       amount + h02_balance AS balance,
                       NULL AS loan_balance,
                       0 AS total,
                       TO_DATE (p_to_date, 'dd/mm/yyyy') + 30
                           AS t05_settlement_date,
                       TO_DATE (p_to_date, 'dd/mm/yyyy') + 30
                           AS t05_timestamp
                  FROM (  SELECT SUM (t02.t02_amnt_in_stl_currency) AS amount,
                                 (  MAX (h02_balance)
                                  + MAX (h02.h02_payable_blocked)
                                  - MAX (h02.h02_receivable_amount))
                                     AS h02_balance,
                                 t02.t02_cash_acnt_id_u06
                            FROM     t02_transaction_log t02
                                 LEFT OUTER JOIN
                                     vw_h02_cash_account_summary h02
                                 ON     h02.h02_date =
                                              TO_DATE (p_to_date, 'dd/mm/yyyy')
                                            - 1
                                    AND h02_cash_account_id_u06 =
                                            pt05_cash_account_id
                           WHERE     t02.t02_cash_acnt_id_u06 =
                                         pt05_cash_account_id
                                 AND t02.t02_txn_code NOT IN
                                         ('REVBTD', 'REVSTD', 'REVADJ', 'FTB')
                                 AND (   (    t02.t02_txn_code IN
                                                  ('STLBUY', 'STLSEL')
                                          AND (   t02.t02_trade_process_stat_id_v01 IN
                                                      (25, 26)
                                               OR t02.t02_exchange_code_m01 =
                                                      'TDWL'))
                                      OR t02.t02_txn_code NOT IN
                                             ('STLBUY', 'STLSEL'))
                                 AND TRUNC (t02.t02_cash_settle_date) >=
                                         TO_DATE (p_from_date, 'dd/mm/yyyy')
                                 AND TRUNC (t02.t02_cash_settle_date) <=
                                         TO_DATE (p_to_date, 'dd/mm/yyyy')
                                 AND t02.t02_txn_entry_status <> 1
                                 AND t02.t02_custodian_type_v01 IN (0, 3)
                        GROUP BY t02.t02_cash_acnt_id_u06);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            IF p_mode = 'CDETAILS'
            THEN
                p_ret_cd := 1;
                p_retmsg := 'Invalid Account No';
            ELSE
                p_ret_cd := 1;
                p_retmsg := 'No Records';
            END IF;
        WHEN e_invalid_account_no
        THEN
            p_ret_cd := 1;
            p_retmsg := 'Invalid Account No';
        WHEN OTHERS
        THEN
            p_ret_cd := 1;
            p_retmsg := 'Error Occured While running query.!';
    END;

    PROCEDURE get_cash_trans_by_trans (p_srvcid       IN     VARCHAR2,
                                       p_chnl_id      IN     VARCHAR2,
                                       p_subchnl_id   IN     VARCHAR2,
                                       p_user_id      IN     VARCHAR2,
                                       p_lang         IN     VARCHAR2,
                                       p_ip           IN     VARCHAR2,
                                       p_session      IN     VARCHAR2,
                                       p_mode         IN     VARCHAR2,
                                       p_from_date    IN     VARCHAR2,
                                       p_to_date      IN     VARCHAR2,
                                       p_acc_no       IN     VARCHAR2,
                                       p_ret_cd          OUT NUMBER,
                                       p_retmsg          OUT VARCHAR2,
                                       p_rs              OUT refcursor)
    IS
        l_min_date_in_t05      DATE;
        pt05_cash_account_id   NUMBER;
        e_invalid_account_no   EXCEPTION;
        l_cr                   NUMBER (20, 3) := 0;
        l_dr                   NUMBER (20, 3) := 0;
        l_tot_vat              NUMBER (20, 3) := 0;
    BEGIN
        p_ret_cd := 0;

        /*sec.prc_oms_rpt_access (p_chnl_id,
                                p_subchnl_id,
                                p_srvcid,
                                p_user_id,
                                p_session,
                                p_ip,
                                p_acc_no,
                                p_ret_cd,
                                p_retmsg);*/


        SELECT NVL (u06.u06_id, -1)
          INTO pt05_cash_account_id
          FROM u06_cash_account u06
         WHERE u06.u06_investment_account_no = p_acc_no;

        IF (p_mode = 'CDETAILS')
        THEN
            SELECT NVL (SUM (ABS (dr)), 0) dr,
                   NVL (SUM ( (cr)), 0) cr,
                   NVL (SUM (vat), 0) vat
              INTO l_cr, l_dr, l_tot_vat
              FROM (  SELECT CASE
                                 WHEN t02.t02_amnt_in_stl_currency < 0
                                 THEN
                                     ROUND (
                                           (ABS (t02.t02_amnt_in_stl_currency))
                                         - (  t02.t02_broker_tax
                                            + t02.t02_exchange_tax),
                                         2)
                             END
                                 AS dr,
                             CASE
                                 WHEN t02.t02_amnt_in_stl_currency > 0
                                 THEN
                                     ROUND (
                                           (t02.t02_amnt_in_stl_currency)
                                         + (  t02.t02_broker_tax
                                            + t02.t02_exchange_tax),
                                         2)
                             END
                                 AS cr,
                             t02.t02_broker_tax + t02.t02_exchange_tax AS vat
                        FROM t02_transaction_log t02
                       WHERE     t02.t02_cash_acnt_id_u06 =
                                     pt05_cash_account_id
                             AND t02.t02_txn_code NOT IN
                                     ('REVBTD', 'REVSTD', 'REVADJ', 'FTB')
                             AND (   (    t02.t02_txn_code IN
                                              ('STLBUY', 'STLSEL')
                                      AND (   t02.t02_trade_process_stat_id_v01 IN
                                                  (25, 26)
                                           OR t02.t02_exchange_code_m01 =
                                                  'TDWL'))
                                  OR t02.t02_txn_code NOT IN
                                         ('STLBUY', 'STLSEL'))
                             AND TRUNC (t02.t02_create_date) >=
                                     TO_DATE (p_from_date, 'dd/mm/yyyy')
                             AND TRUNC (t02.t02_create_date) <=
                                     TO_DATE (p_to_date, 'dd/mm/yyyy')
                             AND t02.t02_txn_entry_status <> 1
                             AND t02.t02_custodian_type_v01 IN (0, 3)
                    ORDER BY t02.t02_cash_settle_date, t02.t02_create_date);

            OPEN p_rs FOR
                SELECT u01_customer_no AS customer_no,
                       DECODE (p_lang, 'E', custname, custname_lang)
                           AS customer_name,
                       vw.u06_investment_account_no AS account_no,
                       DECODE (p_lang,
                               'E', vw.u06_currency_code_m03,
                               m03.m03_description_lang)
                           AS currency,
                       vw.u06_iban_no AS t03_iban_no,
                       address,
                       l_dr AS dr,
                       l_cr AS cr,
                       l_tot_vat AS tot_vat,
                          TO_CHAR (TO_DATE (p_from_date, 'dd/mm/yyyy'),
                                   'DD/MM/YYYY')
                       || ' '
                       || '-'
                       || ' '
                       || TO_CHAR (TO_DATE (p_from_date, 'dd/mm/yyyy'),
                                   'DD/MM/YYYY')
                           AS period
                  FROM     vw_b2b_cdetails vw
                       INNER JOIN
                           m03_currency m03
                       ON m03.m03_code = vw.u06_currency_code_m03
                 WHERE vw.u06_investment_account_no = p_acc_no;
        END IF;

        IF (p_mode = 'TRANDETAILS')
        THEN
            OPEN p_rs FOR
                SELECT 0 AS rownumber,
                       TO_DATE (SYSDATE, 'dd/mm/yyyy') AS transaction_date,
                       NULL AS settlement_date,
                       NULL AS transaction_type,
                       DECODE (
                           p_lang,
                           'E', 'Opening balance',
                           UNISTR (
                               REPLACE (
                                   '\u0627\u0644\u0631\u0635\u064a\u062f \u0627\u0644\u0627\u0641\u062a\u062a\u0627\u062d\u064a',
                                   'u')))
                           AS description,
                       TO_NUMBER (NULL) AS dr,
                       TO_NUMBER (NULL) AS cr,
                       TO_NUMBER (NULL) AS vat,
                       (  h02_balance
                        + h02.h02_payable_blocked
                        - h02.h02_receivable_amount)
                           balance,
                       NULL AS loan_balance,
                       0 AS total,
                       h02.h02_date - 8 AS t05_settlement_date,
                       h02.h02_date - 8 AS t05_timestamp
                  FROM vw_h02_cash_account_summary h02
                 WHERE h02.h02_date = TO_DATE (p_from_date, 'dd/mm/yyyy') - 1
                UNION ALL
                SELECT ROWNUM AS rownumber,
                       t02.t02_create_date AS transaction_date,
                       TRUNC (t02.t02_cash_settle_date) AS settlement_date,
                       DECODE (p_lang,
                               'E', v01_description,
                               NVL (v01_description_lang, v01_description))
                           AS transaction_type,
                       CASE
                           WHEN t02.t02_txn_code = 'STLBUY' AND 'E' = 'E'
                           THEN
                               TO_CHAR (
                                      t02.t02_symbol_code_m20
                                   || '-'
                                   || m20.m20_short_description
                                   || ','
                                   || ' Qty'
                                   || ' : '
                                   || TRIM (
                                          TO_CHAR (t02.t02_ordqty,
                                                   '999,999,999,999,999'))
                                   || ' shares at '
                                   || TRIM (
                                          TO_CHAR (ABS (t02.t02_last_price),
                                                   '999,999,999,999,999.00'))
                                   || ' '
                                   || t02.t02_txn_currency
                                   || ', Ord: '
                                   || t02.t02_order_no)
                           WHEN t02.t02_txn_code = 'STLBUY' AND 'E' = 'A'
                           THEN
                               TO_CHAR (
                                      t02.t02_order_no
                                   || ' : '
                                   || UNISTR (
                                          REPLACE (
                                              '\u200E\u0623\u0645\u0631\u200E',
                                              'u'))
                                   || UNISTR (REPLACE ('\u060C', 'u'))
                                   || TRIM (
                                          TO_CHAR (t02.t02_last_price,
                                                   '999,999,999,999,999.00'))
                                   || ' '
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || DECODE (p_lang,
                                              'E', t02.t02_txn_currency,
                                              m03.m03_description_lang)
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || ' '
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || UNISTR (
                                          REPLACE (
                                              '\u0628\u0640\u0640\u0640\u0640',
                                              'u'))
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || UNISTR (
                                          REPLACE (
                                              '\u0627\u0644\u0623\u0633\u0647\u0645',
                                              'u'))
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || UNISTR (REPLACE ('\u060C', 'u'))
                                   || TRIM (
                                          TO_CHAR (t02.t02_ordqty,
                                                   '999,999,999,999,999'))
                                   || ' : '
                                   || UNISTR (
                                          REPLACE (
                                              '\u200E\u0627\u0644\u0643\u0645\u064a\u0629\u200E',
                                              'u'))
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || ' '
                                   || NVL (m20.m20_short_description_lang,
                                           m20.m20_short_description)
                                   || '-'
                                   || t02.t02_symbol_code_m20)
                           WHEN t02.t02_txn_code = 'STLSEL' AND p_lang = 'E'
                           THEN
                               TO_CHAR (
                                      t02.t02_symbol_code_m20
                                   || '-'
                                   || m20.m20_short_description
                                   || ','
                                   || ' Qty'
                                   || ' :'
                                   || TRIM (
                                          TO_CHAR (t02.t02_ordqty,
                                                   '999,999,999,999,999'))
                                   || ' shares at '
                                   || TRIM (
                                          TO_CHAR (ABS (t02.t02_last_price),
                                                   '999,999,999,999,999.00'))
                                   || ' '
                                   || t02.t02_txn_currency
                                   || ', Ord: '
                                   || t02.t02_order_no)
                           WHEN t02.t02_txn_code = 'Sell' AND p_lang = 'A'
                           THEN
                               TO_CHAR (
                                      t02.t02_order_no
                                   || ' : '
                                   || UNISTR (
                                          REPLACE (
                                              '\u200E\u0623\u0645\u0631\u200E',
                                              'u'))
                                   || UNISTR (REPLACE ('\u060C', 'u'))
                                   || TRIM (
                                          TO_CHAR (t02.t02_last_price,
                                                   '999,999,999,999,999.00'))
                                   || ' '
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || DECODE (p_lang,
                                              'E', t02.t02_txn_currency,
                                              m03.m03_description_lang)
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || ' '
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || UNISTR (
                                          REPLACE (
                                              '\u0628\u0640\u0640\u0640\u0640',
                                              'u'))
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || UNISTR (
                                          REPLACE (
                                              '\u0627\u0644\u0623\u0633\u0647\u0645',
                                              'u'))
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || UNISTR (REPLACE ('\u060C', 'u'))
                                   || TRIM (
                                          TO_CHAR (t02.t02_ordqty,
                                                   '999,999,999,999,999'))
                                   || ' : '
                                   || UNISTR (
                                          REPLACE (
                                              '\u200E\u0627\u0644\u0643\u0645\u064a\u0629\u200E',
                                              'u'))
                                   || UNISTR (REPLACE ('\u200E', 'u'))
                                   || ' '
                                   || NVL (m20.m20_short_description_lang,
                                           m20.m20_short_description)
                                   || '-'
                                   || t02.t02_symbol_code_m20)
                           ELSE
                               t02.t02_narration
                       END
                           AS description,
                       CASE
                           WHEN t02.t02_amnt_in_stl_currency < 0
                           THEN
                               ROUND (
                                     ABS (t02.t02_amnt_in_stl_currency)
                                   - (  t02.t02_broker_tax
                                      + t02.t02_exchange_tax),
                                   2)
                       END
                           AS dr,
                       CASE
                           WHEN t02.t02_amnt_in_stl_currency > 0
                           THEN
                               ROUND (
                                     t02.t02_amnt_in_stl_currency
                                   + (  t02.t02_broker_tax
                                      + t02.t02_exchange_tax),
                                   2)
                       END
                           AS cr,
                       t02.t02_broker_tax + t02.t02_exchange_tax AS vat,
                         NVL (
                             (  h02_balance
                              + h02.h02_payable_blocked
                              - h02.h02_receivable_amount),
                             0)
                       + SUM (
                             ROUND (t02.t02_amnt_in_stl_currency, 2))
                         OVER (
                             ORDER BY
                                 t02.t02_cash_settle_date,
                                 t02.t02_create_date)
                           AS balance,
                       NVL (0, 0) AS loan_balance,
                         NVL (
                             (  h02_balance
                              + h02.h02_payable_blocked
                              - h02.h02_receivable_amount),
                             0)
                       + SUM (
                             ROUND (t02.t02_amnt_in_stl_currency, 2))
                         OVER (
                             ORDER BY
                                 t02.t02_cash_settle_date,
                                 t02.t02_create_date)
                       + NVL (0, 0)
                           AS total,
                       t02.t02_cash_settle_date t05_settlement_date,
                       t02.t02_create_date t05_timestamp
                  FROM t02_transaction_log t02
                       INNER JOIN m20_symbol m20
                           ON t02.t02_symbol_id_m20 = m20.m20_id
                       INNER JOIN m03_currency m03
                           ON m03.m03_code = t02.t02_txn_currency
                       INNER JOIN v01_system_master_data v01
                           ON v01_type = 15 AND v01.v01_id = t02.t02_side
                       LEFT OUTER JOIN vw_h02_cash_account_summary h02
                           ON     h02.h02_date =
                                      TO_DATE (p_from_date, 'dd/mm/yyyy') - 1
                              AND h02_cash_account_id_u06 =
                                      pt05_cash_account_id
                 WHERE     t02.t02_cash_acnt_id_u06 = pt05_cash_account_id
                       AND t02.t02_txn_code NOT IN
                               ('REVBTD', 'REVSTD', 'REVADJ', 'FTB')
                       AND (   (    t02.t02_txn_code IN ('STLBUY', 'STLSEL')
                                AND (   t02.t02_trade_process_stat_id_v01 IN
                                            (25, 26)
                                     OR t02.t02_exchange_code_m01 = 'TDWL'))
                            OR t02.t02_txn_code NOT IN ('STLBUY', 'STLSEL'))
                       AND TRUNC (t02.t02_create_date) >=
                               TO_DATE (p_from_date, 'dd/mm/yyyy')
                       AND TRUNC (t02.t02_create_date) <=
                               TO_DATE (p_to_date, 'dd/mm/yyyy')
                       AND t02.t02_txn_entry_status <> 1
                       AND t02.t02_custodian_type_v01 IN (0, 3)
                UNION ALL
                SELECT 10000 AS rownumber,
                       TO_DATE (p_to_date, 'dd/mm/yyyy') AS transaction_date,
                       NULL AS settlement_date,
                       NULL AS transaction_type,
                       DECODE (
                           p_lang,
                           'E', 'Closing balance',
                           UNISTR (
                               REPLACE (
                                   '\u0627\u0644\u0631\u0635\u064a\u062f \u0627\u0644\u0646\u0647\u0627\u0626\u064a',
                                   'u')))
                           AS description,
                       TO_NUMBER (NULL) AS dr,
                       TO_NUMBER (NULL) AS cr,
                       TO_NUMBER (NULL) AS vat,
                       amount + h02_balance AS balance,
                       NULL AS loan_balance,
                       0 AS total,
                       TO_DATE (p_to_date, 'dd/mm/yyyy') + 30
                           AS t05_settlement_date,
                       TO_DATE (p_to_date, 'dd/mm/yyyy') + 30
                           AS t05_timestamp
                  FROM (  SELECT SUM (t02.t02_amnt_in_stl_currency) AS amount,
                                 (  MAX (h02_balance)
                                  + MAX (h02.h02_payable_blocked)
                                  - MAX (h02.h02_receivable_amount))
                                     AS h02_balance,
                                 t02.t02_cash_acnt_id_u06
                            FROM     t02_transaction_log t02
                                 LEFT OUTER JOIN
                                     vw_h02_cash_account_summary h02
                                 ON     h02.h02_date =
                                              TO_DATE (p_to_date, 'dd/mm/yyyy')
                                            - 1
                                    AND h02_cash_account_id_u06 =
                                            pt05_cash_account_id
                           WHERE     t02.t02_cash_acnt_id_u06 =
                                         pt05_cash_account_id
                                 AND t02.t02_txn_code NOT IN
                                         ('REVBTD', 'REVSTD', 'REVADJ', 'FTB')
                                 AND (   (    t02.t02_txn_code IN
                                                  ('STLBUY', 'STLSEL')
                                          AND (   t02.t02_trade_process_stat_id_v01 IN
                                                      (25, 26)
                                               OR t02.t02_exchange_code_m01 =
                                                      'TDWL'))
                                      OR t02.t02_txn_code NOT IN
                                             ('STLBUY', 'STLSEL'))
                                 AND TRUNC (t02.t02_create_date) >=
                                         TO_DATE (p_from_date, 'dd/mm/yyyy')
                                 AND TRUNC (t02.t02_create_date) <=
                                         TO_DATE (p_to_date, 'dd/mm/yyyy')
                                 AND t02.t02_txn_entry_status <> 1
                                 AND t02.t02_custodian_type_v01 IN (0, 3)
                        GROUP BY t02.t02_cash_acnt_id_u06);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            IF p_mode = 'CDETAILS'
            THEN
                p_ret_cd := 1;
                p_retmsg := 'Invalid Account No';
            ELSE
                p_ret_cd := 1;
                p_retmsg := 'No Records';
            END IF;
        WHEN e_invalid_account_no
        THEN
            p_ret_cd := 1;
            p_retmsg := 'Invalid Account No';
        WHEN OTHERS
        THEN
            p_ret_cd := 1;
            p_retmsg := 'Error Occured While running query.!';
    END;

    PROCEDURE get_holding_summary (p_srvcid       IN     VARCHAR2,
                                   p_chnl_id      IN     VARCHAR2,
                                   p_subchnl_id   IN     VARCHAR2,
                                   p_user_id      IN     VARCHAR2,
                                   p_lang         IN     VARCHAR2,
                                   p_ip           IN     VARCHAR2,
                                   p_session      IN     VARCHAR2,
                                   p_mode         IN     VARCHAR2,
                                   pdate          IN     VARCHAR2,
                                   p_cpt          IN     VARCHAR2,
                                   p_ret_cd          OUT NUMBER,
                                   p_retmsg          OUT VARCHAR2,
                                   p_rs              OUT refcursor)
    IS
        e_invalid_account_no   EXCEPTION;
    BEGIN
        /* sec.prc_oms_rpt_access (p_chnl_id,
                                  p_subchnl_id,
                                  p_srvcid,
                                  p_user_id,
                                  p_session,
                                  p_ip,
                                  p_cpt,
                                  p_ret_cd,
                                  p_retmsg);

          IF p_ret_cd != 0
          THEN
              RETURN;
          END IF;
          */


        IF (TRUNC (TO_DATE (pdate, 'dd/mm/yyyy')) = TRUNC (SYSDATE))
        THEN
            OPEN p_rs FOR
                SELECT cutomer_no,
                       mubasher_no,
                       custname,
                       security_ac,
                       instrument_type,
                       exchange,
                       symbol,
                       short_description,
                       cusip_no,
                       isin_code,
                       ric,
                       ownedqty,
                       availableqty,
                       avg_cost,
                       pledgedqty,
                       avg_price,
                       nominal,
                       strike_price,
                       expiry_date,
                       block_qty,
                       market_price,
                       cost_basis,
                       sell_pending,
                       buy_pending,
                       open_sell,
                       open_buy,
                       net_day_holdings,
                       covered_call_option,
                       receivable_qty,
                       payable_qty,
                       pending_subcribed_qty,
                       subscribed_quantity,
                       wanc,
                       CASE
                           WHEN xyz.m20_instrument_type_code_v09 = 'BN'
                           THEN
                               ROUND (
                                     (  ROUND (xyz.market_price, 8)
                                      * (  xyz.u24_net_holding
                                         - xyz.u24_manual_block
                                         - xyz.u24_pledge_qty)
                                      * xyz.m20_lot_size)
                                   / 100,
                                   2)
                           ELSE
                               ROUND (
                                     ROUND (xyz.market_price, 8)
                                   * (  xyz.u24_net_holding
                                      - xyz.u24_manual_block
                                      - xyz.u24_pledge_qty)
                                   * xyz.m20_lot_size,
                                   2)
                       END
                           AS valuation,
                       CASE
                           WHEN xyz.m20_instrument_type_code_v09 = 'BN'
                           THEN
                               ROUND (
                                     (  ROUND (xyz.market_price, 8)
                                      * (  xyz.u24_net_holding
                                         - xyz.u24_manual_block
                                         - xyz.u24_sell_pending
                                         - xyz.u24_pledge_qty)
                                      * xyz.m20_lot_size)
                                   / 100,
                                   2)
                           ELSE
                               ROUND (
                                     ROUND (xyz.market_price, 8)
                                   * (  xyz.u24_net_holding
                                      - xyz.u24_manual_block
                                      - xyz.u24_sell_pending
                                      - xyz.u24_pledge_qty)
                                   * xyz.m20_lot_size
                                   * xyz.margin_per
                                   / 100,
                                   2)
                       END
                           AS margin_valuation,
                         CASE
                             WHEN xyz.m20_instrument_type_code_v09 = 'BN'
                             THEN
                                 ROUND (
                                       (  ROUND (xyz.market_price, 8)
                                        * (  xyz.u24_net_holding
                                           - xyz.u24_manual_block
                                           - xyz.u24_pledge_qty)
                                        * xyz.m20_lot_size)
                                     / 100,
                                     2)
                             ELSE
                                 ROUND (
                                       ROUND (xyz.market_price, 8)
                                     * (  xyz.u24_net_holding
                                        - xyz.u24_manual_block
                                        - xyz.u24_pledge_qty)
                                     * xyz.m20_lot_size,
                                     2)
                         END
                       - cost_basis
                           AS gain_loss
                  FROM (SELECT u01.u01_customer_no AS cutomer_no,
                               u01.u01_id AS mubasher_no,
                               u01.u01_display_name AS custname,
                               u07.u07_exchange_account_no AS security_ac,
                               m20.m20_instrument_type_code_v09
                                   AS instrument_type,
                               u24.u24_exchange_code_m01 AS exchange,
                               u24.u24_symbol_code_m20 AS symbol,
                               DECODE ('E',
                                       'E', m20.m20_short_description,
                                       m20.m20_short_description_lang)
                                   AS short_description,
                               m20.m20_cusip_no AS cusip_no,
                               m20.m20_isincode AS isin_code,
                               m20_instrument_type_code_v09,
                               m20.m20_reuters_code AS ric,
                               u24.u24_net_holding,
                               u24.u24_manual_block,
                               u24.u24_pledge_qty,
                               u24.u24_sell_pending,
                               m20_lot_size,
                                 u24.u24_net_holding
                               + u24.u24_payable_holding
                               - u24.u24_receivable_holding
                                   AS ownedqty,
                                 u24.u24_net_holding
                               - u24.u24_manual_block
                               - u24.u24_sell_pending
                               - u24.u24_pledge_qty
                                   AS availableqty,
                               ROUND (u24.u24_avg_cost, 2) AS avg_cost,
                               CASE
                                   WHEN m20.m20_instrument_type_code_v09 !=
                                            'BN'
                                   THEN
                                       u24.u24_pledge_qty
                               END
                                   AS pledgedqty,
                               ROUND (u24.u24_avg_price, 2) AS avg_price,
                               CASE
                                   WHEN m20.m20_instrument_type_code_v09 =
                                            'BN'
                                   THEN
                                       u24.u24_net_holding
                               END
                                   AS nominal,
                               CASE
                                   WHEN m20.m20_instrument_type_code_v09 =
                                            'OPT'
                                   THEN
                                       ROUND (m20.m20_strike_price, 2)
                               END
                                   AS strike_price,
                               m20.m20_expire_date AS expiry_date,
                               u24.u24_manual_block AS block_qty,
                               CASE
                                   WHEN m02.m02_price_type_for_margin = 1 -- Last Trade
                                   THEN
                                       esp.lasttradedprice
                                   WHEN m02.m02_price_type_for_margin = 2 -- VWAP
                                   THEN
                                       NVL (esp.vwap, 0)
                                   WHEN m02.m02_price_type_for_margin = 3 -- Previous Closed
                                   THEN
                                       NVL (esp.previousclosed, 0)
                                   WHEN m02.m02_price_type_for_margin = 4 -- Closing Price
                                   THEN
                                       CASE
                                           WHEN NVL (esp.todaysclosed, 0) = 0
                                           THEN
                                               NVL (esp.previousclosed, 0)
                                           ELSE
                                               NVL (esp.todaysclosed, 0)
                                       END
                                   ELSE                             -- Default
                                       esp.lasttradedprice
                               END
                                   AS market_price,
                               CASE
                                   WHEN m20.m20_instrument_type_code_v09 =
                                            'BN'
                                   THEN
                                       ROUND (
                                             (  u24.u24_net_holding
                                              - u24.u24_manual_block
                                              - u24.u24_pledge_qty)
                                           * m20.m20_lot_size
                                           * u24.u24_avg_cost
                                           / 100,
                                           2)
                                   ELSE
                                       ROUND (
                                             (  u24.u24_net_holding
                                              - u24.u24_manual_block
                                              - u24.u24_pledge_qty)
                                           * m20.m20_lot_size
                                           * u24.u24_avg_cost,
                                           2)
                               END
                                   AS cost_basis,
                               u24.u24_sell_pending AS sell_pending,
                               u24.u24_buy_pending AS buy_pending,
                               NULL AS open_sell,
                               NULL AS open_buy,
                               NULL AS net_day_holdings,
                               ABS (u24.u24_short_holdings)
                                   AS covered_call_option,
                               u24.u24_receivable_holding AS receivable_qty,
                               u24.u24_payable_holding AS payable_qty,
                               (  u24.u24_subscribed_qty
                                + ABS (u24.u24_pending_subscribe_qty))
                                   AS pending_subcribed_qty,
                               u24.u24_subscribed_qty AS subscribed_quantity,
                               ROUND (u24.u24_weighted_avg_cost, 2) AS wanc,
                               m78_marginable_per AS margin_per
                          FROM u24_holdings u24
                               INNER JOIN u07_trading_account u07
                                   ON u07.u07_id =
                                          u24.u24_trading_acnt_id_u07
                               INNER JOIN u01_customer u01
                                   ON u01.u01_id = u07.u07_customer_id_u01
                               INNER JOIN m20_symbol m20
                                   ON m20.m20_id = u24.u24_symbol_id_m20
                               INNER JOIN dfn_price.esp_todays_snapshots esp
                                   ON     esp.symbol =
                                              u24.u24_symbol_code_m20
                                      AND u24.u24_exchange_code_m01 =
                                              exchangecode
                               INNER JOIN m02_institute m02
                                   ON m02.m02_id = u01.u01_institute_id_m02
                               INNER JOIN u06_cash_account u06
                                   ON u06.u06_id =
                                          u07.u07_cash_account_id_u06
                               LEFT OUTER JOIN u23_customer_margin_product u23
                                   ON u23.u23_id =
                                          u06.u06_margin_product_id_u23
                               LEFT OUTER JOIN m77_symbol_marginability_grps m77
                                   ON m77.m77_id =
                                          u23.u23_sym_margin_group_m77
                               LEFT OUTER JOIN m78_symbol_marginability m78
                                   ON m78.m78_sym_margin_group_m77 =
                                          m77.m77_id
                         WHERE u24.u24_symbol_id_m20 = m78.m78_symbol_id_m20) xyz;
        ELSE
            OPEN p_rs FOR
                SELECT cutomer_no,
                       mubasher_no,
                       custname,
                       security_ac,
                       instrument_type,
                       exchange,
                       symbol,
                       short_description,
                       cusip_no,
                       isin_code,
                       ric,
                       ownedqty,
                       availableqty,
                       avg_cost,
                       pledgedqty,
                       avg_price,
                       nominal,
                       strike_price,
                       expiry_date,
                       block_qty,
                       market_price,
                       cost_basis,
                       sell_pending,
                       buy_pending,
                       open_sell,
                       open_buy,
                       net_day_holdings,
                       covered_call_option,
                       receivable_qty,
                       payable_qty,
                       pending_subcribed_qty,
                       subscribed_quantity,
                       wanc,
                       CASE
                           WHEN xyz.m20_instrument_type_code_v09 = 'BN'
                           THEN
                               ROUND (
                                     (  ROUND (xyz.market_price, 8)
                                      * (  xyz.u24_net_holding
                                         - xyz.u24_manual_block
                                         - xyz.u24_pledge_qty)
                                      * xyz.m20_lot_size)
                                   / 100,
                                   2)
                           ELSE
                               ROUND (
                                     ROUND (xyz.market_price, 8)
                                   * (  xyz.u24_net_holding
                                      - xyz.u24_manual_block
                                      - xyz.u24_pledge_qty)
                                   * xyz.m20_lot_size,
                                   2)
                       END
                           AS valuation,
                       CASE
                           WHEN xyz.m20_instrument_type_code_v09 = 'BN'
                           THEN
                               ROUND (
                                     (  ROUND (xyz.market_price, 8)
                                      * (  xyz.u24_net_holding
                                         - xyz.u24_manual_block
                                         - xyz.u24_sell_pending
                                         - xyz.u24_pledge_qty)
                                      * xyz.m20_lot_size)
                                   / 100,
                                   2)
                           ELSE
                               ROUND (
                                     ROUND (xyz.market_price, 8)
                                   * (  xyz.u24_net_holding
                                      - xyz.u24_manual_block
                                      - xyz.u24_sell_pending
                                      - xyz.u24_pledge_qty)
                                   * xyz.m20_lot_size
                                   * xyz.margin_per
                                   / 100,
                                   2)
                       END
                           AS margin_valuation,
                         CASE
                             WHEN xyz.m20_instrument_type_code_v09 = 'BN'
                             THEN
                                 ROUND (
                                       (  ROUND (xyz.market_price, 8)
                                        * (  xyz.u24_net_holding
                                           - xyz.u24_manual_block
                                           - xyz.u24_pledge_qty)
                                        * xyz.m20_lot_size)
                                     / 100,
                                     2)
                             ELSE
                                 ROUND (
                                       ROUND (xyz.market_price, 8)
                                     * (  xyz.u24_net_holding
                                        - xyz.u24_manual_block
                                        - xyz.u24_pledge_qty)
                                     * xyz.m20_lot_size,
                                     2)
                         END
                       - cost_basis
                           AS gain_loss
                  FROM (SELECT u01.u01_customer_no AS cutomer_no,
                               u01.u01_id AS mubasher_no,
                               u01.u01_display_name AS custname,
                               u07.u07_exchange_account_no AS security_ac,
                               m20.m20_instrument_type_code_v09
                                   AS instrument_type,
                               vw.h01_exchange_code_m01 AS exchange,
                               vw.h01_symbol_code_m20 AS symbol,
                               DECODE ('E',
                                       'E', m20.m20_short_description,
                                       m20.m20_short_description_lang)
                                   AS short_description,
                               m20.m20_cusip_no AS cusip_no,
                               m20.m20_isincode AS isin_code,
                               m20_instrument_type_code_v09,
                               m20.m20_reuters_code AS ric,
                               vw.h01_net_holding AS u24_net_holding,
                               vw.h01_manual_block u24_manual_block,
                               vw.h01_pledge_qty AS u24_pledge_qty,
                               vw.h01_sell_pending AS u24_sell_pending,
                               m20_lot_size,
                                 vw.h01_net_holding
                               + vw.h01_payable_holding
                               - vw.h01_receivable_holding
                                   AS ownedqty,
                                 vw.h01_net_holding
                               - vw.h01_manual_block
                               - vw.h01_sell_pending
                               - vw.h01_pledge_qty
                                   AS availableqty,
                               ROUND (vw.h01_avg_cost, 2) AS avg_cost,
                               CASE
                                   WHEN m20.m20_instrument_type_code_v09 !=
                                            'BN'
                                   THEN
                                       vw.h01_pledge_qty
                               END
                                   AS pledgedqty,
                               ROUND (vw.h01_avg_price, 2) AS avg_price,
                               CASE
                                   WHEN m20.m20_instrument_type_code_v09 =
                                            'BN'
                                   THEN
                                       vw.h01_net_holding
                               END
                                   AS nominal,
                               CASE
                                   WHEN m20.m20_instrument_type_code_v09 =
                                            'OPT'
                                   THEN
                                       ROUND (m20.m20_strike_price, 2)
                               END
                                   AS strike_price,
                               m20.m20_expire_date AS expiry_date,
                               vw.h01_manual_block AS block_qty,
                               CASE
                                   WHEN m02.m02_price_type_for_margin = 1 -- Last Trade
                                   THEN
                                       esp.lasttradedprice
                                   WHEN m02.m02_price_type_for_margin = 2 -- VWAP
                                   THEN
                                       NVL (esp.vwap, 0)
                                   WHEN m02.m02_price_type_for_margin = 3 -- Previous Closed
                                   THEN
                                       NVL (esp.previousclosed, 0)
                                   WHEN m02.m02_price_type_for_margin = 4 -- Closing Price
                                   THEN
                                       CASE
                                           WHEN NVL (esp.todaysclosed, 0) = 0
                                           THEN
                                               NVL (esp.previousclosed, 0)
                                           ELSE
                                               NVL (esp.todaysclosed, 0)
                                       END
                                   ELSE                             -- Default
                                       esp.lasttradedprice
                               END
                                   AS market_price,
                               CASE
                                   WHEN m20.m20_instrument_type_code_v09 =
                                            'BN'
                                   THEN
                                       ROUND (
                                             (  vw.h01_net_holding
                                              - vw.h01_manual_block
                                              - vw.h01_pledge_qty)
                                           * m20.m20_lot_size
                                           * vw.h01_avg_cost
                                           / 100,
                                           2)
                                   ELSE
                                       ROUND (
                                             (  vw.h01_net_holding
                                              - vw.h01_manual_block
                                              - vw.h01_pledge_qty)
                                           * m20.m20_lot_size
                                           * vw.h01_avg_cost,
                                           2)
                               END
                                   AS cost_basis,
                               vw.h01_sell_pending AS sell_pending,
                               vw.h01_buy_pending AS buy_pending,
                               NULL AS open_sell,
                               NULL AS open_buy,
                               NULL AS net_day_holdings,
                               ABS (vw.h01_short_holdings)
                                   AS covered_call_option,
                               vw.h01_receivable_holding AS receivable_qty,
                               vw.h01_payable_holding AS payable_qty,
                               NULL AS pending_subcribed_qty,
                               NULL AS subscribed_quantity,
                               ROUND (vw.h01_weighted_avg_cost, 2) AS wanc,
                               m78_marginable_per AS margin_per
                          FROM vw_h01_holding_summary vw
                               INNER JOIN u07_trading_account u07
                                   ON u07.u07_id = vw.h01_trading_acnt_id_u07
                               INNER JOIN u01_customer u01
                                   ON u01.u01_id = u07.u07_customer_id_u01
                               INNER JOIN m20_symbol m20
                                   ON m20.m20_id = vw.h01_symbol_id_m20
                               INNER JOIN dfn_price.esp_todays_snapshots esp
                                   ON     esp.symbol = vw.h01_symbol_code_m20
                                      AND vw.h01_exchange_code_m01 =
                                              exchangecode
                               INNER JOIN m02_institute m02
                                   ON m02.m02_id = u01.u01_institute_id_m02
                               INNER JOIN u06_cash_account u06
                                   ON u06.u06_id =
                                          u07.u07_cash_account_id_u06
                               LEFT OUTER JOIN u23_customer_margin_product u23
                                   ON u23.u23_id =
                                          u06.u06_margin_product_id_u23
                               LEFT OUTER JOIN m77_symbol_marginability_grps m77
                                   ON m77.m77_id =
                                          u23.u23_sym_margin_group_m77
                               LEFT OUTER JOIN m78_symbol_marginability m78
                                   ON m78.m78_sym_margin_group_m77 =
                                          m77.m77_id
                         WHERE     vw.h01_symbol_id_m20 =
                                       m78.m78_symbol_id_m20
                               AND vw.h01_date = TRUNC (SYSDATE)) xyz;
        END IF;
    END;


    PROCEDURE get_portfolio_potion_details (p_srvcid       IN     VARCHAR2,
                                            p_chnl_id      IN     VARCHAR2,
                                            p_subchnl_id   IN     VARCHAR2,
                                            p_user_id      IN     VARCHAR2,
                                            p_lang         IN     VARCHAR2,
                                            p_ip           IN     VARCHAR2,
                                            p_session      IN     VARCHAR2,
                                            p_mode         IN     VARCHAR2,
                                            l_date         IN     VARCHAR2,
                                            p_cpt          IN     VARCHAR2,
                                            p_instr        IN     VARCHAR2,
                                            p_port         IN     VARCHAR2,
                                            p_ret_cd          OUT NUMBER,
                                            p_retmsg          OUT VARCHAR2,
                                            p_rs              OUT refcursor)
    IS
        l_sysdate              DATE := SYSDATE;
        pcustomer_id           NUMBER;
        e_invalid_account_no   EXCEPTION;
        pdate                  DATE;
        l_cost_value_usd       NUMBER (30, 5);
        l_market_value_usd     NUMBER (30, 5);
        l_profit_lost_usd      NUMBER (30, 5);
    BEGIN
        /*sec.prc_oms_rpt_access (p_chnl_id,
                                 p_subchnl_id,
                                 p_srvcid,
                                 p_user_id,
                                 p_session,
                                 p_ip,
                                 p_cpt,
                                 p_ret_cd,
                                 p_retmsg);

         IF p_ret_cd != 0
         THEN
             RETURN;
         END IF;*/

        SELECT u01.u01_id
          INTO pcustomer_id
          FROM u01_customer u01
         WHERE u01.u01_customer_no = p_cpt;

        IF (p_mode = 'CDETAILS')
        THEN
            IF TRUNC (pdate) = TRUNC (l_sysdate)
            THEN
                SELECT SUM (cost_basis_usd),
                       SUM (valuation_usd),
                       SUM ( (valuation_usd - cost_basis_usd))
                           AS profit_lost_usd
                  INTO l_cost_value_usd,
                       l_market_value_usd,
                       l_profit_lost_usd
                  FROM (SELECT   cost_basis
                               * get_exchange_rate (vw.u07_institute_id_m02,
                                                    vw.m20_currency_code_m03,
                                                    'USD')
                                   AS cost_basis_usd,
                                 get_exchange_rate (vw.u07_institute_id_m02,
                                                    vw.m20_currency_code_m03,
                                                    'USD')
                               * CASE
                                     WHEN vw.instrument_type = 'BN'
                                     THEN
                                         ROUND (
                                               (  ROUND (vw.market_price, 8)
                                                * (  vw.u24_net_holding
                                                   - vw.u24_manual_block
                                                   - vw.u24_pledge_qty)
                                                * vw.m20_lot_size)
                                             / 100,
                                             2)
                                     ELSE
                                         ROUND (
                                               ROUND (vw.market_price, 8)
                                             * (  vw.u24_net_holding
                                                - vw.u24_manual_block
                                                - vw.u24_pledge_qty)
                                             * vw.m20_lot_size,
                                             2)
                                 END
                                   AS valuation_usd
                          FROM vw_b2b_current_holding vw
                         WHERE vw.u07_customer_id_u01 = pcustomer_id);
            ELSE
                SELECT SUM (cost_basis_usd),
                       SUM (valuation_usd),
                       SUM ( (valuation_usd - cost_basis_usd))
                           AS profit_lost_usd
                  INTO l_cost_value_usd,
                       l_market_value_usd,
                       l_profit_lost_usd
                  FROM (SELECT   cost_basis
                               * get_exchange_rate (vw.u07_institute_id_m02,
                                                    vw.m20_currency_code_m03,
                                                    'USD')
                                   AS cost_basis_usd,
                                 get_exchange_rate (vw.u07_institute_id_m02,
                                                    vw.m20_currency_code_m03,
                                                    'USD')
                               * CASE
                                     WHEN vw.instrument_type = 'BN'
                                     THEN
                                         ROUND (
                                               (  ROUND (vw.market_price, 8)
                                                * (  vw.h01_net_holding
                                                   - vw.h01_manual_block
                                                   - vw.h01_pledge_qty)
                                                * vw.m20_lot_size)
                                             / 100,
                                             2)
                                     ELSE
                                         ROUND (
                                               ROUND (vw.market_price, 8)
                                             * (  vw.h01_net_holding
                                                - vw.h01_manual_block
                                                - vw.h01_pledge_qty)
                                             * vw.m20_lot_size,
                                             2)
                                 END
                                   AS valuation_usd
                          FROM vw_b2b_history_holding vw
                         WHERE     vw.u07_customer_id_u01 = pcustomer_id
                               AND vw.h01_date = TRUNC (pdate));

                OPEN p_rs FOR
                    SELECT u01_customer_no AS customer_no,
                           DECODE ('E', 'E', custname, custname_lang)
                               AS custname,
                           DECODE (p_lang,
                                   'E', u06_currency_code_m03,
                                   m03.m03_description_lang)
                               AS currency,
                           u02_mobile AS contact_no,
                           portfolio AS portfolio_no,
                           TRUNC ( (settle_balance), 4) AS cash_balance,
                           address,
                           l_cost_value_usd AS cost_value_usd,
                           l_market_value_usd AS market_value_usd,
                           l_profit_lost_usd AS profit_lost_usd,
                           pdate AS pdate
                      FROM     vw_b2b_cdetails vw
                           INNER JOIN
                               m03_currency m03
                           ON vw.u06_currency_code_m03 = m03.m03_code
                     WHERE vw.u06_customer_id_u01 = pcustomer_id;

                IF SQL%NOTFOUND
                THEN
                    RAISE e_invalid_account_no;
                END IF;
            END IF;
        END IF;

        IF (p_mode = 'INSTDETAILS')
        THEN
            IF TRUNC (pdate) = TRUNC (l_sysdate)
            THEN
                OPEN p_rs FOR
                    SELECT SUM (cost_basis_usd) cost_value_tot,
                           SUM (valuation_usd) market_value_tot,
                           SUM ( (valuation_usd - cost_basis_usd))
                               AS unrealise_profit_lost_tot,
                           u07_exchange_account_no portfolio_no,
                           instrument_type,
                           u01_customer_no,
                           m20_currency_code_m03 AS currency,
                           m05_name AS country_name,
                           TO_CHAR (SYSDATE, 'dd/mm/yyyy') AS report_date
                      FROM (  SELECT   cost_basis
                                     * get_exchange_rate (
                                           vw.u07_institute_id_m02,
                                           vw.m20_currency_code_m03,
                                           'USD')
                                         AS cost_basis_usd,
                                       get_exchange_rate (
                                           vw.u07_institute_id_m02,
                                           vw.m20_currency_code_m03,
                                           'USD')
                                     * CASE
                                           WHEN vw.instrument_type = 'BN'
                                           THEN
                                               ROUND (
                                                     (  ROUND (vw.market_price,
                                                               8)
                                                      * (  vw.u24_net_holding
                                                         - vw.u24_manual_block
                                                         - vw.u24_pledge_qty)
                                                      * vw.m20_lot_size)
                                                   / 100,
                                                   2)
                                           ELSE
                                               ROUND (
                                                     ROUND (vw.market_price, 8)
                                                   * (  vw.u24_net_holding
                                                      - vw.u24_manual_block
                                                      - vw.u24_pledge_qty)
                                                   * vw.m20_lot_size,
                                                   2)
                                       END
                                         AS valuation_usd,
                                     m05.m05_name,
                                     m20_currency_code_m03,
                                     u07_exchange_account_no,
                                     instrument_type,
                                     u01_customer_no
                                FROM vw_b2b_current_holding vw
                                     INNER JOIN m01_exchanges m01
                                         ON m01.m01_exchange_code = vw.exchange
                                     INNER JOIN vw_b2b_cdetails c
                                         ON c.u06_customer_id_u01 =
                                                vw.u07_customer_id_u01
                                     INNER JOIN m05_country m05
                                         ON m05.m05_id = m01.m01_country_id_m05
                               WHERE vw.u07_customer_id_u01 = pcustomer_id
                            GROUP BY u07_exchange_account_no,
                                     instrument_type,
                                     m05_name,
                                     m20_currency_code_m03,
                                     u01_customer_no);
            ELSE
                OPEN p_rs FOR
                    SELECT SUM (cost_basis_usd) cost_value_tot,
                           SUM (valuation_usd) market_value_tot,
                           SUM ( (valuation_usd - cost_basis_usd))
                               AS unrealise_profit_lost_tot,
                           u01_customer_no AS customer_no,
                           u07_exchange_account_no AS portfolio_no,
                           NULL AS m77_instrument_type,
                           instrument_type AS inst_type_code,
                           m05_name AS country,
                           currency,
                           TO_CHAR (SYSDATE, 'dd/mm/yyyy') AS report_date
                      FROM (  SELECT   cost_basis
                                     * get_exchange_rate (
                                           vw.u07_institute_id_m02,
                                           vw.m20_currency_code_m03,
                                           'USD')
                                         AS cost_basis_usd,
                                       get_exchange_rate (
                                           vw.u07_institute_id_m02,
                                           vw.m20_currency_code_m03,
                                           'USD')
                                     * CASE
                                           WHEN vw.instrument_type = 'BN'
                                           THEN
                                               ROUND (
                                                     (  ROUND (vw.market_price,
                                                               8)
                                                      * (  vw.h01_net_holding
                                                         - vw.h01_manual_block
                                                         - vw.h01_pledge_qty)
                                                      * vw.m20_lot_size)
                                                   / 100,
                                                   2)
                                           ELSE
                                               ROUND (
                                                     ROUND (vw.market_price, 8)
                                                   * (  vw.h01_net_holding
                                                      - vw.h01_manual_block
                                                      - vw.h01_pledge_qty)
                                                   * vw.m20_lot_size,
                                                   2)
                                       END
                                         AS valuation_usd,
                                     m05.m05_name,
                                     m20_currency_code_m03 currency,
                                     u07_exchange_account_no,
                                     instrument_type,
                                     u01_customer_no
                                FROM vw_b2b_history_holding vw
                                     INNER JOIN m01_exchanges m01
                                         ON m01.m01_exchange_code = vw.exchange
                                     INNER JOIN vw_b2b_cdetails c
                                         ON c.u06_customer_id_u01 =
                                                vw.u07_customer_id_u01
                                     INNER JOIN m05_country m05
                                         ON m05.m05_id = m01.m01_country_id_m05
                               WHERE     vw.u07_customer_id_u01 = pcustomer_id
                                     AND vw.h01_date = TRUNC (pdate)
                            GROUP BY u07_exchange_account_no,
                                     instrument_type,
                                     m05_name,
                                     m20_currency_code_m03,
                                     u01_customer_no);
            END IF;
        END IF;

        IF (p_mode = 'TRANDETAILS')
        THEN
            IF TRUNC (pdate) = TRUNC (l_sysdate)
            THEN
                OPEN p_rs FOR
                    SELECT trn.*,
                           (market_value - cost_value) unrealise_profit_lost
                      FROM (SELECT symbol,
                                   DECODE (p_lang,
                                           'E', m20_short_description,
                                           m20_short_description_lang)
                                       AS name,
                                   ownedqty AS quantity,
                                   availableqty AS availableqty,
                                   pledgedqty AS pleadge_amount,
                                   covered_call_option AS covered_call_option,
                                   u24_manual_block AS block_quantity,
                                   m20_currency_code_m03 AS trade_currency,
                                   u24_avg_cost cost_price,
                                   cost_basis cost_value,
                                   market_price AS market_price,
                                   CASE
                                       WHEN vw.instrument_type = 'BN'
                                       THEN
                                           ROUND (
                                                 (  ROUND (vw.market_price,
                                                           8)
                                                  * (  vw.u24_net_holding
                                                     - vw.u24_manual_block
                                                     - vw.u24_pledge_qty)
                                                  * vw.m20_lot_size)
                                               / 100,
                                               2)
                                       ELSE
                                           ROUND (
                                                 ROUND (vw.market_price, 8)
                                               * (  vw.u24_net_holding
                                                  - vw.u24_manual_block
                                                  - vw.u24_pledge_qty)
                                               * vw.m20_lot_size,
                                               2)
                                   END
                                       AS market_value,
                                   instrument_type AS instrument_type,
                                   instrument_type AS instrument_code,
                                   instrument_type AS portfolio_no,
                                   (  u06.u06_balance
                                    + u06.u06_payable_blocked
                                    - u06.u06_receivable_amount)
                                       AS cash_balance,
                                   m05.m05_name AS country_name,
                                   u06.u06_currency_code_m03 AS currency
                              FROM vw_b2b_current_holding vw
                                   INNER JOIN u06_cash_account u06
                                       ON vw.u07_cash_account_id_u06 =
                                              u06.u06_id
                                   INNER JOIN m01_exchanges m01
                                       ON m01.m01_exchange_code = vw.exchange
                                   INNER JOIN m05_country m05
                                       ON m05.m05_id = m01.m01_country_id_m05
                             WHERE vw.u07_exchange_account_no = p_port) trn;
            ELSE
                OPEN p_rs FOR
                    SELECT trn.*,
                           (market_value - cost_value) unrealise_profit_lost
                      FROM (SELECT symbol,
                                   DECODE (p_lang,
                                           'E', m20_short_description,
                                           m20_short_description_lang)
                                       AS name,
                                   ownedqty AS quantity,
                                   availableqty AS availableqty,
                                   pledgedqty AS pleadge_amount,
                                   covered_call_option AS covered_call_option,
                                   vw.h01_manual_block AS block_quantity,
                                   m20_currency_code_m03 AS trade_currency,
                                   vw.h01_avg_cost cost_price,
                                   cost_basis cost_value,
                                   market_price AS market_price,
                                   CASE
                                       WHEN vw.instrument_type = 'BN'
                                       THEN
                                           ROUND (
                                                 (  ROUND (vw.market_price,
                                                           8)
                                                  * (  vw.h01_net_holding
                                                     - vw.h01_manual_block
                                                     - vw.h01_pledge_qty)
                                                  * vw.m20_lot_size)
                                               / 100,
                                               2)
                                       ELSE
                                           ROUND (
                                                 ROUND (vw.market_price, 8)
                                               * (  vw.h01_net_holding
                                                  - vw.h01_manual_block
                                                  - vw.h01_pledge_qty)
                                               * vw.m20_lot_size,
                                               2)
                                   END
                                       AS market_value,
                                   instrument_type AS instrument_type,
                                   instrument_type AS instrument_code,
                                   instrument_type AS portfolio_no,
                                   (  u06.u06_balance
                                    + u06.u06_payable_blocked
                                    - u06.u06_receivable_amount)
                                       AS cash_balance,
                                   m05.m05_name AS country_name,
                                   u06.u06_currency_code_m03 AS currency
                              FROM vw_b2b_history_holding vw
                                   INNER JOIN u06_cash_account u06
                                       ON vw.u07_cash_account_id_u06 =
                                              u06.u06_id
                                   INNER JOIN m01_exchanges m01
                                       ON m01.m01_exchange_code = vw.exchange
                                   INNER JOIN m05_country m05
                                       ON m05.m05_id = m01.m01_country_id_m05
                             WHERE     vw.u07_exchange_account_no = p_port
                                   AND vw.h01_date = TRUNC (pdate)) trn;
            END IF;
        END IF;
    END;

    PROCEDURE holding_sample_report (p_srvcid       IN     VARCHAR2,
                                     p_chnl_id      IN     VARCHAR2,
                                     p_subchnl_id   IN     VARCHAR2,
                                     p_user_id      IN     VARCHAR2,
                                     p_lang         IN     VARCHAR2,
                                     p_ip           IN     VARCHAR2,
                                     p_session      IN     VARCHAR2,
                                     p_portfolio    IN     VARCHAR2,
                                     p_ret_cd          OUT NUMBER,
                                     p_retmsg          OUT VARCHAR2,
                                     p_rs              OUT refcursor)
    IS
    BEGIN
        /* sec.prc_oms_rpt_access (p_chnl_id,
                                 p_subchnl_id,
                                 p_srvcid,
                                 p_user_id,
                                 p_session,
                                 p_ip,
                                 p_portfolio,
                                 p_ret_cd,
                                 p_retmsg);

         IF p_ret_cd != 0
         THEN
             RETURN;
         END IF;*/

        OPEN p_rs FOR
            SELECT i.*, (market_value - t04_total_cost) profit
              FROM (SELECT u07_exchange_account_no AS securityac,
                           symbol t04_symbol,
                           DECODE ('E',
                                   'E', m20_short_description,
                                   m20_short_description_lang)
                               symbolshortdescription_1,
                           ownedqty AS own_qty,
                           ric,
                           isin_code m77_isincode,
                           u24_net_holding,
                           availableqty AS availableqty,
                           u24_avg_cost t04_avg_cost,
                           CASE
                               WHEN vw.instrument_type != 'BN'
                               THEN
                                   vw.u24_pledge_qty
                           END
                               AS t04_pledgedqty,
                           ROUND (avg_price, 2) t04_avg_price,
                           block_qty t04_other_blocked_qty,
                           market_price,
                           cost_basis t04_total_cost,
                           CASE
                               WHEN vw.instrument_type = 'BN'
                               THEN
                                   ROUND (
                                         (  ROUND (vw.market_price, 8)
                                          * (  vw.u24_net_holding
                                             - vw.u24_manual_block
                                             - vw.u24_pledge_qty)
                                          * vw.m20_lot_size)
                                       / 100,
                                       2)
                               ELSE
                                   ROUND (
                                         ROUND (vw.market_price, 8)
                                       * (  vw.u24_net_holding
                                          - vw.u24_manual_block
                                          - vw.u24_pledge_qty)
                                       * vw.m20_lot_size,
                                       2)
                           END
                               AS market_value,
                           CASE
                               WHEN vw.instrument_type = 'BN'
                               THEN
                                   ROUND (
                                         (  ROUND (vw.market_price, 8)
                                          * (  vw.u24_net_holding
                                             - vw.u24_manual_block
                                             - vw.u24_pledge_qty)
                                          * vw.m20_lot_size)
                                       / 100,
                                       2)
                               ELSE
                                   ROUND (
                                         ROUND (vw.market_price, 8)
                                       * (  vw.u24_net_holding
                                          - vw.u24_manual_block
                                          - vw.u24_pledge_qty)
                                       * vw.m20_lot_size
                                       * m78.m78_marginable_per
                                       / 100,
                                       2)
                           END
                               AS margin_market_value,
                           sell_pending t04_sell_pending,
                           buy_pending t04_buy_pending,
                           NULL AS t04_open_sell_cont,
                           NULL AS t04_open_buy_cont,
                           NULL AS t04_net_day_holdings,
                           covered_call_option AS t04_short_holding,
                           receivable_qty t04_pending_settle,
                           payable_qty t04_payable_holding,
                           pending_subcribed_qty t04_pending_subscription,
                           subscribed_quantity t04_subscribed_quantity,
                           m78_marginable_per AS margin_per
                      FROM vw_b2b_current_holding vw
                           INNER JOIN u06_cash_account u06
                               ON u06.u06_id = vw.u07_cash_account_id_u06
                           LEFT OUTER JOIN u23_customer_margin_product u23
                               ON u23.u23_id = u06.u06_margin_product_id_u23
                           LEFT OUTER JOIN m77_symbol_marginability_grps m77
                               ON m77.m77_id = u23.u23_sym_margin_group_m77
                           LEFT OUTER JOIN m78_symbol_marginability m78
                               ON     m78.m78_sym_margin_group_m77 =
                                          m77.m77_id
                                  AND vw.u24_symbol_id_m20 =
                                          m78.m78_symbol_id_m20
                     WHERE     (   ABS (u24_net_holding) > 0
                                OR ABS (u24_pledge_qty) > 0
                                OR ABS (sell_pending) > 0
                                OR ABS (covered_call_option) <> 0
                                OR ABS (payable_qty) <> 0
                                OR ABS (receivable_qty) <> 0)
                           AND u07_exchange_account_no = '') i;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            p_ret_cd := 1;
            p_retmsg := 'No Records';
        WHEN OTHERS
        THEN
            p_ret_cd := 1;
            p_retmsg := 'Error Occured While running query.!';
    END;

    PROCEDURE hsbc_sample_report (p_srvcid       IN     VARCHAR2,
                                  p_chnl_id      IN     VARCHAR2,
                                  p_subchnl_id   IN     VARCHAR2,
                                  p_user_id      IN     VARCHAR2,
                                  p_lang         IN     VARCHAR2,
                                  p_ip           IN     VARCHAR2,
                                  p_session      IN     VARCHAR2,
                                  p_cpt          IN     VARCHAR2,
                                  pfrom_date     IN     VARCHAR2,
                                  pto_date       IN     VARCHAR2,
                                  p_ret_cd          OUT NUMBER,
                                  p_retmsg          OUT VARCHAR2,
                                  p_rs              OUT refcursor)
    IS
    BEGIN
        /*  sec.prc_oms_rpt_access (p_chnl_id,
                                  p_subchnl_id,
                                  p_srvcid,
                                  p_user_id,
                                  p_session,
                                  p_ip,
                                  p_cpt,
                                  p_ret_cd,

                                  p_retmsg);*/
        OPEN p_rs FOR
            SELECT '005' AS broker_code,
                   i.trade_date AS trade_date,
                   i.sett_date AS settle_date,
                   'Saudi Fransi Capital' broker_client_code,
                   UNISTR (REPLACE (i.custname, '\u', '\')) AS investor_name,
                   i.investor_no AS invester_no,
                   i.m13_description_1 AS side,
                   i.m107_short_description AS stockname,
                   i.t01_symbol AS local_isin_no,
                   i.t01_cumqty AS quantity,
                   i.t01_ordvalue AS amount,
                   i.t01_cumnetsettle AS net_amount,
                   t01_exg_commission + brokercommission AS comm,
                   t01_exg_commission AS market_fee,
                   NULL AS broker_reference,
                   NULL AS broker_remarks,
                   NULL AS broker_status,
                   'N' AS trun_around_trade,
                   NULL AS international_broker_nin,
                   NULL AS ib_commission,
                   j.t01_orderid
              FROM (  SELECT TRUNC (MAX (a.t01_last_updated_date_time))
                                 trade_date,
                             MAX (a.t01_cash_settle_date) AS sett_date,
                             u07.u07_exchange_account_no AS investor_no,
                             v01.v01_description AS m13_description_1,
                             m20.m20_short_description
                                 AS m107_short_description,
                             MAX (u07.u07_display_name) AS custname,
                             a.t01_symbol_code_m20 AS t01_symbol,
                             SUM (a.t01_cum_quantity) AS t01_cumqty,
                             SUM (a.t01_cum_ord_value) AS t01_ordvalue,
                             SUM (a.t01_cum_netstl) AS t01_cumnetsettle,
                             SUM (a.t01_cum_exec_brk_commission)
                                 AS t01_exg_commission,
                             SUM (
                                   a.t01_cum_commission
                                 - a.t01_cum_exec_brk_commission)
                                 AS brokercommission,
                             MAX (a.t01_exchange_ord_id) AS t01_orderid
                        FROM t01_order a
                             INNER JOIN u07_trading_account u07
                                 ON u07.u07_exchange_account_no =
                                        a.t01_trading_acntno_u07
                             INNER JOIN v01_system_master_data v01
                                 ON v01_type = 15 AND v01_id = a.t01_side
                             INNER JOIN m20_symbol m20
                                 ON m20.m20_id = a.t01_symbol_id_m20
                       WHERE     a.t01_status_id_v30 IN
                                     ('2', '1', '4', 'q', 'r', '5')
                             AND a.t01_cum_quantity > 0
                             AND a.t01_exchange_code_m01 = 'TDWL'
                             AND u07.u07_customer_no_u01 = p_cpt
                             AND a.t01_last_updated_date_time BETWEEN TO_DATE (
                                                                          pfrom_date, --
                                                                          'dd/mm/yyyy')
                                                                  AND   TO_DATE (
                                                                            pto_date, --
                                                                            'dd/mm/yyyy')
                                                                      + 0.99999
                    GROUP BY a.t01_symbol_code_m20,
                             v01_description,
                             u07_exchange_account_no,
                             m20_short_description) i,
                   (    SELECT t01_symbol_code_m20 AS t01_symbol,
                               t01_trading_acntno_u07 AS t01_routingac,
                               SUBSTR (
                                   MAX (SYS_CONNECT_BY_PATH (t01_orderid, ', ')),
                                   3)
                                   t01_orderid
                          FROM (SELECT ROW_NUMBER ()
                                       OVER (
                                           PARTITION BY t01_symbol_code_m20
                                           ORDER BY
                                               t01_symbol_code_m20,
                                               t01_trading_acntno_u07)
                                           rnum,
                                       t01_symbol_code_m20,
                                       t01_orderid,
                                       t01_trading_acntno_u07
                                  FROM (SELECT a.t01_symbol_code_m20,
                                               a.t01_trading_acntno_u07,
                                               a.t01_exchange_ord_id
                                                   AS t01_orderid
                                          FROM     t01_order a
                                               INNER JOIN
                                                   u07_trading_account u07
                                               ON u07.u07_id =
                                                      a.t01_trading_acc_id_u07
                                         WHERE     a.t01_status_id_v30 IN
                                                       ('2',
                                                        '1',
                                                        '4',
                                                        'q',
                                                        'r',
                                                        '5')
                                               AND a.t01_cum_quantity > 0
                                               AND a.t01_exchange_code_m01 =
                                                       'TDWL'
                                               AND u07.u07_customer_no_u01 =
                                                       p_cpt
                                               AND t01_last_updated_date_time BETWEEN TO_DATE (
                                                                                          pfrom_date,
                                                                                          'dd/mm/yyyy')
                                                                                  AND   TO_DATE (
                                                                                            pto_date,
                                                                                            'dd/mm/yyyy')
                                                                                      + 0.99999))
                    START WITH rnum = 1
                    CONNECT BY     PRIOR rnum = rnum - 1
                               AND PRIOR t01_symbol_code_m20 =
                                       t01_symbol_code_m20
                      GROUP BY t01_symbol_code_m20, t01_trading_acntno_u07
                      ORDER BY t01_symbol_code_m20) j
             WHERE     i.t01_symbol = j.t01_symbol
                   AND j.t01_routingac = i.investor_no;
    END;


    PROCEDURE kamko_daily_trade_report (p_srvcid       IN     VARCHAR2,
                                        p_chnl_id      IN     VARCHAR2,
                                        p_subchnl_id   IN     VARCHAR2,
                                        p_user_id      IN     VARCHAR2,
                                        p_lang         IN     VARCHAR2,
                                        p_ip           IN     VARCHAR2,
                                        p_session      IN     VARCHAR2,
                                        p_account      IN     VARCHAR2,
                                        pfrom_date     IN     VARCHAR2,
                                        pto_date       IN     VARCHAR2,
                                        p_ret_cd          OUT NUMBER,
                                        p_retmsg          OUT VARCHAR2,
                                        p_rs              OUT refcursor)
    IS
    BEGIN
        /*sec.prc_oms_rpt_access (p_chnl_id,
                                p_subchnl_id,
                                p_srvcid,
                                p_user_id,
                                p_session,
                                p_ip,
                                p_account,
                                p_ret_cd,
                                p_retmsg); */

        OPEN p_rs FOR
            SELECT a.t01_trading_acntno_u07 AS portfolio,
                   m20.m20_short_description AS stock_name,
                   a.t01_symbol_id_m20 || '.SE' AS ric,
                   m20.m20_isincode AS isin,
                   TRUNC (t01_last_updated_date_time) AS trade_date,
                   a.t01_cash_settle_date AS settle_date,
                   v01.v01_description AS side,
                   a.t01_avg_price AS trading_price,
                   t01_cum_quantity AS quantity,
                   a.t01_cum_ord_value AS gross_amount,
                   t01_cum_commission AS net_commission,
                   (a.t01_cum_broker_tax + a.t01_cum_exchange_tax) AS vat,
                   a.t01_cum_netstl AS settle_amount,
                   a.t01_cum_net_value AS net_amount,
                   a.t01_avg_cost AS avg_cost,
                   'SFC' AS broker,
                   u06.u06_investment_account_no AS cc_ac,
                   555 AS kamco_client
              FROM t01_order a
                   INNER JOIN u06_cash_account u06
                       ON u06.u06_id = a.t01_cash_acc_id_u06
                   INNER JOIN v01_system_master_data v01
                       ON v01_type = 15 AND v01_id = a.t01_side
                   INNER JOIN m20_symbol m20
                       ON m20.m20_id = a.t01_symbol_id_m20
             WHERE     t01_status_id_v30 IN ('2', '1', '4', 'q', 'r', '5')
                   AND a.t01_cum_quantity > 0
                   AND a.t01_exchange_code_m01 = 'TDWL'
                   AND u06.u06_investment_account_no = p_account
                   AND a.t01_last_updated_date_time BETWEEN TO_DATE (
                                                                pfrom_date,
                                                                'dd/mm/yyyy')
                                                        AND   TO_DATE (
                                                                  pto_date,
                                                                  'dd/mm/yyyy')
                                                            + 0.99999;
    END;

    PROCEDURE trade_notification_report (p_srvcid       IN     VARCHAR2,
                                         p_chnl_id      IN     VARCHAR2,
                                         p_subchnl_id   IN     VARCHAR2,
                                         p_user_id      IN     VARCHAR2,
                                         p_lang         IN     VARCHAR2,
                                         p_ip           IN     VARCHAR2,
                                         p_session      IN     VARCHAR2,
                                         p_fromdate     IN     VARCHAR2,
                                         p_todate       IN     VARCHAR2,
                                         p_portfolio    IN     VARCHAR2,
                                         p_ret_cd          OUT NUMBER,
                                         p_retmsg          OUT VARCHAR2,
                                         p_rs              OUT refcursor)
    IS
    --e_invalid_account_no   EXCEPTION;
    BEGIN
        /* sec.prc_oms_rpt_access (p_chnl_id,
                                 p_subchnl_id,
                                 p_srvcid,
                                 p_user_id,
                                 p_session,
                                 p_ip,
                                 p_portfolio,
                                 p_ret_cd,
                                 p_retmsg);

         IF p_ret_cd != 0
         THEN
             RETURN;
         END IF;*/
        OPEN p_rs FOR
            SELECT ord.*,
                   NVL (t11_prv.t11_filled_volume, 0)
                       AS previous_executed_qty,
                   NVL (t11_prv.t11_value, 0) AS prevoius_executed_value,
                   NVL (t11_prv.t11_price, 0) AS previous_executed_avg_price,
                   NVL (t11_tdy.t11_filled_volume, 0) AS today_executed_qty,
                   NVL (t11_tdy.t11_value, 0) AS today_executed_value,
                   NVL (t11_tdy.t11_price, 0) AS today_executed_avg_price,
                     NVL (t11_prv.t11_filled_volume, 0)
                   + NVL (t11_tdy.t11_filled_volume, 0)
                       AS executed_qty_till_date,
                   NVL (t11_prv.t11_value, 0) + NVL (t11_tdy.t11_value, 0)
                       AS executed_value_till_date,
                   DECODE (
                         NVL (t11_prv.t11_filled_volume, 0)
                       + NVL (t11_tdy.t11_filled_volume, 0),
                       0, 0,
                       ROUND (
                             (  NVL (t11_prv.t11_value, 0)
                              + NVL (t11_tdy.t11_value, 0))
                           / (  NVL (t11_prv.t11_filled_volume, 0)
                              + NVL (t11_tdy.t11_filled_volume, 0)),
                           2))
                       AS executed_avg_price_till_date
              FROM (SELECT DECODE (p_lang, 'E', custname, custname_lang)
                               custname,
                           address,
                           u06_investment_account_no AS account_no,
                           portfolio AS portfolio_no,
                           t01.t01_cash_settle_date AS settlement_date,
                           t01.t01_ord_no AS order_no,
                           v01.v01_description AS order_type,
                           DECODE (p_lang,
                                   'E', v30.v30_description,
                                   v30.v30_description_lang)
                               AS order_status,
                           t01.t01_exchange_ord_id AS esis_no,
                           DECODE (p_lang,
                                   'E', m20.m20_short_description,
                                   m20_short_description_lang)
                               AS stock_name,
                           t01.t01_quantity AS order_qty,
                           t01.t01_last_price AS price,
                           TRUNC (t01.t01_db_created_date) AS order_date,
                           t01.t01_expiry_date AS tif_date,
                           t01.t01_symbol_code_m20 AS symbol,
                           t01.t01_cum_commission commission,
                           (t01.t01_cum_broker_tax + t01.t01_cum_exchange_tax)
                               AS vat,
                           t01.t01_cum_netstl AS net_value,
                           vw.m02_vat_no AS tin
                      FROM vw_b2b_cdetails vw
                           INNER JOIN t01_order t01
                               ON vw.u06_customer_id_u01 =
                                      t01.t01_customer_id_u01
                           INNER JOIN v01_system_master_data v01
                               ON v01_type = 15 AND v01_id = t01.t01_side
                           INNER JOIN v30_order_status v30
                               ON v30.v30_status_id = t01.t01_status_id_v30
                           INNER JOIN m20_symbol m20
                               ON m20.m20_id = t01.t01_symbol_id_m20
                     WHERE     t01.t01_status_id_v30 IN
                                   ('2', '1', '4', 'q', 'r', '5')
                           AND t01.t01_cum_quantity > 0
                           AND t01.t01_last_updated_date_time BETWEEN TRUNC (
                                                                          TO_DATE (
                                                                              p_fromdate,
                                                                              'dd/mm/yyyy'))
                                                                  AND   TRUNC (
                                                                            TO_DATE (
                                                                                p_todate,
                                                                                'dd/mm/yyyy'))
                                                                      + 0.99999
                           AND portfolio = p_portfolio) ord,
                   (  SELECT t02_order_no t11_orderno,
                             SUM (t02.t02_last_shares) t11_filled_volume,
                             SUM (t02.t02_ord_value_adjst) AS t11_value,
                             ROUND (AVG (t02.t02_last_price), 8) AS t11_price
                        FROM t02_transaction_log t02
                       WHERE t02.t02_create_datetime BETWEEN   TRUNC (
                                                                   TO_DATE (
                                                                       p_fromdate,
                                                                       'dd/mm/yyyy'))
                                                             - 1000
                                                         AND   TRUNC (
                                                                   TO_DATE (
                                                                       p_fromdate,
                                                                       'dd/mm/yyyy'))
                                                             + 0.99999
                    GROUP BY t02.t02_order_no) t11_prv,
                   (  SELECT t02_order_no t11_orderno,
                             SUM (t02.t02_last_shares) t11_filled_volume,
                             SUM (t02.t02_ord_value_adjst) AS t11_value,
                             ROUND (AVG (t02.t02_last_price), 8) AS t11_price
                        FROM t02_transaction_log t02
                       WHERE t02.t02_create_datetime BETWEEN TRUNC (
                                                                 TO_DATE (
                                                                     p_fromdate,
                                                                     'dd/mm/yyyy'))
                                                         AND   TRUNC (
                                                                   TO_DATE (
                                                                       p_fromdate,
                                                                       'dd/mm/yyyy'))
                                                             + 0.99999
                    GROUP BY t02.t02_order_no) t11_tdy
             WHERE     t11_prv.t11_orderno = ord.order_no
                   AND t11_tdy.t11_orderno = ord.order_no;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            p_ret_cd := 1;
            p_retmsg := 'No Records';
        WHEN OTHERS
        THEN
            p_ret_cd := 1;
            p_retmsg := 'Error Occured While running query.!';
    END;
END;
/
