/* Formatted on 12/23/2020 10:45:56 PM (QP5 v5.206) */
DECLARE
    l_count   NUMBER := 0;
BEGIN
    DELETE dfn_ntp.m19_routing_data;

    COMMIT;

    UPDATE dfn_ntp.app_seq_store
       SET app_seq_value = 0
     WHERE app_seq_name = 'M19_ROUTING_DATA';

    COMMIT;

    FOR i
        IN (SELECT DISTINCT m37_fix_tag_49, m37_fix_tag_56
              FROM mubasher_oms.m37_trading_markets@mubasher_db_link
             WHERE     m37_fix_tag_49 IS NOT NULL
                   AND m37_fix_tag_56 IS NOT NULL
                   AND m37_is_exchange = 0
                   AND m37_status_id = 2)
    LOOP
        INSERT INTO dfn_ntp.m19_routing_data (m19_id,
                                              m19_connection_status,
                                              m19_fix_tag_49,
                                              m19_fix_tag_56,
                                              m19_connection_alias,
                                              m19_created_by_id_u17,
                                              m19_created_date,
                                              m19_status_id_v01,
                                              m19_status_changed_by_id_u17,
                                              m19_status_changed_date,
                                              m19_custom_type,
                                              m19_primary_institute_id_m02,
                                              m19_gmt_offset_trade,
                                              m19_overwrite_tag_50)
             VALUES (dfn_ntp.fn_get_next_sequnce ('M19_ROUTING_DATA'),
                     0,
                     i.m37_fix_tag_49,
                     i.m37_fix_tag_56,
                     i.m37_fix_tag_56,
                     1,
                     SYSDATE,
                     2,
                     1,
                     SYSDATE,
                     '1',
                     1,
                     0,
                     0);
    END LOOP;

    COMMIT;

    FOR i
        IN (SELECT DISTINCT m37_fix_tag_49,
                            m37_fix_tag_56,
                            m37_fix_tag_50,
                            m37_connection_alias
              FROM mubasher_oms.m37_trading_markets@mubasher_db_link m37
             WHERE     m37_fix_tag_49 IS NOT NULL
                   AND m37_fix_tag_56 IS NOT NULL
                   AND m37_is_exchange = 1
                   AND m37_status_id = 2)
    LOOP
        SELECT COUNT (*)
          INTO l_count
          FROM dfn_ntp.m19_routing_data m19
         WHERE     m19_fix_tag_49 = i.m37_fix_tag_49
               AND m19_fix_tag_56 = i.m37_fix_tag_56
               AND m19_connection_alias = i.m37_connection_alias;

        IF (l_count = 0)
        THEN
            INSERT
              INTO dfn_ntp.m19_routing_data (m19_id,
                                             m19_connection_status,
                                             m19_fix_tag_49,
                                             m19_fix_tag_56,
                                             m19_connection_alias,
                                             m19_created_by_id_u17,
                                             m19_created_date,
                                             m19_status_id_v01,
                                             m19_status_changed_by_id_u17,
                                             m19_status_changed_date,
                                             m19_custom_type,
                                             m19_primary_institute_id_m02,
                                             m19_gmt_offset_trade,
                                             m19_overwrite_tag_50)
            VALUES (dfn_ntp.fn_get_next_sequnce ('M19_ROUTING_DATA'),
                    0,
                    i.m37_fix_tag_49,
                    i.m37_fix_tag_56,
                    i.m37_connection_alias,
                    1,
                    SYSDATE,
                    2,
                    1,
                    SYSDATE,
                    '1',
                    1,
                    0,
                    0);
        END IF;

        COMMIT;
    END LOOP;
END;
/
commit;
