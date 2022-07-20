DECLARE
    l_market_maker_grps_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m131_id), 0)
      INTO l_market_maker_grps_id
      FROM dfn_ntp.m131_market_maker_grps;

    DELETE FROM error_log
          WHERE mig_table = 'M131_MARKET_MAKER_GRPS';

    FOR i
        IN (SELECT m348.m348_id,
                   m348.m348_name,
                   map01.map01_ntp_id,
                   NVL (u17_created_by.new_employee_id, 0)
                       AS created_by_new_id,
                   NVL (m348.m348_created_date, SYSDATE) AS created_date,
                   m02_map.new_institute_id,
                   m131_map.new_market_maker_grp_id
              FROM mubasher_oms.m348_market_makers@mubasher_db_link m348,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created_by,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   m131_market_maker_grp_mappings m131_map
             WHERE     m348.m348_status_id = map01.map01_oms_id
                   AND m348.m348_created_by =
                           u17_created_by.old_employee_id(+)
                   AND m348.m348_id = m131_map.old_market_maker_grp_id(+)
                   AND m02_map.new_institute_id =
                           m131_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_market_maker_grp_id IS NULL
            THEN
                l_market_maker_grps_id := l_market_maker_grps_id + 1;

                INSERT
                  INTO dfn_ntp.m131_market_maker_grps (
                           m131_id,
                           m131_name,
                           m131_created_by_id_u17,
                           m131_created_date,
                           m131_modified_by_id_u17,
                           m131_modified_date,
                           m131_status_id_v01,
                           m131_status_changed_by_id_u17,
                           m131_status_changed_date,
                           m131_custom_type,
                           m131_institute_id_m02)
                VALUES (l_market_maker_grps_id, -- m131_id
                        i.m348_name, -- m131_name
                        i.created_by_new_id, -- m131_created_by_id_u17
                        i.created_date, -- m131_created_date
                        NULL, -- m131_modified_by_id_u17
                        NULL, -- m131_modified_date
                        i.map01_ntp_id, -- m131_status_id_v01
                        0, -- m131_status_changed_by_id_u17
                        SYSDATE, -- m131_status_changed_date
                        '1', -- m131_custom_type
                        i.new_institute_id -- m131_institute_id_m02
                                          );

                INSERT INTO m131_market_maker_grp_mappings
                     VALUES (
                                i.m348_id,
                                l_market_maker_grps_id,
                                i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m131_market_maker_grps
                   SET m131_name = i.m348_name, -- m131_name
                       m131_status_id_v01 = i.map01_ntp_id, -- m131_status_id_v01
                       m131_modified_by_id_u17 = 0, -- m131_modified_by_id_u17
                       m131_modified_date = SYSDATE -- m131_modified_date
                 WHERE m131_id = i.new_market_maker_grp_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M131_MARKET_MAKER_GRPS',
                                i.m348_id,
                                CASE
                                    WHEN i.new_market_maker_grp_id IS NULL
                                    THEN
                                        l_market_maker_grps_id
                                    ELSE
                                        i.new_market_maker_grp_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_market_maker_grp_id IS NULL
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
