DECLARE
    l_cur_rate_id   NUMBER;
    l_sqlerrm       VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m04_id), 0)
      INTO l_cur_rate_id
      FROM dfn_ntp.m04_currency_rate;

    DELETE FROM error_log
          WHERE mig_table = 'M04_CURRENCY_RATE';

    FOR i
        IN (SELECT m03.m03_c1,
                   m03.m03_c2,
                   m03.m03_rate,
                   m03.m03_buy_rate,
                   m03.m03_sell_rate,
                   m03.m03_spread,
                   m02_map.new_institute_id,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (m03.m03_created_date, SYSDATE) AS created_date,
                   map1.map01_ntp_id,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m03.m03_modified_date AS modified_date,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m03.m03_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m03_from.m03_id AS m03_id_from,
                   m03_to.m03_id AS m03_id_to,
                   m04_map.new_currency_rate
              FROM mubasher_oms.m03_exchange_rates@mubasher_db_link m03,
                   map01_approval_status_v01 map1,
                   dfn_ntp.m03_currency m03_from,
                   dfn_ntp.m03_currency m03_to,
                   m02_institute_mappings m02_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m04_currency_rate_mappings m04_map
             WHERE     m03.m03_status_id = map1.map01_oms_id
                   AND m03.m03_c1 = m03_from.m03_code
                   AND m03.m03_c2 = m03_to.m03_code
                   AND m03.m03_inst_id = m02_map.old_institute_id
                   AND m03.m03_created_by = u17_created.old_employee_id(+)
                   AND m03.m03_modified_by = u17_modified.old_employee_id(+)
                   AND m03.m03_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m03.m03_c1 = m04_map.from_currency(+)
                   AND m03.m03_c2 = m04_map.to_currency(+)
                   AND m02_map.new_institute_id = m04_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_currency_rate IS NULL
            THEN
                l_cur_rate_id := l_cur_rate_id + 1;

                INSERT
                  INTO dfn_ntp.m04_currency_rate (m04_from_currency_code_m03,
                                                  m04_to_currency_code_m03,
                                                  m04_rate,
                                                  m04_buy_rate,
                                                  m04_sell_rate,
                                                  m04_spread,
                                                  m04_institute_id_m02,
                                                  m04_created_by_id_u17,
                                                  m04_created_date,
                                                  m04_status_id_v01,
                                                  m04_modified_by_id_u17,
                                                  m04_modified_date,
                                                  m04_status_changed_by_id_u17,
                                                  m04_status_changed_date,
                                                  m04_id,
                                                  m04_from_currency_id_m03,
                                                  m04_to_currency_id_m03,
                                                  m04_custom_type,
                                                  m04_category_v01)
                VALUES (i.m03_c1, -- m04_from_currency_code_m03
                        i.m03_c2, -- m04_to_currency_code_m03
                        i.m03_rate, -- m04_rate
                        i.m03_buy_rate, -- m04_buy_rate
                        i.m03_sell_rate, -- m04_sell_rate
                        i.m03_spread, -- m04_spread
                        i.new_institute_id, -- m04_institute_id_m02
                        i.created_by_new_id, -- m04_created_by_id_u17
                        i.created_date, -- m04_created_date
                        i.map01_ntp_id, -- m04_status_id_v01
                        i.modifed_by_new_id, -- m04_modified_by_id_u17
                        i.modified_date, -- m04_modified_date
                        i.status_changed_by_new_id, -- m04_status_changed_by_id_u17
                        i.status_changed_date, -- m04_status_changed_date
                        l_cur_rate_id, -- m04_id
                        i.m03_id_from, -- m04_from_currency_id_m03
                        i.m03_id_to, -- m04_to_currency_id_m03
                        '1', -- m04_custom_type
                        0 -- m04_category_v01 | Not Avialable
                         );

                INSERT INTO m04_currency_rate_mappings (from_currency,
                                                        to_currency,
                                                        new_currency_rate,
                                                        new_institute_id)
                     VALUES (i.m03_c1,
                             i.m03_c2,
                             l_cur_rate_id,
                             i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m04_currency_rate
                   SET m04_rate = i.m03_rate, -- m04_rate
                       m04_buy_rate = i.m03_buy_rate, -- m04_buy_rate
                       m04_sell_rate = i.m03_sell_rate, -- m04_sell_rate
                       m04_spread = i.m03_spread, -- m04_spread
                       m04_status_id_v01 = i.map01_ntp_id, -- m04_status_id_v01
                       m04_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m04_modified_by_id_u17
                       m04_modified_date = NVL (i.modified_date, SYSDATE), -- m04_modified_date
                       m04_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m04_status_changed_by_id_u17
                       m04_status_changed_date = i.status_changed_date, -- m04_status_changed_date
                       m04_from_currency_id_m03 = i.m03_id_from, -- m04_from_currency_id_m03
                       m04_to_currency_id_m03 = i.m03_id_to -- m04_to_currency_id_m03
                 WHERE m04_id = i.new_currency_rate;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M04_CURRENCY_RATE',
                                   'From Currency : '
                                || i.m03_c1
                                || ' | To Currency : '
                                || i.m03_c2,
                                CASE
                                    WHEN i.new_currency_rate IS NULL
                                    THEN
                                        l_cur_rate_id
                                    ELSE
                                        i.new_currency_rate
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_currency_rate IS NULL
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