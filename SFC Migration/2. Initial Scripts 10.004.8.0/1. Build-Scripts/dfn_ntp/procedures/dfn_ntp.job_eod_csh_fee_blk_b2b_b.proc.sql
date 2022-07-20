CREATE OR REPLACE PROCEDURE dfn_ntp.job_eod_csh_fee_blk_b2b_b
IS
    l_dependant_job_status        NUMBER;
    l_dependant_job               VARCHAR (100);
    l_current_job_id              NUMBER;
    l_current_job_log_id          NUMBER;
    l_t02_amnt_in_txn_currency    NUMBER := 0;
    l_u06_id                      NUMBER := 0;
    l_u06_currency_code_m03       VARCHAR2 (10);
    l_u08_id                      NUMBER := 0;
    l_u08_bank_account_type_v01   NUMBER := 0;
    l_user_id                     NUMBER := 0;
BEGIN
    SELECT v07_id
      INTO l_current_job_id
      FROM v07_db_jobs
     WHERE v07_job_name = 'EOD_CASH_TRN_FEE_BULK_UPDATE_FTB_B';

    job_sch_verify_job_dependancy (l_dependant_job_status,
                                   l_dependant_job,
                                   l_current_job_id);

    IF (l_dependant_job_status > 0)
    THEN
        job_sch_insert_job_history (l_current_job_log_id, l_current_job_id);

        SELECT SUM (ABS (NVL (t02_amnt_in_txn_currency, 0)))
                   t02_amnt_in_txn_currency
          INTO l_t02_amnt_in_txn_currency
          FROM t02_transaction_log a
         WHERE     t02_txn_code IN ('CTRFEE_OTR', 'CTRFEE_INT', 'CTRFEE_BNK')
               AND t02_eod_bulk_post_b = 0
               AND a.t02_create_date BETWEEN TRUNC (SYSDATE - 2)
                                         AND TRUNC (SYSDATE) + 0.99999;

        SELECT u17.u17_id
          INTO l_user_id
          FROM u17_employee u17
         WHERE u17.u17_login_name = 'INTEGRATION_USER';

        SELECT u06_id, u06.u06_currency_code_m03
          INTO l_u06_id, l_u06_currency_code_m03
          FROM u06_cash_account u06
         WHERE u06_external_ref_no = 'OMNIPINV';

        SELECT u08_id, u08_bank_account_type_v01
          INTO l_u08_id, l_u08_bank_account_type_v01
          FROM u08_customer_beneficiary_acc u08
         WHERE u08_iban_no = 'FTFTOAC';

        INSERT INTO t06_cash_transaction (t06_id,
                                          t06_cash_acc_id_u06,
                                          t06_code,
                                          t06_date,
                                          t06_narration,
                                          t06_payment_method,
                                          t06_txn_code_m03,
                                          t06_amt_in_txn_currency,
                                          t06_settle_currency_rate_m04,
                                          t06_settlement_date,
                                          t06_beneficiary_id_u08,
                                          t06_entered_by_id_u17,
                                          t06_entered_date,
                                          t06_last_changed_by_id_u17,
                                          t06_last_changed_date,
                                          t06_status_id,
                                          t06_settle_currency_code_m03,
                                          t06_amt_in_settle_currency,
                                          t06_institute_id_m02,
                                          t06_type_id)
             VALUES ( (SELECT MAX (t06_id) + 1 FROM t06_cash_transaction), --t06_id
                     l_u06_id,
                     'FTB',
                     SYSDATE,
                     'EOD Cash Transfer Fee',
                     '3',
                     l_u06_currency_code_m03,
                     l_t02_amnt_in_txn_currency,
                     1,                         --t06_settle_currency_rate_m04
                     SYSDATE,
                     l_u08_id,                        --t06_beneficiary_id_u08
                     l_user_id,
                     SYSDATE,
                     l_user_id,
                     SYSDATE,
                     30,                                       --t06_status_id
                     l_u06_currency_code_m03,   --t06_settle_currency_code_m03
                     l_t02_amnt_in_txn_currency,  --t06_amt_in_settle_currency
                     1,
                     l_u08_bank_account_type_v01);

        UPDATE t02_transaction_log a
           SET t02_eod_bulk_post_b = 1
         WHERE     t02_txn_code IN ('CTRFEE_OTR', 'CTRFEE_INT', 'CTRFEE_BNK')
               AND t02_eod_bulk_post_b = 0
               AND a.t02_create_date BETWEEN TRUNC (SYSDATE - 2)
                                         AND TRUNC (SYSDATE) + 0.99999;

        COMMIT;

        job_sch_update_job_history (
            l_current_job_id,
            l_current_job_log_id,
            1,
            'EOD_CASH_TRN_FEE_BULK_UPDATE_FTB_B Executed Successfully');
    ELSE
        job_sch_update_job_history (
            l_current_job_id,
            l_current_job_log_id,
            3,
               'ERROR!!! Dependancy Job '
            || l_dependant_job
            || ' Not Executed! Current Job EOD_CASH_TRN_FEE_BULK_UPDATE_FTB_B Will Not Execute');

        job_sch_send_notification (
               'ERROR!!! Dependancy Job '
            || l_dependant_job
            || ' Not Executed! Current Job EOD_CASH_TRN_FEE_BULK_UPDATE_FTB_B Will Not Execute');
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        COMMIT;

        job_sch_update_job_history (l_current_job_id,
                                    l_current_job_log_id,
                                    3,
                                    SUBSTR (SQLERRM, 1, 512));

        job_sch_send_notification (
               'ERROR!!! EOD_CASH_TRN_FEE_BULK_UPDATE_FTB_B Execution Failed -> '
            || SUBSTR (SQLERRM, 1, 512));
END;
/
