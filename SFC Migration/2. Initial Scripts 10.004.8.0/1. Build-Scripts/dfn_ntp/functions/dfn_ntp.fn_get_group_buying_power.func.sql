CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_group_buying_power (
    pu06_id                  IN u06_cash_account.u06_id%TYPE,
    pu06_currency_code_m03   IN u06_cash_account.u06_currency_code_m03%TYPE,
    pu06_customer_id_u01     IN u06_cash_account.u06_customer_id_u01%TYPE)
    RETURN u06_cash_account.u06_balance%TYPE
IS
    lbuying_power         u06_cash_account.u06_balance%TYPE DEFAULT 0;
    lbuying_power_value   u06_cash_account.u06_balance%TYPE DEFAULT 0;

    CURSOR cash_accounts (
        customer_id    NUMBER)
    IS
        SELECT DISTINCT (u06.u06_id),
                        u06.u06_currency_code_m03,
                        u06.u06_balance,
                        u06.u06_blocked,
                        u06.u06_pending_deposit,
                        u06.u06_manual_full_blocked,
                        u06.u06_margin_block,
                        u06.u06_primary_od_limit,
                        u06.u06_primary_expiry,
                        u06.u06_secondary_od_limit,
                        u06.u06_secondary_expiry,
                        u06_institute_id_m02
          FROM u06_cash_account u06
         WHERE     u06.u06_margin_enabled = 0
               AND u06.u06_currency_code_m03 = pu06_currency_code_m03
               AND u06.u06_customer_id_u01 = pu06_customer_id_u01
        ORDER BY u06.u06_id DESC;

    rec                   cash_accounts%ROWTYPE DEFAULT NULL;
BEGIN
    IF (pu06_customer_id_u01 IS NULL)
    THEN
        RETURN '0 NULL';
    END IF;

    OPEN cash_accounts (pu06_customer_id_u01);

    LOOP
        FETCH cash_accounts   INTO rec;

        EXIT WHEN cash_accounts%NOTFOUND;
        lbuying_power_value :=
              NVL (rec.u06_balance, 0)
            + NVL (rec.u06_blocked, 0)
            + NVL (rec.u06_pending_deposit, 0)
            + NVL (rec.u06_manual_full_blocked, 0)
            + NVL (rec.u06_margin_block, 0);

        IF (    rec.u06_secondary_od_limit > 0
            AND rec.u06_secondary_expiry IS NOT NULL
            AND SYSDATE <= rec.u06_secondary_expiry)
        THEN
            lbuying_power_value :=
                lbuying_power_value + NVL (rec.u06_secondary_od_limit, 0);
        END IF;

        IF (    rec.u06_primary_od_limit > 0
            AND rec.u06_primary_expiry IS NOT NULL
            AND SYSDATE <= rec.u06_primary_expiry)
        THEN
            lbuying_power_value :=
                lbuying_power_value + NVL (rec.u06_primary_od_limit, 0);
        ELSIF (    rec.u06_primary_od_limit > 0
               AND rec.u06_primary_expiry IS NULL)
        THEN
            lbuying_power_value :=
                lbuying_power_value + NVL (rec.u06_primary_od_limit, 0);
        END IF;

        lbuying_power :=
              lbuying_power
            +   lbuying_power_value
              * get_exchange_rate (rec.u06_institute_id_m02,
                                   rec.u06_currency_code_m03,
                                   pu06_currency_code_m03);
    END LOOP;

    CLOSE cash_accounts;

    RETURN lbuying_power;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN -1;
END;
/