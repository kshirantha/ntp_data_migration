CREATE OR REPLACE PROCEDURE dfn_ntp.sp_h01_update_balance (
    p_current_date       IN h01_holding_summary.h01_date%TYPE,
    p_new_date           IN h01_holding_summary.h01_date%TYPE,
    p_trading_acnt_id    IN h01_holding_summary.h01_trading_acnt_id_u07%TYPE,
    p_side               IN NUMBER,
    p_original_qty       IN h01_holding_summary.h01_net_holding%TYPE,
    p_new_qty            IN h01_holding_summary.h01_net_holding%TYPE,
    p_symbol_id          IN NUMBER,
    p_custodian_id       IN NUMBER,
    p_trade_process_id   IN h01_holding_summary.h01_trade_processing_id_t17%TYPE DEFAULT 0)
IS
    l_h01_payable_holding     NUMBER;
    l_h01_pending_settle      NUMBER;
    l_diff                    NUMBER;
    l_diff_from_date          DATE;
    l_diff_act                NUMBER;
    l_sysmbol_code            VARCHAR2 (50);
    l_exchange_id             NUMBER;
    l_exchange_code           VARCHAR2 (50);
    l_price_instrument_type   NUMBER;
    l_count                   NUMBER;
    l_new_date                DATE := TRUNC (p_new_date);
    l_trade_process_id        NUMBER;
    l_primary_institute_id    NUMBER;
BEGIN
    SELECT m20.m20_symbol_code,
           m20.m20_exchange_id_m01,
           m20.m20_exchange_code_m01,
           m20.m20_price_instrument_id_v34,
           m20.m20_institute_id_m02
      INTO l_sysmbol_code,
           l_exchange_id,
           l_exchange_code,
           l_price_instrument_type,
           l_primary_institute_id
      FROM m20_symbol m20
     WHERE m20.m20_id = p_symbol_id;

    l_diff := p_new_qty - p_original_qty;

    SELECT COUNT (h01_date)
      INTO l_count
      FROM h01_holding_summary a
     WHERE     h01_date = p_new_date
           AND h01_trading_acnt_id_u07 = p_trading_acnt_id
           AND h01_symbol_id_m20 = p_symbol_id
           AND h01_custodian_id_m26 = p_custodian_id;

    DELETE FROM dfn_ntp.h00_dates
          WHERE h00_date = l_new_date;

    INSERT INTO dfn_ntp.h00_dates (h00_date)
         VALUES (l_new_date);

    IF (l_count = 0)
    THEN
        INSERT INTO h01_holding_summary
            SELECT h01_trading_acnt_id_u07,
                   h01_exchange_code_m01,
                   h01_symbol_id_m20,
                   p_new_date AS h01_date,
                   h01_custodian_id_m26,
                   h01_holding_block,
                   h01_sell_pending,
                   h01_buy_pending,
                   h01_weighted_avg_price,
                   h01_avg_price,
                   h01_weighted_avg_cost,
                   h01_avg_cost,
                   h01_receivable_holding,
                   h01_payable_holding,
                   h01_symbol_code_m20,
                   h01_realized_gain_lost,
                   h01_currency_code_m03,
                   h01_price_inst_type,
                   h01_pledge_qty,
                   h01_last_trade_price,
                   h01_vwap,
                   h01_market_price,
                   h01_previous_closed,
                   h01_todays_closed,
                   h01_manual_block,
                   h01_net_holding,
                   h01_custodian_code_m26,
                   h01_short_holdings,
                   h01_net_receivable,
                   1,
                   p_trade_process_id,
                   h01_primary_institute_id_m02,
                   h01_subscribed_qty,
                   h01_pending_subscribe_qty,
                   h01_is_archive_ready
              FROM (  SELECT *
                        FROM (SELECT * FROM h01_holding_summary
                              UNION ALL
                              SELECT p_trading_acnt_id
                                         AS h01_trading_acnt_id_u07,
                                     l_exchange_code AS h01_exchange_code_m01,
                                     p_symbol_id AS h01_symbol_id_m20,
                                     TO_DATE ('1970/01/01', 'YYYY/MM/DD')
                                         AS h01_date,
                                     p_custodian_id AS h01_custodian_id_m26,
                                     0 AS h01_holding_block,
                                     0 AS h01_sell_pending,
                                     0 AS h01_buy_pending,
                                     0 AS h01_weighted_avg_price,
                                     0 AS h01_avg_price,
                                     0 AS h01_weighted_avg_cost,
                                     0 AS h01_avg_cost,
                                     0 AS h01_receivable_holding,
                                     0 AS h01_payable_holding,
                                     l_sysmbol_code AS h01_symbol_code_m20,
                                     0 AS h01_realized_gain_lost,
                                     '' AS h01_currency_code_m03,
                                     l_price_instrument_type
                                         AS h01_price_inst_type,
                                     0 AS h01_pledge_qty,
                                     0 AS h01_last_trade_price,
                                     0 AS h01_vwap,
                                     0 AS h01_market_price,
                                     0 AS h01_previous_closed,
                                     0 AS h01_todays_closed,
                                     0 AS h01_manual_block,
                                     0 AS h01_net_holding,
                                     '' AS h01_custodian_code_m26,
                                     0 AS h01_short_holdings,
                                     0 AS h01_net_receivable,
                                     0,
                                     '0',
                                     l_primary_institute_id,
                                     0 AS h01_subscribed_qty,
                                     0 AS h01_pending_subscribe_qty,
                                     0 AS h01_is_archive_ready
                                FROM DUAL) a
                       WHERE     h01_date < p_new_date
                             AND h01_trading_acnt_id_u07 = p_trading_acnt_id
                             AND h01_symbol_id_m20 = p_symbol_id
                             AND h01_custodian_id_m26 = p_custodian_id
                    ORDER BY h01_date DESC)
             WHERE ROWNUM = 1;
    END IF;

    IF (p_current_date > p_new_date)
    THEN
        l_diff_from_date := p_current_date;

        FOR j
            IN (SELECT h01_payable_holding,
                       a.h01_receivable_holding,
                       h01_date
                  FROM h01_holding_summary a
                 WHERE     h01_date >= p_new_date
                       AND h01_date < p_current_date
                       AND h01_trading_acnt_id_u07 = p_trading_acnt_id
                       AND h01_symbol_id_m20 = p_symbol_id
                       AND h01_custodian_id_m26 = p_custodian_id)
        LOOP
            IF (p_side = 1)                                              --Buy
            THEN
                l_diff_act := j.h01_receivable_holding + p_new_qty;

                IF (l_diff_act <= 0)
                THEN
                    l_diff_act := 0;
                END IF;

                UPDATE h01_holding_summary
                   SET h01_net_holding = h01_net_holding + p_new_qty,
                       h01_receivable_holding = l_diff_act,
                       h01_is_history_adjusted = 1,
                       h01_trade_processing_id_t17 = 1   -- l_trade_process_id
                 WHERE     h01_date = j.h01_date
                       AND h01_trading_acnt_id_u07 = p_trading_acnt_id
                       AND h01_symbol_id_m20 = p_symbol_id
                       AND h01_custodian_id_m26 = p_custodian_id;
            END IF;

            IF (p_side = 2)                                             --Sell
            THEN
                l_diff_act := j.h01_payable_holding + p_new_qty;

                IF (l_diff_act <= 0)
                THEN
                    l_diff_act := 0;
                END IF;

                UPDATE h01_holding_summary
                   SET h01_net_holding = h01_net_holding - p_new_qty,
                       h01_payable_holding = l_diff_act,
                       h01_is_history_adjusted = 1,
                       h01_trade_processing_id_t17 = 2   -- l_trade_process_id
                 WHERE     h01_date = j.h01_date
                       AND h01_trading_acnt_id_u07 = p_trading_acnt_id
                       AND h01_symbol_id_m20 = p_symbol_id
                       AND h01_custodian_id_m26 = p_custodian_id;
            END IF;
        END LOOP;
    END IF;

    IF (p_new_date > p_current_date)
    THEN
        l_diff_from_date := p_new_date;

        FOR j
            IN (SELECT h01_payable_holding,
                       a.h01_receivable_holding,
                       h01_date
                  FROM h01_holding_summary a
                 WHERE     h01_date >= p_current_date
                       AND h01_date < p_new_date
                       AND h01_trading_acnt_id_u07 = p_trading_acnt_id
                       AND h01_symbol_id_m20 = p_symbol_id
                       AND h01_custodian_id_m26 = p_custodian_id)
        LOOP
            IF (p_side = 1)                                              --Buy
            THEN
                l_diff_act := j.h01_receivable_holding - p_original_qty;

                IF (l_diff_act <= 0)
                THEN
                    l_diff_act := 0;
                END IF;

                UPDATE h01_holding_summary
                   SET h01_net_holding = h01_net_holding - p_original_qty,
                       h01_receivable_holding = l_diff_act,
                       h01_is_history_adjusted = 1,
                       h01_trade_processing_id_t17 = 3   -- l_trade_process_id
                 WHERE     h01_date = j.h01_date
                       AND h01_trading_acnt_id_u07 = p_trading_acnt_id
                       AND h01_symbol_id_m20 = p_symbol_id
                       AND h01_custodian_id_m26 = p_custodian_id;
            END IF;

            IF (p_side = 2)                                             --Sell
            THEN
                l_diff_act := j.h01_payable_holding - p_original_qty;

                IF (l_diff_act <= 0)
                THEN
                    l_diff_act := 0;
                END IF;

                UPDATE h01_holding_summary
                   SET h01_net_holding = h01_net_holding + p_original_qty,
                       h01_payable_holding = l_diff_act,
                       h01_is_history_adjusted = 1,
                       h01_trade_processing_id_t17 = 4   -- l_trade_process_id
                 WHERE     h01_date = j.h01_date
                       AND h01_trading_acnt_id_u07 = p_trading_acnt_id
                       AND h01_symbol_id_m20 = p_symbol_id
                       AND h01_custodian_id_m26 = p_custodian_id;
            END IF;
        END LOOP;
    END IF;

    IF (p_new_date = p_current_date)
    THEN
        l_diff_from_date := p_current_date;
    END IF;

    FOR j
        IN (SELECT h01_payable_holding, a.h01_receivable_holding, h01_date
              FROM h01_holding_summary a
             WHERE     h01_date >= l_diff_from_date
                   AND h01_trading_acnt_id_u07 = p_trading_acnt_id
                   AND h01_symbol_id_m20 = p_symbol_id
                   AND h01_custodian_id_m26 = p_custodian_id)
    LOOP
        IF (l_diff <> 0)
        THEN
            IF (p_side = 1)                                              --Buy
            THEN
                l_diff_act := j.h01_receivable_holding + l_diff;

                IF (l_diff_act <= 0)
                THEN
                    l_diff_act := 0;
                END IF;

                UPDATE h01_holding_summary
                   SET h01_net_holding = h01_net_holding + l_diff,
                       h01_receivable_holding = l_diff_act,
                       h01_is_history_adjusted = 1,
                       h01_trade_processing_id_t17 = 5    --l_trade_process_id
                 WHERE     h01_date = j.h01_date
                       AND h01_trading_acnt_id_u07 = p_trading_acnt_id
                       AND h01_symbol_id_m20 = p_symbol_id
                       AND h01_custodian_id_m26 = p_custodian_id;
            END IF;

            IF (p_side = 2)                                             --Sell
            THEN
                l_diff_act := j.h01_payable_holding + l_diff;

                IF (l_diff_act <= 0)
                THEN
                    l_diff_act := 0;
                END IF;

                UPDATE h01_holding_summary
                   SET h01_net_holding = h01_net_holding - l_diff,
                       h01_payable_holding = l_diff_act,
                       h01_is_history_adjusted = 1,
                       h01_trade_processing_id_t17 = 6   -- l_trade_process_id
                 WHERE     h01_date = j.h01_date
                       AND h01_trading_acnt_id_u07 = p_trading_acnt_id
                       AND h01_symbol_id_m20 = p_symbol_id
                       AND h01_custodian_id_m26 = p_custodian_id;
            END IF;
        END IF;
    END LOOP;
END;
/

