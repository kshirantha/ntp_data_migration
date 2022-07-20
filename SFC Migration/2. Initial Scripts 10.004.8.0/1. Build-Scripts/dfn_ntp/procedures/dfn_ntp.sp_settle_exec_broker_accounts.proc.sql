CREATE OR REPLACE PROCEDURE dfn_ntp.sp_settle_exec_broker_accounts (
    p_key                    OUT NUMBER,
    p_t83                        NUMBER,
    p_cash_account_id_m185       NUMBER,
    p_custody_execb_id_m26       NUMBER,
    p_settle_amount              NUMBER,
    p_trans_currency             VARCHAR2,
    p_procesed_by_id_u17         NUMBER,
    p_institute_id               NUMBER)
IS
    l_currency_m185   VARCHAR2 (50);
    l_fx_rate         NUMBER (10, 5);
    l_next            NUMBER (18, 0) DEFAULT 0;
BEGIN
    BEGIN
        l_fx_rate :=
            get_exchange_rate (p_institute_id,
                               p_trans_currency,
                               l_currency_m185);

        SELECT MAX (NVL (t79_id, 0)) + 1
          INTO l_next
          FROM t79_custody_excb_cash_acnt_log;

        INSERT
          INTO t79_custody_excb_cash_acnt_log (t79_id,
                                               t79_id_t83,
                                               t79_institute_id_m02,
                                               t79_custodian_id_m26,
                                               t79_cash_acc_id_m185,
                                               t79_txn_id_m97,
                                               t79_txn_code_m97,
                                               t79_amnt_in_stl_currency,
                                               t79_amnt_in_txn_currency,
                                               t79_fx_rate,
                                               t79_txn_date,
                                               t79_txn_currency_code_m03,
                                               t79_stl_currency_code_m03,
                                               t79_created_by_u17,
                                               t79_created_date)
        VALUES (
                   l_next,
                   p_t83,
                   p_institute_id,
                   p_custody_execb_id_m26,
                   p_cash_account_id_m185,
                   CASE WHEN p_settle_amount > 0 THEN 0 ELSE 1 END,
                   CASE
                       WHEN p_settle_amount > 0 THEN 'DEPOST'
                       ELSE 'WITHDR'
                   END,
                   p_settle_amount,
                   p_settle_amount,
                   l_fx_rate,
                   SYSDATE,
                   p_trans_currency,
                   l_currency_m185,
                   p_procesed_by_id_u17,
                   SYSDATE);

        p_key := 1;
    EXCEPTION
        WHEN OTHERS
        THEN
            p_key := -1;
            RETURN;
    END;
END;
/
