DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_int_cash_acc_id        NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (t05_id), 0)
      INTO l_int_cash_acc_id
      FROM dfn_ntp.t05_institute_cash_acc_log;

    DELETE FROM error_log
          WHERE mig_table = 'T05_INSTITUTE_CASH_ACC_LOG';

    FOR i
        IN (SELECT m02_map.new_institute_id,
                   m01.m01_id,
                   m01.m01_exchange_code,
                   NVL (
                       m93_map.new_bank_accounts_id,
                       (SELECT MAX (m93_id)
                          FROM dfn_ntp.m93_bank_accounts
                         WHERE     m93_institution_id_m02 =
                                       m02_map.new_institute_id
                               AND m93_is_default_omnibus = 1))
                       AS institute_bank_id,
                   m97.m97_id,
                   m97.m97_code,
                   t43.t43_amt_in_settle_currency,
                   t43.t43_amt_in_trans_currency,
                   TRUNC (t43_date) AS txn_date,
                   t43.t43_date,
                   t43.t43_settlement_date,
                   m03_txn.m03_id AS txn_currency_id,
                   t43.t43_transaction_currency,
                   m03_settle.m03_id AS settle_currency_id,
                   t43.t43_settle_currency,
                   t43.t43_issue_stl_rate,
                   t43.t43_id,
                   u08_map.new_cust_benefcry_acc_id,
                   t43.t43_reference_doc_narration,
                   t05_map.new_inst_cash_acc_log_id
              FROM mubasher_oms.t43_exe_inst_cash_acc_log@mubasher_db_link t43,
                   m02_institute_mappings m02_map,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   m93_bank_accounts_mappings m93_map,
                   map15_transaction_codes_m97 map15,
                   dfn_ntp.m97_transaction_codes m97,
                   dfn_ntp.m03_currency m03_txn,
                   dfn_ntp.m03_currency m03_settle,
                   u08_cust_benefcry_acc_mappings u08_map,
                   t05_inst_cash_acc_log_mappings t05_map
             WHERE     t43.t43_inst_id = m02_map.old_institute_id
                   AND t43.t43_exchange = m01.m01_exchange_code(+)
                   AND t43.t43_code = map15.map15_oms_code(+)
                   AND map15.map15_ntp_code = m97.m97_code(+)
                   AND t43.t43_bank_id = m93_map.old_bank_accounts_id(+)
                   AND t43.t43_transaction_currency = m03_txn.m03_code
                   AND t43.t43_settle_currency = m03_settle.m03_code
                   AND t43.t43_cust_bank_account_id =
                           u08_map.old_cust_benefcry_acc_id(+)
                   AND t43.t43_id = t05_map.old_inst_cash_acc_log_id(+))
    LOOP
        BEGIN
            IF i.institute_bank_id IS NULL
            THEN
                raise_application_error (
                    -20001,
                    'Institute Bank Account Id Not Available',
                    TRUE);
            END IF;

            IF i.m97_code IS NULL
            THEN
                raise_application_error (-20001,
                                         'Transaction Code Not Available',
                                         TRUE);
            END IF;

            IF i.new_inst_cash_acc_log_id IS NULL
            THEN
                l_int_cash_acc_id := l_int_cash_acc_id + 1;

                INSERT
                  INTO dfn_ntp.t05_institute_cash_acc_log (
                           t05_id,
                           t05_institute_id_m02,
                           t05_exchange_id_m01,
                           t05_exchange_code_m01,
                           t05_institute_bank_id_m93,
                           t05_txn_id_m97,
                           t05_txn_code_m97,
                           t05_amnt_in_stl_currency,
                           t05_amnt_in_txn_currency,
                           t05_txn_date,
                           t05_txn_date_time,
                           t05_settle_date,
                           t05_txn_currency_id_m03,
                           t05_txn_currency_code_m03,
                           t05_settle_currency_id_m03,
                           t05_settle_currency_code_m03,
                           t05_fx_rate,
                           t05_reference,
                           t05_cust_bank_account_id_u08,
                           t05_cust_cash_acc_id_u06,
                           t05_t02_id,
                           t05_reference_doc_narration)
                VALUES (l_int_cash_acc_id, -- t05_id
                        i.new_institute_id, -- t05_institute_id_m02
                        i.m01_id, -- t05_exchange_id_m01
                        i.m01_exchange_code, -- t05_exchange_code_m01
                        i.institute_bank_id, -- t05_institute_bank_id_m93
                        i.m97_id, -- t05_txn_id_m97
                        i.m97_code, -- t05_txn_code_m97
                        i.t43_amt_in_settle_currency, -- t05_amnt_in_stl_currency
                        i.t43_amt_in_trans_currency, -- t05_amnt_in_txn_currency
                        i.txn_date, -- t05_txn_date
                        i.t43_date, -- t05_txn_date_time
                        i.t43_settlement_date, -- t05_settle_date
                        i.txn_currency_id, -- t05_txn_currency_id_m03
                        i.t43_transaction_currency, -- t05_txn_currency_code_m03
                        i.settle_currency_id, -- t05_settle_currency_id_m03
                        i.t43_settle_currency, -- t05_settle_currency_code_m03
                        i.t43_issue_stl_rate, -- t05_fx_rate
                        i.t43_id, -- t05_reference
                        i.new_cust_benefcry_acc_id, -- t05_cust_bank_account_id_u08
                        NULL, -- t05_cust_cash_acc_id_u06 | Not Available
                        NULL, -- t05_t02_id
                        i.t43_reference_doc_narration -- t05_reference_doc_narration
                                                     );

                INSERT INTO t05_inst_cash_acc_log_mappings
                     VALUES (i.t43_id, l_int_cash_acc_id);
            ELSE
                UPDATE dfn_ntp.t05_institute_cash_acc_log
                   SET t05_institute_id_m02 = i.new_institute_id, -- t05_institute_id_m02
                       t05_exchange_id_m01 = i.m01_id, -- t05_exchange_id_m01
                       t05_exchange_code_m01 = i.m01_exchange_code, -- t05_exchange_code_m01
                       t05_institute_bank_id_m93 = i.institute_bank_id, -- t05_institute_bank_id_m93
                       t05_txn_id_m97 = i.m97_id, -- t05_txn_id_m97
                       t05_txn_code_m97 = i.m97_code, -- t05_txn_code_m97
                       t05_amnt_in_stl_currency = i.t43_amt_in_settle_currency, -- t05_amnt_in_stl_currency
                       t05_amnt_in_txn_currency = i.t43_amt_in_trans_currency, -- t05_amnt_in_txn_currency
                       t05_txn_date = i.txn_date, -- t05_txn_date
                       t05_txn_date_time = i.t43_date, -- t05_txn_date_time
                       t05_settle_date = i.t43_settlement_date, -- t05_settle_date
                       t05_txn_currency_id_m03 = i.txn_currency_id, -- t05_txn_currency_id_m03
                       t05_txn_currency_code_m03 = i.t43_transaction_currency, -- t05_txn_currency_code_m03
                       t05_settle_currency_id_m03 = i.settle_currency_id, -- t05_settle_currency_id_m03
                       t05_settle_currency_code_m03 = i.t43_settle_currency, -- t05_settle_currency_code_m03
                       t05_fx_rate = i.t43_issue_stl_rate, -- t05_fx_rate
                       t05_reference = i.t43_id, -- t05_reference
                       t05_cust_bank_account_id_u08 =
                           i.new_cust_benefcry_acc_id, -- t05_cust_bank_account_id_u08
                       t05_reference_doc_narration =
                           i.t43_reference_doc_narration -- t05_reference_doc_narration
                 WHERE t05_id = i.new_inst_cash_acc_log_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T05_INSTITUTE_CASH_ACC_LOG',
                                i.t43_id,
                                CASE
                                    WHEN i.new_inst_cash_acc_log_id IS NULL
                                    THEN
                                        l_int_cash_acc_id
                                    ELSE
                                        i.new_inst_cash_acc_log_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_inst_cash_acc_log_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/