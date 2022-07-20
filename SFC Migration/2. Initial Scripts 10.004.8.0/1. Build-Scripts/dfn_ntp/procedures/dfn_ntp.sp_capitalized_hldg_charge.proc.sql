CREATE OR REPLACE PROCEDURE dfn_ntp.sp_capitalized_hldg_charge (
    p_custodian_id    NUMBER DEFAULT -1)
IS
    l_eod_date             DATE := func_get_eod_date ();
    l_fx_rate_for_nastro   NUMBER;
    l_currency_code        VARCHAR2 (3);
BEGIN
    IF (p_custodian_id = -1)
    THEN
        FOR i
            IN (SELECT t21_cash_account_id_u06,
                       t21_custodian_id_m26,
                       t21_charges_id_m97,
                       t21_charges_code_m97,
                       t21_institute_id_m02,
                       t21_frequency_id,
                       charge_amt,
                       total_tax,
                       u06.u06_currency_code_m03,
                       u06.u06_currency_id_m03,
                       m72.m72_id,
                       m72.m72_currency_id_m03,
                       m72.m72_currency_code_m03
                FROM (SELECT t21.t21_cash_account_id_u06,
                             t21.t21_custodian_id_m26,
                             t21_charges_id_m97,
                             t21_charges_code_m97,
                             t21_institute_id_m02,
                             t21.t21_frequency_id,
                             SUM (t21.t21_interest_charge_amt) AS charge_amt,
                             SUM (t21_tax_amount) AS total_tax
                        FROM t21_daily_interest_for_charges t21
                       WHERE     t21.t21_status = 0
                             AND t21_charges_code_m97 IN ('CUDYHLDFEE')
                             AND t21.t21_value_date BETWEEN l_eod_date
                                                        AND   l_eod_date
                                                            + 0.99999
                      GROUP BY t21.t21_cash_account_id_u06,
                               t21.t21_custodian_id_m26,
                               t21_charges_id_m97,
                               t21_charges_code_m97,
                               t21_institute_id_m02,
                               t21.t21_frequency_id) hldg
                     INNER JOIN u06_cash_account u06
                         ON hldg.t21_cash_account_id_u06 = u06.u06_id
                     INNER JOIN m72_exec_broker_cash_account m72
                         ON hldg.t21_custodian_id_m26 =
                                m72.m72_exec_broker_id_m26
                WHERE m72.m72_is_default = 1)
        LOOP
            l_fx_rate_for_nastro :=
                get_exchange_rate (i.t21_institute_id_m02,
                                   i.u06_currency_code_m03,
                                   i.m72_currency_code_m03);


            INSERT
              INTO a13_cash_holding_adjust_log a (a13_id,
                                                  a13_job_id_v07,
                                                  a13_created_date,
                                                  a13_cash_account_id_u06,
                                                  a.a13_u06_balance,
                                                  a.a13_code_m97,
                                                  a13_impact_type,
                                                  a13_t02_required,
                                                  a13_narration,
                                                  a13_broker_tax)
            VALUES (seq_a13_id.NEXTVAL,
                    23,
                    TRUNC (SYSDATE),
                    i.t21_cash_account_id_u06,
                    -ABS (i.charge_amt),
                    'CUDYHLDFEE',
                    2,
                    1,
                    'Custodian Holding Charge - ' || i.t21_charges_code_m97,
                    i.total_tax);



            UPDATE m72_exec_broker_cash_account
               SET m72_balance =
                         m72_balance
                       + ABS (i.charge_amt) * l_fx_rate_for_nastro
             WHERE m72_id = i.m72_id;


            INSERT INTO t07_nastro_account_log (t07_id,
                                                t07_institute_id_m02,
                                                t07_custodian_id_m26,
                                                t07_nastro_acc_id_m72,
                                                t07_txn_id_m97,
                                                t07_txn_code_m97,
                                                t07_amnt_in_stl_currency,
                                                t07_amnt_in_txn_currency,
                                                t07_fx_rate,
                                                t07_txn_date,
                                                t07_txn_currency_code_m03,
                                                t07_stl_currency_code_m03,
                                                t07_trans_activity_id_v01,
                                                t07_custom_type)
            VALUES (seq_t07_id.NEXTVAL,
                    i.t21_institute_id_m02,
                    i.t21_custodian_id_m26,
                    i.m72_id,
                    47,
                    'CUDYORDFEE',
                    i.charge_amt * l_fx_rate_for_nastro,
                    i.charge_amt,
                    l_fx_rate_for_nastro,
                    SYSDATE,
                    i.u06_currency_code_m03,
                    i.m72_currency_code_m03,
                    1,
                    '1');
        END LOOP;

        UPDATE t21_daily_interest_for_charges t21
           SET t21.t21_status = 1
         WHERE     t21_status = 0
               AND t21_charges_code_m97 IN ('CUDYHLDFEE')
               AND t21.t21_value_date BETWEEN l_eod_date
                                          AND l_eod_date + 0.99999;


        UPDATE m26_executing_broker m26
           SET m26.m26_hold_chrg_last_pay_date = SYSDATE
         WHERE m26.m26_id IN
                   (SELECT DISTINCT t21_custodian_id_m26
                      FROM t21_daily_interest_for_charges t21
                     WHERE     t21_status = 0
                           AND t21_charges_code_m97 IN ('CUDYHLDFEE')
                           AND t21.t21_value_date BETWEEN l_eod_date
                                                      AND   l_eod_date
                                                          + 0.99999);
    ELSE
        FOR i
            IN (SELECT t21_cash_account_id_u06,
                       t21_custodian_id_m26,
                       t21_charges_id_m97,
                       t21_charges_code_m97,
                       t21_institute_id_m02,
                       t21_frequency_id,
                       charge_amt,
                       total_tax,
                       u06.u06_currency_code_m03,
                       u06.u06_currency_id_m03,
                       m72.m72_id,
                       m72.m72_currency_id_m03,
                       m72.m72_currency_code_m03
                FROM (SELECT t21.t21_cash_account_id_u06,
                             t21.t21_custodian_id_m26,
                             t21_charges_id_m97,
                             t21_charges_code_m97,
                             t21_institute_id_m02,
                             t21.t21_frequency_id,
                             SUM (t21.t21_interest_charge_amt) AS charge_amt,
                             SUM (t21_tax_amount) AS total_tax
                        FROM t21_daily_interest_for_charges t21
                       WHERE     t21_custodian_id_m26 = p_custodian_id
                             AND t21.t21_status = 0
                             AND t21_charges_code_m97 IN ('CUDYHLDFEE')
                      GROUP BY t21.t21_cash_account_id_u06,
                               t21.t21_custodian_id_m26,
                               t21_charges_id_m97,
                               t21_charges_code_m97,
                               t21_institute_id_m02,
                               t21.t21_frequency_id) hldg
                     INNER JOIN u06_cash_account u06
                         ON hldg.t21_cash_account_id_u06 = u06.u06_id
                     INNER JOIN m72_exec_broker_cash_account m72
                         ON hldg.t21_custodian_id_m26 =
                                m72.m72_exec_broker_id_m26
                WHERE m72.m72_is_default = 1)
        LOOP
            l_fx_rate_for_nastro :=
                get_exchange_rate (i.t21_institute_id_m02,
                                   i.u06_currency_code_m03,
                                   i.m72_currency_code_m03);

            INSERT
              INTO a13_cash_holding_adjust_log a (a13_id,
                                                  a13_job_id_v07,
                                                  a13_created_date,
                                                  a13_cash_account_id_u06,
                                                  a.a13_u06_balance,
                                                  a.a13_code_m97,
                                                  a13_impact_type,
                                                  a13_t02_required,
                                                  a13_narration,
                                                  a13_broker_tax)
            VALUES (seq_a13_id.NEXTVAL,
                    23,
                    TRUNC (SYSDATE),
                    i.t21_cash_account_id_u06,
                    -ABS (i.charge_amt),
                    'CUDYHLDFEE',
                    2,
                    1,
                    'Custodian Holding Charge - ' || i.t21_charges_code_m97,
                    i.total_tax);



            UPDATE m72_exec_broker_cash_account
               SET m72_balance =
                         m72_balance
                       + ABS (i.charge_amt) * l_fx_rate_for_nastro
             WHERE m72_id = i.m72_id;


            INSERT INTO t07_nastro_account_log (t07_id,
                                                t07_institute_id_m02,
                                                t07_custodian_id_m26,
                                                t07_nastro_acc_id_m72,
                                                t07_txn_id_m97,
                                                t07_txn_code_m97,
                                                t07_amnt_in_stl_currency,
                                                t07_amnt_in_txn_currency,
                                                t07_fx_rate,
                                                t07_txn_date,
                                                t07_txn_currency_code_m03,
                                                t07_stl_currency_code_m03,
                                                t07_trans_activity_id_v01,
                                                t07_custom_type)
            VALUES (seq_t07_id.NEXTVAL,
                    i.t21_institute_id_m02,
                    i.t21_custodian_id_m26,
                    i.m72_id,
                    47,
                    'CUDYORDFEE',
                    i.charge_amt * l_fx_rate_for_nastro,
                    i.charge_amt,
                    l_fx_rate_for_nastro,
                    SYSDATE,
                    i.u06_currency_code_m03,
                    i.m72_currency_code_m03,
                    1,
                    '1');
        END LOOP;

        UPDATE t21_daily_interest_for_charges t21
           SET t21.t21_status = 1
         WHERE     t21_custodian_id_m26 = p_custodian_id
               AND t21_status = 0
               AND t21_charges_code_m97 IN ('CUDYHLDFEE');

        UPDATE m26_executing_broker m26
           SET m26.m26_hold_chrg_last_pay_date = SYSDATE
         WHERE m26.m26_id = p_custodian_id;
    END IF;
END;
/
