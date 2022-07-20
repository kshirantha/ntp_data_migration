CREATE OR REPLACE PROCEDURE dfn_ntp.sp_instant_capitalize_margnfee (
    p_view                    OUT SYS_REFCURSOR,
    prows                     OUT NUMBER,
    pinstituteid           IN     NUMBER,
    pcash_account_id_u06   IN     NUMBER)
IS
    l_eod_date   DATE := func_get_eod_date ();
BEGIN
    FOR i
        IN (SELECT t21_cash_account_id_u06,
                   SUM (t21_interest_charge_amt) AS total_interest_charge,
                   SUM (t21_tax_amount) AS total_tax
            FROM t21_daily_interest_for_charges
            WHERE     t21_cash_account_id_u06 = pcash_account_id_u06
                  AND t21_institute_id_m02 = pinstituteid
                  AND t21_status = 0
                  AND t21_charges_code_m97 IN ('MGNFEE_ADJ', 'MGNFEE')
                  AND t21_value_date <= TRUNC (LAST_DAY (SYSDATE))
            GROUP BY t21_cash_account_id_u06)
    LOOP
        IF i.total_interest_charge > 0
        THEN
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
                    16,
                    TRUNC (SYSDATE),
                    i.t21_cash_account_id_u06,
                    -ABS (i.total_interest_charge),
                    'MGNFEE',
                    2,
                    1,
                    'Margin Interest Fee - MGNFEE',
                    i.total_tax);

            UPDATE u06_cash_account u06
               SET u06.u06_accrued_interest =
                         u06.u06_accrued_interest
                       - ABS (i.total_interest_charge)
             WHERE u06.u06_id = pcash_account_id_u06;

            UPDATE t21_daily_interest_for_charges t21
               SET t21.t21_status = 1
             WHERE     t21.t21_cash_account_id_u06 = t21_cash_account_id_u06
                   AND t21.t21_institute_id_m02 = pinstituteid
                   AND t21_status = 0
                   AND t21_charges_code_m97 IN ('MGNFEE_ADJ', 'MGNFEE')
                   AND t21_value_date <= TRUNC (LAST_DAY (SYSDATE));
        END IF;
    END LOOP;

    OPEN p_view FOR
        SELECT a.t21_created_date,
               t21_interest_rate,
               t21_flat_fee,
               t21_interest_charge_amt,
               NULL AS re_calculated_interest
          FROM t21_daily_interest_for_charges a
         WHERE     a.t21_cash_account_id_u06 = pcash_account_id_u06
               AND a.t21_institute_id_m02 = pinstituteid
               AND a.t21_value_date <= TRUNC (LAST_DAY (SYSDATE))
               AND t21_charges_code_m97 IN ('MGNFEE_ADJ', 'MGNFEE')
               AND t21_status = 1;
END;
/