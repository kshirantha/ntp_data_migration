CREATE OR REPLACE PROCEDURE dfn_ntp.sp_e100_process_deposit_txn_c
IS
    l_default_m93                NUMBER;
    l_m93_online_trans_type      NUMBER;
    l_is_first                   NUMBER := 1;
    l_t86_id                     NUMBER;
    l_primary_institute_id_m02   NUMBER;
    l_institute_id_m02           NUMBER;
BEGIN
    SELECT m93.m93_id, m93.m93_online_trans_type_id_v01
      INTO l_default_m93, l_m93_online_trans_type
      FROM m93_bank_accounts m93
     WHERE     m93.m93_is_default_omnibus = 1
           AND m93.m93_currency_code_m03 = 'SAR';

    FOR i
        IN (SELECT e100_data AS data,
                   e100_client_id AS clientid,
                   e100_cash_account AS cashaccount,
                   e100_transac_date AS transactiondate,
                   e100_value_date AS valuedate,
                   e100_txn_timestamp AS transactimestamp,
                   e100_trans_type AS transtype,
                   e100_branch_code AS branchcode,
                   e100_transac_ref AS transacref,
                   e100_txn_type AS txntype,
                   e100_withdrawal_type AS TYPE,
                   e100_currency AS currency,
                   e100_amount AS amount,
                   e100_debit_account AS debitaccount,
                   e100_debit_acc_name AS debaccname,
                   e100_seq_no AS sequenceno,
                   u06.u06_id,
                   NVL (m93.m93_id, 0) AS m93_account_id,
                   NVL (m93.m93_online_trans_type_id_v01, 0)
                       AS m93_online_trans_type_id_v01,
                   'Valid' AS record_status,
                   '' AS record_status_reason,
                   '' AS process_status,
                   '' AS process_status_reason,
                   u06.u06_customer_id_u01,
                   u06.u06_currency_code_m03,
                   u06.u06_institute_id_m02
            FROM e100_process_deposit_txn_c a
                 LEFT OUTER JOIN u06_cash_account u06
                     ON e100_cash_account = u06.u06_investment_account_no
                 LEFT OUTER JOIN m93_bank_accounts m93
                     ON e100_debit_account = m93.m93_accountno
            WHERE u06.u06_status_id_v01 NOT IN (3))
    LOOP
        IF (   l_is_first = 1
            OR l_institute_id_m02 IS NULL
            OR l_institute_id_m02 <> i.u06_institute_id_m02)
        THEN
            l_t86_id := seq_t86_id.NEXTVAL;
            l_institute_id_m02 := i.u06_institute_id_m02;

            SELECT m02_primary_institute_id_m02
              INTO l_primary_institute_id_m02
              FROM m02_institute
             WHERE m02_id = i.u06_institute_id_m02;

            INSERT
              INTO t86_bulk_cash_holding_process (
                       t86_id,
                       t86_created_date,
                       t86_description,
                       t86_txn_type,
                       t86_status_id_v01,
                       t86_primary_institute_id_m02,
                       t86_type,
                       t86_user_id_u17,
                       t86_position_date)
            VALUES (l_t86_id,
                    SYSDATE,
                    'Falcom Deposit File upload',
                    5,
                    1,
                    l_primary_institute_id_m02,
                    1,
                    1,
                    TRUNC (SYSDATE));

            l_is_first := 0;
        END IF;

        INSERT INTO t87_bulk_cash_adjustments (t87_id,
                                               t87_institute_id_m02,
                                               t87_cash_account_id_u06,
                                               t87_txn_code,
                                               t87_txn_currency,
                                               t87_amnt_in_txn_currency,
                                               t87_settle_currency,
                                               t87_fx_rate,
                                               t87_amnt_in_stl_currency,
                                               t87_description,
                                               t87_batch_id_t86,
                                               t87_type,
                                               t87_bank_id_m93,
                                               t87_online_trans_type_id_v01,
                                               t87_customer_id_u01)
            VALUES (
                       seq_t87_id.NEXTVAL,
                       i.u06_institute_id_m02,
                       i.u06_id,
                       'DEPOST',
                       i.currency,
                       i.amount,
                       i.u06_currency_code_m03,
                       get_exchange_rate (i.u06_institute_id_m02,
                                          i.currency,
                                          i.u06_currency_code_m03),
                         i.amount
                       * get_exchange_rate (i.u06_institute_id_m02,
                                            i.currency,
                                            i.u06_currency_code_m03),
                       'Deposit File Upload',
                       l_t86_id,
                       1,
                       i.m93_account_id,
                       i.m93_online_trans_type_id_v01,
                       i.u06_customer_id_u01);
    END LOOP;
END;
/