DECLARE
    l_broker_id                  NUMBER;
    l_primary_institute_id       NUMBER;
    l_exchange_id                NUMBER;
    l_entity_status_history_id   NUMBER;
    l_sqlerrm                    VARCHAR2 (4000);

    l_rec_cnt                    NUMBER := 0;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (a10_id), 0)
      INTO l_entity_status_history_id
      FROM dfn_ntp.a10_entity_status_history;

    DELETE FROM error_log
          WHERE mig_table LIKE 'Other - A10_ENTITY_STATUS_HISTORY%';

    -- Exchanges

    FOR i
        IN (SELECT m66.m66_id,
                   map03.map03_ntp_id,
                   map03.map03_mapping_table,
                   m01.m01_id AS entity_pk,
                   map01.map01_ntp_id,
                   NVL (u17.new_employee_id, 0) AS status_changed_by_new_id,
                   NVL (m66.m66_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   a10_map.new_ent_status_hist_id
              FROM mubasher_oms.m66_entity_status_history@mubasher_db_link m66
                   JOIN map03_approval_entity_id map03
                       ON m66.m66_approval_entity_id = map03.map03_oms_id
                   LEFT JOIN map16_optional_exchanges_m01 map16
                       ON m66.m66_entity_pk = map16.map16_oms_code
                   LEFT JOIN (SELECT m01_id, m01_exchange_code
                                FROM dfn_ntp.m01_exchanges
                               WHERE m01_institute_id_m02 =
                                         l_primary_institute_id) m01
                       ON NVL (map16.map16_ntp_code, m66.m66_entity_pk) =
                              m01.m01_exchange_code
                   JOIN map01_approval_status_v01 map01
                       ON m66.m66_approval_status_id = map01.map01_oms_id
                   LEFT OUTER JOIN u17_employee_mappings u17
                       ON m66.m66_status_changed_by = u17.old_employee_id
                   LEFT JOIN a10_entity_status_his_mappings a10_map
                       ON     m66.m66_id = a10_map.old_ent_status_hist_id
                          AND map03.map03_mapping_table =
                                  a10_map.mapping_table
                          AND m01.m01_id = a10_map.entity_key
             WHERE m66_approval_entity_id = 36 -- Exchanges
                                              AND map03.map03_type = 2)
    LOOP
        BEGIN
            IF i.entity_pk IS NULL
            THEN
                raise_application_error (-20001,
                                         'Entity Not Available',
                                         TRUE);
            END IF;

            IF i.new_ent_status_hist_id IS NULL
            THEN
                l_entity_status_history_id := l_entity_status_history_id + 1;

                INSERT
                  INTO dfn_ntp.a10_entity_status_history (
                           a10_id,
                           a10_approval_entity_id,
                           a10_entity_pk,
                           a10_approval_status_id_v01,
                           a10_status_changed_by_id_u17,
                           a10_status_changed_date)
                VALUES (l_entity_status_history_id, -- a10_id
                        i.map03_ntp_id, -- a10_approval_entity_id
                        i.entity_pk, -- a10_entity_pk
                        i.map01_ntp_id, -- a10_approval_status_id_v01
                        i.status_changed_by_new_id, -- a10_status_changed_by_id_u17
                        i.status_changed_date -- a10_status_changed_date
                                             );

                INSERT
                  INTO a10_entity_status_his_mappings (old_ent_status_hist_id,
                                                       mapping_table,
                                                       entity_key,
                                                       new_ent_status_hist_id)
                VALUES (i.m66_id,
                        i.map03_mapping_table,
                        i.entity_pk,
                        l_entity_status_history_id);
            ELSE
                UPDATE dfn_ntp.a10_entity_status_history
                   SET a10_approval_entity_id = i.map03_ntp_id, -- a10_approval_entity_id
                       a10_entity_pk = i.entity_pk, -- a10_entity_pk
                       a10_approval_status_id_v01 = i.map01_ntp_id, -- a10_approval_status_id_v01
                       a10_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- a10_status_changed_by_id_u17
                       a10_status_changed_date = i.status_changed_date -- a10_status_changed_date
                 WHERE a10_id = i.new_ent_status_hist_id;
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
                                'Other - A10_ENTITY_STATUS_HISTORY - [Exchanges]',
                                i.m66_id,
                                CASE
                                    WHEN i.new_ent_status_hist_id IS NULL
                                    THEN
                                        l_entity_status_history_id
                                    ELSE
                                        i.new_ent_status_hist_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_ent_status_hist_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;

    -- Sectors

    FOR i
        IN (SELECT m66.m66_id,
                   map03.map03_ntp_id,
                   map03.map03_mapping_table,
                   m63.m63_id AS entity_pk,
                   map01.map01_ntp_id,
                   NVL (u17_map.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m66.m66_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   a10_map.new_ent_status_hist_id
              FROM mubasher_oms.m66_entity_status_history@mubasher_db_link m66
                   JOIN map03_approval_entity_id map03
                       ON m66.m66_approval_entity_id = map03.map03_oms_id
                   LEFT JOIN (SELECT m63_id,
                                     m63_institute_id_m02,
                                        NVL (map16.map16_oms_code,
                                             m63_exchange_code_m01)
                                     || m63_sector_code
                                         AS new_entity_pk
                                FROM dfn_ntp.m63_sectors,
                                     map16_optional_exchanges_m01 map16
                               WHERE     m63_exchange_code_m01 =
                                             map16.map16_ntp_code(+) -- Key is Generated with Old Exchange
                                     AND m63_institute_id_m02 =
                                             l_primary_institute_id) m63 -- No Mapping Table as Exchange Code & Sector Code Used
                       ON m66.m66_entity_pk = m63.new_entity_pk
                   JOIN map01_approval_status_v01 map01
                       ON m66.m66_approval_status_id = map01.map01_oms_id
                   LEFT OUTER JOIN u17_employee_mappings u17_map
                       ON m66.m66_status_changed_by = u17_map.old_employee_id
                   LEFT JOIN a10_entity_status_his_mappings a10_map
                       ON     m66.m66_id = a10_map.old_ent_status_hist_id
                          AND map03.map03_mapping_table =
                                  a10_map.mapping_table
                          AND m63.m63_id = a10_map.entity_key
             WHERE m66_approval_entity_id = 33 -- Sectors
                                              AND map03.map03_type = 2)
    LOOP
        BEGIN
            IF i.entity_pk IS NULL
            THEN
                raise_application_error (-20001,
                                         'Entity Not Available',
                                         TRUE);
            END IF;

            IF i.new_ent_status_hist_id IS NULL
            THEN
                l_entity_status_history_id := l_entity_status_history_id + 1;

                INSERT
                  INTO dfn_ntp.a10_entity_status_history (
                           a10_id,
                           a10_approval_entity_id,
                           a10_entity_pk,
                           a10_approval_status_id_v01,
                           a10_status_changed_by_id_u17,
                           a10_status_changed_date)
                VALUES (l_entity_status_history_id, -- a10_id
                        i.map03_ntp_id, -- a10_approval_entity_id
                        i.entity_pk, -- a10_entity_pk
                        i.map01_ntp_id, -- a10_approval_status_id_v01
                        i.status_changed_by_new_id, -- a10_status_changed_by_id_u17
                        i.status_changed_date -- a10_status_changed_date
                                             );

                INSERT
                  INTO a10_entity_status_his_mappings (old_ent_status_hist_id,
                                                       mapping_table,
                                                       entity_key,
                                                       new_ent_status_hist_id)
                VALUES (i.m66_id,
                        i.map03_mapping_table,
                        i.entity_pk,
                        l_entity_status_history_id);
            ELSE
                UPDATE dfn_ntp.a10_entity_status_history
                   SET a10_approval_entity_id = i.map03_ntp_id, -- a10_approval_entity_id
                       a10_entity_pk = i.entity_pk, -- a10_entity_pk
                       a10_approval_status_id_v01 = i.map01_ntp_id, -- a10_approval_status_id_v01
                       a10_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- a10_status_changed_by_id_u17
                       a10_status_changed_date = i.status_changed_date -- a10_status_changed_date
                 WHERE a10_id = i.new_ent_status_hist_id;
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
                                'Other - A10_ENTITY_STATUS_HISTORY - [Sectors]',
                                i.m66_id,
                                CASE
                                    WHEN i.new_ent_status_hist_id IS NULL
                                    THEN
                                        l_entity_status_history_id
                                    ELSE
                                        i.new_ent_status_hist_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_ent_status_hist_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;

    -- Trading Accounts

    FOR i
        IN (SELECT m66.m66_id,
                   map03.map03_ntp_id,
                   map03.map03_mapping_table,
                   u07_map.new_trading_account_id AS entity_pk,
                   map01.map01_ntp_id,
                   NVL (u17_map.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m66.m66_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   a10_map.new_ent_status_hist_id
              FROM mubasher_oms.m66_entity_status_history@mubasher_db_link m66
                   JOIN map03_approval_entity_id map03
                       ON     m66.m66_approval_entity_id = map03.map03_oms_id
                          AND map03.map03_type = 2
                   LEFT JOIN (SELECT u06.u06_security_ac_id,
                                     u06.u06_exchange,
                                        u06.u06_security_ac_id
                                     || u06.u06_exchange
                                         AS entity_pk
                                FROM mubasher_oms.u06_routing_accounts@mubasher_db_link u06) u06_oms
                       ON m66.m66_entity_pk = u06_oms.entity_pk
                   LEFT JOIN map16_optional_exchanges_m01 map16
                       ON u06_oms.u06_exchange = map16.map16_oms_code
                   LEFT JOIN u07_trading_account_mappings u07_map
                       ON     u06_oms.u06_security_ac_id =
                                  u07_map.old_trading_account_id
                          AND NVL (map16.map16_ntp_code,
                                   u06_oms.u06_exchange) =
                                  u07_map.exchange_code
                   JOIN map01_approval_status_v01 map01
                       ON m66.m66_approval_status_id = map01.map01_oms_id
                   LEFT JOIN u17_employee_mappings u17_map
                       ON m66.m66_status_changed_by = u17_map.old_employee_id
                   LEFT JOIN a10_entity_status_his_mappings a10_map
                       ON     m66.m66_id = a10_map.old_ent_status_hist_id
                          AND map03.map03_mapping_table =
                                  a10_map.mapping_table
                          AND u07_map.new_trading_account_id =
                                  a10_map.entity_key
             WHERE m66_approval_entity_id = 3 -- Trading Account
                                             )
    LOOP
        BEGIN
            IF i.entity_pk IS NULL
            THEN
                raise_application_error (-20001,
                                         'Entity Not Available',
                                         TRUE);
            END IF;

            IF i.new_ent_status_hist_id IS NULL
            THEN
                l_entity_status_history_id := l_entity_status_history_id + 1;

                INSERT
                  INTO dfn_ntp.a10_entity_status_history (
                           a10_id,
                           a10_approval_entity_id,
                           a10_entity_pk,
                           a10_approval_status_id_v01,
                           a10_status_changed_by_id_u17,
                           a10_status_changed_date)
                VALUES (l_entity_status_history_id, -- a10_id
                        i.map03_ntp_id, -- a10_approval_entity_id
                        i.entity_pk, -- a10_entity_pk
                        i.map01_ntp_id, -- a10_approval_status_id_v01
                        i.status_changed_by_new_id, -- a10_status_changed_by_id_u17
                        i.status_changed_date -- a10_status_changed_date
                                             );

                INSERT
                  INTO a10_entity_status_his_mappings (old_ent_status_hist_id,
                                                       mapping_table,
                                                       entity_key,
                                                       new_ent_status_hist_id)
                VALUES (i.m66_id,
                        i.map03_mapping_table,
                        i.entity_pk,
                        l_entity_status_history_id);
            ELSE
                UPDATE dfn_ntp.a10_entity_status_history
                   SET a10_approval_entity_id = i.map03_ntp_id, -- a10_approval_entity_id
                       a10_entity_pk = i.entity_pk, -- a10_entity_pk
                       a10_approval_status_id_v01 = i.map01_ntp_id, -- a10_approval_status_id_v01
                       a10_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- a10_status_changed_by_id_u17
                       a10_status_changed_date = i.status_changed_date -- a10_status_changed_date
                 WHERE a10_id = i.new_ent_status_hist_id;
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
                                'Other - A10_ENTITY_STATUS_HISTORY - [Trading Accounts]',
                                i.m66_id,
                                CASE
                                    WHEN i.new_ent_status_hist_id IS NULL
                                    THEN
                                        l_entity_status_history_id
                                    ELSE
                                        i.new_ent_status_hist_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_ent_status_hist_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;

    -- Customer Corporate Actions

    FOR i
        IN (SELECT m66.m66_id,
                   map03.map03_ntp_id,
                   map03.map03_mapping_table,
                   m141_map.new_cust_corp_action_id AS entity_pk,
                   map01.map01_ntp_id,
                   NVL (u17_map.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m66.m66_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   a10_map.new_ent_status_hist_id
              FROM mubasher_oms.m66_entity_status_history@mubasher_db_link m66
                   JOIN map03_approval_entity_id map03
                       ON     m66.m66_approval_entity_id = map03.map03_oms_id
                          AND map03.map03_type = 2
                   LEFT JOIN m141_cust_corp_action_mappings m141_map
                       ON CASE INSTR (m66.m66_entity_pk, ',')
                              WHEN 0
                              THEN
                                  m66.m66_entity_pk
                              ELSE
                                  SUBSTR (m66.m66_entity_pk,
                                          1,
                                          INSTR (m66.m66_entity_pk, ',') - 1)
                          END = m141_map.old_cust_corp_action_id
                   JOIN map01_approval_status_v01 map01
                       ON m66.m66_approval_status_id = map01.map01_oms_id
                   LEFT JOIN u17_employee_mappings u17_map
                       ON m66.m66_status_changed_by = u17_map.old_employee_id
                   LEFT JOIN a10_entity_status_his_mappings a10_map
                       ON     m66.m66_id = a10_map.old_ent_status_hist_id
                          AND map03.map03_mapping_table =
                                  a10_map.mapping_table
                          AND m141_map.new_cust_corp_action_id =
                                  a10_map.entity_key
             WHERE m66_approval_entity_id = 94 -- Cust Corporate Action
                                              )
    LOOP
        BEGIN
            IF i.entity_pk IS NULL
            THEN
                raise_application_error (-20001,
                                         'Entity Not Available',
                                         TRUE);
            END IF;

            IF i.new_ent_status_hist_id IS NULL
            THEN
                l_entity_status_history_id := l_entity_status_history_id + 1;

                INSERT
                  INTO dfn_ntp.a10_entity_status_history (
                           a10_id,
                           a10_approval_entity_id,
                           a10_entity_pk,
                           a10_approval_status_id_v01,
                           a10_status_changed_by_id_u17,
                           a10_status_changed_date)
                VALUES (l_entity_status_history_id, -- a10_id
                        i.map03_ntp_id, -- a10_approval_entity_id
                        i.entity_pk, -- a10_entity_pk
                        i.map01_ntp_id, -- a10_approval_status_id_v01
                        i.status_changed_by_new_id, -- a10_status_changed_by_id_u17
                        i.status_changed_date -- a10_status_changed_date
                                             );

                INSERT
                  INTO a10_entity_status_his_mappings (old_ent_status_hist_id,
                                                       mapping_table,
                                                       entity_key,
                                                       new_ent_status_hist_id)
                VALUES (i.m66_id,
                        i.map03_mapping_table,
                        i.entity_pk,
                        l_entity_status_history_id);
            ELSE
                UPDATE dfn_ntp.a10_entity_status_history
                   SET a10_approval_status_id_v01 = i.map01_ntp_id, -- a10_approval_status_id_v01
                       a10_status_changed_by_id_u17 =
                           i.status_changed_by_new_id -- a10_status_changed_by_id_u17
                 WHERE a10_id = i.new_ent_status_hist_id;
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
                                'Other - A10_ENTITY_STATUS_HISTORY - [Customer Corporate Action]',
                                i.m66_id,
                                CASE
                                    WHEN i.new_ent_status_hist_id IS NULL
                                    THEN
                                        l_entity_status_history_id
                                    ELSE
                                        i.new_ent_status_hist_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_ent_status_hist_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;

    -- Power od Attorney

    FOR i
        IN (SELECT m66.m66_id,
                   map03.map03_ntp_id,
                   map03.map03_mapping_table,
                   u47_map.new_power_of_attorney_id AS entity_pk,
                   map01.map01_ntp_id,
                   NVL (u17_map.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m66.m66_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   a10_map.new_ent_status_hist_id
              FROM mubasher_oms.m66_entity_status_history@mubasher_db_link m66
                   JOIN map03_approval_entity_id map03
                       ON m66.m66_approval_entity_id = map03.map03_oms_id
                   JOIN mubasher_oms.m137_customer_poa@mubasher_db_link m137
                       ON m66.m66_entity_pk = m137.m137_id
                   LEFT JOIN u47_power_of_attorney_mappings u47_map
                       ON     m137.m137_poa = u47_map.old_poa_id
                          AND m137.m137_customer_id = u47_map.old_customer_id
                   JOIN map01_approval_status_v01 map01
                       ON m66.m66_approval_status_id = map01.map01_oms_id
                   LEFT JOIN u17_employee_mappings u17_map
                       ON m66.m66_status_changed_by = u17_map.old_employee_id
                   LEFT JOIN a10_entity_status_his_mappings a10_map
                       ON     m66.m66_id = a10_map.old_ent_status_hist_id
                          AND map03.map03_mapping_table =
                                  a10_map.mapping_table
                          AND u47_map.new_power_of_attorney_id =
                                  a10_map.entity_key
             WHERE m66_approval_entity_id = 55 -- Power od Attorney
                                              AND map03.map03_type = 2)
    LOOP
        BEGIN
            IF i.entity_pk IS NULL
            THEN
                raise_application_error (-20001,
                                         'Entity Not Available',
                                         TRUE);
            END IF;

            IF i.new_ent_status_hist_id IS NULL
            THEN
                l_entity_status_history_id := l_entity_status_history_id + 1;

                INSERT
                  INTO dfn_ntp.a10_entity_status_history (
                           a10_id,
                           a10_approval_entity_id,
                           a10_entity_pk,
                           a10_approval_status_id_v01,
                           a10_status_changed_by_id_u17,
                           a10_status_changed_date)
                VALUES (l_entity_status_history_id, -- a10_id
                        i.map03_ntp_id, -- a10_approval_entity_id
                        i.entity_pk, -- a10_entity_pk
                        i.map01_ntp_id, -- a10_approval_status_id_v01
                        i.status_changed_by_new_id, -- a10_status_changed_by_id_u17
                        i.status_changed_date -- a10_status_changed_date
                                             );

                INSERT
                  INTO a10_entity_status_his_mappings (old_ent_status_hist_id,
                                                       mapping_table,
                                                       entity_key,
                                                       new_ent_status_hist_id)
                VALUES (i.m66_id,
                        i.map03_mapping_table,
                        i.entity_pk,
                        l_entity_status_history_id);
            ELSE
                UPDATE dfn_ntp.a10_entity_status_history
                   SET a10_approval_entity_id = i.map03_ntp_id, -- a10_approval_entity_id
                       a10_entity_pk = i.entity_pk, -- a10_entity_pk
                       a10_approval_status_id_v01 = i.map01_ntp_id, -- a10_approval_status_id_v01
                       a10_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- a10_status_changed_by_id_u17
                       a10_status_changed_date = i.status_changed_date -- a10_status_changed_date
                 WHERE a10_id = i.new_ent_status_hist_id;
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
                                'Other - A10_ENTITY_STATUS_HISTORY - [Power of Attorney]',
                                i.m66_id,
                                CASE
                                    WHEN i.new_ent_status_hist_id IS NULL
                                    THEN
                                        l_entity_status_history_id
                                    ELSE
                                        i.new_ent_status_hist_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_ent_status_hist_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;

    -- Currency Rates

    FOR i
        IN (SELECT m66.m66_id,
                   map03.map03_ntp_id,
                   map03.map03_mapping_table,
                   m04_map.new_currency_rate AS entity_pk,
                   map01.map01_ntp_id,
                   NVL (u17.new_employee_id, 0) AS status_changed_by_new_id,
                   NVL (m66.m66_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   a10_map.new_ent_status_hist_id
              FROM mubasher_oms.m66_entity_status_history@mubasher_db_link m66
                   JOIN map03_approval_entity_id map03
                       ON     m66.m66_approval_entity_id = map03.map03_oms_id
                          AND map03.map03_type = 2
                          AND m66_approval_entity_id = 22 -- Currency Rates
                   LEFT JOIN (SELECT m03.m03_c1,
                                     m03.m03_c2,
                                     m03.m03_inst_id,
                                     m02_map.new_institute_id,
                                     (   m03.m03_c1
                                      || '-'
                                      || m03.m03_c2
                                      || '-'
                                      || TO_CHAR (m03.m03_inst_id))
                                         AS entity_pk
                                FROM mubasher_oms.m03_exchange_rates@mubasher_db_link m03,
                                     m02_institute_mappings m02_map
                               WHERE m03.m03_inst_id =
                                         m02_map.old_institute_id) m03
                       ON m66.m66_entity_pk = m03.entity_pk
                   LEFT JOIN m04_currency_rate_mappings m04_map
                       ON     m03.m03_c1 = m04_map.from_currency
                          AND m03.m03_c2 = m04_map.to_currency
                          AND m03.new_institute_id = m04_map.new_institute_id
                   JOIN map01_approval_status_v01 map01
                       ON m66.m66_approval_status_id = map01.map01_oms_id
                   LEFT OUTER JOIN u17_employee_mappings u17
                       ON m66.m66_status_changed_by = u17.old_employee_id
                   LEFT JOIN a10_entity_status_his_mappings a10_map
                       ON     m66.m66_id = a10_map.old_ent_status_hist_id
                          AND map03.map03_mapping_table =
                                  a10_map.mapping_table
                          AND m04_map.new_currency_rate = a10_map.entity_key)
    LOOP
        BEGIN
            IF i.entity_pk IS NULL
            THEN
                raise_application_error (-20001,
                                         'Entity Not Available',
                                         TRUE);
            END IF;

            IF i.new_ent_status_hist_id IS NULL
            THEN
                l_entity_status_history_id := l_entity_status_history_id + 1;

                INSERT
                  INTO dfn_ntp.a10_entity_status_history (
                           a10_id,
                           a10_approval_entity_id,
                           a10_entity_pk,
                           a10_approval_status_id_v01,
                           a10_status_changed_by_id_u17,
                           a10_status_changed_date)
                VALUES (l_entity_status_history_id, -- a10_id
                        i.map03_ntp_id, -- a10_approval_entity_id
                        i.entity_pk, -- a10_entity_pk
                        i.map01_ntp_id, -- a10_approval_status_id_v01
                        i.status_changed_by_new_id, -- a10_status_changed_by_id_u17
                        i.status_changed_date -- a10_status_changed_date
                                             );

                INSERT
                  INTO a10_entity_status_his_mappings (old_ent_status_hist_id,
                                                       mapping_table,
                                                       entity_key,
                                                       new_ent_status_hist_id)
                VALUES (i.m66_id,
                        i.map03_mapping_table,
                        i.entity_pk,
                        l_entity_status_history_id);
            ELSE
                UPDATE dfn_ntp.a10_entity_status_history
                   SET a10_approval_entity_id = i.map03_ntp_id, -- a10_approval_entity_id
                       a10_entity_pk = i.entity_pk, -- a10_entity_pk
                       a10_approval_status_id_v01 = i.map01_ntp_id, -- a10_approval_status_id_v01
                       a10_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- a10_status_changed_by_id_u17
                       a10_status_changed_date = i.status_changed_date -- a10_status_changed_date
                 WHERE a10_id = i.new_ent_status_hist_id;
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
                                'Other - A10_ENTITY_STATUS_HISTORY - [Currency Rates]',
                                i.m66_id,
                                CASE
                                    WHEN i.new_ent_status_hist_id IS NULL
                                    THEN
                                        l_entity_status_history_id
                                    ELSE
                                        i.new_ent_status_hist_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_ent_status_hist_id IS NULL
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