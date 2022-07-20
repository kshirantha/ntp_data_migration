CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_cash_accounts
IS
    l_sysdate            DATE := func_get_eod_date;
    l_sysdate_plus_one   DATE := func_get_eod_date + 1;
    l_time               VARCHAR2 (10);
    l_today              DATE;
BEGIN
    --Expire Margin
    BEGIN
        l_today := TRUNC (l_sysdate);

        FOR i
            IN (SELECT u06_id, u23_id
                FROM u23_customer_margin_product, u06_cash_account
                WHERE     TRUNC (u23_margin_expiry_date) <= l_today
                      AND u06_margin_enabled = 1
                      AND u06_margin_product_id_u23 = u23_id)
        LOOP
            UPDATE u06_cash_account
            SET u06_margin_enabled = 2 --, u06_margin_product_id_u23 = NULL DO not detach product from u06
            WHERE u06_id = i.u06_id;

            UPDATE u23_customer_margin_product
            SET u23_margin_expired = 1
            WHERE u23_id = i.u23_id;
        END LOOP;

        COMMIT;
    EXCEPTION
        WHEN OTHERS
        THEN
            ROLLBACK;
            RAISE;
    END;
END;
/