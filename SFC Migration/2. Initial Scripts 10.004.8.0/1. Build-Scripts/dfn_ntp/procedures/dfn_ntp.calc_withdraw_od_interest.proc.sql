CREATE OR REPLACE PROCEDURE dfn_ntp.calc_withdraw_od_interest (
    in_date    IN DATE DEFAULT SYSDATE,
    cash_acc   IN NUMBER DEFAULT 0,
    status     IN NUMBER DEFAULT 0)
IS
    posteddate   DATE;
BEGIN
    FOR i
        IN (SELECT a.u06_id,
                   m02.m02_id,
                   NVL (a.u06_withdr_overdrawn_amt, 0) withdrodamt,
                   NVL (m118_interest_rate,
                        NVL (m02.m02_overdrawn_interest_rate, 0))
                       interest_rate,
                   ROUND (
                       ABS (
                             NVL (a.u06_withdr_overdrawn_amt, 0)
                           * NVL (m118_interest_rate,
                                  NVL (m02.m02_overdrawn_interest_rate, 0))
                           / 36000),
                       2)
                       AS charge_amt,
                   ROUND (
                         ROUND (
                             ABS (
                                   NVL (a.u06_withdr_overdrawn_amt, 0)
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
                   m97.m97_id AS chargeid,
                   1 AS postedfquencetype,
                   m97.m97_code AS charge_code,
                   m118.m118_broker_vat
            FROM u06_cash_account a,
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
            WHERE     a.u06_institute_id_m02 = m02.m02_id
                  AND a.u06_institute_id_m02 = m118_institute_id_m02(+)
                  AND a.u06_charges_group_m117 = m118.m118_group_id_m117(+)
                  AND a.u06_currency_code_m03 =
                          m118.m118_currency_code_m03(+)
                  AND NVL (a.u06_withdr_overdrawn_amt, 0) < 0
                  AND m97.m97_code = 'WODINT'
                  AND (a.u06_id = cash_acc OR cash_acc = 0))
    LOOP
        posteddate := fn_get_posted_date (i.postedfquencetype, in_date);

        IF (i.charge_amt > 0)
        THEN
            INSERT
              INTO t21_daily_interest_for_charges a (
                       a.t21_id,
                       a.t21_cash_account_id_u06,
                       a.t21_charges_id_m97,
                       a.t21_interest_charge_amt,
                       a.t21_created_date,
                       a.t21_value_date,
                       a.t21_status,
                       a.t21_remarks,
                       a.t21_cash_transaction_id_t06,
                       a.t21_ovedraw_amt,
                       a.t21_interest_rate,
                       a.t21_posted_date,
                       a.t21_frequency_id,
                       a.t21_charges_code_m97,
                       a.t21_created_by_id_u17,
                       a.t21_approved_by_id_u17,
                       a.t21_approved_date,
                       a.t21_trans_value_date,
                       --  a.t21_interest_indices_rate_m65,
                       a.t21_tax_amount,
                       a.t21_tax_rate)
            VALUES (fn_get_next_sequnce ('T21_DAILY_INTEREST_FOR_CHARGES'),
                    i.u06_id,
                    i.chargeid,
                    i.charge_amt + i.tax_amount,
                    in_date,
                    posteddate,
                    status,
                    '',
                    NULL,
                    i.withdrodamt,
                    i.interest_rate,
                    NULL,
                    1,
                    i.charge_code,
                    0,
                    NULL,
                    NULL,
                    NULL,
                    --   i.m65_rate, -- t21_interest_indices_rate_m65
                    i.tax_amount,
                    i.m118_broker_vat);
        END IF;
    END LOOP;
END;
/