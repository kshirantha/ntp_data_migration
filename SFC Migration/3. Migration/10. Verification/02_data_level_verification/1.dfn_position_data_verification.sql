DECLARE
    l_count   NUMBER := 0;
    l_table   VARCHAR2 (50) := 'position_verification';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 1)
    THEN
        EXECUTE IMMEDIATE 'DROP TABLE ' || l_table || '';
    END IF;

    EXECUTE IMMEDIATE
           'CREATE TABLE '
        || l_table
        || ' (
    target_table          VARCHAR2 (100 BYTE),
    source_table          VARCHAR2 (100 BYTE),
    verify_condition      VARCHAR2 (100 BYTE),
    old_entity_key        VARCHAR2 (500 BYTE),
    new_entity_key        VARCHAR2 (500 BYTE),
    source_value          NUMBER (30, 10),
    target_value          NUMBER (30, 10),
    difference            NUMBER (30, 10)    
    )';
END;
/

---------- Payable Amount DIFFERENCE -----------

BEGIN
    FOR i IN (SELECT *
                FROM (SELECT t03_account_id,
                             u06.u06_id,
                             t03_payable_amount,
                             u06_payable_blocked,
                             t03_payable_amount - u06_payable_blocked
                                 AS difference
                        FROM (SELECT t03.t03_account_id,
                                     NVL (t03.t03_payable_amount, 0)
                                         AS t03_payable_amount
                                FROM mubasher_oms.t03_cash_account@mubasher_db_link t03
                               WHERE t03.t03_branch_id > 0) t03
                             LEFT JOIN u06_cash_account_mappings u06_map
                                 ON t03.t03_account_id =
                                        u06_map.old_cash_account_id
                             LEFT JOIN (SELECT u06.u06_id,
                                               NVL (u06.u06_payable_blocked,
                                                    0)
                                                   AS u06_payable_blocked
                                          FROM dfn_ntp.u06_cash_account u06) u06
                                 ON u06_map.new_cash_account_id = u06.u06_id)
               WHERE difference <> 0 OR u06_id IS NULL)
    LOOP
        INSERT INTO position_verification (target_table,
                                           source_table,
                                           verify_condition,
                                           old_entity_key,
                                           new_entity_key,
                                           source_value,
                                           target_value,
                                           difference)
             VALUES ('U06_CASH_ACCOUNT',
                     'T03_CASH_ACCOUNT',
                     'Payable Amount',
                     i.t03_account_id,
                     i.u06_id,
                     i.t03_payable_amount,
                     i.u06_payable_blocked,
                     i.difference);
    END LOOP;
END;
/

---------- Pending Settle DIFFERENCE -----------

BEGIN
    FOR i IN (SELECT *
                FROM (SELECT t03_account_id,
                             u06.u06_id,
                             t03_pending_settle,
                             u06_receivable_amount,
                             t03_pending_settle - u06_receivable_amount
                                 AS difference
                        FROM (SELECT t03.t03_account_id,
                                     NVL (t03.t03_pending_settle, 0)
                                         AS t03_pending_settle
                                FROM mubasher_oms.t03_cash_account@mubasher_db_link t03
                               WHERE t03.t03_branch_id > 0) t03
                             LEFT JOIN u06_cash_account_mappings u06_map
                                 ON t03.t03_account_id =
                                        u06_map.old_cash_account_id
                             LEFT JOIN (SELECT u06.u06_id,
                                               NVL (
                                                   u06.u06_receivable_amount,
                                                   0)
                                                   AS u06_receivable_amount
                                          FROM dfn_ntp.u06_cash_account u06) u06
                                 ON u06_map.new_cash_account_id = u06.u06_id)
               WHERE difference <> 0 OR u06_id IS NULL)
    LOOP
        INSERT INTO position_verification (target_table,
                                           source_table,
                                           verify_condition,
                                           old_entity_key,
                                           new_entity_key,
                                           source_value,
                                           target_value,
                                           difference)
             VALUES ('U06_CASH_ACCOUNT',
                     'T03_CASH_ACCOUNT',
                     'Receivable Amount',
                     i.t03_account_id,
                     i.u06_id,
                     i.t03_pending_settle,
                     i.u06_receivable_amount,
                     i.difference);
    END LOOP;
END;
/

---------- Blocked Amount DIFFERENCE -----------

BEGIN
    FOR i IN (SELECT *
                FROM (SELECT t03_account_id,
                             u06.u06_id,
                             t03_blocked_amount,
                             u06_blocked,
                             t03_blocked_amount - u06_blocked AS difference
                        FROM (SELECT t03.t03_account_id,
                                     (  ABS (NVL (t03.t03_blocked_amount, 0))
                                      + ABS (NVL(t03.t03_margin_block, 0)))
                                         AS t03_blocked_amount
                                FROM mubasher_oms.t03_cash_account@mubasher_db_link t03
                               WHERE t03.t03_branch_id > 0) t03
                             LEFT JOIN u06_cash_account_mappings u06_map
                                 ON t03.t03_account_id =
                                        u06_map.old_cash_account_id
                             LEFT JOIN (SELECT u06.u06_id,
                                               NVL (u06.u06_blocked, 0)
                                                   AS u06_blocked
                                          FROM dfn_ntp.u06_cash_account u06) u06
                                 ON u06_map.new_cash_account_id = u06.u06_id)
               WHERE difference <> 0 OR u06_id IS NULL)
    LOOP
        INSERT INTO position_verification (target_table,
                                           source_table,
                                           verify_condition,
                                           old_entity_key,
                                           new_entity_key,
                                           source_value,
                                           target_value,
                                           difference)
             VALUES ('U06_CASH_ACCOUNT',
                     'T03_CASH_ACCOUNT',
                     'Blokced Amount',
                     i.t03_account_id,
                     i.u06_id,
                     i.t03_blocked_amount,
                     i.u06_blocked,
                     i.difference);
    END LOOP;
END;
/

---------- Net Receivable DIFFERENCE -----------

BEGIN
    FOR i IN (SELECT *
                FROM (SELECT t03_account_id,
                             u06.u06_id,
                             t03_net_receivable,
                             u06_net_receivable,
                             t03_net_receivable - u06_net_receivable
                                 AS difference
                        FROM (SELECT t03.t03_account_id,
                                     NVL (t03.t03_net_receivable, 0)
                                         AS t03_net_receivable
                                FROM mubasher_oms.t03_cash_account@mubasher_db_link t03
                               WHERE t03.t03_branch_id > 0) t03
                             LEFT JOIN u06_cash_account_mappings u06_map
                                 ON t03.t03_account_id =
                                        u06_map.old_cash_account_id
                             LEFT JOIN (SELECT u06.u06_id,
                                               NVL (u06.u06_net_receivable,
                                                    0)
                                                   AS u06_net_receivable
                                          FROM dfn_ntp.u06_cash_account u06) u06
                                 ON u06_map.new_cash_account_id = u06.u06_id)
               WHERE difference <> 0 OR u06_id IS NULL)
    LOOP
        INSERT INTO position_verification (target_table,
                                           source_table,
                                           verify_condition,
                                           old_entity_key,
                                           new_entity_key,
                                           source_value,
                                           target_value,
                                           difference)
             VALUES ('U06_CASH_ACCOUNT',
                     'T03_CASH_ACCOUNT',
                     'Net Receivable Amount',
                     i.t03_account_id,
                     i.u06_id,
                     i.t03_net_receivable,
                     i.u06_net_receivable,
                     i.difference);
    END LOOP;
END;
/

---------- TDWL Payable Holding DIFFERENCE -----------

BEGIN
    FOR i
        IN (SELECT *
              FROM (SELECT t04.t04_security_ac_id,
                           t04.t04_symbol,
                           NVL (map16.map16_ntp_code, t04.t04_exchange)
                               AS exchange,
                           u24.u24_trading_acnt_id_u07,
                           u24.u24_symbol_code_m20,
                           u24.u24_exchange_code_m01,
                           t04.t04_payable_holding,
                           u24.u24_payable_holding,
                             t04.t04_payable_holding
                           - u24.u24_payable_holding
                               AS difference
                      FROM (SELECT t04.t04_security_ac_id,
                                   t04.t04_symbol,
                                   t04.t04_exchange,
                                   NVL (t04.t04_payable_holding, 0)
                                       AS t04_payable_holding
                              FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04
                             WHERE t04.t04_exchange = 'TDWL') t04
                           LEFT JOIN map16_optional_exchanges_m01 map16
                               ON t04.t04_exchange = map16.map16_oms_code
                           LEFT JOIN u07_trading_account_mappings u07_map
                               ON     t04.t04_security_ac_id =
                                          u07_map.old_trading_account_id
                                  AND NVL (map16.map16_ntp_code,
                                           t04.t04_exchange) =
                                          u07_map.exchange_code
                           LEFT JOIN (SELECT u24.u24_trading_acnt_id_u07,
                                             u24.u24_symbol_code_m20,
                                             u24.u24_exchange_code_m01,
                                             NVL (u24.u24_payable_holding,
                                                  0)
                                                 AS u24_payable_holding
                                        FROM dfn_ntp.u24_holdings u24
                                       WHERE u24.u24_exchange_code_m01 =
                                                 'TDWL') u24
                               ON     u07_map.new_trading_account_id =
                                          u24.u24_trading_acnt_id_u07
                                  AND u07_map.exchange_code =
                                          u24.u24_exchange_code_m01
                                  AND t04.t04_symbol =
                                          u24.u24_symbol_code_m20
                     WHERE     u24.u24_trading_acnt_id_u07 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                           AND u24.u24_symbol_code_m20 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                                                                  )
             WHERE    difference <> 0
                   OR u24_trading_acnt_id_u07 IS NULL
                   OR u24_symbol_code_m20 IS NULL
                   OR u24_exchange_code_m01 IS NULL)
    LOOP
        INSERT INTO position_verification (target_table,
                                           source_table,
                                           verify_condition,
                                           old_entity_key,
                                           new_entity_key,
                                           source_value,
                                           target_value,
                                           difference)
             VALUES (
                        'U24_HOLDINGS',
                        'T04_HOLDINGS_INTRADAY',
                        'Payable Holding',
                           i.t04_security_ac_id
                        || ' - '
                        || i.exchange
                        || ' - '
                        || i.t04_symbol,
                           i.u24_trading_acnt_id_u07
                        || ' - '
                        || i.u24_exchange_code_m01
                        || ' - '
                        || i.u24_symbol_code_m20,
                        i.t04_payable_holding,
                        i.u24_payable_holding,
                        i.difference);
    END LOOP;
END;
/

---------- None TDWL Payable Holding DIFFERENCE -----------

BEGIN
    FOR i
        IN (SELECT *
              FROM (SELECT t04_dtl.t04_security_ac_id,
                           t04_dtl.t04_symbol,
                           NVL (map16.map16_ntp_code, t04_dtl.t04_exchange)
                               AS exchange,
                           t04_dtl.t04_custodian,
                           u24.u24_trading_acnt_id_u07,
                           u24.u24_symbol_code_m20,
                           u24.u24_exchange_code_m01,
                           u24.u24_custodian_id_m26,
                           t04_dtl.t04_payable_holding,
                           u24.u24_payable_holding,
                             t04_dtl.t04_payable_holding
                           - u24.u24_payable_holding
                               AS difference
                      FROM (SELECT t04_dtl.t04_security_ac_id,
                                   t04_dtl.t04_symbol,
                                   t04_dtl.t04_exchange,
                                   t04_dtl.t04_custodian,
                                   NVL (t04_dtl.t04_payable_holding, 0)
                                       AS t04_payable_holding
                              FROM mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link t04_dtl
                             WHERE t04_dtl.t04_exchange <> 'TDWL') t04_dtl
                           LEFT JOIN map16_optional_exchanges_m01 map16
                               ON t04_dtl.t04_exchange =
                                      map16.map16_oms_code
                           LEFT JOIN u07_trading_account_mappings u07_map
                               ON     t04_dtl.t04_security_ac_id =
                                          u07_map.old_trading_account_id
                                  AND NVL (map16.map16_ntp_code,
                                           t04_dtl.t04_exchange) =
                                          u07_map.exchange_code
                           LEFT JOIN m26_executing_broker_mappings m26_map
                               ON t04_dtl.t04_custodian =
                                      m26_map.old_executing_broker_id
                           LEFT JOIN (SELECT u24.u24_trading_acnt_id_u07,
                                             u24.u24_symbol_code_m20,
                                             u24.u24_exchange_code_m01,
                                             u24.u24_custodian_id_m26,
                                             NVL (u24.u24_payable_holding,
                                                  0)
                                                 AS u24_payable_holding
                                        FROM dfn_ntp.u24_holdings u24
                                       WHERE u24.u24_exchange_code_m01 <>
                                                 'TDWL') u24
                               ON     u07_map.new_trading_account_id =
                                          u24.u24_trading_acnt_id_u07
                                  AND u07_map.exchange_code =
                                          u24.u24_exchange_code_m01
                                  AND t04_dtl.t04_symbol =
                                          u24.u24_symbol_code_m20
                                  AND m26_map.new_executing_broker_id =
                                          u24.u24_custodian_id_m26
                     WHERE     u24.u24_trading_acnt_id_u07 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                           AND u24.u24_symbol_code_m20 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                           AND u24.u24_custodian_id_m26 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                                                                   )
             WHERE    difference <> 0
                   OR u24_trading_acnt_id_u07 IS NULL
                   OR u24_symbol_code_m20 IS NULL
                   OR u24_custodian_id_m26 IS NULL
                   OR u24_exchange_code_m01 IS NULL)
    LOOP
        INSERT INTO position_verification (target_table,
                                           source_table,
                                           verify_condition,
                                           old_entity_key,
                                           new_entity_key,
                                           source_value,
                                           target_value,
                                           difference)
             VALUES (
                        'U24_HOLDINGS',
                        'T04_HOLDINGS_INTRADAY_DTL',
                        'Payable Holding',
                           i.t04_security_ac_id
                        || ' - '
                        || i.exchange
                        || ' - '
                        || i.t04_symbol
                        || ' - '
                        || i.t04_custodian,
                           i.u24_trading_acnt_id_u07
                        || ' - '
                        || i.u24_exchange_code_m01
                        || ' - '
                        || i.u24_symbol_code_m20
                        || ' - '
                        || i.u24_custodian_id_m26,
                        i.t04_payable_holding,
                        i.u24_payable_holding,
                        i.difference);
    END LOOP;
END;
/

---------- TDWL Receivable Holding DIFFERENCE -----------

BEGIN
    FOR i
        IN (SELECT *
              FROM (SELECT t04.t04_security_ac_id,
                           t04.t04_symbol,
                           NVL (map16.map16_ntp_code, t04.t04_exchange)
                               AS exchange,
                           u24.u24_trading_acnt_id_u07,
                           u24.u24_symbol_code_m20,
                           u24.u24_exchange_code_m01,
                           t04.t04_pending_settle,
                           u24.u24_receivable_holding,
                             t04.t04_pending_settle
                           - u24.u24_receivable_holding
                               AS difference
                      FROM (SELECT t04.t04_security_ac_id,
                                   t04.t04_symbol,
                                   t04.t04_exchange,
                                   NVL (t04.t04_pending_settle, 0)
                                       AS t04_pending_settle
                              FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04
                             WHERE t04.t04_exchange = 'TDWL') t04
                           LEFT JOIN map16_optional_exchanges_m01 map16
                               ON t04.t04_exchange = map16.map16_oms_code
                           LEFT JOIN u07_trading_account_mappings u07_map
                               ON     t04.t04_security_ac_id =
                                          u07_map.old_trading_account_id
                                  AND NVL (map16.map16_ntp_code,
                                           t04.t04_exchange) =
                                          u07_map.exchange_code
                           LEFT JOIN (SELECT u24.u24_trading_acnt_id_u07,
                                             u24.u24_symbol_code_m20,
                                             u24.u24_exchange_code_m01,
                                             NVL (
                                                 u24.u24_receivable_holding,
                                                 0)
                                                 AS u24_receivable_holding
                                        FROM dfn_ntp.u24_holdings u24
                                       WHERE u24.u24_exchange_code_m01 =
                                                 'TDWL') u24
                               ON     u07_map.new_trading_account_id =
                                          u24.u24_trading_acnt_id_u07
                                  AND u07_map.exchange_code =
                                          u24.u24_exchange_code_m01
                                  AND t04.t04_symbol =
                                          u24.u24_symbol_code_m20
                     WHERE     u24.u24_trading_acnt_id_u07 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                           AND u24.u24_symbol_code_m20 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                                                                  )
             WHERE    difference <> 0
                   OR u24_trading_acnt_id_u07 IS NULL
                   OR u24_symbol_code_m20 IS NULL
                   OR u24_exchange_code_m01 IS NULL)
    LOOP
        INSERT INTO position_verification (target_table,
                                           source_table,
                                           verify_condition,
                                           old_entity_key,
                                           new_entity_key,
                                           source_value,
                                           target_value,
                                           difference)
             VALUES (
                        'U24_HOLDINGS',
                        'T04_HOLDINGS_INTRADAY',
                        'Receivable Holding',
                           i.t04_security_ac_id
                        || ' - '
                        || i.exchange
                        || ' - '
                        || i.t04_symbol,
                           i.u24_trading_acnt_id_u07
                        || ' - '
                        || i.u24_exchange_code_m01
                        || ' - '
                        || i.u24_symbol_code_m20,
                        i.t04_pending_settle,
                        i.u24_receivable_holding,
                        i.difference);
    END LOOP;
END;
/

---------- None TDWL Receivable Holding DIFFERENCE -----------

BEGIN
    FOR i
        IN (SELECT *
              FROM (SELECT t04_dtl.t04_security_ac_id,
                           t04_dtl.t04_symbol,
                           NVL (map16.map16_ntp_code, t04_dtl.t04_exchange)
                               AS exchange,
                           t04_dtl.t04_custodian,
                           u24.u24_trading_acnt_id_u07,
                           u24.u24_symbol_code_m20,
                           u24.u24_exchange_code_m01,
                           u24.u24_custodian_id_m26,
                           t04_dtl.t04_pending_settle,
                           u24.u24_receivable_holding,
                             t04_dtl.t04_pending_settle
                           - u24.u24_receivable_holding
                               AS difference
                      FROM (SELECT t04_dtl.t04_security_ac_id,
                                   t04_dtl.t04_symbol,
                                   t04_dtl.t04_exchange,
                                   t04_dtl.t04_custodian,
                                   NVL (t04_dtl.t04_pending_settle, 0)
                                       AS t04_pending_settle
                              FROM mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link t04_dtl
                             WHERE t04_dtl.t04_exchange <> 'TDWL') t04_dtl
                           LEFT JOIN map16_optional_exchanges_m01 map16
                               ON t04_dtl.t04_exchange =
                                      map16.map16_oms_code
                           LEFT JOIN u07_trading_account_mappings u07_map
                               ON     t04_dtl.t04_security_ac_id =
                                          u07_map.old_trading_account_id
                                  AND NVL (map16.map16_ntp_code,
                                           t04_dtl.t04_exchange) =
                                          u07_map.exchange_code
                           LEFT JOIN m26_executing_broker_mappings m26_map
                               ON t04_dtl.t04_custodian =
                                      m26_map.old_executing_broker_id
                           LEFT JOIN (SELECT u24.u24_trading_acnt_id_u07,
                                             u24.u24_symbol_code_m20,
                                             u24.u24_exchange_code_m01,
                                             u24.u24_custodian_id_m26,
                                             NVL (
                                                 u24.u24_receivable_holding,
                                                 0)
                                                 AS u24_receivable_holding
                                        FROM dfn_ntp.u24_holdings u24
                                       WHERE u24.u24_exchange_code_m01 <>
                                                 'TDWL') u24
                               ON     u07_map.new_trading_account_id =
                                          u24.u24_trading_acnt_id_u07
                                  AND u07_map.exchange_code =
                                          u24.u24_exchange_code_m01
                                  AND t04_dtl.t04_symbol =
                                          u24.u24_symbol_code_m20
                                  AND m26_map.new_executing_broker_id =
                                          u24.u24_custodian_id_m26
                     WHERE     u24.u24_trading_acnt_id_u07 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                           AND u24.u24_symbol_code_m20 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                           AND u24.u24_custodian_id_m26 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                                                                   )
             WHERE    difference <> 0
                   OR u24_trading_acnt_id_u07 IS NULL
                   OR u24_symbol_code_m20 IS NULL
                   OR u24_custodian_id_m26 IS NULL
                   OR u24_exchange_code_m01 IS NULL)
    LOOP
        INSERT INTO position_verification (target_table,
                                           source_table,
                                           verify_condition,
                                           old_entity_key,
                                           new_entity_key,
                                           source_value,
                                           target_value,
                                           difference)
             VALUES (
                        'U24_HOLDINGS',
                        'T04_HOLDINGS_INTRADAY_DTL',
                        'Receivable Holding',
                           i.t04_security_ac_id
                        || ' - '
                        || i.exchange
                        || ' - '
                        || i.t04_symbol
                        || ' - '
                        || i.t04_custodian,
                           i.u24_trading_acnt_id_u07
                        || ' - '
                        || i.u24_exchange_code_m01
                        || ' - '
                        || i.u24_symbol_code_m20
                        || ' - '
                        || i.u24_custodian_id_m26,
                        i.t04_pending_settle,
                        i.u24_receivable_holding,
                        i.difference);
    END LOOP;
END;
/

---------- TDWL Pledged Quantity DIFFERENCE -----------

BEGIN
    FOR i
        IN (SELECT *
              FROM (SELECT t04.t04_security_ac_id,
                           t04.t04_symbol,
                           NVL (map16.map16_ntp_code, t04.t04_exchange)
                               AS exchange,
                           u24.u24_trading_acnt_id_u07,
                           u24.u24_symbol_code_m20,
                           u24.u24_exchange_code_m01,
                           t04.t04_pledgedqty,
                           u24.u24_pledge_qty,
                           t04.t04_pledgedqty - u24.u24_pledge_qty
                               AS difference
                      FROM (SELECT t04.t04_security_ac_id,
                                   t04.t04_symbol,
                                   t04.t04_exchange,
                                   NVL (t04.t04_pledgedqty, 0)
                                       AS t04_pledgedqty
                              FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04
                             WHERE t04.t04_exchange = 'TDWL') t04
                           LEFT JOIN map16_optional_exchanges_m01 map16
                               ON t04.t04_exchange = map16.map16_oms_code
                           LEFT JOIN u07_trading_account_mappings u07_map
                               ON     t04.t04_security_ac_id =
                                          u07_map.old_trading_account_id
                                  AND NVL (map16.map16_ntp_code,
                                           t04.t04_exchange) =
                                          u07_map.exchange_code
                           LEFT JOIN (SELECT u24.u24_trading_acnt_id_u07,
                                             u24.u24_symbol_code_m20,
                                             u24.u24_exchange_code_m01,
                                             NVL (u24.u24_pledge_qty, 0)
                                                 AS u24_pledge_qty
                                        FROM dfn_ntp.u24_holdings u24
                                       WHERE u24.u24_exchange_code_m01 =
                                                 'TDWL') u24
                               ON     u07_map.new_trading_account_id =
                                          u24.u24_trading_acnt_id_u07
                                  AND u07_map.exchange_code =
                                          u24.u24_exchange_code_m01
                                  AND t04.t04_symbol =
                                          u24.u24_symbol_code_m20
                     WHERE     u24.u24_trading_acnt_id_u07 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                           AND u24.u24_symbol_code_m20 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                                                                  )
             WHERE    difference <> 0
                   OR u24_trading_acnt_id_u07 IS NULL
                   OR u24_symbol_code_m20 IS NULL
                   OR u24_exchange_code_m01 IS NULL)
    LOOP
        INSERT INTO position_verification (target_table,
                                           source_table,
                                           verify_condition,
                                           old_entity_key,
                                           new_entity_key,
                                           source_value,
                                           target_value,
                                           difference)
             VALUES (
                        'U24_HOLDINGS',
                        'T04_HOLDINGS_INTRADAY',
                        'Pledged Quantity',
                           i.t04_security_ac_id
                        || ' - '
                        || i.exchange
                        || ' - '
                        || i.t04_symbol,
                           i.u24_trading_acnt_id_u07
                        || ' - '
                        || i.u24_exchange_code_m01
                        || ' - '
                        || i.u24_symbol_code_m20,
                        i.t04_pledgedqty,
                        i.u24_pledge_qty,
                        i.difference);
    END LOOP;
END;
/

---------- None TDWL Pledged Quantity DIFFERENCE -----------

BEGIN
    FOR i
        IN (SELECT *
              FROM (SELECT t04_dtl.t04_security_ac_id,
                           t04_dtl.t04_symbol,
                           NVL (map16.map16_ntp_code, t04_dtl.t04_exchange)
                               AS exchange,
                           t04_dtl.t04_custodian,
                           u24.u24_trading_acnt_id_u07,
                           u24.u24_symbol_code_m20,
                           u24.u24_exchange_code_m01,
                           u24.u24_custodian_id_m26,
                           t04_dtl.t04_pledgedqty,
                           u24.u24_pledge_qty,
                           t04_dtl.t04_pledgedqty - u24.u24_pledge_qty
                               AS difference
                      FROM (SELECT t04_dtl.t04_security_ac_id,
                                   t04_dtl.t04_symbol,
                                   t04_dtl.t04_exchange,
                                   t04_dtl.t04_custodian,
                                   NVL (t04_dtl.t04_pledgedqty, 0)
                                       AS t04_pledgedqty
                              FROM mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link t04_dtl
                             WHERE t04_dtl.t04_exchange <> 'TDWL') t04_dtl
                           LEFT JOIN map16_optional_exchanges_m01 map16
                               ON t04_dtl.t04_exchange =
                                      map16.map16_oms_code
                           LEFT JOIN u07_trading_account_mappings u07_map
                               ON     t04_dtl.t04_security_ac_id =
                                          u07_map.old_trading_account_id
                                  AND NVL (map16.map16_ntp_code,
                                           t04_dtl.t04_exchange) =
                                          u07_map.exchange_code
                           LEFT JOIN m26_executing_broker_mappings m26_map
                               ON t04_dtl.t04_custodian =
                                      m26_map.old_executing_broker_id
                           LEFT JOIN (SELECT u24.u24_trading_acnt_id_u07,
                                             u24.u24_symbol_code_m20,
                                             u24.u24_exchange_code_m01,
                                             u24.u24_custodian_id_m26,
                                             NVL (u24.u24_pledge_qty, 0)
                                                 AS u24_pledge_qty
                                        FROM dfn_ntp.u24_holdings u24
                                       WHERE u24.u24_exchange_code_m01 <>
                                                 'TDWL') u24
                               ON     u07_map.new_trading_account_id =
                                          u24.u24_trading_acnt_id_u07
                                  AND u07_map.exchange_code =
                                          u24.u24_exchange_code_m01
                                  AND t04_dtl.t04_symbol =
                                          u24.u24_symbol_code_m20
                                  AND m26_map.new_executing_broker_id =
                                          u24.u24_custodian_id_m26
                     WHERE     u24.u24_trading_acnt_id_u07 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                           AND u24.u24_symbol_code_m20 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                           AND u24.u24_custodian_id_m26 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                                                                   )
             WHERE    difference <> 0
                   OR u24_trading_acnt_id_u07 IS NULL
                   OR u24_symbol_code_m20 IS NULL
                   OR u24_custodian_id_m26 IS NULL
                   OR u24_exchange_code_m01 IS NULL)
    LOOP
        INSERT INTO position_verification (target_table,
                                           source_table,
                                           verify_condition,
                                           old_entity_key,
                                           new_entity_key,
                                           source_value,
                                           target_value,
                                           difference)
             VALUES (
                        'U24_HOLDINGS',
                        'T04_HOLDINGS_INTRADAY_DTL',
                        'Pledged Quantity',
                           i.t04_security_ac_id
                        || ' - '
                        || i.exchange
                        || ' - '
                        || i.t04_symbol
                        || ' - '
                        || i.t04_custodian,
                           i.u24_trading_acnt_id_u07
                        || ' - '
                        || i.u24_exchange_code_m01
                        || ' - '
                        || i.u24_symbol_code_m20
                        || ' - '
                        || i.u24_custodian_id_m26,
                        i.t04_pledgedqty,
                        i.u24_pledge_qty,
                        i.difference);
    END LOOP;
END;
/

---------- TDWL Blocked Holding (Sell Pending) DIFFERENCE -----------

BEGIN
    FOR i
        IN (SELECT *
              FROM (SELECT t04.t04_security_ac_id,
                           t04.t04_symbol,
                           NVL (map16.map16_ntp_code, t04.t04_exchange)
                               AS exchange,
                           u24.u24_trading_acnt_id_u07,
                           u24.u24_symbol_code_m20,
                           u24.u24_exchange_code_m01,
                           t04.t04_sell_pending,
                           u24.u24_sell_pending,
                           t04.t04_sell_pending - u24.u24_sell_pending
                               AS difference
                      FROM (SELECT t04.t04_security_ac_id,
                                   t04.t04_symbol,
                                   t04.t04_exchange,
                                   NVL (t04.t04_sell_pending, 0)
                                       AS t04_sell_pending
                              FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04
                             WHERE t04.t04_exchange = 'TDWL') t04
                           LEFT JOIN map16_optional_exchanges_m01 map16
                               ON t04.t04_exchange = map16.map16_oms_code
                           LEFT JOIN u07_trading_account_mappings u07_map
                               ON     t04.t04_security_ac_id =
                                          u07_map.old_trading_account_id
                                  AND NVL (map16.map16_ntp_code,
                                           t04.t04_exchange) =
                                          u07_map.exchange_code
                           LEFT JOIN (SELECT u24.u24_trading_acnt_id_u07,
                                             u24.u24_symbol_code_m20,
                                             u24.u24_exchange_code_m01,
                                             NVL (u24.u24_sell_pending, 0)
                                                 AS u24_sell_pending
                                        FROM dfn_ntp.u24_holdings u24
                                       WHERE u24.u24_exchange_code_m01 =
                                                 'TDWL') u24
                               ON     u07_map.new_trading_account_id =
                                          u24.u24_trading_acnt_id_u07
                                  AND u07_map.exchange_code =
                                          u24.u24_exchange_code_m01
                                  AND t04.t04_symbol =
                                          u24.u24_symbol_code_m20
                     WHERE     u24.u24_trading_acnt_id_u07 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                           AND u24.u24_symbol_code_m20 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                                                                  )
             WHERE    difference <> 0
                   OR u24_trading_acnt_id_u07 IS NULL
                   OR u24_symbol_code_m20 IS NULL
                   OR u24_exchange_code_m01 IS NULL)
    LOOP
        INSERT INTO position_verification (target_table,
                                           source_table,
                                           verify_condition,
                                           old_entity_key,
                                           new_entity_key,
                                           source_value,
                                           target_value,
                                           difference)
             VALUES (
                        'U24_HOLDINGS',
                        'T04_HOLDINGS_INTRADAY',
                        'Sell Pending Quantity',
                           i.t04_security_ac_id
                        || ' - '
                        || i.exchange
                        || ' - '
                        || i.t04_symbol,
                           i.u24_trading_acnt_id_u07
                        || ' - '
                        || i.u24_exchange_code_m01
                        || ' - '
                        || i.u24_symbol_code_m20,
                        i.t04_sell_pending,
                        i.u24_sell_pending,
                        i.difference);
    END LOOP;
END;
/

---------- None TDWL Blocked Holding (Sell Pending) DIFFERENCE -----------

BEGIN
    FOR i
        IN (SELECT *
              FROM (SELECT t04_dtl.t04_security_ac_id,
                           t04_dtl.t04_symbol,
                           NVL (map16.map16_ntp_code, t04_dtl.t04_exchange)
                               AS exchange,
                           t04_dtl.t04_custodian,
                           u24.u24_trading_acnt_id_u07,
                           u24.u24_symbol_code_m20,
                           u24.u24_exchange_code_m01,
                           u24.u24_custodian_id_m26,
                           t04_dtl.t04_sell_pending,
                           u24.u24_sell_pending,
                           t04_dtl.t04_sell_pending - u24.u24_sell_pending
                               AS difference
                      FROM (SELECT t04_dtl.t04_security_ac_id,
                                   t04_dtl.t04_symbol,
                                   t04_dtl.t04_exchange,
                                   t04_dtl.t04_custodian,
                                   NVL (t04_dtl.t04_sell_pending, 0)
                                       AS t04_sell_pending
                              FROM mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link t04_dtl
                             WHERE t04_dtl.t04_exchange <> 'TDWL') t04_dtl
                           LEFT JOIN map16_optional_exchanges_m01 map16
                               ON t04_dtl.t04_exchange =
                                      map16.map16_oms_code
                           LEFT JOIN u07_trading_account_mappings u07_map
                               ON     t04_dtl.t04_security_ac_id =
                                          u07_map.old_trading_account_id
                                  AND NVL (map16.map16_ntp_code,
                                           t04_dtl.t04_exchange) =
                                          u07_map.exchange_code
                           LEFT JOIN m26_executing_broker_mappings m26_map
                               ON t04_dtl.t04_custodian =
                                      m26_map.old_executing_broker_id
                           LEFT JOIN (SELECT u24.u24_trading_acnt_id_u07,
                                             u24.u24_symbol_code_m20,
                                             u24.u24_exchange_code_m01,
                                             u24.u24_custodian_id_m26,
                                             NVL (u24.u24_sell_pending, 0)
                                                 AS u24_sell_pending
                                        FROM dfn_ntp.u24_holdings u24
                                       WHERE u24.u24_exchange_code_m01 <>
                                                 'TDWL') u24
                               ON     u07_map.new_trading_account_id =
                                          u24.u24_trading_acnt_id_u07
                                  AND u07_map.exchange_code =
                                          u24.u24_exchange_code_m01
                                  AND t04_dtl.t04_symbol =
                                          u24.u24_symbol_code_m20
                                  AND m26_map.new_executing_broker_id =
                                          u24.u24_custodian_id_m26
                     WHERE     u24.u24_trading_acnt_id_u07 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                           AND u24.u24_symbol_code_m20 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                           AND u24.u24_custodian_id_m26 IS NOT NULL -- [Add Migration Validation to Filter Out Errorneos Records]
                                                                   )
             WHERE    difference <> 0
                   OR u24_trading_acnt_id_u07 IS NULL
                   OR u24_symbol_code_m20 IS NULL
                   OR u24_custodian_id_m26 IS NULL
                   OR u24_exchange_code_m01 IS NULL)
    LOOP
        INSERT INTO position_verification (target_table,
                                           source_table,
                                           verify_condition,
                                           old_entity_key,
                                           new_entity_key,
                                           source_value,
                                           target_value,
                                           difference)
             VALUES (
                        'U24_HOLDINGS',
                        'T04_HOLDINGS_INTRADAY_DTL',
                        'Sell Pending Quantity',
                           i.t04_security_ac_id
                        || ' - '
                        || i.exchange
                        || ' - '
                        || i.t04_symbol
                        || ' - '
                        || i.t04_custodian,
                           i.u24_trading_acnt_id_u07
                        || ' - '
                        || i.u24_exchange_code_m01
                        || ' - '
                        || i.u24_symbol_code_m20
                        || ' - '
                        || i.u24_custodian_id_m26,
                        i.t04_sell_pending,
                        i.u24_sell_pending,
                        i.difference);
    END LOOP;
END;
/
