/* Formatted on 24-Dec-2020 12:07:22 (QP5 v5.206) */
DECLARE
    l_count    NUMBER := 0;
    l_m19_id   NUMBER := 0;
BEGIN
    DELETE dfn_ntp.m31_exec_broker_routing;

    COMMIT;

    UPDATE dfn_ntp.app_seq_store
       SET app_seq_value = 0
     WHERE app_seq_name = 'M31_EXEC_BROKER_ROUTING';

    COMMIT;

    FOR i IN (SELECT m37_exchange,
                     m37_mkt_code,
                     m37_fix_tag_49,
                     m37_fix_tag_56,
                     m37_fix_tag_50,
                     m37_connection_alias,
                     m37_deri_int_trader_id,
                     m01.m01_id
                FROM     mubasher_oms.m37_trading_markets@mubasher_db_link m37
                     INNER JOIN
                         dfn_ntp.m01_exchanges m01
                     ON m01.m01_exchange_code = m37.m37_exchange)
    LOOP
        FOR j IN (SELECT m87_exec_broker_id_m26
                    FROM dfn_ntp.m87_exec_broker_exchange
                   WHERE m87_exchange_code_m01 = i.m37_exchange)
        LOOP
            SELECT COUNT (*)
              INTO l_count
              FROM dfn_ntp.m19_routing_data m19
             WHERE     m19.m19_fix_tag_49 = i.m37_fix_tag_49
                   AND m19.m19_fix_tag_56 = i.m37_fix_tag_56;

            IF (l_count = 1)
            THEN
                SELECT m19.m19_id
                  INTO l_m19_id
                  FROM dfn_ntp.m19_routing_data m19
                 WHERE     m19.m19_fix_tag_49 = i.m37_fix_tag_49
                       AND m19.m19_fix_tag_56 = i.m37_fix_tag_56;
            ELSIF (l_count > 1)
            THEN
                SELECT COUNT (*)
                  INTO l_count
                  FROM dfn_ntp.m19_routing_data m19
                 WHERE     m19.m19_fix_tag_49 = i.m37_fix_tag_49
                       AND m19.m19_fix_tag_56 = i.m37_fix_tag_56
                       AND m19.m19_connection_alias = i.m37_connection_alias;

                IF (l_count = 1)
                THEN
                    SELECT m19.m19_id
                      INTO l_m19_id
                      FROM dfn_ntp.m19_routing_data m19
                     WHERE     m19.m19_fix_tag_49 = i.m37_fix_tag_49
                           AND m19.m19_fix_tag_56 = i.m37_fix_tag_56
                           AND m19.m19_connection_alias =
                                   i.m37_connection_alias;
                ELSE
                    CONTINUE;
                END IF;
            ELSE
                CONTINUE;
            END IF;

            INSERT
              INTO dfn_ntp.m31_exec_broker_routing (
                       m31_exchange_code_m01,
                       m31_routing_data_id_m19,
                       m31_id,
                       m31_fix_tag_50,
                       m31_exchange_id_m01,
                       m31_exec_broker_id_m26,
                       m31_board_code_m54,
                       m31_connect_status,
                       m31_institute_id,
                       m31_status_changed_by_id_u17,
                       m31_status_changed_date,
                       m31_status_id_v01,
                       m31_is_active,
                       m31_type)
            VALUES (i.m37_exchange,
                    l_m19_id,
                    dfn_ntp.fn_get_next_sequnce ('M31_EXEC_BROKER_ROUTING'),
                    i.m37_fix_tag_50,
                    i.m01_id,
                    j.m87_exec_broker_id_m26,
                    i.m37_mkt_code,
                    0,
                    1,
                    1,
                    SYSDATE,
                    2,
                    1,
                    DECODE (i.m37_mkt_code, 'SAEQ_U', 2, 1));
        END LOOP;
    END LOOP;

    COMMIT;
END;
/
commit;
