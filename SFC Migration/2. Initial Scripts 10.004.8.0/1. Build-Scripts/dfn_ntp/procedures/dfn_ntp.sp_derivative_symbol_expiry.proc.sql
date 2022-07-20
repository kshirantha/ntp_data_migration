CREATE OR REPLACE PROCEDURE dfn_ntp.sp_derivative_symbol_expiry
IS
    l_rec_count         NUMBER (18) := 0;
    l_commit_blk_size   NUMBER (5) := 2500;
BEGIN
    FOR i
        IN (SELECT u24.u24_symbol_code_m20,
                   u24.u24_exchange_code_m01,
                   u24.u24_custodian_id_m26,
                   (  u24.u24_net_holding
                    + u24.u24_payable_holding
                    - u24.u24_receivable_holding)
                       u24_net_holding,
                   u24.u24_maintain_margin_charged,
                   u24.u24_maintain_margin_block,
                   m20.m20_initial_margin_value,
                   u07.u07_cash_account_id_u06
              FROM u24_holdings u24
                   INNER JOIN m20_symbol m20
                       ON     u24.u24_symbol_id_m20 = m20.m20_id
                          AND m20_expire_date = TRUNC (SYSDATE)
                          AND m20.m20_instrument_type_code_v09 = 'FUT'
                   INNER JOIN u07_trading_account u07
                       ON     u24.u24_trading_acnt_id_u07 = u07.u07_id
                          AND (  u24.u24_net_holding
                               + u24.u24_payable_holding
                               - u24.u24_receivable_holding) <> 0)
    LOOP
        INSERT INTO a13_cash_holding_adjust_log (a13_id,
                                                 a13_job_id_v07,
                                                 a13_created_date,
                                                 a13_cash_account_id_u06,
                                                 a13_u06_balance,
                                                 a13_impact_type,
                                                 a13_t02_required,
                                                 a13_u24_symbol_code_m20,
                                                 a13_u24_exchange_code_m01,
                                                 a13_u24_net_receivable,
                                                 a13_u24_custodian_id_m26,
                                                 a13_initial_margin_value,
                                                 a13_u06_payable_blocked)
             VALUES (seq_a13_id.NEXTVAL,
                     27,
                     TRUNC (SYSDATE),
                     i.u07_cash_account_id_u06,
                     i.u24_maintain_margin_charged,
                     5,
                     1,
                     i.u24_symbol_code_m20,
                     i.u24_exchange_code_m01,
                     i.u24_net_holding,
                     i.u24_custodian_id_m26,
                     ABS (i.m20_initial_margin_value * i.u24_net_holding),
                     i.u24_maintain_margin_block);

        l_rec_count := l_rec_count + 1;

        IF MOD (l_rec_count, l_commit_blk_size) = 0
        THEN
            COMMIT;
        END IF;
    END LOOP;
END;
/
