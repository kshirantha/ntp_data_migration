DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_exg_tif_id             NUMBER;
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

    SELECT NVL (MAX (m58_id), 0)
      INTO l_exg_tif_id
      FROM dfn_ntp.m58_exchange_tif;

    DELETE FROM error_log
          WHERE mig_table = 'M58_EXCHANGE_TIF';

    FOR i
        IN (SELECT m118_id,
                   m01_id,
                   m118_tif, -- [SAME IDs]
                   m118_duration,
                   m58_map.new_exchange_tif_id
              FROM mubasher_oms.m118_exchange_tif@mubasher_db_link m118,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   map16_optional_exchanges_m01 map16,
                   m58_exchange_tif_mappings m58_map
             WHERE     m118.m118_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, m118.m118_exchange) =
                           m01.m01_exchange_code(+)
                   AND m118.m118_id = m58_map.old_exchange_tif_id(+))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.new_exchange_tif_id IS NULL
            THEN
                l_exg_tif_id := l_exg_tif_id + 1;

                INSERT INTO dfn_ntp.m58_exchange_tif (m58_id,
                                                      m58_exchange_id_m01,
                                                      m58_tif_id_v10,
                                                      m58_duration)
                     VALUES (l_exg_tif_id, -- m58_id
                             i.m01_id, -- m58_exchange_id_m01
                             i.m118_tif, -- m58_tif_id_v10
                             i.m118_duration -- m58_duration
                                            );

                INSERT INTO m58_exchange_tif_mappings
                     VALUES (i.m118_id, l_exg_tif_id);
            ELSE
                UPDATE dfn_ntp.m58_exchange_tif
                   SET m58_exchange_id_m01 = i.m01_id, -- m58_exchange_id_m01
                       m58_tif_id_v10 = i.m118_tif, -- m58_tif_id_v10
                       m58_duration = i.m118_duration -- m58_duration
                 WHERE m58_id = i.new_exchange_tif_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M58_EXCHANGE_TIF',
                                i.m118_id,
                                CASE
                                    WHEN i.new_exchange_tif_id IS NULL
                                    THEN
                                        l_exg_tif_id
                                    ELSE
                                        i.new_exchange_tif_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_exchange_tif_id IS NULL
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
