CREATE OR REPLACE PACKAGE dfn_ntp.pkg_sfc_ams_inquiries
IS
    TYPE refcursor IS REF CURSOR;

    PROCEDURE get_ams_order_list (p_svc_id           IN     VARCHAR2,
                                  p_channel_id       IN     VARCHAR2,
                                  p_sub_channel_id   IN     VARCHAR2,
                                  p_user_id          IN     VARCHAR2,
                                  p_lang             IN     VARCHAR2,
                                  p_ip_addr          IN     VARCHAR2,
                                  p_pf_no            IN     VARCHAR2,
                                  p_order_no         IN     VARCHAR2,
                                  p_from_date        IN     DATE,
                                  p_to_date          IN     DATE,
                                  p_type             IN     NUMBER,
                                  p_ret_cd              OUT NUMBER,
                                  p_ret_desc            OUT VARCHAR2,
                                  p_rs                  OUT refcursor);

    PROCEDURE get_ams_order_execution (p_svc_id           IN     VARCHAR2,
                                       p_channel_id       IN     VARCHAR2,
                                       p_sub_channel_id   IN     VARCHAR2,
                                       p_user_id          IN     VARCHAR2,
                                       p_lang             IN     VARCHAR2,
                                       p_ip_addr          IN     VARCHAR2,
                                       p_ord_no           IN     VARCHAR2,
                                       p_ret_cd              OUT NUMBER,
                                       p_ret_desc            OUT VARCHAR2,
                                       p_rs                  OUT refcursor);

    PROCEDURE get_ams_cash_inquiry (p_svc_id           IN     VARCHAR2,
                                    p_channel_id       IN     VARCHAR2,
                                    p_sub_channel_id   IN     VARCHAR2,
                                    p_user_id          IN     VARCHAR2,
                                    p_lang             IN     VARCHAR2,
                                    p_ip_addr          IN     VARCHAR2,
                                    p_pinv_no          IN     VARCHAR2,
                                    p_ret_cd              OUT NUMBER,
                                    p_ret_desc            OUT VARCHAR2,
                                    p_rs                  OUT refcursor);

    PROCEDURE get_ams_portfolio_inquiry (p_svc_id           IN     VARCHAR2,
                                         p_channel_id       IN     VARCHAR2,
                                         p_sub_channel_id   IN     VARCHAR2,
                                         p_user_id          IN     VARCHAR2,
                                         p_lang             IN     VARCHAR2,
                                         p_ip_addr          IN     VARCHAR2,
                                         p_pf_no            IN     VARCHAR2,
                                         p_cust_no          IN     VARCHAR2,
                                         p_symbol_cd        IN     VARCHAR2,
                                         p_ret_cd              OUT NUMBER,
                                         p_ret_desc            OUT VARCHAR2,
                                         p_rs                  OUT refcursor);

    PROCEDURE get_cash_blocked_list (
        p_view                OUT refcursor,
        p_svc_id           IN     VARCHAR2,
        p_channel_id       IN     VARCHAR2,
        p_sub_channel_id   IN     VARCHAR2,
        p_user_id          IN     VARCHAR2,
        p_lang             IN     VARCHAR2,
        p_ip_addr          IN     VARCHAR2,
        p_external_ref     IN     VARCHAR2 DEFAULT NULL,
        p_fromdate         IN     DATE,
        p_todate           IN     DATE);

    PROCEDURE get_pledge_request_list (
        p_view                 OUT refcursor,
        p_svc_id            IN     VARCHAR2,
        p_channel_id        IN     VARCHAR2,
        p_sub_channel_id    IN     VARCHAR2,
        p_user_id           IN     VARCHAR2,
        p_lang              IN     VARCHAR2,
        p_ip_addr           IN     VARCHAR2,
        p_exchange_acc_no   IN     VARCHAR2 DEFAULT NULL,
        p_fromdate          IN     DATE,
        p_todate            IN     DATE);

    PROCEDURE get_stock_transaction_list (
        p_svc_id            IN     VARCHAR2,
        p_channel_id        IN     VARCHAR2,
        p_sub_channel_id    IN     VARCHAR2,
        p_user_id           IN     VARCHAR2,
        p_lang              IN     VARCHAR2 DEFAULT 'EN',
        p_ip_addr           IN     VARCHAR2,
        p_exchange_acc_no   IN     VARCHAR2 DEFAULT NULL,
        p_from_date         IN     DATE,
        p_to_date           IN     DATE,
        p_ret_cd               OUT NUMBER,
        p_ret_desc             OUT VARCHAR2,
        p_rs                   OUT refcursor);


    PROCEDURE get_cash_transaction_list (
        p_svc_id           IN     VARCHAR2,
        p_channel_id       IN     VARCHAR2,
        p_sub_channel_id   IN     VARCHAR2,
        p_user_id          IN     VARCHAR2,
        p_lang             IN     VARCHAR2 DEFAULT 'EN',
        p_ip_addr          IN     VARCHAR2,
        p_pinv_no          IN     VARCHAR2 DEFAULT NULL,
        p_from_date        IN     DATE,
        p_to_date          IN     DATE,
        p_ret_cd              OUT NUMBER,
        p_ret_desc            OUT VARCHAR2,
        p_rs                  OUT refcursor);

    PROCEDURE get_symbol_marginabiliy_list (
        p_svc_id           IN     VARCHAR2,
        p_channel_id       IN     VARCHAR2,
        p_sub_channel_id   IN     VARCHAR2,
        p_user_id          IN     VARCHAR2,
        p_lang             IN     VARCHAR2 DEFAULT 'EN',
        p_ip_addr          IN     VARCHAR2,
        p_symbol           IN     VARCHAR2 DEFAULT NULL,
        p_ret_cd              OUT NUMBER,
        p_ret_desc            OUT VARCHAR2,
        p_rs                  OUT refcursor);

    PROCEDURE get_accrued_interest_inquiry (
        p_svc_id           IN     VARCHAR2,
        p_channel_id       IN     VARCHAR2,
        p_sub_channel_id   IN     VARCHAR2,
        p_user_id          IN     VARCHAR2,
        p_lang             IN     VARCHAR2 DEFAULT 'EN',
        p_ip_addr          IN     VARCHAR2,
        p_pinv_no          IN     VARCHAR2 DEFAULT NULL,
        p_fromdate         IN     DATE,
        p_todate           IN     DATE,
        p_ret_cd              OUT NUMBER,
        p_ret_desc            OUT VARCHAR2,
        p_rs                  OUT refcursor);

    PROCEDURE get_pending_amount_inquiry (pdate     IN     DATE,
                                          pivn      IN     VARCHAR2,
                                          pcursor      OUT SYS_REFCURSOR);

    PROCEDURE get_pending_settlement_inquiry (pivn      IN     VARCHAR2,
                                              pcursor      OUT SYS_REFCURSOR);

    PROCEDURE get_od_loan_balance_inquiry (pcursor          OUT SYS_REFCURSOR,
                                           pivn          IN     VARCHAR2,
                                           ptradingacc   IN     VARCHAR2);

    PROCEDURE get_vat_invoice_reports (p_srvcid       IN     VARCHAR2,
                                       p_chnl_id      IN     VARCHAR2,
                                       p_subchnl_id   IN     VARCHAR2,
                                       p_user_id      IN     VARCHAR2,
                                       p_lang         IN     VARCHAR2,
                                       p_ip           IN     VARCHAR2,
                                       p_session_id   IN     VARCHAR2,
                                       p_cust_no      IN     VARCHAR2,
                                       p_month        IN     VARCHAR2,
                                       p_year         IN     VARCHAR2,
                                       p_invoice_no   IN     VARCHAR2,
                                       p_mode         IN     VARCHAR2,
                                       p_ret_cd          OUT NUMBER,
                                       retmsg            OUT VARCHAR2,
                                       pcursor           OUT SYS_REFCURSOR);

    PROCEDURE generate_vat_invoice (l_fromdate      DATE,
                                    l_todate        DATE,
                                    p_cust_no    IN VARCHAR2);

    PROCEDURE get_market_sector_inquiry (exchange   IN     VARCHAR2,
                                         pcursor       OUT SYS_REFCURSOR);
END;
/


CREATE OR REPLACE PACKAGE BODY dfn_ntp.pkg_sfc_ams_inquiries
IS
    PROCEDURE get_ams_order_list (p_svc_id           IN     VARCHAR2,
                                  p_channel_id       IN     VARCHAR2,
                                  p_sub_channel_id   IN     VARCHAR2,
                                  p_user_id          IN     VARCHAR2,
                                  p_lang             IN     VARCHAR2,
                                  p_ip_addr          IN     VARCHAR2,
                                  p_pf_no            IN     VARCHAR2,
                                  p_order_no         IN     VARCHAR2,
                                  p_from_date        IN     DATE,
                                  p_to_date          IN     DATE,
                                  p_type             IN     NUMBER,
                                  p_ret_cd              OUT NUMBER,
                                  p_ret_desc            OUT VARCHAR2,
                                  p_rs                  OUT refcursor)
    IS
    BEGIN
        p_ret_cd := 0;

        IF p_type = 1
        THEN
            OPEN p_rs FOR
                SELECT *
                  FROM vw_ams_order_list ord
                 WHERE     ord.t01_portfoliono = p_pf_no
                       AND ord.t01_expiry_date >= TRUNC (SYSDATE);
        ELSIF (p_type = 2)
        THEN
            OPEN p_rs FOR
                SELECT *
                  FROM vw_ams_order_list ord
                 WHERE     ord.t01_portfoliono = p_pf_no
                       AND ord.orddate BETWEEN TRUNC (p_from_date)
                                           AND TRUNC (p_to_date) + 0.99999;
        ELSE
            OPEN p_rs FOR
                SELECT *
                  FROM vw_ams_order_list ord
                 WHERE ord.t01_portfoliono = p_pf_no AND ordno = p_order_no;
        END IF;
    EXCEPTION
        WHEN OTHERS
        THEN
            NULL;
    END;

    PROCEDURE get_ams_order_execution (p_svc_id           IN     VARCHAR2,
                                       p_channel_id       IN     VARCHAR2,
                                       p_sub_channel_id   IN     VARCHAR2,
                                       p_user_id          IN     VARCHAR2,
                                       p_lang             IN     VARCHAR2,
                                       p_ip_addr          IN     VARCHAR2,
                                       p_ord_no           IN     VARCHAR2,
                                       p_ret_cd              OUT NUMBER,
                                       p_ret_desc            OUT VARCHAR2,
                                       p_rs                  OUT refcursor)
    AS
    BEGIN
        p_ret_cd := 0;

        OPEN p_rs FOR
              SELECT t02_order_exec_id AS "SNO",
                     t02.t02_order_no AS "ORDERNO",
                     t02_db_create_date AS "EXECDATE",
                     t02_last_shares AS "FILLEDQTY",
                     t02_last_price AS "EXECPRICE",
                     t02_commission_adjst AS "COMMISSION",
                     ABS (t02_amnt_in_txn_currency) AS "NETVALUE",
                     (  t02_exchange_tax
                      + t02_exec_cma_tax
                      + t02_exec_cpp_tax
                      + t02_exec_dcm_tax)
                         AS t11_exchange_vat,
                     t02_broker_tax AS t11_broker_vat,
                       (  t02_exchange_tax
                        + t02_exec_cma_tax
                        + t02_exec_cpp_tax
                        + t02_exec_dcm_tax)
                     + t02_broker_tax
                         AS total_vat
                FROM t02_transaction_log t02
               WHERE t02_order_no = p_ord_no
            ORDER BY 1;
    END get_ams_order_execution;


    PROCEDURE get_ams_cash_inquiry (p_svc_id           IN     VARCHAR2,
                                    p_channel_id       IN     VARCHAR2,
                                    p_sub_channel_id   IN     VARCHAR2,
                                    p_user_id          IN     VARCHAR2,
                                    p_lang             IN     VARCHAR2,
                                    p_ip_addr          IN     VARCHAR2,
                                    p_pinv_no          IN     VARCHAR2,
                                    p_ret_cd              OUT NUMBER,
                                    p_ret_desc            OUT VARCHAR2,
                                    p_rs                  OUT refcursor)
    AS
    BEGIN
        p_ret_cd := 0;

        OPEN p_rs FOR
            SELECT u06_currency_code_m03 AS currency,
                   u06_investment_account_no AS pinv_no,
                     u06_balance
                   - (  u06_blocked
                      + u06_manual_transfer_blocked
                      + u06.u06_manual_full_blocked
                      + u06.u06_loan_amount
                      + u06.u06_net_receivable)
                       AS availcashbalance,
                   -u06_blocked AS blockamt,
                   u06_manual_full_blocked AS otherblockamt,
                   u06_manual_transfer_blocked AS transferblockamt,
                   u06_receivable_amount AS pendingsettle,
                     u06_balance
                   - (  u06_blocked
                      + u06_manual_transfer_blocked
                      + u06.u06_manual_full_blocked
                      + u06.u06_loan_amount
                      + u06.u06_net_receivable)
                       AS transferableamount
              FROM u06_cash_account u06
             WHERE u06.u06_investment_account_no = p_pinv_no;
    END get_ams_cash_inquiry;


    PROCEDURE get_ams_portfolio_inquiry (p_svc_id           IN     VARCHAR2,
                                         p_channel_id       IN     VARCHAR2,
                                         p_sub_channel_id   IN     VARCHAR2,
                                         p_user_id          IN     VARCHAR2,
                                         p_lang             IN     VARCHAR2,
                                         p_ip_addr          IN     VARCHAR2,
                                         p_pf_no            IN     VARCHAR2,
                                         p_cust_no          IN     VARCHAR2,
                                         p_symbol_cd        IN     VARCHAR2,
                                         p_ret_cd              OUT NUMBER,
                                         p_ret_desc            OUT VARCHAR2,
                                         p_rs                  OUT refcursor)
    AS
    BEGIN
        p_ret_cd := 0;

        OPEN p_rs FOR
            SELECT portfoliono,
                   mktid,
                   stockcode,
                   stockbalqty,
                   avgprice,
                   pledgeqty,
                   avgcost,
                   blockqty,
                   avlqty,
                   lasttradeprice,
                   stockname,
                   (market_value - cost_value) AS unrealizeprofit,
                   ROUND (
                       (CASE
                            WHEN (    (market_value - cost_value) <> 0
                                  AND cost_value <> 0)
                            THEN
                                  ( (market_value - cost_value) / cost_value)
                                * 100
                            ELSE
                                0
                        END),
                       4)
                       AS unrealizeprofitperc
              FROM (SELECT portfoliono,
                           mktid,
                           stockcode,
                           stockbalqty,
                           avgprice,
                           pledgeqty,
                           avgcost,
                           blockqty,
                           avlqty,
                           lasttradeprice,
                           DECODE (p_lang,
                                   'A', shortdesc_2,
                                   shortdesc_1 || '-hs')
                               AS stockname,
                           stockbalqty * lasttradeprice AS market_value,
                           stockbalqty * avgprice AS cost_value
                      FROM (SELECT u07.u07_exchange_account_no AS portfoliono,
                                   u24.u24_exchange_code_m01 AS mktid,
                                   u24.u24_symbol_code_m20 AS stockcode,
                                   (  u24.u24_net_holding
                                    + u24.u24_payable_holding
                                    - u24.u24_receivable_holding)
                                       AS stockbalqty,
                                   u24.u24_pledge_qty AS pledgeqty,
                                   ROUND (u24.u24_avg_cost, 2) AS avgcost,
                                   ROUND (u24.u24_avg_price, 2) AS avgprice,
                                   u24.u24_manual_block AS blockqty,
                                   (  u24.u24_net_holding
                                    - u24.u24_pledge_qty
                                    - u24.u24_holding_block
                                    - u24.u24_manual_block)
                                       AS avlqty,
                                   CASE
                                       WHEN esp.lasttradeprice > 0
                                       THEN
                                           ROUND (esp.lasttradeprice, 2)
                                       ELSE
                                           ROUND (esp.previousclosed, 2)
                                   END
                                       AS lasttradeprice,
                                   NVL (sym.symbolshortdescription_1,
                                        u24.u24_symbol_code_m20)
                                       AS shortdesc_1,
                                   NVL (sym.symbolshortdescription_2,
                                        u24.u24_symbol_code_m20)
                                       AS shortdesc_2
                              FROM dfn_ntp.u24_holdings u24
                                   INNER JOIN dfn_ntp.u07_trading_account u07
                                       ON u07.u07_id =
                                              u24.u24_trading_acnt_id_u07
                                   INNER JOIN dfn_price.esp_todays_snapshots esp
                                       ON     u24_exchange_code_m01 =
                                                  esp.exchangecode
                                          AND u24_symbol_code_m20 =
                                                  esp.symbol
                                   INNER JOIN dfn_price.esp_symbolmap sym
                                       ON     u24_exchange_code_m01 =
                                                  sym.exchange
                                          AND u24_symbol_code_m20 =
                                                  sym.symbol
                                          AND u07.u07_exchange_account_no =
                                                  p_pf_no));
    END get_ams_portfolio_inquiry;



    PROCEDURE get_cash_blocked_list (
        p_view                OUT refcursor,
        p_svc_id           IN     VARCHAR2,
        p_channel_id       IN     VARCHAR2,
        p_sub_channel_id   IN     VARCHAR2,
        p_user_id          IN     VARCHAR2,
        p_lang             IN     VARCHAR2,
        p_ip_addr          IN     VARCHAR2,
        p_external_ref     IN     VARCHAR2 DEFAULT NULL,
        p_fromdate         IN     DATE,
        p_todate           IN     DATE)
    IS
    BEGIN
        IF p_external_ref IS NOT NULL
        THEN
            OPEN p_view FOR
                SELECT id,
                       blockedamount,
                       fromdate,
                       todate,
                       narration,
                       status,
                       createddate,
                       userid,
                       externalref,
                       created_by,
                       custname
                  FROM vw_ams_transfer_block
                 WHERE     externalref = p_external_ref
                       AND createddate BETWEEN TRUNC (p_fromdate)
                                           AND TRUNC (p_todate) + 0.99999;
        ELSE
            OPEN p_view FOR
                SELECT id,
                       blockedamount,
                       fromdate,
                       todate,
                       narration,
                       status,
                       createddate,
                       userid,
                       externalref,
                       created_by,
                       custname
                  FROM vw_ams_transfer_block
                 WHERE createddate BETWEEN TRUNC (p_fromdate)
                                       AND TRUNC (p_todate) + 0.99999;
        END IF;
    END;


    PROCEDURE get_pledge_request_list (
        p_view                 OUT refcursor,
        p_svc_id            IN     VARCHAR2,
        p_channel_id        IN     VARCHAR2,
        p_sub_channel_id    IN     VARCHAR2,
        p_user_id           IN     VARCHAR2,
        p_lang              IN     VARCHAR2,
        p_ip_addr           IN     VARCHAR2,
        p_exchange_acc_no   IN     VARCHAR2 DEFAULT NULL,
        p_fromdate          IN     DATE,
        p_todate            IN     DATE)
    IS
    BEGIN
        IF p_exchange_acc_no IS NOT NULL
        THEN
            OPEN p_view FOR
                  SELECT *
                    FROM vw_ams_pledge a
                   WHERE     enterdate BETWEEN TRUNC (p_fromdate)
                                           AND TRUNC (p_todate) + 0.99999
                         AND a.exchangeaccountno = p_exchange_acc_no
                ORDER BY a.id DESC;
        ELSE
            OPEN p_view FOR
                  SELECT *
                    FROM vw_ams_pledge a
                   WHERE enterdate BETWEEN TRUNC (p_fromdate)
                                       AND TRUNC (p_todate) + 0.99999
                ORDER BY a.id DESC;
        END IF;
    END get_pledge_request_list;


    PROCEDURE get_stock_transaction_list (
        p_svc_id            IN     VARCHAR2,
        p_channel_id        IN     VARCHAR2,
        p_sub_channel_id    IN     VARCHAR2,
        p_user_id           IN     VARCHAR2,
        p_lang              IN     VARCHAR2 DEFAULT 'EN',
        p_ip_addr           IN     VARCHAR2,
        p_exchange_acc_no   IN     VARCHAR2 DEFAULT NULL,
        p_from_date         IN     DATE,
        p_to_date           IN     DATE,
        p_ret_cd               OUT NUMBER,
        p_ret_desc             OUT VARCHAR2,
        p_rs                   OUT refcursor)
    IS
    BEGIN
        p_ret_cd := 0;

        IF p_exchange_acc_no IS NOT NULL
        THEN
            OPEN p_rs FOR
                  SELECT *
                    FROM vw_ams_stock_transaction a
                   WHERE     a.createddate BETWEEN TRUNC (p_from_date)
                                               AND TRUNC (p_to_date) + 0.99999
                         AND a.portfoliono = p_exchange_acc_no
                ORDER BY a.transactionid DESC;
        ELSE
            OPEN p_rs FOR
                  SELECT *
                    FROM vw_ams_stock_transaction a
                   WHERE a.createddate BETWEEN TRUNC (p_from_date)
                                           AND TRUNC (p_to_date) + 0.99999
                ORDER BY a.transactionid DESC;
        END IF;
    END get_stock_transaction_list;


    PROCEDURE get_cash_transaction_list (
        p_svc_id           IN     VARCHAR2,
        p_channel_id       IN     VARCHAR2,
        p_sub_channel_id   IN     VARCHAR2,
        p_user_id          IN     VARCHAR2,
        p_lang             IN     VARCHAR2 DEFAULT 'EN',
        p_ip_addr          IN     VARCHAR2,
        p_pinv_no          IN     VARCHAR2 DEFAULT NULL,
        p_from_date        IN     DATE,
        p_to_date          IN     DATE,
        p_ret_cd              OUT NUMBER,
        p_ret_desc            OUT VARCHAR2,
        p_rs                  OUT refcursor)
    IS
    BEGIN
        p_ret_cd := 0;

        IF p_pinv_no IS NOT NULL
        THEN
            OPEN p_rs FOR
                  SELECT *
                    FROM vw_ams_cash_transaction_list a
                   WHERE     a.transactiondate BETWEEN TRUNC (p_from_date)
                                                   AND   TRUNC (p_to_date)
                                                       + 0.99999
                         AND a.fromacc = p_pinv_no
                ORDER BY a.transactionid ASC;
        ELSE
            OPEN p_rs FOR
                  SELECT *
                    FROM vw_ams_cash_transaction_list a
                   WHERE a.transactiondate BETWEEN TRUNC (p_from_date)
                                               AND TRUNC (p_to_date) + 0.99999
                ORDER BY a.transactionid ASC;
        END IF;
    END get_cash_transaction_list;

    PROCEDURE get_symbol_marginabiliy_list (
        p_svc_id           IN     VARCHAR2,
        p_channel_id       IN     VARCHAR2,
        p_sub_channel_id   IN     VARCHAR2,
        p_user_id          IN     VARCHAR2,
        p_lang             IN     VARCHAR2 DEFAULT 'EN',
        p_ip_addr          IN     VARCHAR2,
        p_symbol           IN     VARCHAR2 DEFAULT NULL,
        p_ret_cd              OUT NUMBER,
        p_ret_desc            OUT VARCHAR2,
        p_rs                  OUT refcursor)
    IS
    BEGIN
        p_ret_cd := 0;

        IF p_symbol IS NULL
        THEN
            OPEN p_rs FOR
                  SELECT *
                    FROM vw_ams_symbol_margin_list vw
                ORDER BY vw.m78_symbol_id_m20 ASC;
        ELSE
            OPEN p_rs FOR
                  SELECT *
                    FROM vw_ams_symbol_margin_list vw
                   WHERE vw.symbol LIKE '%' || p_symbol || '%'
                ORDER BY vw.m78_symbol_id_m20 ASC;
        END IF;
    END get_symbol_marginabiliy_list;


    PROCEDURE get_accrued_interest_inquiry (
        p_svc_id           IN     VARCHAR2,
        p_channel_id       IN     VARCHAR2,
        p_sub_channel_id   IN     VARCHAR2,
        p_user_id          IN     VARCHAR2,
        p_lang             IN     VARCHAR2 DEFAULT 'EN',
        p_ip_addr          IN     VARCHAR2,
        p_pinv_no          IN     VARCHAR2 DEFAULT NULL,
        p_fromdate         IN     DATE,
        p_todate           IN     DATE,
        p_ret_cd              OUT NUMBER,
        p_ret_desc            OUT VARCHAR2,
        p_rs                  OUT refcursor)
    IS
    BEGIN
        p_ret_cd := 0;

        IF p_pinv_no IS NOT NULL
        THEN
            OPEN p_rs FOR
                  SELECT *
                    FROM vw_ams_accrued_interest a
                   WHERE     a.u06_investment_account_no = p_pinv_no
                         AND a.created_date BETWEEN p_fromdate
                                                AND p_todate + 0.99999
                ORDER BY a.created_date DESC;
        ELSE
            OPEN p_rs FOR
                  SELECT *
                    FROM vw_ams_accrued_interest a
                   WHERE a.created_date BETWEEN p_fromdate
                                            AND p_todate + 0.99999
                ORDER BY a.created_date DESC;
        END IF;
    END get_accrued_interest_inquiry;

    PROCEDURE get_pending_amount_inquiry (pdate     IN     DATE,
                                          pivn      IN     VARCHAR2,
                                          pcursor      OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN pcursor FOR
              SELECT a.cpt,
                     a.customername AS customername,
                     a.currency AS basecurrency,
                     a.t06_amt_in_settle_currency AS t12_amt_in_settle_currency,
                     a.currency AS t12_transaction_currency,
                     a.amount AS t12_amt_in_trans_currency,
                     a.t06_status_id AS t12_status,
                     a.status,
                     a.transactiondate AS t12_date,
                     a.t12_exchange_vat,
                     a.t12_broker_vat,
                     a.total_vat
                FROM vw_ams_cash_transaction_list a
               WHERE     a.transactiondate BETWEEN TRUNC (pdate)
                                               AND TRUNC (pdate) + 0.99999
                     AND a.t06_code != 'FTB'
                     AND a.fromacc = pivn
            ORDER BY a.transactionid ASC;
    END get_pending_amount_inquiry;


    PROCEDURE get_pending_settlement_inquiry (pivn      IN     VARCHAR2,
                                              pcursor      OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN pcursor FOR
            SELECT u06.u06_receivable_amount AS receivableamount,
                   u06.u06_payable_blocked AS payableamount,
                   u01.u01_customer_no AS cpt
              FROM     u06_cash_account u06
                   INNER JOIN
                       u01_customer u01
                   ON u01.u01_id = u06.u06_customer_id_u01
             WHERE u06.u06_investment_account_no = pivn;
    END get_pending_settlement_inquiry;


    PROCEDURE get_od_loan_balance_inquiry (pcursor          OUT SYS_REFCURSOR,
                                           pivn          IN     VARCHAR2,
                                           ptradingacc   IN     VARCHAR2)
    IS
    BEGIN
        OPEN pcursor FOR
            SELECT u06.u06_loan_amount AS loandue,
                   u23.u23_max_margin_limit AS marginlimit,
                   u23.u23_max_limit_currency_m03 AS currency,
                   u23.u23_margin_expiry_date AS expirydate,
                   u01.u01_customer_no cpt,
                   CASE
                       WHEN u06.u06_balance < 0
                       THEN
                           (u06.u06_loan_amount - u06.u06_balance)
                       ELSE
                           0
                   END
                       AS limitutilized
              FROM u06_cash_account u06
                   INNER JOIN u01_customer u01
                       ON u01.u01_id = u06.u06_customer_id_u01
                   LEFT OUTER JOIN u07_trading_account u07
                       ON     u07.u07_cash_account_id_u06 = u06.u06_id
                          AND u07.u07_exchange_account_no = ptradingacc
                   LEFT OUTER JOIN u23_customer_margin_product u23
                       ON u23.u23_id = u06.u06_margin_product_id_u23
             WHERE     u06.u06_investment_account_no = pivn
                   AND u06.u06_margin_enabled = 1;
    END;

    PROCEDURE get_market_sector_inquiry (exchange   IN     VARCHAR2,
                                         pcursor       OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN pcursor FOR
              SELECT m63_id AS sectorid, m63_description AS description
                FROM m63_sectors
               WHERE m63_status_id_v01 = 2 AND m63_exchange_code_m01 = exchange
            ORDER BY m63_id;
    END get_market_sector_inquiry;


    PROCEDURE get_vat_invoice_reports (p_srvcid       IN     VARCHAR2,
                                       p_chnl_id      IN     VARCHAR2,
                                       p_subchnl_id   IN     VARCHAR2,
                                       p_user_id      IN     VARCHAR2,
                                       p_lang         IN     VARCHAR2,
                                       p_ip           IN     VARCHAR2,
                                       p_session_id   IN     VARCHAR2,
                                       p_cust_no      IN     VARCHAR2,
                                       p_month        IN     VARCHAR2,
                                       p_year         IN     VARCHAR2,
                                       p_invoice_no   IN     VARCHAR2,
                                       p_mode         IN     VARCHAR2,
                                       p_ret_cd          OUT NUMBER,
                                       retmsg            OUT VARCHAR2,
                                       pcursor           OUT SYS_REFCURSOR)
    IS
        l_type              VARCHAR2 (20);
        v_req_msg_other     VARCHAR2 (500);
        l_no                t49_tax_invoice_details.t49_invoice_no_t48%TYPE;
        l_cust_id           u01_customer.u01_id%TYPE;
        l_fromdate          DATE;
        l_todate            DATE;
        l_buy_service_ar    VARCHAR2 (500);
        l_sell_service_ar   VARCHAR2 (500);
    BEGIN
        /*
      sec.prc_oms_valid_access (p_chnl_id,
                                p_subchnl_id,
                                p_srvcid,
                                p_user_id,
                                p_session_id,
                                p_ip,
                                p_ret_cd,
                                retmsg);

        IF p_ret_cd = 1                                              -- return
        THEN
            RETURN;
        END IF;
                            */

        SELECT UNISTR (
                   REPLACE (
                       '\u062E\u062F\u0645\u0627\u062A \u0648\u0633\u0627\u0637\u0629 - \u0634\u0631\u0627\u0621',
                       'u'))
          INTO l_buy_service_ar
          FROM DUAL;

        SELECT UNISTR (
                   REPLACE (
                       '\u062E\u062F\u0645\u0627\u062A \u0648\u0633\u0627\u0637\u0629 \u2013\u0628\u064A\u0639',
                       'u'))
          INTO l_sell_service_ar
          FROM DUAL;

        SELECT TO_DATE (p_month || '-' || p_year, 'MM-YYYY')
          INTO l_fromdate
          FROM DUAL;

        SELECT LAST_DAY (l_fromdate) INTO l_todate FROM DUAL;


        IF p_mode = 'V'
        THEN
            OPEN pcursor FOR
                SELECT t48_invoice_no AS invoice_number,
                       u01_customer_no AS customer_number,
                       u01.u01_display_name AS customer_name,
                       TRUNC (t48_from_date) AS from_date,
                       TRUNC (t48_to_date) AS TO_DATE,
                       t48_txn_code AS transaction_type
                  FROM     t48_tax_invoices a
                       INNER JOIN
                           u01_customer u01
                       ON     t48_customer_id_u01 = u01.u01_id
                          AND u01.u01_customer_no = p_cust_no
                 WHERE t48_from_date BETWEEN TRUNC (l_fromdate)
                                         AND TRUNC (l_todate);
        ELSIF p_mode = 'V1'
        THEN
            SELECT t48_txn_code
              INTO l_type
              FROM     t48_tax_invoices a
                   INNER JOIN
                       u01_customer u01
                   ON     t48_customer_id_u01 = u01.u01_id
                      AND u01.u01_customer_no = p_cust_no
                      AND a.t48_invoice_no = p_invoice_no;

            IF l_type = 'ALL'
            THEN
                OPEN pcursor FOR
                      SELECT MAX (from_name) from_name,
                             MAX (from_address) from_address,
                             MAX (customer_name) customer_name,
                             MAX (NVL (address, address_ar)) AS to_address,
                             MAX (vat_number) vat_number,
                             MAX (t48_issue_date) AS issue_date,
                             MAX (invoice_no) invoice_no,
                             NULL AS due_date,
                             MAX (total_excl_vat) total_excl_vat,
                             MAX (vat_no_of_supplying_company)
                                 vat_no_of_supplying_company,
                             MAX (vat) vat,
                             MAX (total) total,
                             NULL AS balance_due,
                             MAX (
                                    (TRUNC (t48_from_date))
                                 || ' to '
                                 || (TRUNC (t48_to_date)))
                                 AS from_to_date,
                             MAX (vat_rate) vat_rate,
                             MAX (description) description
                        FROM vw_vat_invoice
                       WHERE     u01_customer_no = p_cust_no
                             AND invoice_no = p_invoice_no
                    GROUP BY t05_code, vat_rate
                    ORDER BY description;
            ELSIF (   l_type = 'STLBUY'
                   OR l_type = 'STLSEL'
                   OR l_type = 'REVBUY'
                   OR l_type = 'REVSEL')
            THEN
                OPEN pcursor FOR
                      SELECT MAX (from_name) from_name,
                             MAX (from_address) from_address,
                             MAX (customer_name) customer_name,
                             MAX (NVL (address, address_ar)) AS to_address,
                             MAX (vat_number) vat_number,
                             MAX (t48_issue_date) AS issue_date,
                             MAX (invoice_no) invoice_no,
                             NULL AS due_date,
                             MAX (total_excl_vat) total_excl_vat,
                             MAX (vat_no_of_supplying_company)
                                 vat_no_of_supplying_company,
                             MAX (vat) vat,
                             MAX (total) total,
                             NULL AS balance_due,
                             MAX (
                                    (TRUNC (t48_from_date))
                                 || ' to '
                                 || (TRUNC (t48_to_date)))
                                 AS from_to_date,
                             MAX (vat_rate) vat_rate
                        FROM vw_vat_invoice
                       WHERE     u01_customer_no = p_cust_no
                             AND invoice_no = p_invoice_no
                             AND t05_code = l_type
                    GROUP BY supply_date, t05_code, vat_rate
                    ORDER BY supply_date;
            ELSE
                OPEN pcursor FOR
                      SELECT MAX (from_name) from_name,
                             MAX (from_address) from_address,
                             MAX (customer_name) customer_name,
                             MAX (NVL (address, address_ar)) AS to_address,
                             MAX (vat_number) vat_number,
                             MAX (t48_issue_date) AS issue_date,
                             MAX (invoice_no) invoice_no,
                             NULL AS due_date,
                             MAX (total_excl_vat) total_excl_vat,
                             MAX (vat_no_of_supplying_company)
                                 vat_no_of_supplying_company,
                             MAX (vat) vat,
                             MAX (total) total,
                             NULL AS balance_due,
                             MAX (
                                    (TRUNC (t48_from_date))
                                 || ' to '
                                 || (TRUNC (t48_to_date)))
                                 AS from_to_date,
                             MAX (vat_rate) vat_rate
                        FROM vw_vat_invoice
                       WHERE     u01_customer_no = p_cust_no
                             AND invoice_no = p_invoice_no
                             AND t05_code = l_type
                    GROUP BY supply_date, t05_code
                    ORDER BY supply_date;
            END IF;
        ELSIF p_mode = 'V2'
        THEN
            SELECT t48_txn_code
              INTO l_type
              FROM     t48_tax_invoices a
                   INNER JOIN
                       u01_customer u01
                   ON     t48_customer_id_u01 = u01.u01_id
                      AND u01.u01_customer_no = p_cust_no
                      AND a.t48_invoice_no = p_invoice_no;


            IF l_type = 'ALL'
            THEN
                OPEN pcursor FOR
                      SELECT MAX (from_name) from_name,
                             MAX (from_address) from_address,
                             MAX (customer_name) customer_name,
                             MAX (NVL (address, address_ar)) AS to_address,
                             MAX (vat_number) vat_number,
                             MAX (t48_issue_date) AS issue_date,
                             MAX (invoice_no) invoice_no,
                             NULL AS due_date,
                             MAX (total_excl_vat) total_excl_vat,
                             MAX (vat_no_of_supplying_company)
                                 vat_no_of_supplying_company,
                             MAX (vat) vat,
                             MAX (total) total,
                             NULL AS balance_due,
                             MAX (
                                    (TRUNC (t48_from_date))
                                 || ' to '
                                 || (TRUNC (t48_to_date)))
                                 AS from_to_date,
                             CASE description
                                 WHEN 'Buy'
                                 THEN
                                     MAX (
                                            'Brokerage Service-Buy - '
                                         || l_buy_service_ar)
                                 WHEN 'Sell'
                                 THEN
                                     MAX (
                                            'Brokerage Service-Sell - '
                                         || l_sell_service_ar)
                                 ELSE
                                     MAX (description)
                             END
                                 AS description,
                             MAX (vat_rate) vat_rate
                        FROM vw_vat_invoice
                       WHERE     u01_customer_no = p_cust_no
                             AND invoice_no = p_invoice_no
                    GROUP BY t05_code, vat_rate
                    ORDER BY supply_date;
            ELSIF (   l_type = 'STLBUY'
                   OR l_type = 'STLSEL'
                   OR l_type = 'REVBUY'
                   OR l_type = 'REVSEL')
            THEN
                OPEN pcursor FOR
                      SELECT MAX (from_name) from_name,
                             MAX (from_address) from_address,
                             MAX (customer_name) customer_name,
                             MAX (NVL (address, address_ar)) AS to_address,
                             MAX (vat_number) vat_number,
                             MAX (t48_issue_date) AS issue_date,
                             MAX (invoice_no) invoice_no,
                             NULL AS due_date,
                             MAX (total_excl_vat) total_excl_vat,
                             MAX (vat_no_of_supplying_company)
                                 vat_no_of_supplying_company,
                             MAX (vat) vat,
                             MAX (total) total,
                             NULL AS balance_due,
                             MAX (
                                    (TRUNC (t48_from_date))
                                 || ' to '
                                 || (TRUNC (t48_to_date)))
                                 AS from_to_date,
                             CASE description
                                 WHEN 'Buy'
                                 THEN
                                     MAX (
                                            'Brokerage Service-Buy - '
                                         || l_buy_service_ar)
                                 WHEN 'Sell'
                                 THEN
                                     MAX (
                                            'Brokerage Service-Sell - '
                                         || l_sell_service_ar)
                                 ELSE
                                     MAX (description)
                             END
                                 AS description,
                             MAX (vat_rate) vat_rate
                        FROM vw_vat_invoice
                       WHERE     u01_customer_no = p_cust_no
                             AND invoice_no = p_invoice_no
                             AND t05_code = l_type
                             AND vat_rate <> 0
                    GROUP BY supply_date, t05_code, vat_rate
                    ORDER BY supply_date;
            ELSE
                OPEN pcursor FOR
                      SELECT MAX (from_name) from_name,
                             MAX (from_address) from_address,
                             MAX (customer_name) customer_name,
                             MAX (NVL (address, address_ar)) AS to_address,
                             MAX (vat_number) vat_number,
                             MAX (t48_issue_date) AS issue_date,
                             MAX (invoice_no) invoice_no,
                             NULL AS due_date,
                             MAX (total_excl_vat) total_excl_vat,
                             MAX (vat_no_of_supplying_company)
                                 vat_no_of_supplying_company,
                             MAX (vat) vat,
                             MAX (total) total,
                             NULL AS balance_due,
                             MAX (
                                    (TRUNC (t48_from_date))
                                 || ' to '
                                 || (TRUNC (t48_to_date)))
                                 AS from_to_date,
                             CASE description
                                 WHEN 'Buy'
                                 THEN
                                     MAX (
                                            'Brokerage Service-Buy - '
                                         || l_buy_service_ar)
                                 WHEN 'Sell'
                                 THEN
                                     MAX (
                                            'Brokerage Service-Sell - '
                                         || l_sell_service_ar)
                                 ELSE
                                     MAX (description)
                             END
                                 AS description,
                             MAX (vat_rate) vat_rate
                        FROM vw_vat_invoice
                       WHERE     u01_customer_no = p_cust_no
                             AND invoice_no = p_invoice_no
                             AND t05_code = l_type
                             AND vat_rate <> 0
                    GROUP BY supply_date, t05_code
                    ORDER BY supply_date;
            END IF;
        ELSIF p_mode = 'G'
        THEN
            pkg_sfc_ams_inquiries.generate_vat_invoice (l_fromdate,
                                                        l_todate,
                                                        p_cust_no);
        END IF;
    END get_vat_invoice_reports;


    PROCEDURE generate_vat_invoice (l_fromdate      DATE,
                                    l_todate        DATE,
                                    p_cust_no    IN VARCHAR2)
    IS
        CURSOR pcursor
        IS
            SELECT u06.*
              FROM     u01_customer u01
                   INNER JOIN
                       u06_cash_account u06
                   ON u01.u01_id = u06.u06_customer_id_u01
             WHERE u01_customer_no = p_cust_no;

        l_cash_acc_row   u06_cash_account%ROWTYPE;
        l_sequence_id    NUMBER := 0;
        l_sequence_no    VARCHAR (20);
        l_user_id        NUMBER := 0;
    BEGIN
        SELECT u17_id
          INTO l_user_id
          FROM u17_employee
         WHERE u17_login_name = 'INTEGRATION_USER';

        SELECT app_seq_value, LPAD (app_seq_value, 10, 0)
          INTO l_sequence_id, l_sequence_no
          FROM app_seq_store
         WHERE app_seq_name = 'T48_TAX_INVOICES';

        OPEN pcursor;

        LOOP
            FETCH pcursor INTO l_cash_acc_row;

            EXIT WHEN pcursor%NOTFOUND;

            INSERT INTO t48_tax_invoices (t48_id,
                                          t48_invoice_no,
                                          t48_customer_id_u01,
                                          t48_from_date,
                                          t48_to_date,
                                          t48_issue_date,
                                          t48_txn_code,
                                          t48_created_by_id_u17,
                                          t48_custom_type,
                                          t48_institute_id_m02,
                                          t48_eom_report,
                                          t48_cash_account_id_u06)
                 VALUES (l_sequence_id,
                         l_sequence_no,
                         l_cash_acc_row.u06_customer_no_u01,
                         l_fromdate,
                         l_todate,
                         SYSDATE,
                         'ALL',
                         l_user_id,
                         '1',
                         l_cash_acc_row.u06_institute_id_m02,
                         0,
                         l_cash_acc_row.u06_id);


            FOR i
                IN (SELECT t02_last_db_seq_id, t02_txn_code
                      FROM t02_transaction_log t02
                     WHERE     t02.t02_cash_acnt_id_u06 =
                                   l_cash_acc_row.u06_id
                           AND t02_create_date BETWEEN SYSDATE
                                                   AND SYSDATE + 0.99999)
            LOOP
                INSERT
                  INTO t49_tax_invoice_details (t49_invoice_no_t48,
                                                t49_last_db_seq_id_t02,
                                                t49_txn_code)
                VALUES (l_sequence_no, i.t02_last_db_seq_id, i.t02_txn_code);
            END LOOP;



            l_sequence_id := l_sequence_id + 1;
        END LOOP;

        CLOSE pcursor;

        UPDATE app_seq_store
           SET app_seq_value = l_sequence_id
         WHERE app_seq_name = 'T48_TAX_INVOICES';
    END generate_vat_invoice;
END;
/
