CREATE OR REPLACE PROCEDURE dfn_ntp.sp_add_cash_account (
    p_key                        OUT VARCHAR,
    p_u06_id                     OUT NUMBER,
    p_u06_display_name           OUT VARCHAR,
    p_u01_id                  IN     NUMBER,
    p_u01_customer_no         IN     u01_customer.u01_customer_no%TYPE,
    p_u01_display_name        IN     u01_customer.u01_display_name%TYPE,
    p_u01_default_id_no       IN     u01_customer.u01_default_id_no%TYPE,
    p_user_id                 IN     NUMBER,
    p_institution_id          IN     NUMBER,
    p_default_currency_code   IN     VARCHAR2,
    p_default_currency_id     IN     NUMBER)
IS
    l_error_reason   NVARCHAR2 (4000);
    l_m03_id         NUMBER;
BEGIN
    p_u06_id := fn_get_next_sequnce (pseq_name => 'U06_CASH_ACCOUNT');
    p_u06_display_name := 'C' || p_u06_id || '-' || p_default_currency_code;

    /*  SELECT m03_i
        INTO l_m03_id
        FROM m03_currency
       WHERE m03_code = 'SAR';*/

    INSERT INTO u06_cash_account (u06_id,
                                  u06_institute_id_m02,
                                  u06_customer_id_u01,
                                  u06_customer_no_u01,
                                  u06_display_name_u01,
                                  u06_default_id_no_u01,
                                  u06_currency_code_m03,
                                  u06_currency_id_m03,
                                  u06_display_name,
                                  u06_balance,
                                  u06_blocked,
                                  u06_open_buy_blocked,
                                  u06_payable_blocked,
                                  u06_manual_trade_blocked,
                                  u06_manual_full_blocked,
                                  u06_manual_transfer_blocked,
                                  u06_receivable_amount,
                                  u06_net_receivable,
                                  u06_is_default,
                                  u06_account_type_v01,
                                  u06_created_by_id_u17,
                                  u06_created_date,
                                  u06_status_id_v01,
                                  u06_status_changed_by_id_u17,
                                  u06_status_changed_date,
                                  u06_custom_type)
         VALUES (p_u06_id,                                           --u06_id,
                 p_institution_id,                     --u06_institute_id_m02,
                 p_u01_id,                              --u06_customer_id_u01,
                 p_u01_customer_no,                     --u06_customer_no_u01,
                 p_u01_display_name,                   --u06_display_name_u01,
                 p_u01_default_id_no,                 --u06_default_id_no_u01,
                 p_default_currency_code,             --u06_currency_code_m03,
                 p_default_currency_id,                 --u06_currency_id_m03,
                 p_u06_display_name,                       --u06_display_name,
                 0,                                             --u06_balance,
                 0,                                             --u06_blocked,
                 0,                                    --u06_open_buy_blocked,
                 0,                                     --u06_payable_blocked,
                 0,                                --u06_manual_trade_blocked,
                 0,                                 --u06_manual_full_blocked,
                 0,                             --u06_manual_transfer_blocked,
                 0,                                   --u06_receivable_amount,
                 0,                                      --u06_net_receivable,
                 1,                                          --u06_is_default,
                 1,             --u06_account_type_v01,  -- investment account
                 p_user_id,                           --u06_created_by_id_u17,
                 SYSDATE,                                  --u06_created_date,
                 2,                                       --u06_status_id_v01,
                 p_user_id,                    --u06_status_changed_by_id_u17,
                 SYSDATE,                           --u06_status_changed_date,
                 1                                           --u06_custom_type
                  );

    p_key := p_u06_id;
END;
/
