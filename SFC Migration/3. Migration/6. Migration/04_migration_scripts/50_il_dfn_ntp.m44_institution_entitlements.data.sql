/*  All Entitlements are Added to Each Institution as Integration User is Ganted All

DECLARE
    l_inst_entitlements_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
    l_count                  NUMBER;
BEGIN
    SELECT NVL (MAX (m44_id), 0)
      INTO l_inst_entitlements_id
      FROM dfn_ntp.m44_institution_entitlements;

    DELETE FROM error_log
          WHERE mig_table = 'M44_INSTITUTION_ENTITLEMENTS';

    FOR i
        IN (SELECT inst_entilements.*, m44.m44_id
              FROM (  SELECT MAX (m61.m61_id) AS m61_id,
                             map04_ntp_id,
                             new_institute_id
                        FROM (SELECT *
                                FROM mubasher_oms.m61_institution_entitlements@mubasher_db_link
                               WHERE m61_institution_id > 0) m61,
                             map04_entitlements_v04 map04,
                             m02_institute_mappings m02_map
                       WHERE     m61.m61_entitlement_id = map04.map04_oms_id(+)
                             AND m61.m61_institution_id =
                                     m02_map.old_institute_id(+)
                    GROUP BY map04_ntp_id, new_institute_id) inst_entilements,
                   dfn_ntp.m44_institution_entitlements m44
             WHERE     inst_entilements.new_institute_id =
                           m44.m44_institution_id_m02(+)
                   AND inst_entilements.map04_ntp_id =
                           m44.m44_entitlement_id_v04(+))
    LOOP
        BEGIN
            IF i.new_institute_id IS NULL
            THEN
                raise_application_error (-20001, 'Invalid Institution', TRUE);
            END IF;

            IF i.map04_ntp_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Entitlement Not Available',
                                         TRUE);
            END IF;

            IF i.m44_id IS NULL
            THEN
                l_inst_entitlements_id := l_inst_entitlements_id + 1;

                INSERT
                  INTO dfn_ntp.m44_institution_entitlements (
                           m44_id,
                           m44_institution_id_m02,
                           m44_entitlement_id_v04,
                           m44_custom_type)
                VALUES (l_inst_entitlements_id, -- m44_id
                        i.new_institute_id, -- m44_institution_id_m02
                        i.map04_ntp_id, -- m44_entitlement_id_v04
                        '1' -- m44_custom_type
                           );
            ELSE
                UPDATE dfn_ntp.m44_institution_entitlements
                   SET m44_institution_id_m02 = i.new_institute_id, -- m44_institution_id_m02
                       m44_entitlement_id_v04 = i.map04_ntp_id -- m44_entitlement_id_v04
                 WHERE m44_id = i.m44_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M44_INSTITUTION_ENTITLEMENTS',
                                i.m61_id,
                                CASE
                                    WHEN i.m44_id IS NULL
                                    THEN
                                        l_inst_entitlements_id
                                    ELSE
                                        i.m44_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.m44_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
*/

DECLARE
    l_inst_entitlements_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m44_id), 0)
      INTO l_inst_entitlements_id
      FROM dfn_ntp.m44_institution_entitlements;

    DELETE FROM error_log
          WHERE mig_table = 'M44_INSTITUTION_ENTITLEMENTS';

    

    FOR i
        IN (SELECT m02_map.new_institute_id, v04.v04_id, m44.m44_id
              FROM dfn_ntp.v04_entitlements v04,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   dfn_ntp.m44_institution_entitlements m44
             WHERE     m02_map.new_institute_id =
                           m44.m44_institution_id_m02(+)
                   AND v04.v04_id = m44.m44_entitlement_id_v04(+))
    LOOP
        BEGIN
            IF i.m44_id IS NULL
            THEN
                l_inst_entitlements_id := l_inst_entitlements_id + 1;

                INSERT
                  INTO dfn_ntp.m44_institution_entitlements (
                           m44_id,
                           m44_institution_id_m02,
                           m44_entitlement_id_v04,
                           m44_custom_type)
                VALUES (l_inst_entitlements_id, -- m44_id
                        i.new_institute_id, -- m44_institution_id_m02
                        i.v04_id, -- m44_entitlement_id_v04
                        '1' -- m44_custom_type
                           );
            ELSE
                UPDATE dfn_ntp.m44_institution_entitlements
                   SET m44_custom_type = '1' -- m44_custom_type
                 WHERE m44_id = i.m44_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M44_INSTITUTION_ENTITLEMENTS',
                                   'Institute : '
                                || i.new_institute_id
                                || ' | Entitlement : '
                                || i.v04_id,
                                CASE
                                    WHEN i.m44_id IS NULL
                                    THEN
                                        l_inst_entitlements_id
                                    ELSE
                                        i.m44_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.m44_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/