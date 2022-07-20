-- Updating Customer Margin Product for All Cash Accounts & Enabling Group Buying Power

BEGIN
    MERGE INTO dfn_ntp.u06_cash_account u06
         USING (  SELECT u06_map.new_cash_account_id,
                         MAX (u23_map.new_cust_margin_prod_id)
                             AS new_cust_margin_prod_id,
                         CASE
                             WHEN     MAX (u05.u05_mrg_trd_enabled) = 1
                                  AND MAX (u23.u23_margin_expired) = 1
                             THEN
                                 2 -- Expired
                             WHEN MAX (u05.u05_mrg_trd_enabled) = 1
                             THEN
                                 1 -- Enabled
                             ELSE
                                 0 -- No
                         END
                             AS margin_enabled
                    FROM mubasher_oms.u05_security_accounts@mubasher_db_link u05,
                         u06_cash_account_mappings u06_map,
                         u23_cust_margin_prod_mappings u23_map,
                         dfn_ntp.u23_customer_margin_product u23
                   WHERE     u05.u05_cash_account_id =
                                 u06_map.old_cash_account_id
                         AND u05.u05_customer_margin_product =
                                 u23_map.old_cust_margin_prod_id
                         AND u23_map.new_cust_margin_prod_id = u23.u23_id
                GROUP BY u06_map.new_cash_account_id) margin
            ON (u06.u06_id = margin.new_cash_account_id)
    WHEN MATCHED
    THEN
        UPDATE SET
            u06.u06_margin_enabled = margin.margin_enabled,
            u06.u06_group_bp_enable =
                CASE WHEN margin.margin_enabled = 1 THEN 0 ELSE 1 END,
            u06.u06_margin_product_id_u23 = margin.new_cust_margin_prod_id;
END;
/

UPDATE dfn_ntp.u06_cash_account u06
   SET u06.u06_margin_enabled = 0
 WHERE u06.u06_margin_enabled IS NULL;

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('U06_CASH_ACCOUNT');
END;
/

-- Updating Customer Margin Product Default and Other Cash Accounts Considering First Cash Account as the Default & Rest as Other

BEGIN
    FOR i
        IN (SELECT u23_map.new_cust_margin_prod_id,
                   cust_margin.default_cash_account,
                   cust_margin.other_cash_accounts
              FROM     (  SELECT u05.u05_customer_margin_product,
                                 CASE
                                     WHEN INSTR (
                                              LISTAGG (
                                                  u05.u05_cash_account_id,
                                                  ',')
                                              WITHIN GROUP (ORDER BY u05.u05_cash_account_id),
                                              ',') > 0
                                     THEN
                                         SUBSTR (
                                             LISTAGG (
                                                 u05.u05_cash_account_id,
                                                 ',')
                                             WITHIN GROUP (ORDER BY
                                                               u05.u05_cash_account_id),
                                             0,
                                               INSTR (
                                                   LISTAGG (
                                                       u05.u05_cash_account_id,
                                                       ',')
                                                   WITHIN GROUP (ORDER BY
                                                                     u05.u05_cash_account_id),
                                                   ',')
                                             - 1)
                                     ELSE
                                         LISTAGG (
                                             u05.u05_cash_account_id,
                                             ',')
                                         WITHIN GROUP (ORDER BY
                                                           u05.u05_cash_account_id)
                                 END
                                     AS default_cash_account,
                                 CASE
                                     WHEN INSTR (
                                              LISTAGG (
                                                  u05.u05_cash_account_id,
                                                  ',')
                                              WITHIN GROUP (ORDER BY u05.u05_cash_account_id),
                                              ',') > 0
                                     THEN
                                         SUBSTR (
                                             LISTAGG (
                                                 u05.u05_cash_account_id,
                                                 ',')
                                             WITHIN GROUP (ORDER BY
                                                               u05.u05_cash_account_id),
                                               INSTR (
                                                   LISTAGG (
                                                       u05.u05_cash_account_id,
                                                       ',')
                                                   WITHIN GROUP (ORDER BY
                                                                     u05.u05_cash_account_id),
                                                   ',')
                                             + 1)
                                 END
                                     AS other_cash_accounts
                            FROM mubasher_oms.u05_security_accounts@mubasher_db_link u05,
                                 u06_cash_account_mappings u06_map
                           WHERE     u05.u05_cash_account_id =
                                         u06_map.old_cash_account_id
                                 AND u05.u05_customer_margin_product > 0
                        GROUP BY u05.u05_customer_margin_product) cust_margin
                   JOIN
                       u23_cust_margin_prod_mappings u23_map
                   ON cust_margin.u05_customer_margin_product =
                          u23_map.old_cust_margin_prod_id)
    LOOP
        UPDATE dfn_ntp.u23_customer_margin_product u23
           SET u23.u23_default_cash_acc_id_u06 = i.default_cash_account,
               u23.u23_other_cash_acc_ids_u06 = i.other_cash_accounts
         WHERE u23.u23_id = i.new_cust_margin_prod_id;
    END LOOP;
END;
/

COMMIT;

-- Apply Cash Account Restrictions

BEGIN
    FOR i IN (SELECT u11_cash_account_id_u06
                FROM dfn_ntp.u11_cash_restriction
               WHERE u11_restriction_type_id_v31 = 9) --Deposit
    LOOP
        UPDATE dfn_ntp.u30_login_cash_acc
           SET u30_deposit = 1
         WHERE u30_cash_acc_id_u06 = i.u11_cash_account_id_u06;
    END LOOP;

    FOR i IN (SELECT u11_cash_account_id_u06
                FROM dfn_ntp.u11_cash_restriction
               WHERE u11_restriction_type_id_v31 = 10) --Withdraw
    LOOP
        UPDATE dfn_ntp.u30_login_cash_acc
           SET u30_withdraw = 1
         WHERE u30_cash_acc_id_u06 = i.u11_cash_account_id_u06;
    END LOOP;

    FOR i IN (SELECT u11_cash_account_id_u06
                FROM dfn_ntp.u11_cash_restriction
               WHERE u11_restriction_type_id_v31 = 11) --Transfer
    LOOP
        UPDATE dfn_ntp.u30_login_cash_acc
           SET u30_transfer = 1
         WHERE u30_cash_acc_id_u06 = i.u11_cash_account_id_u06;
    END LOOP;
END;
/

COMMIT;

-- Apply Trading Account Restrictions

BEGIN
    FOR i IN (SELECT u12_trading_account_id_u07
                FROM dfn_ntp.u12_trading_restriction
               WHERE u12_restriction_type_id_v31 = 1)
    LOOP
        UPDATE dfn_ntp.u10_login_trading_acc
           SET u10_buy = 1
         WHERE u10_trading_acc_id_u07 = i.u12_trading_account_id_u07;
    END LOOP;

    FOR i IN (SELECT u12_trading_account_id_u07
                FROM dfn_ntp.u12_trading_restriction
               WHERE u12_restriction_type_id_v31 = 2)
    LOOP
        UPDATE dfn_ntp.u10_login_trading_acc
           SET u10_sell = 1
         WHERE u10_trading_acc_id_u07 = i.u12_trading_account_id_u07;
    END LOOP;

    FOR i IN (SELECT u12_trading_account_id_u07
                FROM dfn_ntp.u12_trading_restriction
               WHERE u12_restriction_type_id_v31 = 6)
    LOOP
        UPDATE dfn_ntp.u10_login_trading_acc
           SET u10_deposit = 1
         WHERE u10_trading_acc_id_u07 = i.u12_trading_account_id_u07;
    END LOOP;

    FOR i IN (SELECT u12_trading_account_id_u07
                FROM dfn_ntp.u12_trading_restriction
               WHERE u12_restriction_type_id_v31 = 7)
    LOOP
        UPDATE dfn_ntp.u10_login_trading_acc
           SET u10_withdraw = 1
         WHERE u10_trading_acc_id_u07 = i.u12_trading_account_id_u07;
    END LOOP;

    FOR i IN (SELECT u12_trading_account_id_u07
                FROM dfn_ntp.u12_trading_restriction
               WHERE u12_restriction_type_id_v31 = 8)
    LOOP
        UPDATE dfn_ntp.u10_login_trading_acc
           SET u10_transfer = 1
         WHERE u10_trading_acc_id_u07 = i.u12_trading_account_id_u07;
    END LOOP;
END;
/

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('U10_LOGIN_TRADING_ACC');
END;
/

-- Updating Trading Account Pending Restriction Flag

BEGIN
    FOR i
        IN (  SELECT u12.u12_trading_account_id_u07,
                     CASE WHEN COUNT (*) > 0 THEN 1 ELSE 0 END AS is_enabled
                FROM dfn_ntp.u12_trading_restriction u12
            GROUP BY u12.u12_trading_account_id_u07)
    LOOP
        UPDATE dfn_ntp.u07_trading_account u07
           SET u07.u07_pending_restriction = i.is_enabled
         WHERE u07.u07_id = i.u12_trading_account_id_u07;
    END LOOP;
END;
/

COMMIT;

-- Updating Customer Last Login Channel

BEGIN
    MERGE INTO dfn_ntp.u09_customer_login u09
         USING (SELECT last_login.*
                  FROM dfn_ntp.u09_customer_login u09,
                       (SELECT a18_login_id, a18_channel_id_v29
                          FROM (SELECT a18_channel_id_v29,
                                       a18_login_id,
                                       a18_login_time,
                                       RANK ()
                                       OVER (PARTITION BY a18_login_id
                                             ORDER BY a18_login_time DESC)
                                           AS RANK
                                  FROM dfn_ntp.a18_user_login_audit
                                 WHERE a18_entity_type = 1)
                         WHERE RANK = 1) last_login
                 WHERE u09.u09_id = last_login.a18_login_id) last_login
            ON (u09.u09_id = last_login.a18_login_id)
    WHEN MATCHED
    THEN
        UPDATE SET
            u09.u09_last_login_channel_id_v29 = last_login.a18_channel_id_v29;
END;
/

COMMIT;

-- Updating Desk Order References in Order Table

BEGIN
    dfn_ntp.sp_stat_gather ('U09_CUSTOMER_LOGIN');
END;
/

BEGIN
    IF fn_use_new_key ('T01_ORDER') = 1
    THEN
        FOR i
            IN (SELECT t01.t01_cl_ord_id,
                       t52_map.new_desk_orders_id,
                       t52.t52_orderno
                  FROM dfn_ntp.t01_order t01,
                       t52_desk_orders_mappings t52_map,
                       dfn_ntp.t52_desk_orders t52
                 WHERE     t01.t01_desk_order_ref_t52 =
                               t52_map.old_desk_orders_id
                       AND t52_map.new_desk_orders_id = t52.t52_order_id)
        LOOP
            UPDATE dfn_ntp.t01_order t01
               SET t01.t01_desk_order_ref_t52 = NVL (i.new_desk_orders_id, -1),
                   t01.t01_desk_order_no_t52 = NVL (i.t52_orderno, -1)
             WHERE t01.t01_cl_ord_id = i.t01_cl_ord_id;
        END LOOP;
    END IF;
END;
/

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('T01_ORDER');
END;
/

-- Updating Cash Tranacation Reference in Transaction Table

BEGIN
    FOR i
        IN (SELECT t02.t02_audit_key, t06_map.new_cash_transaction_id
              FROM dfn_ntp.t02_transaction_log t02,
                   t06_cash_transaction_mappings t06_map
             WHERE     t02.t02_update_type = 2
                   AND t02.t02_cashtxn_id = t06_map.old_cash_transaction_id)
    LOOP
        UPDATE dfn_ntp.t02_transaction_log t02
           SET t02.t02_cashtxn_id = i.new_cash_transaction_id
         WHERE t02.t02_audit_key = i.t02_audit_key;
    END LOOP;
END;
/

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('T02_TRANSACTION_LOG');
END;
/

-- Updating Customer External Reference Across All Tables & Cash External References to Display Name and Investment Acc No

BEGIN
    UPDATE dfn_ntp.u01_customer u01
       SET u01.u01_customer_no = u01.u01_external_ref_no;

    COMMIT;

    UPDATE dfn_ntp.u06_cash_account u06
       SET u06.u06_display_name =
               u06.u06_external_ref_no || '-' || u06.u06_currency_code_m03,
           u06.u06_investment_account_no = u06.u06_external_ref_no
     WHERE u06.u06_investment_account_no NOT IN ('OMNIPINV', 'FTFTOAC'); -- [Janaka Requetsed] Required for Transfer Charges. This is Automatically Updates U07, H02 & U08 Accordingly

    COMMIT;

    MERGE INTO dfn_ntp.u07_trading_account u07
         USING dfn_ntp.u06_cash_account u06
            ON (u07.u07_cash_account_id_u06 = u06.u06_id)
    WHEN MATCHED
    THEN
        UPDATE SET u07_display_name_u06 = u06.u06_display_name;

    COMMIT;

    MERGE INTO dfn_ntp.h02_cash_account_summary h02
         USING dfn_ntp.u06_cash_account u06
            ON (h02.h02_cash_account_id_u06 = u06.u06_id)
    WHEN MATCHED
    THEN
        UPDATE SET
            h02.h02_investment_account_no = u06.u06_investment_account_no;

    COMMIT;

    MERGE INTO dfn_ntp.h09_cash_account_update h09
         USING dfn_ntp.u06_cash_account u06
            ON (h09.h09_cash_acc_id_u06 = u06.u06_id)
    WHEN MATCHED
    THEN
        UPDATE SET h09.h09_investor_acc_no = u06.u06_investment_account_no;

    COMMIT;

    MERGE INTO dfn_ntp.u06_cash_account u06
         USING dfn_ntp.u01_customer u01
            ON (u06.u06_customer_id_u01 = u01.u01_id)
    WHEN MATCHED
    THEN
        UPDATE SET u06.u06_customer_no_u01 = u01.u01_customer_no;

    COMMIT;

    MERGE INTO dfn_ntp.u07_trading_account u07
         USING dfn_ntp.u01_customer u01
            ON (u07.u07_customer_id_u01 = u01.u01_id)
    WHEN MATCHED
    THEN
        UPDATE SET u07.u07_customer_no_u01 = u01.u01_customer_no;

    COMMIT;

    MERGE INTO dfn_ntp.t02_transaction_log t02
         USING dfn_ntp.u01_customer u01
            ON (t02.t02_customer_id_u01 = u01.u01_id)
    WHEN MATCHED
    THEN
        UPDATE SET t02.t02_customer_no = u01.u01_customer_no;

    COMMIT;

    MERGE INTO dfn_ntp.t54_slice_orders t54
         USING dfn_ntp.u01_customer u01
            ON (t54.t54_customer_id = u01.u01_id)
    WHEN MATCHED
    THEN
        UPDATE SET t54.t54_mubasher_no = u01.u01_customer_no;

    COMMIT;

    MERGE INTO dfn_ntp.t38_conditional_order t38
         USING dfn_ntp.u01_customer u01
            ON (t38.t38_customer_id_u01 = u01.u01_id)
    WHEN MATCHED
    THEN
        UPDATE SET t38.t38_customer_no = u01.u01_customer_no;

    COMMIT;

    MERGE INTO dfn_ntp.u08_customer_beneficiary_acc u08
         USING dfn_ntp.u06_cash_account u06
            ON (    u08.u08_account_id = u06.u06_id
                AND u08.u08_account_type_v01_id = 1
                AND u06.u06_display_name IS NOT NULL)
    WHEN MATCHED
    THEN
        UPDATE SET u08.u08_account_no = u06.u06_display_name;
END;
/

COMMIT;

-- Updating Order Limit Group in Cash Account

BEGIN
    FOR i
        IN (SELECT u06.u06_id, m176_map.new_order_limit_grp_id
              FROM mubasher_oms.t03_cash_account@mubasher_db_link t03,
                   u06_cash_account_mappings u06_map,
                   dfn_ntp.u06_cash_account u06,
                   m176_order_limit_grp_mappings m176_map
             WHERE     t03.t03_account_id = u06_map.old_cash_account_id
                   AND u06_map.new_cash_account_id = u06.u06_id
                   AND u06.u06_institute_id_m02 = m176_map.new_institute_id
                   AND t03.t03_transaction_group_id =
                           m176_map.old_order_limit_grp_id)
    LOOP
        UPDATE dfn_ntp.u06_cash_account u06
           SET u06.u06_order_limit_grp_id_m176 = i.new_order_limit_grp_id
         WHERE u06.u06_id = i.u06_id;
    END LOOP;
END;
/

COMMIT;

-- Updating Transfer Limit Group in Cash Account

BEGIN
    FOR i
        IN (SELECT u06.u06_id, m177_map.new_csh_trns_lmt_grp_id
              FROM mubasher_oms.t03_cash_account@mubasher_db_link t03,
                   u06_cash_account_mappings u06_map,
                   dfn_ntp.u06_cash_account u06,
                   m177_csh_trns_lmt_grp_mappings m177_map
             WHERE     t03.t03_account_id = u06_map.old_cash_account_id
                   AND u06_map.new_cash_account_id = u06.u06_id
                   AND u06.u06_institute_id_m02 = m177_map.new_institute_id
                   AND t03.t03_cash_transfer_limit_group =
                           m177_map.old_csh_trns_lmt_grp_id)
    LOOP
        UPDATE dfn_ntp.u06_cash_account u06
           SET u06.u06_transfer_limit_grp_id_m177 = i.new_csh_trns_lmt_grp_id
         WHERE u06.u06_id = i.u06_id;
    END LOOP;
END;
/

COMMIT;

-- Updating Dealer Incentive Groups

BEGIN
    FOR i
        IN (SELECT m162_map.new_incentive_group_id, u17_map.new_employee_id
              FROM mubasher_oms.m86_agent_comm_group_members@mubasher_db_link m86,
                   m162_incentive_group_mappings m162_map,
                   dfn_ntp.m162_incentive_group m162,
                   u17_employee_mappings u17_map
             WHERE     m86.m86_commission_group =
                           m162_map.old_incentive_group_id
                   AND m86.m86_employee_id = u17_map.old_employee_id
                   AND m162_map.new_incentive_group_id = m162.m162_id
                   AND m162.m162_group_type_id_v01 = 2 -- Dealer
                                                      )
    LOOP
        UPDATE dfn_ntp.u17_employee u17
           SET u17.u17_dealer_cmsn_grp_id_m162 = i.new_incentive_group_id
         WHERE u17.u17_id = i.new_employee_id;
    END LOOP;
END;
/

COMMIT;

-- Updating Asset Management Company

BEGIN
    FOR i
        IN (SELECT m20_ext.m20_id, m178_map.new_asset_mngmnt_comp_id
              FROM dfn_ntp.m20_symbol_extended m20_ext,
                   dfn_ntp.m20_symbol m20,
                   m178_asset_mngmnt_cmp_mappings m178_map
             WHERE     m20_ext.m20_id = m20.m20_id
                   AND m20_ext.m20_amc = m178_map.old_asset_mngmnt_comp_id
                   AND m20.m20_institute_id_m02 = m178_map.new_institute_id)
    LOOP
        UPDATE dfn_ntp.m20_symbol_extended
           SET m20_amc = i.new_asset_mngmnt_comp_id
         WHERE m20_id = i.m20_id;
    END LOOP;
END;
/

COMMIT;

-- Updating Murabaha Basket ID in m73_margin_product

BEGIN
    FOR i
        IN (  SELECT u06.u06_margin_product_id_u23,
                     MAX (t75.t75_basket_id_m181) AS t75_basket_id_m181
                FROM dfn_ntp.t75_murabaha_contracts t75,
                     dfn_ntp.u06_cash_account u06
               WHERE     t75.t75_customer_cash_ac_id_u06 = u06.u06_id
                     AND u06.u06_margin_product_id_u23 > 0
            GROUP BY u06.u06_margin_product_id_u23)
    LOOP
        UPDATE dfn_ntp.m73_margin_products m73
           SET m73.m73_murabaha_basket_id_m181 = i.t75_basket_id_m181
         WHERE m73_id = i.u06_margin_product_id_u23;
    END LOOP;
END;
/

COMMIT;

-- Updating Murabaha Loan Limit in U23_MURABAHA_LOAN_LIMIT

BEGIN
    FOR i
        IN (  SELECT u06.u06_margin_product_id_u23,
                     SUM (t75.t75_loan_amount) AS t75_loan_amount
                FROM dfn_ntp.t75_murabaha_contracts t75,
                     dfn_ntp.u06_cash_account u06
               WHERE     t75.t75_customer_cash_ac_id_u06 = u06.u06_id
                     AND u06.u06_margin_product_id_u23 > 0
                     AND t75.t75_close_status = 0
            GROUP BY u06.u06_margin_product_id_u23)
    LOOP
        UPDATE dfn_ntp.u23_customer_margin_product u23
           SET u23.u23_murabaha_loan_limit = i.t75_loan_amount
         WHERE u23.u23_id = i.u06_margin_product_id_u23;
    END LOOP;
END;
/

COMMIT;

-- Updating Transaction Code for [TRNFEE] Transactions

BEGIN
    FOR i
        IN (  SELECT t49_invoice_no_t48,
                     CASE
                         WHEN COUNT (*) > 1 THEN 'ALL'
                         ELSE MIN (t49_txn_code)
                     END
                         AS txn_code
                FROM (  SELECT t49_invoice_no_t48, t49_txn_code
                          FROM dfn_ntp.t49_tax_invoice_details t49,
                               dfn_ntp.t48_tax_invoices t48
                         WHERE     t49.t49_invoice_no_t48 = t48.t48_invoice_no
                               AND t48.t48_txn_code = 'TRNFEE'
                      GROUP BY t49_invoice_no_t48, t49_txn_code)
            GROUP BY t49_invoice_no_t48)
    LOOP
        UPDATE dfn_ntp.t48_tax_invoices t48
           SET t48.t48_txn_code = i.txn_code
         WHERE t48.t48_invoice_no = i.t49_invoice_no_t48;
    END LOOP;
END;
/

COMMIT;

-- Configuring Default Exchange Trading Account Type for All Exchanges

DECLARE
    l_exg_trd_acc_type   NUMBER;
BEGIN
    SELECT NVL (MAX (m186_id), 0)
      INTO l_exg_trd_acc_type
      FROM dfn_ntp.m186_exg_trading_acc_types;

    FOR i
        IN (  SELECT m01_id, m01_exchange_code, m186.m186_id
                FROM dfn_ntp.m01_exchanges m01,
                     dfn_ntp.m186_exg_trading_acc_types m186
               WHERE m01.m01_id = m186.m186_exchange_id_m01(+)
            ORDER BY m01_id)
    LOOP
        IF i.m186_id IS NULL
        THEN
            l_exg_trd_acc_type := l_exg_trd_acc_type + 1;

            INSERT
              INTO dfn_ntp.m186_exg_trading_acc_types (
                       m186_id,
                       m186_exchange_id_m01,
                       m186_account_type_id_v37,
                       m186_exchange_code_m01,
                       m186_is_default,
                       m186_custom_type)
            VALUES (l_exg_trd_acc_type,
                    i.m01_id,
                    3, -- Mark to Market
                    i.m01_exchange_code,
                    1,
                    '1');
        END IF;
    END LOOP;
END;
/

COMMIT;

-- Updating Currency Decimal Places

BEGIN
    FOR i IN (SELECT m02.m02_symbol, m02.m02_decimal_places
                FROM mubasher_oms.m02_currency@mubasher_db_link m02)
    LOOP
        UPDATE dfn_ntp.m03_currency m03
           SET m03.m03_decimal_places = i.m02_decimal_places
         WHERE m03.m03_code = i.m02_symbol;
    END LOOP;
END;
/

COMMIT;

-- Updating Id Codes

BEGIN
    FOR i
        IN (SELECT map_08.map08_ntp_id,
                   m242.m242_code,
                   CASE
                       WHEN m242.m242_account_frozen_type = 0 THEN 1
                       WHEN m242.m242_account_frozen_type = 1 THEN 2
                       ELSE 3
                   END
                       AS freeze_type
              FROM mubasher_oms.m242_identity_types@mubasher_db_link m242,
                   map08_identity_type_m15 map_08
             WHERE map_08.map08_oms_id = m242.m242_id)
    LOOP
        UPDATE dfn_ntp.m15_identity_type m15
           SET m15.m15_external_ref = i.m242_code,
               m15.m15_account_frozen_type = i.freeze_type
         WHERE m15.m15_id = i.map08_ntp_id;
    END LOOP;
END;
/

COMMIT;

-- Updating Countries External References

BEGIN
    FOR i
        IN (SELECT m05.m05_id, m30.m30_external_reference
              FROM mubasher_oms.m30_country@mubasher_db_link m30,
                   dfn_ntp.m05_country m05
             WHERE     UPPER (m30.m30_country_name) = UPPER (m05.m05_name)
                   AND m30_external_reference IS NOT NULL)
    LOOP
        UPDATE dfn_ntp.m05_country m05
           SET m05.m05_external_ref = i.m30_external_reference
         WHERE m05.m05_id = i.m05_id;
    END LOOP;
END;
/

COMMIT;

BEGIN
    FOR i
        IN (SELECT u03_customer_id_u01, u03_other_next_review
              FROM dfn_ntp.u03_customer_kyc)
    LOOP
        UPDATE dfn_ntp.u01_customer
           SET u01_kyc_next_review = i.u03_other_next_review
         WHERE u01_id = i.u03_customer_id_u01;
    END LOOP;
END;
/

COMMIT;

-- Set TDWL as Local Exchange

UPDATE dfn_ntp.m01_exchanges
   SET m01_is_local = 1
 WHERE m01_exchange_code = 'TDWL';

COMMIT;

-- Update Title's External References

BEGIN
    FOR i
        IN (SELECT m130.m130_id, m130_old.m130_id AS old_id
              FROM dfn_ntp.m130_titles m130,
                   map11_titles_m130 map11,
                   mubasher_oms.m130_titles@mubasher_db_link m130_old
             WHERE     m130.m130_id = map11.map11_ntp_id
                   AND map11.map11_oms_id = m130_old.m130_id)
    LOOP
        UPDATE dfn_ntp.m130_titles
           SET m130_external_ref = i.old_id
         WHERE m130_id = i.m130_id;
    END LOOP;
END;
/

COMMIT;

-- Settle all the orders which were in settling status. Date clause may be changed based on the execution time.

UPDATE dfn_ntp.t02_transaction_log
SET t02_trade_process_stat_id_v01 = 25
WHERE     t02_trade_process_stat_id_v01 = 24
      AND t02_cash_settle_date < SYSDATE;

COMMIT;

-- Updating Sub Agreement Type

MERGE INTO dfn_ntp.u09_customer_login u09
     USING (SELECT m158_user_id_u09,
                   m158_customer_id_u01,
                   NVL (m158_customer_type_v01, 1) AS agreement_type -- If Null Business (1)
              FROM dfn_ntp.m158_priceuser_agreement) m158
        ON (    u09.u09_id = m158.m158_user_id_u09
            AND u09.u09_customer_id_u01 = m158.m158_customer_id_u01)
WHEN MATCHED
THEN
    UPDATE SET u09.u09_sub_agreement_type = m158.agreement_type;

COMMIT;

-- Update Unassigned Cash Accounts

UPDATE dfn_ntp.u06_cash_account u06
   SET u06.u06_is_unasgnd_account = 1
 WHERE u06.u06_id NOT IN
           (SELECT DISTINCT u07_cash_account_id_u06
              FROM dfn_ntp.u07_trading_account);
			  
COMMIT;