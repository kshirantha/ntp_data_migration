CREATE OR REPLACE TRIGGER dfn_ntp.h01_trg_insert_update
    BEFORE INSERT OR UPDATE
    ON dfn_ntp.h01_holding_summary
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
DECLARE
    l_is_history_adjusted   NUMBER;
BEGIN
    l_is_history_adjusted := NVL (:new.h01_is_history_adjusted, 0);

    IF (l_is_history_adjusted = 1)
    THEN
        INSERT INTO a20_holding_adjust_log (a20_date,
                                            a20_trade_processing_id_t17,
                                            a20_symbol_id_h02_m20,
                                            a20_custodian_id_m26,
                                            a20_h01_exchange_code_h01_m01,
                                            a20_history_date_h01,
                                            a20_trading_acnt_id_h01_u07,
                                            a20_old_net_holding,
                                            a20_new_net_holding,
                                            a20_old_receivable_holding,
                                            a20_new_receivable_holding,
                                            a20_old_payable_holding,
                                            a20_new_payable_holding)
             VALUES (SYSDATE,
                     :new.h01_trade_processing_id_t17,
                     :new.h01_symbol_id_m20,
                     :new.h01_custodian_id_m26,
                     :new.h01_exchange_code_m01,
                     :new.h01_date,
                     :new.h01_trading_acnt_id_u07,
                     :old.h01_net_holding,
                     :new.h01_net_holding,
                     :old.h01_receivable_holding,
                     :new.h01_receivable_holding,
                     :old.h01_payable_holding,
                     :new.h01_payable_holding);
    END IF;
END;
/
