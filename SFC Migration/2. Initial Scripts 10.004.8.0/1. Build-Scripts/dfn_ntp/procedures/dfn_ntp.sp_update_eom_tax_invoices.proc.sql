CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_eom_tax_invoices (
    in_date IN DATE DEFAULT SYSDATE)
IS
    l_start_date   DATE;
    l_end_date     DATE;
    l_today        DATE;
    l_invoice_no   VARCHAR2 (20);
    i_last_seq     NUMBER;
BEGIN
    IF (TRUNC (in_date) = TRUNC (LAST_DAY (in_date)))
    THEN
        l_today := TO_DATE (TRUNC (in_date), 'DD/MM/YYYY');

        SELECT MAX (app_seq_value)
          INTO i_last_seq
          FROM app_seq_store
         WHERE app_seq_name = 'T48_TAX_INVOICES';

        SELECT TO_DATE (TRUNC (in_date, 'month'), 'DD/MM/YYYY')
          INTO l_start_date
          FROM DUAL;

        SELECT TO_DATE (TRUNC (LAST_DAY (in_date)), 'DD/MM/YYYY')
          INTO l_end_date
          FROM DUAL;

        FOR i
            IN (  SELECT t02.t02_customer_id_u01,
                         t02.t02_cash_acnt_id_u06 AS cash_acnt_id_u06,
                         MAX (t02.t02_inst_id_m02) AS inst_id_m02
                    FROM t02_transaction_log_all t02
                   WHERE t02.t02_cash_settle_date BETWEEN   l_start_date
                                                          + 0.99999
                                                      AND l_end_date + 0.99999
                GROUP BY t02.t02_customer_id_u01, t02.t02_cash_acnt_id_u06)
        LOOP
            i_last_seq := NVL (i_last_seq, 0) + 1;

            SELECT LPAD (i_last_seq, 10, '0') INTO l_invoice_no FROM DUAL;

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
                 VALUES (i_last_seq,
                         l_invoice_no,
                         i.t02_customer_id_u01,
                         l_start_date,
                         l_end_date,
                         l_today,
                         'ALL',
                         NULL,
                         1,
                         i.inst_id_m02,
                         1,
                         i.cash_acnt_id_u06);

            FOR j
                IN (SELECT t02.t02_last_db_seq_id, t02.t02_txn_code
                      FROM t02_transaction_log_all t02
                     WHERE     t02.t02_customer_id_u01 =
                                   i.t02_customer_id_u01
                           AND t02.t02_cash_acnt_id_u06 = i.cash_acnt_id_u06
                           AND t02.t02_inst_id_m02 = i.inst_id_m02
                           AND t02.t02_cash_settle_date BETWEEN   l_start_date
                                                                + 0.99999
                                                            AND   l_end_date
                                                                + 0.99999
                           AND (t02.t02_exchange_tax + t02.t02_broker_tax /* + t02.t02_exec_cma_tax + t02.t02_exec_cpp_tax + t02.t02_exec_dcm_tax*/
                                                                         ) >
                                   0)
            LOOP
                INSERT
                  INTO t49_tax_invoice_details (t49_invoice_no_t48,
                                                t49_last_db_seq_id_t02,
                                                t49_txn_code)
                VALUES (l_invoice_no, j.t02_last_db_seq_id, j.t02_txn_code);
            END LOOP;
        END LOOP;

        UPDATE app_seq_store
           SET app_seq_value = i_last_seq
         WHERE app_seq_name = 'T48_TAX_INVOICES';

        COMMIT;
    END IF;
END;
/
