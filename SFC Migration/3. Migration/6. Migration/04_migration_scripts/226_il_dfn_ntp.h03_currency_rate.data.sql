DECLARE
    l_currency_rate_id   NUMBER;
    l_sqlerrm            VARCHAR2 (4000);

    l_rec_cnt            NUMBER := 0;
BEGIN
    SELECT NVL (MAX (h03_id), 0)
      INTO l_currency_rate_id
      FROM dfn_ntp.h03_currency_rate;

    DELETE FROM error_log
          WHERE mig_table = 'H03_CURRENCY_RATE';

    FOR i
        IN (SELECT m03_c1.m03_code AS c1_code,
                   m03_c2.m03_code AS c2_code,
                   m03.m03_rate,
                   m03.m03_buy_rate,
                   m03.m03_sell_rate,
                   m03.m03_spread,
                   m03_c1.m03_id AS c1_id,
                   m03_c2.m03_id AS c2_id,
                   m03.m03_date,
                   m02_map.new_institute_id,
                   h03.h03_id
              FROM mubasher_oms.m03_exchange_rates_history@mubasher_db_link m03,
                   dfn_ntp.m03_currency m03_c1,
                   dfn_ntp.m03_currency m03_c2,
                   dfn_ntp.h03_currency_rate h03,
                   m02_institute_mappings m02_map -- [Cross Join - Repeating for each Institution]
             WHERE     m03.m03_c1 = m03_c1.m03_code
                   AND m03.m03_c2 = m03_c2.m03_code
                   AND m03.m03_c1 = h03_from_currency_code_m03(+)
                   AND m03.m03_c2 = h03_to_currency_code_m03(+)
                   AND m03.m03_date = h03.h03_date(+)
                   AND m02_map.new_institute_id = h03.h03_institute_id_m02(+))
    LOOP
        BEGIN
            IF i.h03_id IS NULL
            THEN
                l_currency_rate_id := l_currency_rate_id + 1;

                INSERT
                  INTO dfn_ntp.h03_currency_rate (h03_from_currency_code_m03,
                                                  h03_to_currency_code_m03,
                                                  h03_rate,
                                                  h03_buy_rate,
                                                  h03_sell_rate,
                                                  h03_spread,
                                                  h03_institute_id_m02,
                                                  h03_status_id_v01,
                                                  h03_id,
                                                  h03_from_currency_id_m03,
                                                  h03_to_currency_id_m03,
                                                  h03_date,
                                                  h03_category_v01)
                VALUES (i.c1_code, -- h03_from_currency_code_m03
                        i.c2_code, -- h03_to_currency_code_m03
                        i.m03_rate, -- h03_rate
                        i.m03_buy_rate, -- h03_buy_rate
                        i.m03_sell_rate, -- h03_sell_rate
                        i.m03_spread, -- h03_spread
                        i.new_institute_id, -- h03_institute_id_m02
                        2, -- h03_status_id_v01
                        l_currency_rate_id, -- h03_id
                        i.c1_id, -- h03_from_currency_id_m03
                        i.c2_id, -- h03_to_currency_id_m03
                        i.m03_date, -- h03_date
                        0 -- h03_category_v01 | Not Available
                         );
            ELSE
                UPDATE dfn_ntp.h03_currency_rate
                   SET h03_rate = i.m03_rate, -- h03_rate
                       h03_buy_rate = i.m03_buy_rate, -- h03_buy_rate
                       h03_sell_rate = i.m03_sell_rate, -- h03_sell_rate
                       h03_spread = i.m03_spread -- h03_spread
                 WHERE h03_id = i.h03_id;
            END IF;

            l_rec_cnt := l_rec_cnt + 1;

            IF MOD (l_rec_cnt, 25000) = 0
            THEN
                COMMIT;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'H03_CURRENCY_RATE',
                                   'From Currency : '
                                || i.c1_code
                                || ' | To Currency : '
                                || i.c2_code,
                                CASE
                                    WHEN i.h03_id IS NULL
                                    THEN
                                        l_currency_rate_id
                                    ELSE
                                        i.h03_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.h03_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('H03_CURRENCY_RATE');
END;
/
