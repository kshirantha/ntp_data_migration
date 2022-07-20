CREATE OR REPLACE PROCEDURE dfn_ntp.sp_margin_funding_covering_b (
    ptype   IN NUMBER -- 0 -> LOCAL, 1 -> INTL
                     )
IS
BEGIN
    FOR i
        IN (SELECT u06.u06_id,
                   u06.u06_balance,
                   u06.u06_loan_amount,
                   CASE
                       WHEN u06.u06_balance < 0
                       THEN
                           u06.u06_balance * -1
                       ELSE
                           CASE
                               WHEN u06.u06_balance > u06.u06_loan_amount
                               THEN
                                   u06.u06_loan_amount * -1
                               ELSE
                                   u06.u06_balance * -1
                           END
                   END AS fund_cover_amt
            FROM (SELECT u06_id,
                           u06_balance
                         + u06_payable_blocked
                         - u06_receivable_amount AS u06_balance,
                         u06_loan_amount,
                         u06_currency_code_m03
                  FROM u06_cash_account) u06,
                 u23_customer_margin_product u23
            WHERE     u06.u06_id = u23.u23_default_cash_acc_id_u06
                  AND (   (ptype = 0 --LOCAL
                                     AND u06.u06_currency_code_m03 = 'SAR')
                       OR (ptype = 1 -- INTL
                                     AND u06.u06_currency_code_m03 != 'SAR'))
                  AND (   u06.u06_balance < 0
                       OR (u06.u06_balance > 0 AND u06.u06_loan_amount > 0)))
    LOOP
        INSERT INTO a13_cash_holding_adjust_log (a13_id,
                                                 a13_job_id_v07,
                                                 a13_created_date,
                                                 a13_cash_account_id_u06,
                                                 a13_u06_balance,
                                                 a13_code_m97,
                                                 a13_impact_type,
                                                 a13_t02_required,
                                                 a13_narration,
                                                 a13_u06_loan_amount)
            VALUES (
                seq_a13_id.NEXTVAL,
                16,
                TRUNC (SYSDATE),
                i.u06_id,
                i.fund_cover_amt,
                CASE
                    WHEN i.fund_cover_amt > 0 THEN 'MRGFND'
                    ELSE 'MRGCOV'
                END,
                2,
                1,
                   'Margin '
                || CASE
                       WHEN i.fund_cover_amt > 0 THEN 'Funding - MRGFND'
                       ELSE 'Covering - MRGCOV'
                   END,
                i.fund_cover_amt);
    END LOOP;
END;
/