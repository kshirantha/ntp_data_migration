DECLARE
    l_cust_identity_id   NUMBER;
    l_sqlerrm            VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (u05_id), 0)
      INTO l_cust_identity_id
      FROM dfn_ntp.u05_customer_identification;

    DELETE FROM error_log
          WHERE mig_table = 'U05_CUSTOMER_IDENTIFICATION';

    FOR i
        IN (SELECT m243.m243_id,
                   map08.map08_ntp_id,
                   u01_map.new_customer_id,
                   m243.m243_id_no,
                   m243.m243_issue_date,
                   NVL (m14_map.new_issue_location_id, v20.v20_value)
                       AS issue_place,
                   NVL (m243.m243_expiry_date, SYSDATE + 90) AS expiary_date,
                   map01.map01_ntp_id,
                   u05_map.new_cust_id_id
              FROM mubasher_oms.m243_customer_identifications@mubasher_db_link m243,
                   map01_approval_status_v01 map01,
                   map08_identity_type_m15 map08,
                   u01_customer_mappings u01_map,
                   m14_issue_location_mappings m14_map,
                   dfn_ntp.u01_customer u01,
                   (SELECT v20_institute_id_m02, v20_value
                      FROM dfn_ntp.v20_default_master_data
                     WHERE v20_tag = 'issueLocation') v20,
                   u05_cust_id_mappings u05_map
             WHERE     m243.m243_id_status = map01.map01_oms_id
                   AND m243.m243_customer = u01_map.old_customer_id
                   AND u01_map.new_customer_id = u01.u01_id
                   AND m243.m243_identification_type = map08.map08_oms_id
                   AND m243.m243_issue_place =
                           m14_map.old_issue_location_id(+)
                   AND u01.u01_institute_id_m02 = m14_map.new_institute_id(+)
                   AND u01.u01_institute_id_m02 = v20.v20_institute_id_m02(+)
                   AND m243.m243_id = u05_map.old_cust_id_id(+))
    LOOP
        BEGIN
            IF i.new_cust_id_id IS NULL
            THEN
                l_cust_identity_id := l_cust_identity_id + 1;

                INSERT
                  INTO dfn_ntp.u05_customer_identification (
                           u05_id,
                           u05_identity_type_id_m15,
                           u05_customer_id_u01,
                           u05_id_no,
                           u05_issue_date,
                           u05_issue_location_id_m14,
                           u05_expiry_date,
                           u05_is_default,
                           u05_created_by_id_u17,
                           u05_created_date,
                           u05_status_id_v01,
                           u05_modified_by_id_u17,
                           u05_modified_date,
                           u05_status_changed_by_id_u17,
                           u05_status_changed_date,
                           u05_custom_type)
                VALUES (l_cust_identity_id, -- u05_id
                        i.map08_ntp_id, -- u05_identity_type_id_m15
                        i.new_customer_id, -- u05_customer_id_u01
                        i.m243_id_no, -- u05_id_no
                        i.m243_issue_date, -- u05_issue_date
                        i.issue_place, --u05_issue_location_id_m14
                        i.expiary_date, -- u05_expiry_date
                        1, -- u05_is_default | One to One Mapping
                        NULL, -- u05_created_by_id_u17 | Not Available
                        NULL, -- u05_created_date | Not Available
                        i.map01_ntp_id, -- u05_status_id_v01
                        NULL, -- u05_modified_by_id_u17 | Not Available
                        NULL, -- u05_modified_date | Not Available
                        NULL, -- u05_status_changed_by_id_u17 | Not Available
                        NULL, -- u05_status_changed_date | Not Available
                        '1' -- u05_custom_type
                           );

                INSERT INTO u05_cust_id_mappings
                     VALUES (i.m243_id, l_cust_identity_id);
            ELSE
                UPDATE dfn_ntp.u05_customer_identification
                   SET u05_identity_type_id_m15 = i.map08_ntp_id, -- u05_identity_type_id_m15
                       u05_customer_id_u01 = i.new_customer_id, -- u05_customer_id_u01
                       u05_id_no = i.m243_id_no, -- u05_id_no
                       u05_issue_date = i.m243_issue_date, -- u05_issue_date
                       u05_issue_location_id_m14 = i.issue_place, --u05_issue_location_id_m14
                       u05_expiry_date = i.expiary_date, -- u05_expiry_date
                       u05_status_id_v01 = i.map01_ntp_id, -- u05_status_id_v01
                       u05_modified_by_id_u17 = 0, -- u05_modified_by_id_u17
                       u05_modified_date = SYSDATE -- u05_modified_date
                 WHERE u05_id = i.new_cust_id_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U05_CUSTOMER_IDENTIFICATION',
                                i.m243_id,
                                CASE
                                    WHEN i.new_cust_id_id IS NULL
                                    THEN
                                        l_cust_identity_id
                                    ELSE
                                        i.new_cust_id_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cust_id_id IS NULL
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