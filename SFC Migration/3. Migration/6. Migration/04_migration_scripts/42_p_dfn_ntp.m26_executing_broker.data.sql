DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_exec_broker_id         NUMBER;
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

    SELECT NVL (MAX (m26_id), 0)
      INTO l_exec_broker_id
      FROM dfn_ntp.m26_executing_broker;

    DELETE FROM error_log
          WHERE mig_table = 'M26_EXECUTING_BROKER';

    FOR i
        IN (SELECT ex01.ex01_id,
                   ex01.ex01_name,
                   ex01.ex01_pobox,
                   ex01.ex01_street_address_1,
                   ex01.ex01_street_address_2,
                   ex01.ex01_city,
                   ex01.ex01_zip,
                   ex01.ex01_office_tel_1,
                   ex01.ex01_office_tel_2,
                   ex01.ex01_fax,
                   ex01.ex01_email,
                   CASE
                       WHEN ex01.ex01_type = 1 THEN 1
                       WHEN ex01.ex01_type IN (2, 4) THEN 3
                       WHEN ex01.ex01_type = 3 THEN 2
                   END
                       AS ex_type,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (ex01.ex01_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   ex01.ex01_lastupdated_date AS modified_date,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (ex01.ex01_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   ex01.ex01_sid,
                   ex01.ex01_fix_tag_50,
                   ex01.ex01_fix_tag_142,
                   ex01.ex01_fix_tag_57,
                   ex01.ex01_fix_tag_115,
                   ex01_fix_tag_116,
                   ex01_fix_tag_128,
                   ex01_fix_tag_22,
                   ex01_fix_tag_109,
                   ex01_fix_tag_100,
                   NULL,
                   map07.map07_ntp_id,
                   m26_map.new_executing_broker_id
              FROM mubasher_oms.ex01_executing_institution@mubasher_db_link ex01
                   JOIN map01_approval_status_v01 map01
                       ON ex01.ex01_status_id = map01.map01_oms_id
                   LEFT JOIN (  SELECT MAX (map07_name) AS map07_name,
                                       map07_ntp_id
                                  FROM map07_city_m06
                              GROUP BY map07_ntp_id) map07
                       ON UPPER (ex01.ex01_city) = UPPER (map07.map07_name)
                   LEFT JOIN u17_employee_mappings u17_created
                       ON ex01.ex01_created_by = u17_created.old_employee_id
                   LEFT JOIN u17_employee_mappings u17_modified
                       ON ex01.ex01_lastupdated_by =
                              u17_modified.old_employee_id
                   LEFT JOIN u17_employee_mappings u17_status_changed
                       ON ex01.ex01_status_changed_by =
                              u17_status_changed.old_employee_id
                   LEFT JOIN m26_executing_broker_mappings m26_map
                       ON ex01.ex01_id = m26_map.old_executing_broker_id)
    LOOP
        BEGIN
            IF i.new_executing_broker_id IS NULL
            THEN
                l_exec_broker_id := l_exec_broker_id + 1;

                INSERT
                  INTO dfn_ntp.m26_executing_broker (
                           m26_id,
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
                           m26_hold_chrg_last_pay_date,
                           m26_clearing_type_c,
                           m26_is_default_clearing_type_c)
                VALUES (l_exec_broker_id, -- m26_id
                        i.ex01_name, -- m26_name
                        i.ex01_pobox, -- m26_pobox
                        i.ex01_street_address_1, -- m26_street_address_1
                        i.ex01_street_address_2, -- m26_street_address_2
                        i.map07_ntp_id, -- m26_city_id_m06
                        i.ex01_zip, -- m26_zip
                        i.ex01_office_tel_1, -- m26_office_tel_1
                        i.ex01_office_tel_2, -- m26_office_tel_2
                        i.ex01_fax, -- m26_fax
                        i.ex01_email, -- m26_email
                        i.ex_type, -- m26_type
                        i.created_by_new_id, -- m26_created_by_id_u17
                        i.created_date, -- m26_created_date
                        i.modifed_by_new_id, -- m26_lastupdated_by_id_u17
                        i.modified_date, -- m26_lastupdated_date
                        i.map01_ntp_id, -- m26_status_id_v01
                        i.status_changed_by_new_id, -- m26_status_changed_by_id_u17
                        i.status_changed_date, -- m26_status_changed_date
                        i.ex01_sid, -- m26_sid
                        i.ex01_fix_tag_50, -- m26_fix_tag_50
                        i.ex01_fix_tag_142, -- m26_fix_tag_142
                        i.ex01_fix_tag_57, -- m26_fix_tag_57
                        i.ex01_fix_tag_115, -- m26_fix_tag_115
                        i.ex01_fix_tag_116, -- m26_fix_tag_116
                        i.ex01_fix_tag_128, -- m26_fix_tag_128
                        i.ex01_fix_tag_22, -- m26_fix_tag_22
                        i.ex01_fix_tag_109, -- m26_fix_tag_109
                        i.ex01_fix_tag_100, -- m26_fix_tag_100
                        NULL, -- m26_country_id_m05
                        '1', --  m26_custom_type
                        l_primary_institute_id, -- m26_institution_id_m02
                        NULL, -- m26_trans_chrg_grp_id_m166 | Not Available
                        NULL, -- m26_hold_chrg_grp_id_m166 | Not Available
                        NULL, -- m26_pled_in_chrg_grp_id_m166 | Not Available
                        NULL, -- m26_pled_out_chrg_grp_id_m166 | Not Available
                        NULL, -- m26_shar_tran_chrg_grp_id_m166 | Not Available
                        NULL, -- m26_hold_chrg_last_pay_date | Not Available
                        NULL, -- m26_clearing_type_c | Not Available
                        NULL -- m26_is_default_clearing_type_c | Not Available
                            );

                INSERT INTO m26_executing_broker_mappings
                     VALUES (i.ex01_id, l_exec_broker_id);
            ELSE
                UPDATE dfn_ntp.m26_executing_broker
                   SET m26_name = i.ex01_name, -- m26_name
                       m26_pobox = i.ex01_pobox, -- m26_pobox
                       m26_street_address_1 = i.ex01_street_address_1, -- m26_street_address_1
                       m26_street_address_2 = i.ex01_street_address_2, -- m26_street_address_2
                       m26_city_id_m06 = i.map07_ntp_id, -- m26_city_id_m06
                       m26_zip = i.ex01_zip, -- m26_zip
                       m26_office_tel_1 = i.ex01_office_tel_1, -- m26_office_tel_1
                       m26_office_tel_2 = i.ex01_office_tel_2, -- m26_office_tel_2
                       m26_fax = i.ex01_fax, -- m26_fax
                       m26_email = i.ex01_email, -- m26_email
                       m26_type = i.ex_type, -- m26_type
                       m26_lastupdated_by_id_u17 = i.modifed_by_new_id, -- m26_lastupdated_by_id_u17
                       m26_lastupdated_date = i.modified_date, -- m26_lastupdated_date
                       m26_status_id_v01 = i.map01_ntp_id, -- m26_status_id_v01
                       m26_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m26_status_changed_by_id_u17
                       m26_status_changed_date = i.status_changed_date, -- m26_status_changed_date
                       m26_sid = i.ex01_sid, -- m26_sid
                       m26_fix_tag_50 = i.ex01_fix_tag_50, -- m26_fix_tag_50
                       m26_fix_tag_142 = i.ex01_fix_tag_142, -- m26_fix_tag_142
                       m26_fix_tag_57 = i.ex01_fix_tag_57, -- m26_fix_tag_57
                       m26_fix_tag_115 = i.ex01_fix_tag_115, -- m26_fix_tag_115
                       m26_fix_tag_116 = i.ex01_fix_tag_116, -- m26_fix_tag_116
                       m26_fix_tag_128 = i.ex01_fix_tag_128, -- m26_fix_tag_128
                       m26_fix_tag_22 = i.ex01_fix_tag_22, -- m26_fix_tag_22
                       m26_fix_tag_109 = i.ex01_fix_tag_109, -- m26_fix_tag_109
                       m26_fix_tag_100 = i.ex01_fix_tag_100 -- m26_fix_tag_100
                 WHERE m26_id = i.new_executing_broker_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M26_EXECUTING_BROKER',
                                i.ex01_id,
                                CASE
                                    WHEN i.new_executing_broker_id IS NULL
                                    THEN
                                        l_exec_broker_id
                                    ELSE
                                        i.new_executing_broker_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_executing_broker_id IS NULL
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
