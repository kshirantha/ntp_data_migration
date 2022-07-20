-- M08_TRADING_GROUP

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M08_TRADING_GROUP';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (SELECT m73.m73_id AS id
              FROM mubasher_oms.m73_customer_groups@mubasher_db_link m73);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (
                    6,
                    'M08_TRADING_GROUP',
                    'M73_CUSTOMER_GROUPS',
                    new_row_cnt,
                    old_row_cnt,
                    old_row_cnt, -- Duplicating as TDWL & None TDWL to Segregate Customer Groups into Trading Groups
                    new_row_cnt - old_row_cnt,
                    'Duplicating as TDWL & None TDWL to Segregate Customer Groups into Trading Groups for NTP (+23)',
                    DECODE (new_row_cnt - old_row_cnt,
                            old_row_cnt, 'YES',
                            'NO'));
END;
/

-- T21_DAILY_INTEREST_FOR_CHARGES

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE     owner = 'DFN_NTP'
           AND table_name = 'T21_DAILY_INTEREST_FOR_CHARGES';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (SELECT t75.t75_id AS id
              FROM mubasher_oms.t75_daily_interest_for_charges@mubasher_db_link t75
            UNION ALL
            SELECT t108.t108_id AS id
              FROM mubasher_oms.t108_custodian_accrual_fee@mubasher_db_link t108);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (
                    208,
                    'T21_DAILY_INTEREST_FOR_CHARGES',
                    'T75_DAILY_INTEREST_FOR_CHARGES, T108_CUSTODIAN_ACCRUAL_FEE',
                    new_row_cnt,
                    old_row_cnt,
                    0,
                    new_row_cnt - old_row_cnt,
                    NULL,
                    DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- T13_NOTIFICATIONS

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'T13_NOTIFICATIONS';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (SELECT tmp10.tmp10_id AS id
              FROM mubasher_oms.tmp10_cust_notifications@mubasher_db_link tmp10
            UNION ALL
            SELECT tmp03.tmp03_id AS id
              FROM mubasher_oms.tmp03_sms_out@mubasher_db_link tmp03);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (248,
                 'T13_NOTIFICATIONS',
                 'TMP10_CUST_NOTIFICATIONS, TMP03_SMS_OUT',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- A10_ENTITY_STATUS_HISTORY

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'A10_ENTITY_STATUS_HISTORY';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_oms.m66_entity_status_history@mubasher_db_link
     WHERE m66_approval_entity_id NOT IN
               (2, -- U05_SECURITY_ACCOUNTS [Trading Account Audits Mapped]
                4, -- M18_SYSTEM_GROUPS_TASKS [Migration Keeps Concatenated Key]
                10, -- M80_AGENT_COMMISSION_GROUPS [Not Available]
                11, -- M81_AGENT_COMMISSION_STRUCTS [Not Available]
                12, -- M83_CUSTOMER_REBATE_GROUPS [Not Available]
                13, -- M82_CUSTOMER_REBATE_STRUCTS [Not Available]
                17, -- T04_SYM_DAY_TRD_ENABLE, [Not Available]
                18, -- U05_MARGIN_TRADING_ENABLE [Not Available]
                19, -- U05_MARGIN_TRADING_AMOUNT [Not Available]
                20, -- M101_BOOK_KEEPERS_COM_GROUPS [Not Available]
                21, -- M102_BOOK_KEEPERS_COM_STRUCTS [Not Available]
                22, -- M03_EXCHANGE_RATES [Key is Concatenated String]
                23, -- M110_COMMISSION_GROUPS [Not Available]
                24, -- M111_COMMISSION_STRUCTURES [Not Available]
                25, -- M111_COMMISSION_SLAB [Not Available]
                26, -- M123_COMMISSION_VALUES [Not Available]
                27, -- M30_COUNTRY [Master Data]
                30, -- M02_CURRENCY [Master Data]
                34, -- M41_CHARGES [Master Data]
                35, -- M87_COST_CENTERS [Not Available]
                38, -- M75_INSTRUMENT_TYPES [Master Data]
                39, -- M120_ASSET_MANAGEMENT_COMPANIE [Not Available]
                40, -- M37_TRADING_MARKETS [Approval Histroy Not Migrated. Data Added via Post Migration]
                42, -- M98_COMMODITIES [Not Available]
                43, -- M112_COMMISSION_CATEGORY [Not Available]
                44, -- M113_COMMISSION_TYPES [Not Available]
                47, -- M71_EMPLOYEE_SUBTYPE [Not Available]
                50, -- M132_POWER_OF_ATTERNY [Incorrect Audit Type]
                51, -- M129_JOINT_ACCOUNTS [Not Available]
                52, -- M130_TITLES [Master Data]
                53, -- M133_NATIONALITY_CATEGORY [Not Used]
                54, -- M135_TRANSACTION_CHANNELS [System Data]
                56, -- M136_TRADING_CHANNELS [Not Required]
                57, -- M138_CUSTOMER_SIGNATORY [Not Available]
                59, -- A01_PRESS_RELEASES [Not Available]
                60, -- M149_MARITAL_STATUS [Master Data]
                69, -- M158_CITIES [Master Data]
                70, -- M174_ORDER_ROUTE [Not Available]
                75, -- M176_CHEQUE_COLL_LOCATIONS [Not Available]
                76, -- EX04_EXEC_BROKER_USERS [Not Available]
                78, -- EX05_EXE_INST_BANK_ACCOUNTS [Not Available]
                81, -- T65_IB_CASH_ACCOUNT [Not Available]
                84, -- M245_PHONE_IDENTIFICATION [Not Available]
                87, -- M242_IDENTITY_TYPES [Master Data]
                88, -- M277_PORTFOLIO_GROUP [Not Available]
                91, -- T78_HOLDINGS_BLOCK [Not Available]
                92, -- T77_FUND_RELEASE [Not Available]
                93, -- T78_HOLDINGS_RELEASE [Not Available]
                95, -- M272_CORPORATE_ACTION_CUSTOMERS [Incorrect Audit Type]
                96, -- M276_NON_MARGIN_INTEREST [Not Migrated - SFC Specific]
                99, -- M247_RISK_CLASSIFICATION [Not Available]
                100, -- M164_CUST_CHARGE_DISCOUNTS [Needs to Implement Once New Changes are Ready]
                101, -- M10_EXCHANGE_COMMISSION [Approval Histroy Not Migrated. Data Added via Post Migration]
                102, -- U16_PRICE_SUSPENDED_SYMBOLS [Not Available]
                104, -- T85_SUBSCRIPTION_DOWN_REQUESTS [Not Available]
                105, -- M200_EGYPT_COMM_STRUCTS [Not Available]
                106, -- M288_DISCOUNT_SEGMENTS [Not Available]]
                108, -- M300_IVR_PRIORITY_SEGMENTS [Not Available]
                113, -- M370_ASLGROUPS [Not Migrated - SFC Specific]
                114, -- C13_REPORT_TEMPLATES [Not Available]
                115, -- U16_INST_SHARIA_SYMBOLS [Not Available]
                135 -- M313_OMS_SERVERS_FOR_CUSTOMER [Not Available]
                   );

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (
                    995, -- 995 to 997
                    'A10_ENTITY_STATUS_HISTORY',
                    'M66_ENTITY_STATUS_HISTORY',
                    new_row_cnt,
                    old_row_cnt,
                    602,
                    new_row_cnt - old_row_cnt,
                    'From Type 1 Extra Records Multiple Mappings (+111) | From Type 2 Extra Recors Multiple Mappings and Institutions Both (+491)',
                    DECODE (new_row_cnt - old_row_cnt, 602, 'YES', 'NO'));
END;
/

-- M152_PRODUCTS
/* Janaka: Will be Handled from ETI Migration
DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M152_PRODUCTS';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (  SELECT m236_prd_id
                FROM mubasher_oms.m236_price_subscription_fees@mubasher_db_link
            GROUP BY m236_prd_id, m236_currency, m236_customer_group_id) m236,
           mubasher_oms.m238_products@mubasher_db_link m238
     WHERE m236.m236_prd_id = m238.m238_id;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (267,
                 'M152_PRODUCTS',
                 'M236_PRICE_SUBSCRIPTION_FEES , M238_PRODUCTS',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/
*/

-- M30_EX_MARKET_PERMISSIONS

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M30_EX_MARKET_PERMISSIONS';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_oms.m115_sub_markets@mubasher_db_link m115,
           mubasher_oms.m166_exchange_market_status@mubasher_db_link m166
     WHERE m115_exchange = m166.m166_exchange;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (48,
                 'M30_EX_MARKET_PERMISSIONS',
                 'M115_SUB_MARKETS, M166_EXCHANGE_MARKET_STATUS',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- M176_ORDER_LIMIT_GROUP

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M176_ORDER_LIMIT_GROUP';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_oms.m279_transaction_limit_group@mubasher_db_link m279
     WHERE m279_type = 0;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (286,
                 'M176_ORDER_LIMIT_GROUP',
                 'M279_TRANSACTION_LIMIT_GROUP',
                 new_row_cnt,
                 old_row_cnt,
                 12,
                 new_row_cnt - old_row_cnt,
                 'Looped for Extra Institution for NTP (+12)',
                 DECODE (new_row_cnt - old_row_cnt, 12, 'YES', 'NO'));
END;
/

-- M177_CASH_TRANSFER_LIMIT_GROUP

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE     owner = 'DFN_NTP'
           AND table_name = 'M177_CASH_TRANSFER_LIMIT_GROUP';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_oms.m279_transaction_limit_group@mubasher_db_link m279
     WHERE m279_type = 1;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (287,
                 'M177_CASH_TRANSFER_LIMIT_GROUP',
                 'M279_TRANSACTION_LIMIT_GROUP',
                 new_row_cnt,
                 old_row_cnt,
                 8,
                 new_row_cnt - old_row_cnt,
                 'Looped for Extra Institution for NTP (+8)',
                 DECODE (new_row_cnt - old_row_cnt, 8, 'YES', 'NO'));
END;
/

-- M20_SYMBOL_EXTENDED

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M20_SYMBOL_EXTENDED';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_oms.m77_symbols@mubasher_db_link m77
     WHERE m77.m77_instrument_type IN ('RHT', 'BN', 'MF');

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (26,
                 'M20_SYMBOL_EXTENDED',
                 'M77_SYMBOLS',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- T27_GL_BATCHES

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'T27_GL_BATCHES';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (SELECT TO_CHAR (t76_batch_id) AS id
              FROM mubasher_oms.t76_batch_imports@mubasher_db_link t27
            UNION ALL
              SELECT TO_CHAR (t10.t10_account_no) AS id
                FROM mubasher_oms.t10_gl_integration_sfc@mubasher_db_link t10
            GROUP BY t10.t10_trns_date, t10.t10_account_no
            UNION ALL
              SELECT TO_CHAR (t10.t10_transaction_reference) AS id
                FROM mubasher_oms.t10_gl_local_integration_sfc@mubasher_db_link t10
            GROUP BY t10.t10_transaction_date, t10.t10_transaction_reference);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (
                    307,
                    'T27_GL_BATCHES',
                    'T76_BATCH_IMPORTS, T10_GL_INTEGRATION_SFC, T10_GL_LOCAL_INTEGRATION_SFC',
                    new_row_cnt,
                    old_row_cnt,
                    0,
                    new_row_cnt - old_row_cnt,
                    NULL,
                    DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- U11_CASH_RESTRICTION

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (SELECT t03.t03_account_id, --Withdraw
                                      10 AS restriction, NULL AS narration
              FROM mubasher_oms.t03_cash_account@mubasher_db_link t03
             WHERE t03_transaction_restriction IN (1, 3)
            UNION ALL
            SELECT t03.t03_account_id, 9 AS restriction, --Deposit
                                                        NULL AS narration
              FROM mubasher_oms.t03_cash_account@mubasher_db_link t03
             WHERE t03_transaction_restriction IN (2, 3)
            UNION ALL --Currently Offline & Online Restrictions Considered as a Cash Transfer Disabled
            SELECT t03.t03_account_id,
                   11 AS restriction,
                   t03.t03_online_withdraw_dis_reason AS narration
              FROM mubasher_oms.t03_cash_account@mubasher_db_link t03
             WHERE t03.t03_online_withdraw_enabled = 0);

    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'U11_CASH_RESTRICTION';

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (150,
                 'U11_CASH_RESTRICTION',
                 'T03_CASH_ACCOUNT',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- U14_TRADING_SYMBOL_RESTRICTION

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE     owner = 'DFN_NTP'
           AND table_name = 'U14_TRADING_SYMBOL_RESTRICTION';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (SELECT u08.u08_security_ac_id
              FROM mubasher_oms.u08_restricted_symbols@mubasher_db_link u08
             WHERE u08_type IN (1, 3) -- Buy
                                     AND u08_restricted = 1
            UNION ALL
            SELECT u08.u08_security_ac_id
              FROM mubasher_oms.u08_restricted_symbols@mubasher_db_link u08
             WHERE u08_type IN (2, 3) -- Sell
                                     AND u08_restricted = 1);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (162,
                 'U14_TRADING_SYMBOL_RESTRICTION',
                 'U08_RESTRICTED_SYMBOLS',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- T76_MURABAHA_CONTRACT_COMP

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables a
     WHERE owner = 'DFN_NTP' AND table_name = 'T76_MURABAHA_CONTRACT_COMP';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM dfn_ntp.t75_murabaha_contracts t75,
           dfn_ntp.m182_murabaha_bskt_composition m182
     WHERE t75.t75_basket_id_m181 = m182.m182_basket_id_m181;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (341,
                 'T76_MURABAHA_CONTRACT_COMP',
                 'M182_MURABAHA_BSKT_COMPOSITION',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- H13_INTEREST_INDICES_HISTORY

DECLARE
    new_row_cnt     NUMBER;
    old_row_cnt_1   NUMBER;
    old_row_cnt_2   NUMBER;
    old_row_cnt_3   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'H13_INTEREST_INDICES_HISTORY';

    SELECT COUNT (*)
      INTO old_row_cnt_1
      FROM mubasher_oms.h08_interest_indices_history@mubasher_db_link h08
     WHERE h08_index_id_sibor IS NOT NULL AND h08_index_id_libor IS NULL;

    SELECT COUNT (*)
      INTO old_row_cnt_2
      FROM mubasher_oms.h08_interest_indices_history@mubasher_db_link h08
     WHERE h08_index_id_sibor IS NULL AND h08_index_id_libor IS NOT NULL;

    SELECT COUNT (*)
      INTO old_row_cnt_3
      FROM mubasher_oms.h08_interest_indices_history@mubasher_db_link h08
     WHERE h08_index_id_sibor IS NOT NULL AND h08_index_id_libor IS NOT NULL;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (
                    342,
                    'H13_INTEREST_INDICES_HISTORY',
                    'H08_INTEREST_INDICES_HISTORY',
                    new_row_cnt,
                    (old_row_cnt_1 + old_row_cnt_2 + old_row_cnt_3 * 2), -- Two Record if Both are Not NULL
                    0,
                      new_row_cnt
                    - (old_row_cnt_1 + old_row_cnt_2 + old_row_cnt_3 * 2), -- Two Record if Both are Not NULL
                    NULL,
                    DECODE (
                          new_row_cnt
                        - (old_row_cnt_1 + old_row_cnt_2 + old_row_cnt_3 * 2),
                        0, 'YES',
                        'NO'));
END;
/

-- U12_TRADING_RESTRICTION

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'U12_TRADING_RESTRICTION';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (  SELECT u06_security_ac_id, restriction
                FROM (  SELECT u06.u06_security_ac_id, -- Buy
                                                      1 AS restriction
                          FROM mubasher_oms.u06_routing_accounts@mubasher_db_link u06,
                               mubasher_oms.u05_security_accounts@mubasher_db_link u05
                         WHERE     u06.u06_security_ac_id = u05.u05_id
                               AND (   u06.u06_trading_restriction IN (1, 3)
                                    OR u05.u05_restrict_entire_account = 1)
                      GROUP BY u06.u06_security_ac_id
                      UNION ALL -- Sell
                      SELECT u06.u06_security_ac_id, 2 AS restriction
                        FROM mubasher_oms.u06_routing_accounts@mubasher_db_link u06,
                             mubasher_oms.u05_security_accounts@mubasher_db_link u05
                       WHERE     u06.u06_security_ac_id = u05.u05_id
                             AND (   u06.u06_trading_restriction IN (2, 3)
                                  OR u05.u05_restrict_entire_account = 1)
                      UNION ALL
                      SELECT u05.u05_id, -- Stock Withdraw
                                        7 AS restriction
                        FROM mubasher_oms.u05_security_accounts@mubasher_db_link u05
                       WHERE    u05.u05_restrict_entire_account = 1
                             OR u05.u05_stock_transfer_restriction IN (1, 3)
                      UNION ALL
                      SELECT u05.u05_id, -- Stock Deposit
                                        6 AS restriction
                        FROM mubasher_oms.u05_security_accounts@mubasher_db_link u05
                       WHERE    u05.u05_restrict_entire_account = 1
                             OR u05.u05_stock_transfer_restriction IN (2, 3)
                      UNION ALL
                      SELECT u05.u05_id, -- Pledge In
                                        18 AS restriction
                        FROM mubasher_oms.u05_security_accounts@mubasher_db_link u05
                       WHERE u05.u05_restrict_entire_account = 1
                      UNION ALL
                      SELECT u05.u05_id, -- Pledge Out
                                        19 AS restriction
                        FROM mubasher_oms.u05_security_accounts@mubasher_db_link u05
                       WHERE u05.u05_restrict_entire_account = 1)
            GROUP BY u06_security_ac_id, restriction) old_restrictions,
           u07_trading_account_mappings u07_map
     WHERE old_restrictions.u06_security_ac_id =
               u07_map.old_trading_account_id;


    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (161,
                 'U12_TRADING_RESTRICTION',
                 'U06_ROUTING_ACCOUNTS, U05_SECURITY_ACCOUNTS',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- M154_SUBSCRIPTION_WAIVEOFF_GRP
/* Janaka: Will be Handled from ETI Migration
DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE     owner = 'DFN_NTP'
           AND table_name = 'M154_SUBSCRIPTION_WAIVEOFF_GRP';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (SELECT DISTINCT m237.m237_customer_id
              FROM mubasher_oms.m237_cust_subscription_waveoff@mubasher_db_link m237);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (269,
                 'M154_SUBSCRIPTION_WAIVEOFF_GRP',
                 'M237_CUST_SUBSCRIPTION_WAVEOFF',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/
*/

-- M75_STOCK_CONCENTRATION_GROUP

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M75_STOCK_CONCENTRATION_GROUP';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (SELECT DISTINCT m265_stock_concentration
              FROM mubasher_oms.m265_margin_products@mubasher_db_link
             WHERE m265_stock_concentration IS NOT NULL);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (305,
                 'M75_STOCK_CONCENTRATION_GROUP',
                 'M265_MARGIN_PRODUCTS',
                 new_row_cnt,
                 old_row_cnt,
                 4,
                 new_row_cnt - old_row_cnt,
                 'Looped for Extra Institution for NTP (+4)',
                 DECODE (new_row_cnt - old_row_cnt, 4, 'YES', 'NO'));
END;
/

-- T28_GL_RECORD_WISE_ENTRIES

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'T28_GL_RECORD_WISE_ENTRIES';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (  SELECT t10_account_no
                FROM mubasher_oms.t10_gl_integration_sfc@mubasher_db_link
               WHERE t10_ref_no IS NOT NULL AND t10_sub_ref_no IS NOT NULL
            GROUP BY t10_account_no,
                     t10_created_date,
                     t10_trns_date,
                     t10_remarks,
                     t10_ref_no,
                     t10_sub_ref_no,
                     t10_trns_amount,
                     t10_ex_ref_no,
                     t10_currency);


    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (308,
                 'T28_GL_RECORD_WISE_ENTRIES',
                 'T10_GL_INTEGRATION_SFC',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- U24_HOLDINGS

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'U24_HOLDINGS';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (SELECT t04_dtl.t04_security_ac_id
              FROM mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link t04_dtl
             WHERE t04_dtl.t04_exchange <> 'TDWL'
            UNION ALL
            SELECT t04.t04_security_ac_id
              FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04
             WHERE t04.t04_exchange = 'TDWL');

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (
                    168,
                    'U24_HOLDINGS',
                    'T04_HOLDINGS_INTRADAY, T04_HOLDINGS_INTRADAY_DTL',
                    new_row_cnt,
                    old_row_cnt,
                    -8,
                    new_row_cnt - old_row_cnt,
                    'None TDWL Holdings Under Security Accounts in Admin Institution (-8)',
                    DECODE (new_row_cnt - old_row_cnt, -8, 'YES', 'NO'));
END;
/

-- T02_TRANSACTION_LOG

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'T02_TRANSACTION_LOG';

    SELECT SUM (entries)
      INTO old_row_cnt
      FROM (SELECT SUM (CASE WHEN t05.t05_code = 'ICMR' THEN 2 ELSE 1 END)
                       AS entries
              FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05,
                   (  SELECT t05_orderno
                        FROM mubasher_oms.t05_cash_account_log@mubasher_db_link
                       WHERE t05_code = 'INDCH'
                    GROUP BY t05_orderno) t05_indch
             WHERE     t05.t05_orderno = t05_indch.t05_orderno(+)
                   AND t05_indch.t05_orderno IS NULL
            UNION ALL
            SELECT SUM (1) AS entries
              FROM (  SELECT t05.t05_orderno
                        FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05
                       WHERE t05_code = 'INDCH'
                    GROUP BY t05_orderno)
            UNION ALL
            SELECT SUM (1) AS entries
              FROM mubasher_oms.t06_holdings_log@mubasher_db_link t06
             WHERE t06.t06_side NOT IN (1, 2));

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (
                    189,
                    'T02_TRANSACTION_LOG',
                    'T05_CASH_ACCOUNT_LOG, T06_HOLDINGS_LOG',
                    new_row_cnt,
                    old_row_cnt,
                    -37,
                    new_row_cnt - old_row_cnt,
                    'T05 Log for Admin Institution (-1) | T06 Logs for Admin Institution (-36)',
                    DECODE (new_row_cnt - old_row_cnt, -37, 'YES', 'NO'));
END;
/

-- H07_USER_SESSIONS

DECLARE
    new_row_cnt     NUMBER;
    old_row_cnt_1   NUMBER;
    old_row_cnt_2   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'H07_USER_SESSIONS';

    SELECT COUNT (*)
      INTO old_row_cnt_1
      FROM (  SELECT u04_channel_id
                FROM mubasher_oms.u04_user_sessions_history@mubasher_db_link,
                     u01_customer_mappings u01_map
               WHERE     u04_channel_id NOT IN ('TRS01', 'TRS02')
                     AND u04_channel_id NOT IN ('7', '12')
                     AND u04_userid = u01_map.old_customer_id(+)
            GROUP BY u04_channel_id, new_customer_id, TRUNC (u04_login_time)
            UNION ALL
              SELECT u04_channel_id
                FROM mubasher_oms.u04_user_sessions_history@mubasher_db_link,
                     u17_employee_mappings u17_map
               WHERE     u04_channel_id NOT IN ('TRS01', 'TRS02')
                     AND u04_channel_id IN ('7', '12')
                     AND u04_userid = old_employee_id(+)
            GROUP BY u04_channel_id, old_employee_id, TRUNC (u04_login_time));

    SELECT COUNT (*)
      INTO old_row_cnt_2
      FROM (SELECT u01_oms.u01_session_id
              FROM mubasher_oms.u01_user_sessions@mubasher_db_link u01_oms,
                   mubasher_oms.m04_logins@mubasher_db_link m04_oms
             WHERE     u01_oms.u01_login_id = m04_oms.m04_id(+)
                   AND u01_oms.u01_usertype NOT IN (7, 12)
                   AND m04_oms.m04_user_type = 0
            UNION
            SELECT u01_oms.u01_session_id
              FROM mubasher_oms.u01_user_sessions@mubasher_db_link u01_oms,
                   mubasher_oms.m04_logins@mubasher_db_link m04_oms
             WHERE     u01_oms.u01_login_id = m04_oms.m04_id(+)
                   AND u01_oms.u01_usertype IN (7, 12)
                   AND m04_oms.m04_user_type = 1);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (
                    228,
                    'H07_USER_SESSIONS',
                    'U04_USER_SESSIONS_HISTORY, U01_USER_SESSIONS',
                    new_row_cnt,
                    old_row_cnt_1 + old_row_cnt_2,
                    -1,
                    new_row_cnt - (old_row_cnt_1 + old_row_cnt_2),
                    'Employee in Admin Institution for Old (-1)',
                    DECODE (new_row_cnt - (old_row_cnt_1 + old_row_cnt_2),
                            -1, 'YES',
                            'NO'));
END;
/

/* Will Not Verify. All Entitlements are Added to Each Institution as Integration User is Ganted All

-- M44_INSTITUTION_ENTITLEMENTS

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M44_INSTITUTION_ENTITLEMENTS';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (  SELECT MAX (m61.m61_id) AS m61_id, map04_ntp_id, new_institute_id
                FROM (SELECT *
                        FROM mubasher_oms.m61_institution_entitlements@mubasher_db_link
                       WHERE m61_institution_id > 0) m61,
                     map04_entitlements_v04 map04,
                     m02_institute_mappings m02_map
               WHERE     m61.m61_entitlement_id = map04.map04_oms_id(+)
                     AND m61.m61_institution_id = m02_map.old_institute_id(+)
            GROUP BY map04_ntp_id, new_institute_id);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (50,
                 'M44_INSTITUTION_ENTITLEMENTS',
                 'M61_INSTITUTION_ENTITLEMENTS',
                 new_row_cnt,
                 old_row_cnt,
                 3,
                 new_row_cnt - old_row_cnt,
                 'NTP Entitlements (+3)',
                 DECODE (new_row_cnt - old_row_cnt, 3, 'YES', 'NO'));
END;
/
*/

-- M70_CUSTODY_EXCHANGES

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M70_CUSTODY_EXCHANGES';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM     mubasher_oms.ex02_executing_inst_exchanges@mubasher_db_link
           JOIN
               mubasher_oms.ex01_executing_institution@mubasher_db_link ex01
           ON ex02_executing_institution = ex01_id
     WHERE ex01_type IN (2, 3, 4);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (83,
                 'M70_CUSTODY_EXCHANGES',
                 'EX02_EXECUTING_INST_EXCHANGES',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- M87_EXEC_BROKER_EXCHANGE

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M87_EXEC_BROKER_EXCHANGE';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM     mubasher_oms.ex02_executing_inst_exchanges@mubasher_db_link
           JOIN
               mubasher_oms.ex01_executing_institution@mubasher_db_link ex01
           ON ex02_executing_institution = ex01_id
     WHERE ex01_type IN (1, 2, 4);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (90,
                 'M87_EXEC_BROKER_EXCHANGE',
                 'EX02_EXECUTING_INST_EXCHANGES',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- U09_CUSTOMER_LOGIN

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'U09_CUSTOMER_LOGIN';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_oms.m04_logins@mubasher_db_link m04,
           mubasher_oms.m01_customer@mubasher_db_link m01
     WHERE     m04.m04_user_type = 0
           AND m04.m04_id = m01.m01_login_id(+)
           AND m01.m01_owner_id > 0;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (145,
                 'U09_CUSTOMER_LOGIN',
                 'M04_LOGINS',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- M43_INSTITUTE_EXCHANGES

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M43_INSTITUTE_EXCHANGES';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (  SELECT m39.m39_from_broker, m39.m39_exchange, COUNT (*)
                FROM mubasher_oms.m39_broker_exec_broker_map@mubasher_db_link m39
            GROUP BY m39.m39_from_broker, m39.m39_exchange);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (167,
                 'M43_INSTITUTE_EXCHANGES',
                 'M39_BROKER_EXEC_BROKER_MAP',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- T06_CASH_TRANSACTION

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'T06_CASH_TRANSACTION';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_oms.t12_pending_cash@mubasher_db_link t12;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (
                    202,
                    'T06_CASH_TRANSACTION',
                    'T12_PENDING_CASH',
                    new_row_cnt,
                    old_row_cnt,
                    -67,
                    new_row_cnt - old_row_cnt,
                    'Ignored Status (4, 7, 8, 9, 10, 24) During Corrective Actions Discussed (-67)',
                    DECODE (new_row_cnt - old_row_cnt, -67, 'YES', 'NO'));
END;
/

-- T12_SHARE_TRANSACTION

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'T12_SHARE_TRANSACTION';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_oms.t24_pending_stocks@mubasher_db_link t24
     WHERE t24.t24_txn_type NOT IN (13, 15); -- 13 (Right Subscriptions) WIll be Captured as Orders | 15 (Right Reversals) Will be Ignored While Capturing Subscriptions [Sandamal To Do]

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (
                    206,
                    'T12_SHARE_TRANSACTION',
                    'T24_PENDING_STOCKS',
                    new_row_cnt,
                    old_row_cnt,
                    -68,
                    new_row_cnt - old_row_cnt,
                    'Transactions in ADMIN Institution for Old (-43) | Incorrect T24_REFERENCE_NO for Old (-25)',
                    DECODE (new_row_cnt - old_row_cnt, -68, 'YES', 'NO'));
END;
/

-- T20_PENDING_PLEDGE

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'T20_PENDING_PLEDGE';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_oms.t17_pending_pledge@mubasher_db_link t24;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (207,
                 'T20_PENDING_PLEDGE',
                 'T17_PENDING_PLEDGE',
                 new_row_cnt,
                 old_row_cnt,
                 -13,
                 new_row_cnt - old_row_cnt,
                 'Invalid Pledge Type (C, 0, 1) for Old (-13)',
                 DECODE (new_row_cnt - old_row_cnt, -13, 'YES', 'NO'));
END;
/

-- A06_AUDIT

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'A06_AUDIT';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_oms.t22_audit@mubasher_db_link t24;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (241,
                 'A06_AUDIT',
                 'T22_AUDIT',
                 new_row_cnt,
                 old_row_cnt,
                 -288,
                 new_row_cnt - old_row_cnt,
                 'Aduits for Employees in Admin Institution for Old (-288)',
                 DECODE (new_row_cnt - old_row_cnt, -288, 'YES', 'NO'));
END;
/

-- T49_TAX_INVOICE_DETAILS

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'T49_TAX_INVOICE_DETAILS';

    SELECT SUM (total)
      INTO old_row_cnt
      FROM (SELECT COUNT (*) AS total -- None INDCH & TRNFEE Transactions
              FROM mubasher_oms.t103_tax_invoice_details@mubasher_db_link t103,
                   mubasher_oms.t05_cash_account_log@mubasher_db_link t05,
                   (  SELECT t05_orderno
                        FROM mubasher_oms.t05_cash_account_log@mubasher_db_link
                       WHERE t05_code = 'INDCH'
                    GROUP BY t05_orderno) t05_indch
             WHERE     t103.t103_t05_id = t05.t05_id
                   AND t05.t05_orderno = t05_indch.t05_orderno(+)
                   AND t05_indch.t05_orderno IS NULL
                   AND t103.t103_t05_code <> 'TRNFEE'
            UNION ALL
            SELECT COUNT (*) AS total -- INDCH Transactions
              FROM mubasher_oms.t103_tax_invoice_details@mubasher_db_link t103,
                   (  SELECT MIN (t05_id) AS t05_id,
                             t05_orderno AS t05_orderno,
                             MIN (t05_code) AS t05_code
                        FROM (SELECT t05.t05_id,
                                     t05.t05_orderno,
                                     MIN (
                                         t05.t05_code_min)
                                     KEEP (DENSE_RANK FIRST ORDER BY t05.t05_id)
                                     OVER (PARTITION BY t05.t05_orderno)
                                         AS t05_code
                                FROM (SELECT t05.*,
                                             CASE
                                                 WHEN MIN (
                                                          t05_code)
                                                      KEEP (DENSE_RANK FIRST ORDER BY
                                                                                 t05_id)
                                                      OVER (
                                                          PARTITION BY t05_orderno) IN
                                                          ('STLBUY', 'STLSEL')
                                                 THEN
                                                     MIN (
                                                         t05_code)
                                                     KEEP (DENSE_RANK FIRST ORDER BY
                                                                                t05_id)
                                                     OVER (
                                                         PARTITION BY t05_orderno)
                                                 ELSE
                                                     MAX (
                                                         t05_code)
                                                     KEEP (DENSE_RANK FIRST ORDER BY
                                                                                t05_id DESC)
                                                     OVER (
                                                         PARTITION BY t05_orderno)
                                             END
                                                 AS t05_code_min
                                        FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05) t05,
                                     (  SELECT t05_orderno
                                          FROM mubasher_oms.t05_cash_account_log@mubasher_db_link
                                         WHERE t05_code = 'INDCH'
                                      GROUP BY t05_orderno) t05_indch
                               WHERE t05.t05_orderno = t05_indch.t05_orderno)
                    GROUP BY t05_orderno) t05,
                   (  SELECT t05_orderno
                        FROM mubasher_oms.t05_cash_account_log@mubasher_db_link
                       WHERE t05_code = 'INDCH'
                    GROUP BY t05_orderno) t05_indch
             WHERE     t103.t103_t05_id = t05.t05_id
                   AND t05.t05_orderno = t05_indch.t05_orderno
                   AND t103.t103_t05_code <> 'TRNFEE'
            UNION ALL
            SELECT COUNT (*) AS total -- TRNFEE Transactions
              FROM mubasher_oms.t103_tax_invoice_details@mubasher_db_link t103
             WHERE t103.t103_t05_code = 'TRNFEE');

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (327,
                 'T49_TAX_INVOICE_DETAILS',
                 'T103_TAX_INVOICE_DETAILS',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- M26_EXECUTING_BROKER

DECLARE
    new_row_cnt       NUMBER;
    old_row_cnt       NUMBER;
    l_default_count   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M26_EXECUTING_BROKER';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_oms.ex01_executing_institution@mubasher_db_link ex01;

    SELECT COUNT (*)
      INTO l_default_count
      FROM mubasher_oms.ex01_executing_institution@mubasher_db_link ex01
     WHERE     ex01.ex01_type IN (2, 3, 4)
           AND ( (ex01.ex01_name) = 'TDWL' OR UPPER (ex01.ex01_sid) = 'TDWL')
           AND ex01.ex01_status_id = 2;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (
                    42,
                    'M26_EXECUTING_BROKER',
                    'EX01_EXECUTING_INSTITUTION',
                    new_row_cnt,
                    old_row_cnt,
                    CASE WHEN l_default_count = 0 THEN 1 ELSE 0 END,
                    new_row_cnt - old_row_cnt,
                    NULL,
                    DECODE (
                        new_row_cnt - old_row_cnt,
                        CASE WHEN l_default_count = 0 THEN 1 ELSE 0 END, 'YES',
                        'NO'));
END;
/

-- T01_ORDER

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'T01_ORDER';

    SELECT SUM (rec_count)
      INTO old_row_cnt
      FROM (SELECT COUNT (*) AS rec_count
              FROM mubasher_oms.t01_order_summary_intraday@mubasher_db_link
            UNION ALL
            SELECT COUNT (*) AS rec_count
              FROM mubasher_oms.t01_order_summary_intraday_arc@mubasher_db_link
            UNION ALL
            SELECT COUNT (*) AS rec_count
              FROM mubasher_oms.t24_pending_stocks@mubasher_db_link
             WHERE t24_txn_type IN (13, 15) -- 13 (Right Subscriptions) & 15 (Right Reversals)
                                           AND t24_inst_id <> 0);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (
                    188,
                    'T01_ORDER',
                    'T01_ORDER_SUMMARY_INTRADAY, T01_ORDER_SUMMARY_INTRADAY_ARC',
                    new_row_cnt,
                    old_row_cnt,
                    -9,
                    new_row_cnt - old_row_cnt,
                    'Intraday Orders in Admin Institution for Old (-3) | Intraday Orders for Customer (ID = 0) for Old (-1) | Archival Orders in Admin Institution for Old (-5)',
                    DECODE (new_row_cnt - old_row_cnt, -9, 'YES', 'NO'));
END;
/

-- U47_POWER_OF_ATTORNEY

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'U47_POWER_OF_ATTORNEY';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (  SELECT m137.m137_poa, m137.m137_customer_id
                FROM mubasher_oms.m137_customer_poa@mubasher_db_link m137,
                     mubasher_oms.m132_power_of_atterny@mubasher_db_link m132
               WHERE m137.m137_poa = m132.m132_id
            GROUP BY m137.m137_poa, m137.m137_customer_id);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (184,
                 'U47_POWER_OF_ATTORNEY',
                 'M137_CUSTOMER_POA, M132_POWER_OF_ATTERNY',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- M165_DISCOUNT_CHARGE_GROUPS

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M165_DISCOUNT_CHARGE_GROUPS';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (  SELECT m282.m282_account_id
                FROM mubasher_oms.m280_charges_groups@mubasher_db_link m280,
                     mubasher_oms.m281_charge_structures@mubasher_db_link m281,
                     mubasher_oms.m282_cust_charge_discounts@mubasher_db_link m282
               WHERE     m282.m282_discount > 0
                     AND m282.m282_status_id <> 9
                     AND m282.m282_charges_group_id = m280.m280_id
                     AND m282.m282_charge_struct_id = m281.m281_id
            GROUP BY m282.m282_account_id);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (
                    998,
                    'M165_DISCOUNT_CHARGE_GROUPS',
                    'M280_CHARGES_GROUPS, M281_CHARGE_STRUCTURES, M282_CUST_CHARGE_DISCOUNTS',
                    new_row_cnt,
                    old_row_cnt,
                    0,
                    new_row_cnt - old_row_cnt,
                    NULL,
                    DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- M164_CUST_CHARGE_DISCOUNTS

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M164_CUST_CHARGE_DISCOUNTS';

    SELECT COUNT (m282.m282_account_id)
      INTO old_row_cnt
      FROM mubasher_oms.m282_cust_charge_discounts@mubasher_db_link m282
     WHERE m282.m282_discount > 0 AND m282.m282_status_id <> 9;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (998,
                 'M164_CUST_CHARGE_DISCOUNTS',
                 'M282_CUST_CHARGE_DISCOUNTS',
                 new_row_cnt,
                 old_row_cnt,
                 2,
                 new_row_cnt - old_row_cnt,
                 'FAMIST Code Generates Two Code for NTP (+2)',
                 DECODE (new_row_cnt - old_row_cnt, 2, 'YES', 'NO'));
END;
/

-- U02_CUSTOMER_CONTACT_INFO

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'U02_CUSTOMER_CONTACT_INFO';

    SELECT SUM (row_count)
      INTO old_row_cnt
      FROM (SELECT COUNT (*) AS row_count
              FROM mubasher_oms.m01_customer@mubasher_db_link m01
            UNION
            SELECT COUNT (*) AS row_count
              FROM mubasher_oms.m01_customer@mubasher_db_link m01
             WHERE m01.m01_c1_office_tel IS NOT NULL);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (
                    127,
                    'U02_CUSTOMER_CONTACT_INFO',
                    'M01_CUSTOMER',
                    new_row_cnt,
                    old_row_cnt,
                    -10,
                    new_row_cnt - old_row_cnt,
                    'Customers in Admin Institution for Old (-5) + Customers in Admin Institution for Old having Office Telephone (-5)',
                    DECODE (new_row_cnt - old_row_cnt, -10, 'YES', 'NO'));
END;
/

-- M22_COMMISSION_GROUP

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
    default_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M22_COMMISSION_GROUP';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_oms.m51_commission_groups@mubasher_db_link;

    SELECT COUNT (*)
      INTO default_cnt
      FROM (SELECT DISTINCT u06_exchange
              FROM mubasher_oms.u06_routing_accounts@mubasher_db_link
             WHERE     (   u06_commision_group_id IS NULL
                        OR u06_commision_group_id NOT IN
                               (SELECT m51_commission_group_id
                                  FROM mubasher_oms.m51_commission_groups@mubasher_db_link))
                   AND u06_exchange NOT IN
                           (SELECT m51_exchange_code
                              FROM mubasher_oms.m51_commission_groups@mubasher_db_link)) u06,
           (SELECT m11_default_currency, m11_exchangecode
              FROM mubasher_oms.m11_exchanges@mubasher_db_link) m11
     WHERE u06.u06_exchange = m11.m11_exchangecode;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (
                    28,
                    'M22_COMMISSION_GROUP',
                    'M51_COMMISSION_GROUPS',
                    new_row_cnt,
                    old_row_cnt,
                    default_cnt - 1,
                    new_row_cnt - old_row_cnt,
                    'Group for Admin Institution for Old (-1) | Default Commission Groups for None Existences for NTP (+1)',
                    DECODE (new_row_cnt - old_row_cnt,
                            default_cnt - 1, 'YES',
                            'NO'));
END;
/

-- M74_MARGIN_INTEREST_GROUP

DECLARE
    new_row_cnt               NUMBER;
    old_row_cnt               NUMBER;
    default_cnt               NUMBER;

    l_default_currecny_code   VARCHAR2 (10);
BEGIN
    SELECT VALUE
      INTO l_default_currecny_code
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY_CODE';

    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M74_MARGIN_INTEREST_GROUP';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (  SELECT u22.u22_margin_interst_index,
                     NVL (u22.u22_max_margin_limit_currency,
                          l_default_currecny_code),
                     m01.m01_owner_id
                FROM mubasher_oms.u22_customer_margin_products@mubasher_db_link u22,
                     mubasher_oms.m01_customer@mubasher_db_link m01
               WHERE     u22.u22_customer_id = m01.m01_customer_id
                     AND m01.m01_owner_id > 0
                     AND u22.u22_margin_interst_index IS NOT NULL
            GROUP BY u22.u22_margin_interst_index,
                     NVL (u22.u22_max_margin_limit_currency,
                          l_default_currecny_code),
                     m01.m01_owner_id);

    SELECT COUNT (*)
      INTO default_cnt
      FROM (  SELECT u22.u22_margin_product,
                     NVL (u22.u22_max_margin_limit_currency,
                          l_default_currecny_code),
                     m01.m01_owner_id
                FROM mubasher_oms.u22_customer_margin_products@mubasher_db_link u22,
                     mubasher_oms.m01_customer@mubasher_db_link m01
               WHERE     u22.u22_customer_id = m01.m01_customer_id
                     AND m01.m01_owner_id > 0
            GROUP BY u22.u22_margin_product,
                     NVL (u22.u22_max_margin_limit_currency,
                          l_default_currecny_code),
                     m01.m01_owner_id) u22;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (
                    85,
                    'M74_MARGIN_INTEREST_GROUP',
                    'U22_CUSTOMER_MARGIN_PRODUCTS',
                    new_row_cnt,
                    old_row_cnt,
                    default_cnt,
                    new_row_cnt - old_row_cnt,
                    'Default Margin Interest Groups (+35)',
                    DECODE (new_row_cnt - old_row_cnt,
                            default_cnt, 'YES',
                            'NO'));
END;
/

-- M73_MARGIN_PRODUCTS

DECLARE
    new_row_cnt               NUMBER;
    old_row_cnt               NUMBER;

    l_default_currecny_code   VARCHAR2 (10);
BEGIN
    SELECT VALUE
      INTO l_default_currecny_code
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY_CODE';

    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M73_MARGIN_PRODUCTS';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (  SELECT u22.u22_margin_product,
                     NVL (u22.u22_max_margin_limit_currency,
                          l_default_currecny_code),
                     m01.m01_owner_id
                FROM mubasher_oms.u22_customer_margin_products@mubasher_db_link u22,
                     mubasher_oms.m01_customer@mubasher_db_link m01
               WHERE     u22.u22_customer_id = m01.m01_customer_id
                     AND m01.m01_owner_id > 0
            GROUP BY u22.u22_margin_product,
                     NVL (u22.u22_max_margin_limit_currency,
                          l_default_currecny_code),
                     m01.m01_owner_id);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (89,
                 'M73_MARGIN_PRODUCTS',
                 'U22_CUSTOMER_MARGIN_PRODUCTS',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/


-- M118_CHARGE_FEE_STRUCTURE

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'M118_CHARGE_FEE_STRUCTURE';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_oms.m281_charge_structures@mubasher_db_link m281,
           mubasher_oms.m41_sub_charges@mubasher_db_link m41_sc_oms
     WHERE m281.m281_charge_id = m41_sc_oms.m41_sc_id;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (106,
                 'M118_CHARGE_FEE_STRUCTURE',
                 'M281_CHARGE_STRUCTURES',
                 new_row_cnt,
                 old_row_cnt,
                 (old_row_cnt -- Source Count
                             + 7 -- FAMIST Duplicates
                                ) * 1 -- For Extra Institution
                                     ,
                 new_row_cnt - (old_row_cnt -- Source Count
                                           + 7 -- FAMIST Duplicates
                                              ),
                 'Looped for Extra Institution for NTP (+63)',
                 DECODE (new_row_cnt - (old_row_cnt -- Source Count
                                                   + 7 -- FAMIST Duplicates
                                                      ), 63, 'YES', 'NO'));
END;
/

-- T19_C_UMESSAGE_SHARE_DETAILS

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'T19_C_UMESSAGE_SHARE_DETAILS';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_oms.t84_u_message_share_details@mubasher_db_link t84,
           mubasher_oms.t83_u_message@mubasher_db_link t83,
           mubasher_oms.m77_symbols@mubasher_db_link m77
     WHERE t84.t84_t83_id = t83.t83_id AND t84.t84_symbol = m77.m77_symbol;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (261,
                 'T19_C_UMESSAGE_SHARE_DETAILS',
                 'T84_U_MESSAGE_SHARE_DETAILS',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- U59_TRADING_ACC_FIX_LOGINS

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'U59_TRADING_ACC_FIX_LOGINS';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_oms.u05_security_accounts@mubasher_db_link u05,
           mubasher_oms.m184_fix_logins@mubasher_db_link m184,
           m67_fix_logins_mappings m67_map,
           u07_trading_account_mappings u07_map
     WHERE     u05.u05_allowed_fix_channels >= 0
           AND u05.u05_allowed_fix_channels = m184.m184_id(+)
           AND m184.m184_id = m67_map.old_fix_logins_id(+)
           AND u05.u05_id = u07_map.old_trading_account_id(+);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (345,
                 'U59_TRADING_ACC_FIX_LOGINS',
                 'U05_SECURITY_ACCOUNTS, M184_FIX_LOGINS',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

-- U08_CUSTOMER_BENEFICIARY_ACC

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_NTP' AND table_name = 'U08_CUSTOMER_BENEFICIARY_ACC';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM (  SELECT t03_profile_id,
                     m264_bank,
                     m264_account_number,
                     bank_account_type,
                     beneficiary_cash_account
                FROM (SELECT t03_cust.t03_profile_id,
                             m264.m264_bank,
                             m264.m264_account_number,
                             CASE WHEN m264.m264_type IN (2, 3) THEN 3 END
                                 AS bank_account_type,
                             CASE
                                 WHEN m264.m264_type = 0
                                 THEN
                                     t03.t03_account_id
                             END
                                 AS beneficiary_cash_account
                        FROM mubasher_oms.m264_beneficiary_accounts@mubasher_db_link m264,
                             mubasher_oms.t03_cash_account@mubasher_db_link t03,
                             mubasher_oms.t03_cash_account@mubasher_db_link t03_cust
                       WHERE     m264.m264_account_number =
                                     t03.t03_accountno(+)
                             AND m264.m264_cash_account =
                                     t03_cust.t03_account_id(+))
            GROUP BY t03_profile_id,
                     m264_bank,
                     m264_account_number,
                     bank_account_type,
                     beneficiary_cash_account);

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (144,
                 'U08_CUSTOMER_BENEFICIARY_ACC',
                 'M264_BENEFICIARY_ACCOUNTS',
                 new_row_cnt,
                 old_row_cnt,
                 -1,
                 new_row_cnt - old_row_cnt,
                 'Customers in Admin Institution for Old (-1)',
                 DECODE (new_row_cnt - old_row_cnt, -1, 'YES', 'NO'));
END;
/

-------------------------MUBASHER_PRICE--------------------------

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_PRICE' AND table_name = 'ESP_TODAYS_SNAPSHOTS';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_price.esp_todays_snapshots@mubasher_price_link;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (1001,
                 'ESP_TODAYS_SNAPSHOTS',
                 'ESP_TODAYS_SNAPSHOTS',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/

DECLARE
    new_row_cnt   NUMBER;
    old_row_cnt   NUMBER;
BEGIN
    SELECT num_rows
      INTO new_row_cnt
      FROM all_tables
     WHERE owner = 'DFN_PRICE' AND table_name = 'ESP_TRANSACTIONS_COMPLETE';

    SELECT COUNT (*)
      INTO old_row_cnt
      FROM mubasher_price.esp_transactions_complete@mubasher_price_link;

    INSERT INTO row_count_differences (seq_id,
                                       table_name,
                                       old_name,
                                       new,
                                       old,
                                       expected_diff,
                                       actual_diff,
                                       comments,
                                       equal)
         VALUES (1002,
                 'ESP_TRANSACTIONS_COMPLETE',
                 'ESP_TRANSACTIONS_COMPLETE',
                 new_row_cnt,
                 old_row_cnt,
                 0,
                 new_row_cnt - old_row_cnt,
                 NULL,
                 DECODE (new_row_cnt - old_row_cnt, 0, 'YES', 'NO'));
END;
/