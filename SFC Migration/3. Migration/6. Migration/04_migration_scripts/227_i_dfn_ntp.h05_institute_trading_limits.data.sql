DECLARE
    l_institute_trd_limits_id   NUMBER;
    l_sqlerrm                   VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (h05_id), 0)
      INTO l_institute_trd_limits_id
      FROM dfn_ntp.h05_institute_trading_limits;

    DELETE FROM error_log
          WHERE mig_table = 'H05_INSTITUTE_TRADING_LIMITS';

    FOR i
        IN (SELECT m02_map.new_institute_id,
                   m109.m109_od_limit,
                   m109.m109_margin_limit,
                   m109.m109_last_updated_date AS last_updated_date,
                   u17_updated.new_employee_id AS last_updated_by_new_id,
                   m02_map.old_institute_id,
                   h05.h05_id
              FROM mubasher_oms.m109_institution_trd_limits@mubasher_db_link m109,
                   u17_employee_mappings u17_updated,
                   m02_institute_mappings m02_map,
                   dfn_ntp.h05_institute_trading_limits h05
             WHERE     m109.m109_institution_id = m02_map.old_institute_id
                   AND m109.m109_last_updated_by =
                           u17_updated.old_employee_id(+)
                   AND m02_map.new_institute_id =
                           h05.h05_institution_id_m02(+))
    LOOP
        BEGIN
            IF i.h05_id IS NULL
            THEN
                l_institute_trd_limits_id := l_institute_trd_limits_id + 1;

                INSERT
                  INTO dfn_ntp.h05_institute_trading_limits (
                           h05_id,
                           h05_institution_id_m02,
                           h05_od_limit,
                           h05_margin_limit,
                           h05_updated_date,
                           h05_updated_by_id_u17,
                           h05_custom_type)
                VALUES (l_institute_trd_limits_id, --a.h05_id
                        i.new_institute_id, -- h05_institution_id_m02
                        i.m109_od_limit, -- h05_od_limit
                        i.m109_margin_limit, -- h05_margin_limit
                        i.last_updated_date, -- h05_updated_date
                        i.last_updated_by_new_id, -- h05_updated_by_id_u17
                        '1' -- h05_custom_type
                           );
            ELSE
                UPDATE dfn_ntp.h05_institute_trading_limits
                   SET h05_od_limit = i.m109_od_limit, -- h05_od_limit
                       h05_margin_limit = i.m109_margin_limit, -- h05_margin_limit
                       h05_updated_date = i.last_updated_date, -- h05_updated_date
                       h05_updated_by_id_u17 = i.last_updated_by_new_id -- h05_updated_by_id_u17
                 WHERE h05_id = i.h05_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'H05_INSTITUTE_TRADING_LIMITS',
                                i.old_institute_id,
                                CASE
                                    WHEN i.h05_id IS NULL
                                    THEN
                                        l_institute_trd_limits_id
                                    ELSE
                                        i.h05_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.h05_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
