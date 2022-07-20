CREATE OR REPLACE TRIGGER dfn_ntp.h02_trg_insert_update
    BEFORE INSERT OR UPDATE OF h02_balance
    ON dfn_ntp.h02_cash_account_summary
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
DECLARE
    l_is_history_adjusted   NUMBER;
BEGIN
    l_is_history_adjusted := NVL (:new.h02_is_history_adjusted, 0);

    IF (l_is_history_adjusted = 1)
    THEN
        INSERT INTO a19_cash_account_adjust_log (a19_date,
                                                 a19_trade_processing_id_t17,
                                                 a19_history_date_h02,
                                                 a19_cash_account_id_h02_u06,
                                                 a19_old_cash_balance,
                                                 a19_new_cash_balance,
                                                 a19_old_opening_balance,
                                                 a19_new_opening_balance,
                                                 a19_old_payable_blocked,
                                                 a19_new_payable_blocked,
                                                 a19_old_receivable_amount,
                                                 a19_new_receivable_amount,
                                                 a19_old_net_sell,
                                                 a19_new_net_sell,
                                                 a19_old_net_buy,
                                                 a19_new_net_buy,
                                                 a19_old_net_commission,
                                                 a19_new_net_commission)
             VALUES (SYSDATE,
                     :new.h02_trade_processing_id_t17,
                     :new.h02_date,
                     :new.h02_cash_account_id_u06,
                     :old.h02_balance,
                     :new.h02_balance,
                     :old.h02_opening_balance,
                     :new.h02_opening_balance,
                     :old.h02_payable_blocked,
                     :new.h02_payable_blocked,
                     :old.h02_receivable_amount,
                     :new.h02_receivable_amount,
                     :old.h02_net_sell,
                     :new.h02_net_sell,
                     :old.h02_net_buy,
                     :new.h02_net_buy,
                     :old.h02_net_commission,
                     :new.h02_net_commission);
    END IF;
END;
/
