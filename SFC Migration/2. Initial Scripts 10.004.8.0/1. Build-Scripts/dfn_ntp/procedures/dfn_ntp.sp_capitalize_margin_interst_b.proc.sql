CREATE OR REPLACE PROCEDURE dfn_ntp.sp_capitalize_margin_interst_b (
    ptype   IN NUMBER -- 0 -> LOCAL, 1 -> INTL
                     )
IS
    l_eod_date   DATE := func_get_eod_date ();
BEGIN
    FOR i
        IN (SELECT t21_cash_account_id_u06,
                   'MGNFEE' AS t21_charges_code_m97,
                   SUM (t21_interest_charge_amt) AS total_int_charge,
                   SUM (t21_tax_amount) AS total_tax
            FROM t21_daily_interest_for_charges t21
                 JOIN u06_cash_account u06
                     ON t21.t21_cash_account_id_u06 = u06.u06_id
            WHERE     t21_status = 0
                  AND (   (ptype = 0 --LOCAL
                                     AND u06.u06_currency_code_m03 = 'SAR')
                       OR (ptype = 1 -- INTL
                                     AND u06.u06_currency_code_m03 != 'SAR'))
                  AND t21_charges_code_m97 IN ('MGNFEE_ADJ', 'MGNFEE')
                  AND t21_value_date <= l_eod_date + 0.99999 -- to get what ever pending till today
            GROUP BY t21_cash_account_id_u06)
    LOOP
        IF i.total_int_charge > 0
        THEN
            INSERT INTO a13_cash_holding_adjust_log a (
                            a13_id,
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
                    -ABS (i.total_int_charge),
                    i.t21_charges_code_m97,
                    2,
                    1,
                    'Margin Interest Fee - ' || i.t21_charges_code_m97,
                    i.total_tax);

            UPDATE u06_cash_account u06
            SET u06.u06_accrued_interest =
                    u06.u06_accrued_interest - ABS (i.total_int_charge)
            WHERE u06.u06_id = i.t21_cash_account_id_u06;
        END IF;
    END LOOP;

    COMMIT;

    UPDATE (SELECT t21.t21_status
            FROM t21_daily_interest_for_charges t21
                 INNER JOIN u06_cash_account u06
                     ON     t21.t21_cash_account_id_u06 = u06.u06_id
                        AND (   (    ptype = 0 --LOCAL
                                 AND u06.u06_currency_code_m03 = 'SAR')
                             OR (    ptype = 1 -- INTL
                                 AND u06.u06_currency_code_m03 != 'SAR'))
            WHERE     t21_status = 0
                  AND t21_charges_code_m97 IN ('MGNFEE_ADJ', 'MGNFEE')
                  AND t21_value_date <= l_eod_date + 0.99999) t21
    SET t21.t21_status = 1;
END;
/