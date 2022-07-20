DECLARE
    l_primary_institute_id   NUMBER;
    l_broker_id              NUMBER;
    l_market_id              NUMBER;
    l_emp_exg_id             NUMBER;
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

    SELECT MAX (m29.m29_id)
      INTO l_market_id
      FROM dfn_ntp.m29_markets m29
     WHERE     m29.m29_primary_institution_id_m02 = l_primary_institute_id
           AND m29.m29_exchange_code_m01 = 'TDWL'
           AND m29.m29_is_default = 1;

    SELECT NVL (MAX (u28_id), 0)
      INTO l_emp_exg_id
      FROM dfn_ntp.u28_employee_exchanges;

    DELETE FROM error_log
          WHERE mig_table = 'U28_EMPLOYEE_EXCHANGES';

    FOR i
        IN (SELECT m148.m148_id,
                   m148.m148_employee,
                   u17_map.new_employee_id,
                   CASE
                       WHEN NVL (map16.map16_ntp_code, m148.m148_exchange) =
                                'TDWL'
                       THEN
                           m06.m06_tdwl_trader_id
                   END
                       AS tdwl_trader_id,
                   NVL (map16.map16_ntp_code, m148.m148_exchange)
                       AS exchange_code,
                   m01.m01_id,
                   u28_map.new_emp_exchanges_id
              FROM mubasher_oms.m148_employee_exchanges@mubasher_db_link m148,
                   mubasher_oms.m06_employees@mubasher_db_link m06,
                   u17_employee_mappings u17_map,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   map16_optional_exchanges_m01 map16,
                   u28_emp_exchanges_mappings u28_map
             WHERE     m148.m148_employee = m06.m06_id
                   AND m148.m148_employee = u17_map.old_employee_id
                   AND m148.m148_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, m148.m148_exchange) =
                           m01.m01_exchange_code(+)
                   AND NVL (map16.map16_ntp_code, m148.m148_exchange) =
                           u28_map.exchange_code(+)
                   AND m148.m148_employee = u28_map.old_employee_id(+))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_emp_exchanges_id IS NULL
            THEN
                l_emp_exg_id := l_emp_exg_id + 1;

                INSERT
                  INTO dfn_ntp.u28_employee_exchanges (
                           u28_id,
                           u28_exchange_code_m01,
                           u28_employee_id_u17,
                           u28_created_by_id_u17,
                           u28_created_date,
                           u28_modified_by_id_u17,
                           u28_modified_date,
                           u28_status_id_v01,
                           u28_status_changed_by_id_u17,
                           u28_status_changed_date,
                           u28_dealer_exchange_code,
                           u28_price_subscribed,
                           u28_custom_type,
                           u28_exchange_id_m01,
                           u28_market_id_m29)
                VALUES (l_emp_exg_id, -- u28_id
                        i.exchange_code, -- u28_exchange_code_m01
                        i.new_employee_id, -- u28_employee_id_u17
                        0, -- u28_created_by_id_u17
                        SYSDATE, -- u28_created_date
                        0, -- u28_modified_by_id_u17
                        SYSDATE, -- u28_modified_date
                        2, -- u28_status_id_v01
                        0, -- u28_status_changed_by_id_u17
                        SYSDATE, -- u28_status_changed_date
                        i.tdwl_trader_id, -- u28_dealer_exchange_code
                        1, -- u28_price_subscribed
                        '1', -- u28_custom_type
                        i.m01_id, -- u28_exchange_id_m01
                        l_market_id -- u28_market_id_m29
                                   );

                INSERT
                  INTO u28_emp_exchanges_mappings (old_employee_id,
                                                   exchange_code,
                                                   new_emp_exchanges_id)
                VALUES (i.m148_employee, i.exchange_code, l_emp_exg_id);
            ELSE
                UPDATE dfn_ntp.u28_employee_exchanges
                   SET u28_dealer_exchange_code = i.tdwl_trader_id, -- u28_dealer_exchange_code
                       u28_exchange_id_m01 = i.m01_id, -- u28_exchange_id_m01
                       u28_modified_by_id_u17 = 0, -- u28_modified_by_id_u17
                       u28_modified_date = SYSDATE -- u28_modified_dateu28_modified_date
                 WHERE u28_id = i.new_emp_exchanges_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U28_EMPLOYEE_EXCHANGES',
                                i.m148_id,
                                CASE
                                    WHEN i.new_emp_exchanges_id IS NULL
                                    THEN
                                        l_emp_exg_id
                                    ELSE
                                        i.new_emp_exchanges_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_emp_exchanges_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/