CREATE OR REPLACE PROCEDURE dfn_ntp.sp_m2m_profit_calculation
IS
    l_m2m               NUMBER := 0;
    l_rec_count         NUMBER (18) := 0;
    l_commit_blk_size   NUMBER (5) := 2500;
BEGIN
    FOR i
        IN (SELECT v_h01.h01_trading_acnt_id_u07,
                   v_h01.h01_exchange_code_m01,
                   h01_symbol_code_m20,
                   (  v_h01.h01_net_holding
                    + v_h01.h01_payable_holding
                    - v_h01.h01_receivable_holding)
                       h01_net_holding,
                   u24.u24_derivative_fixing_price,
                   m20.m20_lot_size,
                   v_h01.h01_avg_price,
                   u06.u06_id,
                   NVL (esp.settlement_price, 0) settlement_price,
                   u07.u07_id,
                   u24.u24_avg_price
              FROM vw_h01_holding_summary v_h01
                   INNER JOIN u24_holdings u24
                       ON     v_h01.h01_trading_acnt_id_u07 =
                                  u24.u24_trading_acnt_id_u07
                          AND v_h01.h01_custodian_id_m26 =
                                  u24.u24_custodian_id_m26
                          AND v_h01.h01_symbol_id_m20 = u24.u24_symbol_id_m20
                          AND h01_date = TRUNC (SYSDATE - 1)
                   INNER JOIN m20_symbol m20
                       ON     v_h01.h01_symbol_id_m20 = m20.m20_id
                          AND m20.m20_instrument_type_code_v09 = 'FUT'
                   INNER JOIN u07_trading_account u07
                       ON u24.u24_trading_acnt_id_u07 = u07.u07_id
                   INNER JOIN u06_cash_account u06
                       ON u07.u07_cash_account_id_u06 = u06.u06_id
                   INNER JOIN dfn_price.esp_todays_snapshots esp
                       ON     u24.u24_exchange_code_m01 = esp.exchangecode
                          AND u24.u24_symbol_code_m20 = esp.symbol)
    LOOP
        l_m2m :=
            ROUND (
                  (i.settlement_price - i.u24_derivative_fixing_price)
                * i.m20_lot_size
                * i.h01_net_holding,
                2);

        IF (l_m2m <> 0)
        THEN
            INSERT
              INTO a13_cash_holding_adjust_log (a13_id,
                                                a13_job_id_v07,
                                                a13_created_date,
                                                a13_cash_account_id_u06,
                                                a13_u06_balance,
                                                a13_impact_type,
                                                a13_t02_required,
                                                a13_u24_symbol_code_m20,
                                                a13_u24_exchange_code_m01,
                                                a13_fixing_price,
                                                a13_initial_margin_value,
                                                a13_notional_value,
                                                a13_u24_net_receivable,
                                                a13_code_m97
                                               )
                VALUES (
                           seq_a13_id.NEXTVAL,
                           26,
                           TRUNC (SYSDATE),
                           i.u06_id,
                           l_m2m,
                           2,
                           1,
                           i.h01_symbol_code_m20,
                           i.h01_exchange_code_m01,
                           i.settlement_price,
                           i.settlement_price * i.h01_net_holding,
                             i.h01_avg_price
                           * i.m20_lot_size
                           * i.h01_net_holding,
                           i.h01_net_holding,
                           CASE WHEN l_m2m > 0 THEN 'MTMP' ELSE 'MTML' END);

            INSERT
              INTO t70_mark_to_market (t70_id,
                                       t70_date,
                                       t70_trading_acc_id_u07,
                                       t70_exchange_code_m01,
                                       t70_symbol_code_m20,
                                       t70_own_holdings,
                                       t70_vwap,
                                       t70_settle_price,
                                       t70_m2m_gain_loss,
                                       t70_im_value,
                                       t70_notional_value
                                      )
                VALUES (
                              TO_NUMBER (TO_CHAR (SYSDATE, 'YYYYMMDD'))
                           || seq_t70_id.NEXTVAL,
                           TRUNC (SYSDATE),
                           i.u07_id,
                           i.h01_exchange_code_m01,
                           i.h01_symbol_code_m20,
                           i.h01_net_holding,
                           i.h01_avg_price,
                           i.settlement_price,
                           l_m2m,
                           i.settlement_price * i.h01_net_holding,
                             i.h01_avg_price
                           * i.m20_lot_size
                           * i.h01_net_holding);
        END IF;

        l_rec_count := l_rec_count + 1;

        IF MOD (l_rec_count, l_commit_blk_size) = 0
        THEN
            COMMIT;
        END IF;
    END LOOP;
END;
/