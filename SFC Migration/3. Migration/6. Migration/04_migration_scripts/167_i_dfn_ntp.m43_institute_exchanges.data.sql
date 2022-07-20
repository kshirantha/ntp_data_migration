DECLARE
    l_inst_exg_id   NUMBER;
    l_sqlerrm       VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m43_id), 0)
      INTO l_inst_exg_id
      FROM dfn_ntp.m43_institute_exchanges;

    DELETE FROM error_log
          WHERE mig_table = 'M43_INSTITUTE_EXCHANGES';

    FOR i
        IN (SELECT m39_inst_exg.*, m43_map.new_institute_exg_id
              FROM (  SELECT m39.m39_from_broker,
                             m02_map.new_institute_id,
                             NVL (map16.map16_ntp_code, m39.m39_exchange)
                                 AS exchange_code,
                             MAX (m01.m01_id) AS m01_id,
                             MAX (
                                 CASE m26.m26_type
                                     WHEN 2
                                     THEN
                                         m26_map.new_executing_broker_id
                                     WHEN 3
                                     THEN
                                         m26_map.new_executing_broker_id
                                 END)
                                 AS custodian_id,
                             MAX (
                                 CASE m26.m26_type
                                     WHEN 1
                                     THEN
                                         m26_map.new_executing_broker_id
                                     WHEN 3
                                     THEN
                                         m26_map.new_executing_broker_id
                                 END)
                                 AS exe_broker_id
                        FROM mubasher_oms.m39_broker_exec_broker_map@mubasher_db_link m39,
                             dfn_ntp.m01_exchanges m01,
                             dfn_ntp.m26_executing_broker m26,
                             m02_institute_mappings m02_map,
                             m26_executing_broker_mappings m26_map,
                             map16_optional_exchanges_m01 map16
                       WHERE     m39.m39_exchange = map16.map16_oms_code(+)
                             AND NVL (map16.map16_ntp_code, m39.m39_exchange) =
                                     m01.m01_exchange_code(+)
                             AND m39.m39_from_broker = m02_map.old_institute_id
                             AND m39.m39_to_broker =
                                     m26_map.old_executing_broker_id
                             AND m26_map.new_executing_broker_id = m26.m26_id
                    GROUP BY m39.m39_from_broker,
                             m02_map.new_institute_id,
                             NVL (map16.map16_ntp_code, m39.m39_exchange)) m39_inst_exg,
                   m43_institute_exg_mappings m43_map
             WHERE     m39_inst_exg.m39_from_broker =
                           m43_map.old_from_broker(+)
                   AND m39_inst_exg.exchange_code =
                           m43_map.old_exchange_code(+))
    LOOP
        BEGIN
            IF i.exchange_code IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Code Not Available',
                                         TRUE);
            END IF;

            IF i.new_institute_exg_id IS NULL
            THEN
                l_inst_exg_id := l_inst_exg_id + 1;

                INSERT
                  INTO dfn_ntp.m43_institute_exchanges (
                           m43_institute_id_m02,
                           m43_exchange_code_m01,
                           m43_custodian_id_m26,
                           m43_executing_broker_id_m26,
                           m43_status_id_v01,
                           m43_created_by_id_u17,
                           m43_created_date,
                           m43_modified_by_id_u17,
                           m43_modified_date,
                           m43_status_changed_by_id_u17,
                           m43_status_changed_date,
                           m43_id,
                           m43_exchange_id_m01,
                           m43_custom_type)
                VALUES (i.new_institute_id, -- m43_institute_id_m02
                        i.exchange_code, -- m43_exchange_code_m01
                        i.custodian_id, -- m43_custodian_id_m26
                        i.exe_broker_id, -- m43_executing_broker_id_m26
                        2, -- m43_status_id_v01
                        0, -- m43_created_by_id_u17
                        SYSDATE, -- m43_created_date
                        NULL, -- m43_modified_by_id_u17
                        NULL, -- m43_modified_date
                        0, -- m43_status_changed_by_id_u17
                        SYSDATE, -- m43_status_changed_date
                        l_inst_exg_id, -- m43_id
                        i.m01_id, -- m43_exchange_id_m01
                        '1' -- m43_custom_type
                           );

                INSERT
                  INTO m43_institute_exg_mappings (old_from_broker,
                                                   old_exchange_code,
                                                   new_institute_exg_id)
                VALUES (i.m39_from_broker, i.exchange_code, l_inst_exg_id);
            ELSE
                UPDATE dfn_ntp.m43_institute_exchanges
                   SET m43_custodian_id_m26 = i.custodian_id, -- m43_custodian_id_m26
                       m43_executing_broker_id_m26 = i.exe_broker_id, -- m43_executing_broker_id_m26
                       m43_exchange_id_m01 = i.m01_id, -- m43_exchange_id_m01
                       m43_modified_by_id_u17 = 0, -- m43_modified_by_id_u17
                       m43_modified_date = SYSDATE -- m43_modified_date
                 WHERE m43_id = i.new_institute_exg_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M43_INSTITUTE_EXCHANGES',
                                   'Exchange : '
                                || i.exchange_code
                                || ' | From Broker Id : '
                                || i.m39_from_broker,
                                CASE
                                    WHEN i.new_institute_exg_id IS NULL
                                    THEN
                                        l_inst_exg_id
                                    ELSE
                                        i.new_institute_exg_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_institute_exg_id IS NULL
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

COMMIT;

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_default_count          NUMBER;
    l_default_custodian      NUMBER;
    l_m26_id                 NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT MAX (m26_id) INTO l_m26_id FROM dfn_ntp.m26_executing_broker;

    SELECT COUNT (*)
      INTO l_default_count
      FROM dfn_ntp.m26_executing_broker m26
     WHERE     m26.m26_type IN (2, 3)
           AND ( (m26_name) = 'TDWL' OR UPPER (m26_sid) = 'TDWL')
           AND m26.m26_institution_id_m02 = l_primary_institute_id
           AND m26.m26_status_id_v01 = 2;

    IF l_default_count = 0
    THEN
        l_default_custodian := l_m26_id + 1;

        INSERT
          INTO dfn_ntp.m26_executing_broker (m26_id,
                                             m26_name,
                                             m26_pobox,
                                             m26_street_address_1,
                                             m26_street_address_2,
                                             m26_city_id_m06,
                                             m26_zip,
                                             m26_office_tel_1,
                                             m26_office_tel_2,
                                             m26_fax,
                                             m26_email,
                                             m26_type,
                                             m26_created_by_id_u17,
                                             m26_created_date,
                                             m26_lastupdated_by_id_u17,
                                             m26_lastupdated_date,
                                             m26_status_id_v01,
                                             m26_status_changed_by_id_u17,
                                             m26_status_changed_date,
                                             m26_sid,
                                             m26_fix_tag_50,
                                             m26_fix_tag_142,
                                             m26_fix_tag_57,
                                             m26_fix_tag_115,
                                             m26_fix_tag_116,
                                             m26_fix_tag_128,
                                             m26_fix_tag_22,
                                             m26_fix_tag_109,
                                             m26_fix_tag_100,
                                             m26_country_id_m05,
                                             m26_custom_type,
                                             m26_institution_id_m02,
                                             m26_trans_chrg_grp_id_m166,
                                             m26_hold_chrg_grp_id_m166,
                                             m26_pled_in_chrg_grp_id_m166,
                                             m26_pled_out_chrg_grp_id_m166,
                                             m26_shar_tran_chrg_grp_id_m166,
                                             m26_hold_chrg_last_pay_date)
        VALUES (l_default_custodian, -- m26_id
                'TDWL', -- m26_name
                NULL, -- m26_pobox
                NULL, -- m26_street_address_1
                NULL, -- m26_street_address_2
                1, -- m26_city_id_m06 | 1 : RIYADH
                NULL, -- m26_zip
                NULL, -- m26_office_tel_1
                NULL, -- m26_office_tel_2
                NULL, -- m26_fax
                NULL, -- m26_email
                2, -- m26_type | 2 : Custody
                0, -- m26_created_by_id_u17
                SYSDATE, -- m26_created_date
                NULL, -- m26_lastupdated_by_id_u17
                NULL, -- m26_lastupdated_date
                2, -- m26_status_id_v01
                0, -- m26_status_changed_by_id_u17
                SYSDATE, -- m26_status_changed_date
                'TDWL', -- m26_sid
                NULL, -- m26_fix_tag_50
                NULL, -- m26_fix_tag_142
                NULL, -- m26_fix_tag_57
                NULL, -- m26_fix_tag_115
                NULL, -- m26_fix_tag_116
                NULL, -- m26_fix_tag_128
                NULL, -- m26_fix_tag_22
                NULL, -- m26_fix_tag_109
                NULL, -- m26_fix_tag_100
                2, -- m26_country_id_m05 | 2 : Saudi Arabia
                '1', --  m26_custom_type
                l_primary_institute_id, -- m26_institution_id_m02
                NULL, -- m26_trans_chrg_grp_id_m166 | Not Available
                NULL, -- m26_hold_chrg_grp_id_m166 | Not Available
                NULL, -- m26_pled_in_chrg_grp_id_m166 | Not Available
                NULL, -- m26_pled_out_chrg_grp_id_m166 | Not Available
                NULL, -- m26_shar_tran_chrg_grp_id_m166 | Not Available
                NULL -- m26_hold_chrg_last_pay_date | Not Available
                    );
    ELSE
        SELECT MIN (m26_id)
          INTO l_default_custodian
          FROM dfn_ntp.m26_executing_broker m26
         WHERE     m26.m26_type IN (2, 3)
               AND ( (m26_name) = 'TDWL' OR UPPER (m26_sid) = 'TDWL')
               AND m26.m26_institution_id_m02 = l_primary_institute_id
               AND m26.m26_status_id_v01 = 2;
    END IF;

    FOR i IN (SELECT *
                FROM dfn_ntp.m02_institute m02
               WHERE m02.m02_broker_id_m150 = l_broker_id)
    LOOP
        UPDATE dfn_ntp.m43_institute_exchanges m43
           SET m43.m43_custodian_id_m26 = l_default_custodian
         WHERE     m43.m43_institute_id_m02 = i.m02_id
               AND m43.m43_exchange_code_m01 = 'TDWL';
    END LOOP;
END;
/