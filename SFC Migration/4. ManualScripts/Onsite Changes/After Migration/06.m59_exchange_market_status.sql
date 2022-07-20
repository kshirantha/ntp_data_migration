/* Formatted on 1/12/2021 12:19:53 AM (QP5 v5.206) */
DECLARE
BEGIN
    UPDATE dfn_ntp.app_seq_store
       SET app_seq_value = 0
     WHERE app_seq_name = 'M59_EXCHANGE_MARKET_STATUS';

    DELETE dfn_ntp.m59_exchange_market_status;

    COMMIT;


    FOR i IN (SELECT m01_id, m01_exchange_code FROM dfn_ntp.m01_exchanges)
    LOOP
        IF (i.m01_exchange_code <> 'TDWL')
        THEN
            FOR j IN (SELECT v19_id
                        FROM dfn_ntp.v19_market_status
                       WHERE v19_id IN (2, 3))
            LOOP
                INSERT
                  INTO dfn_ntp.m59_exchange_market_status (m59_id,
                                                   m59_exchange_id_m01,
                                                   m59_market_status_id_v19,
                                                   m59_exchange_code_m01,
                                                   m59_custom_type)
                VALUES (dfn_ntp.fn_get_next_sequnce ('M59_EXCHANGE_MARKET_STATUS'),
                        i.m01_id,
                        j.v19_id,
                        i.m01_exchange_code,
                        '1');
            END LOOP;
        ELSE
            FOR j IN (SELECT * FROM dfn_ntp.v19_market_status)
            LOOP
                INSERT
                  INTO dfn_ntp.m59_exchange_market_status (m59_id,
                                                   m59_exchange_id_m01,
                                                   m59_market_status_id_v19,
                                                   m59_exchange_code_m01,
                                                   m59_custom_type)
                VALUES (dfn_ntp.fn_get_next_sequnce ('M59_EXCHANGE_MARKET_STATUS'),
                        i.m01_id,
                        j.v19_id,
                        i.m01_exchange_code,
                        '1');
            END LOOP;
        END IF;
    END LOOP;
END;
/
commit;
