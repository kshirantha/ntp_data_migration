CREATE OR REPLACE PROCEDURE dfn_ntp.sp_settle_exec_broker_approve (
    p_key   OUT NUMBER,
    p_t79       NUMBER)
IS
    l_settle_amount          NUMBER (18, 5);
    l_trans_amount           NUMBER (10, 5);
    l_cash_account_id_m185   NUMBER (10, 0);
    l_t83                    NUMBER (18, 0);
    l_procesed_by_id_u17     NUMBER (10, 0);
BEGIN
    BEGIN
        SELECT t79.t79_amnt_in_txn_currency,
               t79.t79_amnt_in_stl_currency,
               t79.t79_cash_acc_id_m185,
               t79.t79_id_t83,
               t79.t79_status_change_by_u17
          INTO l_trans_amount,
               l_settle_amount,
               l_cash_account_id_m185,
               l_t83,
               l_procesed_by_id_u17
          FROM t79_custody_excb_cash_acnt_log t79
         WHERE t79_id = p_t79;



        UPDATE t83_exec_broker_wise_settlmnt a
           SET t83_recived_procesed_by_id_u17 = l_procesed_by_id_u17,
               t83_tot_recived_from_exec_brok =
                   t83_tot_recived_from_exec_brok + l_trans_amount
         WHERE t83_id = l_t83;


        UPDATE m185_custody_excb_cash_account b
           SET m185_balance = m185_balance + l_settle_amount
         WHERE m185_id = l_cash_account_id_m185;



        p_key := 1;
    EXCEPTION
        WHEN OTHERS
        THEN
            p_key := -1;
            RETURN;
    END;
END;
/
