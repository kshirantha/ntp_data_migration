DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_daily_status_id        NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (h26_id), 0)
      INTO l_daily_status_id
      FROM dfn_ntp.h26_daily_status;

    DELETE FROM error_log
          WHERE mig_table = 'H26_DAILY_STATUS';

    FOR i
        IN (SELECT t18.t18_date,
                   t18.t18_buy,
                   t18.t18_sell,
                   t18.t18_broker_comm,
                   t18.t18_total_comm,
                   t18.t18_no_of_trades,
                   t18.t18_no_of_orders,
                   t18.t18_no_of_cust_traded,
                   t18.t18_exg_turnover,
                   t18.t18_exg_no_of_trades,
                   NVL (map16.map16_ntp_code, t18.t18_exchange) AS exchange,
                   m01.m01_id,
                   t18.t18_id,
                   h26.h26_id
              FROM mubasher_oms.t18_daily_status@mubasher_db_link t18,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   map16_optional_exchanges_m01 map16,
                   (SELECT *
                      FROM dfn_ntp.h26_daily_status
                     WHERE h26_institution_id_m02 = l_primary_institute_id) h26
             WHERE     t18.t18_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, t18.t18_exchange) =
                           m01.m01_exchange_code(+)
                   AND t18.t18_date = h26.h26_date(+))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.h26_id IS NULL
            THEN
                l_daily_status_id := l_daily_status_id + 1;

                INSERT INTO dfn_ntp.h26_daily_status (h26_id,
                                                      h26_date,
                                                      h26_buy,
                                                      h26_sell,
                                                      h26_broker_comm,
                                                      h26_total_comm,
                                                      h26_no_of_trades,
                                                      h26_no_of_orders,
                                                      h26_no_of_cust_traded,
                                                      h26_exg_turnover,
                                                      h26_exg_no_of_trades,
                                                      h26_exchange,
                                                      h26_institution_id_m02,
                                                      h26_exchange_id_m01)
                     VALUES (l_daily_status_id, -- t21_id
                             i.t18_date, -- h26_date
                             i.t18_buy, -- h26_buy
                             i.t18_sell, -- h26_sell
                             i.t18_broker_comm, -- h26_broker_comm
                             i.t18_total_comm, -- h26_total_comm
                             i.t18_no_of_trades, -- h26_no_of_trades
                             i.t18_no_of_orders, -- h26_no_of_orders
                             i.t18_no_of_cust_traded, -- h26_no_of_cust_traded
                             i.t18_exg_turnover, -- h26_exg_turnover
                             i.t18_exg_no_of_trades, -- h26_exg_no_of_trades
                             i.exchange, -- h26_exchange
                             l_primary_institute_id, -- h26_institution_id_m02
                             i.m01_id -- h26_exchange_id_m01
                                     );
            ELSE
                UPDATE dfn_ntp.h26_daily_status
                   SET h26_buy = i.t18_buy, -- h26_buy
                       h26_sell = i.t18_sell, -- h26_sell
                       h26_broker_comm = i.t18_broker_comm, -- h26_broker_comm
                       h26_total_comm = i.t18_total_comm, -- h26_total_comm
                       h26_no_of_trades = i.t18_no_of_trades, -- h26_no_of_trades
                       h26_no_of_orders = i.t18_no_of_orders, -- h26_no_of_orders
                       h26_no_of_cust_traded = i.t18_no_of_cust_traded, -- h26_no_of_cust_traded
                       h26_exg_turnover = i.t18_exg_turnover, -- h26_exg_turnover
                       h26_exg_no_of_trades = i.t18_exg_no_of_trades, -- h26_exg_no_of_trades
                       h26_exchange = i.exchange, -- h26_exchange
                       h26_exchange_id_m01 = i.m01_id -- h26_exchange_id_m01
                 WHERE h26_id = i.h26_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'H26_DAILY_STATUS',
                                i.t18_id,
                                CASE
                                    WHEN i.h26_id IS NULL
                                    THEN
                                        l_daily_status_id
                                    ELSE
                                        i.h26_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.h26_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/