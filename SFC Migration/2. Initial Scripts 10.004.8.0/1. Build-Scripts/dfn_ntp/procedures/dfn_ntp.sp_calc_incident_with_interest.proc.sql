CREATE OR REPLACE PROCEDURE dfn_ntp.sp_calc_incident_with_interest (
    in_date    IN DATE DEFAULT SYSDATE,
    cash_acc   IN NUMBER DEFAULT 0,
    status     IN NUMBER DEFAULT 0)
IS
    posteddate   DATE;
BEGIN
    FOR i
        IN (SELECT u06.u06_id,
                   m02.m02_id,
                   NVL (u06.u06_withdr_overdrawn_amt, 0) withdr_od_amount,
                   NVL (m118_interest_rate,
                        NVL (m02.m02_overdrawn_interest_rate, 0))
                       interest_rate,
                   ROUND (
                       ABS (
                             NVL (u06.u06_withdr_overdrawn_amt, 0)
                           * NVL (m118_interest_rate,
                                  NVL (m02.m02_overdrawn_interest_rate, 0))
                           / 36000),
                       2)
                       AS charge_amt,
                   ROUND (
                         ROUND (
                             ABS (
                                   NVL (u06.u06_withdr_overdrawn_amt, 0)
                                 * NVL (
                                       m118_interest_rate,
                                       NVL (m02.m02_overdrawn_interest_rate,
                                            0))
                                 / 36000),
                             2)
                       * NVL (m118_broker_vat, 0)
                       / 100,
                       2)
                       AS tax_amount,
                   m97.m97_id,
                   1 AS posted_frequency_type,
                   m97.m97_code,
                   m118.m118_broker_vat
            FROM u06_cash_account u06,
                 m02_institute m02,
                 m97_transaction_codes m97,
                 (SELECT m118_group_id_m117,
                         m118_institute_id_m02,
                         NVL (MAX (m118_interest_rate), 0) m118_interest_rate,
                         NVL (MAX (m118_broker_vat), 0) m118_broker_vat,
                         m118_currency_code_m03
                    FROM m118_charge_fee_structure m118
                   WHERE m118_charge_code_m97 = 'WODINT'
                  GROUP BY m118_group_id_m117,
                           m118_currency_code_m03,
                           m118_institute_id_m02) m118
            WHERE     u06.u06_institute_id_m02 = m02.m02_id
                  AND u06.u06_institute_id_m02 = m118_institute_id_m02(+)
                  AND u06.u06_charges_group_m117 = m118.m118_group_id_m117(+)
                  AND u06.u06_currency_code_m03 =
                          m118.m118_currency_code_m03(+)
                  AND NVL (u06.u06_withdr_overdrawn_amt, 0) < 0
                  AND m97.m97_code = 'WODINT'
                  AND (u06.u06_id = cash_acc OR cash_acc = 0))
    LOOP
        posteddate := fn_get_posted_date (i.posted_frequency_type, in_date);

        IF (i.charge_amt > 0)
        THEN
            INSERT
              INTO t21_daily_interest_for_charges (
                       t21_id,
                       t21_cash_account_id_u06,
                       t21_charges_id_m97,
                       t21_interest_charge_amt,
                       t21_created_date,
                       t21_value_date,
                       t21_status,
                       t21_remarks,
                       t21_cash_transaction_id_t06,
                       t21_ovedraw_amt,
                       t21_interest_rate,
                       t21_posted_date,
                       t21_frequency_id,
                       t21_charges_code_m97,
                       t21_created_by_id_u17,
                       t21_trans_value_date,
                       t21_institute_id_m02,
                       -- t21_interest_indices_rate_m65,
                       t21_tax_amount,
                       t21_tax_rate)
            VALUES (fn_get_next_sequnce ('T21_DAILY_INTEREST_FOR_CHARGES'),
                    i.u06_id,
                    i.m97_id,
                    i.charge_amt + i.tax_amount,
                    in_date,
                    posteddate,
                    status,
                    '',
                    NULL,
                    i.withdr_od_amount,
                    i.interest_rate,
                    NULL,
                    1,
                    i.m97_code,
                    0,
                    NULL,
                    i.m02_id,
                    --     i.m65_rate, -- t21_interest_indices_rate_m65
                    i.tax_amount,
                    i.m118_broker_vat);
        END IF;
    END LOOP;
END;
/