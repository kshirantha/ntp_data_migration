CREATE OR REPLACE PROCEDURE dfn_ntp.sp_validate_edaa_payment_file (
    p_session_id   IN NUMBER)
IS
    countstatus   NUMBER;
BEGIN
    FOR i
        IN (SELECT t501.t501_id,
                   u07.u07_cash_account_id_u06,
                   u07.u07_customer_id_u01
            FROM t501_payment_detail_c t501, u07_trading_account u07
            WHERE     t501.t501_account_code = u07.u07_exchange_account_no
                  AND t501.t501_payment_session_id_t500 = p_session_id)
    LOOP
        UPDATE t501_payment_detail_c t501
           SET t501.t501_cash_account_id_u06 = i.u07_cash_account_id_u06,
               t501.t501_status_id_v01 = 1,
               t501.t501_customer_id_u01 = i.u07_customer_id_u01
         WHERE t501.t501_id = i.t501_id;
    END LOOP;

    UPDATE t501_payment_detail_c t501
       SET t501.t501_status_id_v01 = 3,
           t501.t501_comment = 'Customer not available in OMS',
           t501.t501_payment_confirm = 'Refund to Issuer'
     WHERE t501.t501_cash_account_id_u06 = 0;

    UPDATE t501_payment_detail_c t501
       SET t501.t501_status_id_v01 = 3,
           t501.t501_comment = 'Currency is USD',
           t501.t501_payment_confirm = 'Refund to Issuer'
     WHERE     t501.t501_payment_session_id_t500 = p_session_id
           AND t501.t501_status_id_v01 <> 3
           AND t501.t501_currency_code_m03 = 'USD';

    UPDATE t500_payment_sessions_c t500
       SET t500.t500_status_id_v01 = 1
     WHERE (SELECT COUNT (t500.t500_id)
              FROM t500_payment_sessions_c t500
                   JOIN t501_payment_detail_c t501
                       ON t500.t500_id = t501.t501_payment_session_id_t500
             WHERE t501.t501_status_id_v01 = 1) > 0;

    SELECT COUNT (t501.t501_id)
      INTO countstatus
      FROM t501_payment_detail_c t501
     WHERE     t501.t501_payment_session_id_t500 = p_session_id
           AND t501.t501_status_id_v01 <> 3;

    IF (countstatus = 0)
    THEN
        UPDATE t500_payment_sessions_c t500
           SET t500.t500_status_id_v01 = 3
         WHERE t500.t500_id = p_session_id;
    ELSE
        UPDATE t500_payment_sessions_c t500
           SET t500.t500_status_id_v01 = 1
         WHERE t500.t500_id = p_session_id;
    END IF;
END;
/