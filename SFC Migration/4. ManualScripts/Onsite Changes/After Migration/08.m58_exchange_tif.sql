DECLARE
    l_key   NUMBER := 1;
BEGIN
    UPDATE dfn_ntp.app_seq_store
       SET app_seq_value = 0
     WHERE app_seq_name = 'M58_EXCHANGE_TIF';

    DELETE dfn_ntp.m58_exchange_tif;

    COMMIT;

    DELETE dfn_ntp.v10_tif
     WHERE v10_id > 6;

    COMMIT;

    FOR i IN (SELECT m01_id, m01_exchange_code FROM dfn_ntp.m01_exchanges)
    LOOP
        IF (i.m01_exchange_code = 'TDWL')
        THEN
            FOR j IN (SELECT v10_id FROM dfn_ntp.v10_tif)
            LOOP
                INSERT INTO dfn_ntp.m58_exchange_tif (m58_id,
                                                      m58_exchange_id_m01,
                                                      m58_tif_id_v10,
                                                      m58_duration)
                     VALUES (l_key,
                             i.m01_id,
                             j.v10_id,
                             0);

                l_key := l_key + 1;
            END LOOP;
        ELSIF (i.m01_exchange_code IN
                   ('KSE', 'DFM', 'ADSM', 'CASE', 'DSM', 'MSM'))
        THEN
            FOR j IN (SELECT v10_id
                        FROM dfn_ntp.v10_tif
                       WHERE v10_id IN (0, 1, 6))
            LOOP
                INSERT INTO dfn_ntp.m58_exchange_tif (m58_id,
                                                      m58_exchange_id_m01,
                                                      m58_tif_id_v10,
                                                      m58_duration)
                     VALUES (l_key,
                             i.m01_id,
                             j.v10_id,
                             0);

                l_key := l_key + 1;
            END LOOP;
        ELSE
            INSERT INTO dfn_ntp.m58_exchange_tif (m58_id,
                                                  m58_exchange_id_m01,
                                                  m58_tif_id_v10,
                                                  m58_duration)
                 VALUES (l_key,
                         i.m01_id,
                         0,
                         0);
        END IF;

        l_key := l_key + 1;
    END LOOP;

    COMMIT;
END;
/

COMMIT;
