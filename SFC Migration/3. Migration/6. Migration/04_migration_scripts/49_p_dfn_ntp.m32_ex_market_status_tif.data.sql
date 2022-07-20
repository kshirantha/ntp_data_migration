DECLARE
    l_ex_mkt_status_tif_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m32_id), 0)
      INTO l_ex_mkt_status_tif_id
      FROM dfn_ntp.m32_ex_market_status_tif;

    DELETE FROM error_log
          WHERE mig_table = 'M32_EX_MARKET_STATUS_TIF';

    FOR i
        IN (SELECT m167.m167_id,
                   m167.m167_tif, -- [SAME IDs]
                   m30.m30_id,
                   m57.m57_order_type_id_v06,
                   m30.m30_market_code_m29,
                   m30.m30_market_status_id_v19,
                   m59.m59_exchange_code_m01,
                   m59.m59_exchange_id_m01,
                   m57_map.new_exg_order_types_id,
                   m32_map.new_ex_mkt_status_tif_id
              FROM mubasher_oms.m167_market_status_tif@mubasher_db_link m167,
                   m57_exg_order_types_mappings m57_map,
                   dfn_ntp.m57_exchange_order_types m57,
                   m59_exg_mkt_status_mappings m59_map,
                   dfn_ntp.m59_exchange_market_status m59,
                   dfn_ntp.m30_ex_market_permissions m30,
                   m32_ex_mkt_status_tif_mappings m32_map
             WHERE     m167.m167_exg_order_type =
                           m57_map.old_exg_order_types_id
                   AND m57_map.new_exg_order_types_id = m57.m57_id
                   AND m167.m167_market_status =
                           m59_map.old_exg_mkt_status_id
                   AND m59_map.new_exg_mkt_status_id = m59.m59_id
                   AND m59.m59_exchange_id_m01 = m30.m30_exchange_id_m01
                   AND m59.m59_market_status_id_v19 =
                           m30.m30_market_status_id_v19
                   AND m59.m59_id = m30.m30_exchange_status_id_m59
                   AND m167.m167_id = m32_map.old_ex_mkt_status_tif_id(+))
    LOOP
        BEGIN
            IF i.new_ex_mkt_status_tif_id IS NULL
            THEN
                l_ex_mkt_status_tif_id := l_ex_mkt_status_tif_id + 1;

                INSERT
                  INTO dfn_ntp.m32_ex_market_status_tif (
                           m32_tif_type_id_v10,
                           m32_status_id_m30,
                           m32_order_type_id_v06,
                           m32_id,
                           m32_market_code_m29,
                           m32_market_status_id_v19,
                           m32_exchange_code_m01,
                           m32_exchange_id_m01,
                           m32_exchange_order_type_id_m57,
                           m32_custom_type)
                VALUES (i.m167_tif, -- m32_tif_type_id_v10
                        i.m30_id, -- m32_status_id_m30
                        i.m57_order_type_id_v06, -- m32_order_type_id_v06
                        l_ex_mkt_status_tif_id, -- m32_id
                        i.m30_market_code_m29, -- m32_market_code_m29
                        i.m30_market_status_id_v19, -- m32_market_status_id_v19
                        i.m59_exchange_code_m01, -- m32_exchange_code_m01
                        i.m59_exchange_id_m01, -- m32_exchange_id_m01,
                        i.new_exg_order_types_id, -- m32_exchange_order_type_id_m57
                        '1' -- m32_custom_type
                           );

                INSERT INTO m32_ex_mkt_status_tif_mappings
                     VALUES (i.m167_id, l_ex_mkt_status_tif_id);
            ELSE
                UPDATE dfn_ntp.m32_ex_market_status_tif
                   SET m32_tif_type_id_v10 = i.m167_tif, -- m32_tif_type_id_v10
                       m32_status_id_m30 = i.m30_id, -- m32_status_id_m30
                       m32_order_type_id_v06 = i.m57_order_type_id_v06, -- m32_order_type_id_v06
                       m32_market_code_m29 = i.m30_market_code_m29, -- m32_market_code_m29
                       m32_market_status_id_v19 = i.m30_market_status_id_v19, -- m32_market_status_id_v19
                       m32_exchange_code_m01 = i.m59_exchange_code_m01, -- m32_exchange_code_m01
                       m32_exchange_id_m01 = i.m59_exchange_id_m01, -- m32_exchange_id_m01,
                       m32_exchange_order_type_id_m57 =
                           i.new_exg_order_types_id -- m32_exchange_order_type_id_m57
                 WHERE m32_id = i.new_ex_mkt_status_tif_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M32_EX_MARKET_STATUS_TIF',
                                i.m167_id,
                                CASE
                                    WHEN i.new_ex_mkt_status_tif_id IS NULL
                                    THEN
                                        l_ex_mkt_status_tif_id
                                    ELSE
                                        i.new_ex_mkt_status_tif_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_ex_mkt_status_tif_id IS NULL
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