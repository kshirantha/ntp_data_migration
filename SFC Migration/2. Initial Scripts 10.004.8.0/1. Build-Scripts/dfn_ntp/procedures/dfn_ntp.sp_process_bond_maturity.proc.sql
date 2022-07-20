CREATE OR REPLACE PROCEDURE dfn_ntp.sp_process_bond_maturity (l_date IN DATE)
IS
    l_accrual_interest   NUMBER;
BEGIN
    FOR i
        IN (SELECT (  u24.u24_net_holding
                    - u24.u24_receivable_holding
                    + u24.u24_payable_holding)
                       AS u24_net_holding,
                   u24.u24_avg_price,
                   m20e.m20_int_payment_date,
                   u07.u07_cash_account_id_u06,
                   u24.u24_trading_acnt_id_u07,
                   u24.u24_custodian_id_m26,
                   m20.m20_id,
                   u24.u24_exchange_code_m01,
                   u24.u24_symbol_code_m20,
                   m20.m20_strike_price,
                   m20e.m20_interest_rate,
                   v26.v26_upper_value
              FROM m20_symbol m20
                   JOIN m20_symbol_extended m20e
                       ON m20.m20_id = m20e.m20_id
                   JOIN u24_holdings u24
                       ON     m20.m20_exchange_code_m01 =
                                  u24.u24_exchange_code_m01
                          AND m20.m20_symbol_code = u24.u24_symbol_code_m20
                   JOIN u07_trading_account u07
                       ON u24.u24_trading_acnt_id_u07 = u07.u07_id
                   JOIN u06_cash_account u06
                       ON u07.u07_cash_account_id_u06 = u06.u06_id
                   JOIN v26_interest_day_basis v26
                       ON m20e.m20_interest_day_basis_id_v26 = v26.v26_id
             WHERE     m20.m20_instrument_type_code_v09 = 'BN'
                   AND (  u24.u24_net_holding
                        - u24.u24_receivable_holding
                        + u24.u24_payable_holding) > 0
                   AND m20e.m20_maturity_date BETWEEN TRUNC (l_date)
                                                  AND   TRUNC (l_date)
                                                      + 0.99999)
    LOOP
        INSERT INTO a13_cash_holding_adjust_log (a13_id,
                                                 a13_job_id_v07,
                                                 a13_created_date,
                                                 a13_cash_account_id_u06,
                                                 a13_u06_balance,
                                                 a13_u24_trading_acnt_id_u07,
                                                 a13_u24_custodian_id_m26,
                                                 a13_u24_symbol_id_m20,
                                                 a13_u24_symbol_code_m20,
                                                 a13_u24_exchange_code_m01,
                                                 a13_code_m97,
                                                 a13_created_date_time,
                                                 a13_impact_type,
                                                 a13_t02_required,
                                                 a13_u24_net_holding,
                                                 a13_narration)
             VALUES (seq_a13_id.NEXTVAL,                              --a13_id
                     30,                                      --a13_job_id_v07
                     TRUNC (SYSDATE),                       --a13_created_date
                     i.u07_cash_account_id_u06,      --a13_cash_account_id_u06
                     i.u24_net_holding * i.m20_strike_price, --a13_u06_balance
                     i.u24_trading_acnt_id_u07,  --a13_u24_trading_acnt_id_u07
                     i.u24_custodian_id_m26,        --a13_u24_custodian_id_m26
                     i.m20_id,                         --a13_u24_symbol_id_m20
                     i.u24_symbol_code_m20,          --a13_u24_symbol_code_m20
                     i.u24_exchange_code_m01,      --a13_u24_exchange_code_m01
                     'BNMATR',                                  --a13_code_m97
                     SYSDATE,                          --a13_created_date_time
                     6,                                      --a13_impact_type
                     1,                                     --a13_t02_required
                     i.u24_net_holding * -1,            ---a13_u24_net_holding
                     'Bond Maturity - ' || i.u24_symbol_code_m20 --a13_narration
                                                                );

        l_accrual_interest :=
              (TRUNC (l_date) - TRUNC (i.m20_int_payment_date))
            * (  (  i.u24_net_holding
                  * i.m20_strike_price
                  * i.m20_interest_rate)
               / (i.v26_upper_value * 100));

        IF l_accrual_interest > 0
        THEN
            INSERT
              INTO a13_cash_holding_adjust_log (a13_id,
                                                a13_job_id_v07,
                                                a13_created_date,
                                                a13_cash_account_id_u06,
                                                a13_u06_balance,
                                                a13_u24_trading_acnt_id_u07,
                                                a13_u24_custodian_id_m26,
                                                a13_u24_symbol_id_m20,
                                                a13_u24_symbol_code_m20,
                                                a13_u24_exchange_code_m01,
                                                a13_code_m97,
                                                a13_created_date_time,
                                                a13_impact_type,
                                                a13_t02_required,
                                                a13_narration)
            VALUES (seq_a13_id.NEXTVAL,                               --a13_id
                    30,                                       --a13_job_id_v07
                    TRUNC (SYSDATE),                        --a13_created_date
                    i.u07_cash_account_id_u06,       --a13_cash_account_id_u06
                    l_accrual_interest,                      --a13_u06_balance
                    i.u24_trading_acnt_id_u07,   --a13_u24_trading_acnt_id_u07
                    i.u24_custodian_id_m26,         --a13_u24_custodian_id_m26
                    i.m20_id,                          --a13_u24_symbol_id_m20
                    i.u24_symbol_code_m20,           --a13_u24_symbol_code_m20
                    i.u24_exchange_code_m01,       --a13_u24_exchange_code_m01
                    'BNINTR',                                   --a13_code_m97
                    SYSDATE,                           --a13_created_date_time
                    2,                                       --a13_impact_type
                    1,                                      --a13_t02_required
                    'Bond Accrued Interest - ' || i.u24_symbol_code_m20 --a13_narration
                                                                       );
        END IF;
    END LOOP;

    UPDATE m20_symbol
       SET m20_trading_status_id_v22 = 0                             --Expired
     WHERE     m20_instrument_type_code_v09 = 'BN'
           AND m20_id IN
                   (SELECT m20_id
                      FROM m20_symbol_extended m20e
                     WHERE m20_maturity_date BETWEEN TRUNC (l_date)
                                                 AND TRUNC (l_date) + 0.99999);
END;
/