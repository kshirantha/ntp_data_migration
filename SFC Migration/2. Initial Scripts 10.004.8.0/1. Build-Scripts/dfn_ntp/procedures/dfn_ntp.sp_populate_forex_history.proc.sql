CREATE OR REPLACE PROCEDURE dfn_ntp.sp_populate_forex_history
IS
    l_date   DATE := TRUNC (func_get_eod_date ());
BEGIN
    DELETE FROM h03_currency_rate
          WHERE h03_date = l_date;

    INSERT INTO h03_currency_rate (h03_id,
                                   h03_from_currency_code_m03,
                                   h03_to_currency_code_m03,
                                   h03_date,
                                   h03_institute_id_m02,
                                   h03_rate,
                                   h03_buy_rate,
                                   h03_sell_rate,
                                   h03_spread,
                                   h03_status_id_v01,
                                   h03_from_currency_id_m03,
                                   h03_to_currency_id_m03)
        SELECT (SELECT NVL (MAX (h03_id) + 1, 1) FROM h03_currency_rate),
               m04_from_currency_code_m03,
               m04_to_currency_code_m03,
               l_date,
               m04_institute_id_m02,
               m04_rate,
               m04_buy_rate,
               m04_sell_rate,
               m04_spread,
               m04_status_id_v01,
               m04_from_currency_id_m03,
               m04_to_currency_id_m03
          FROM m04_currency_rate;
END;
/