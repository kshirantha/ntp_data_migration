DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_u_message_detail_id    NUMBER;
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

    SELECT NVL (MAX (t19_id), 0)
      INTO l_u_message_detail_id
      FROM dfn_ntp.t19_c_umessage_share_details;

    DELETE FROM error_log
          WHERE mig_table = 'T19_C_UMESSAGE_SHARE_DETAILS';

    FOR i
        IN (SELECT t84.t84_id,
                   t18_map.new_umessage_id,
                   NVL (NVL (t84.t84_exchange, 'TDWL'), map16.map16_ntp_code)
                       AS exchange,
                   t84.t84_symbol,
                   t84.t84_isin_9719,
                   t84.t84_shares_53,
                   t84.t84_shares_available_9957,
                   t84.t84_shares_pledge_9958,
                   t84.t84_position_date_9720,
                   t84.t84_change_date_9721,
                   t84.t84_net_holding,
                   t18.t18_institute_id_m02,
                   m20.m20_id,
                   t19_map.new_umsg_share_detail_id
              FROM mubasher_oms.t84_u_message_share_details@mubasher_db_link t84,
                   t18_c_umessage_mappings t18_map,
                   dfn_ntp.t18_c_umessage t18,
                   t19_umsg_share_detail_mappings t19_map,
                   map16_optional_exchanges_m01 map16,
                   (SELECT m20_id, m20_symbol_code, m20_exchange_code_m01
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20
             WHERE     t84.t84_t83_id = t18_map.old_umessage_id(+)
                   AND t18_map.new_umessage_id = t18.t18_id -- [Discussed] Skip Those Not Having U Message
                   AND t84.t84_symbol = m20.m20_symbol_code -- [Discussed] Skip Those Not Having a Symbol
                   AND NVL (t84.t84_exchange, 'TDWL') =
                           map16.map16_oms_code(+)
                   AND NVL (NVL (t84.t84_exchange, 'TDWL'),
                            map16.map16_ntp_code) = m20.m20_exchange_code_m01 -- [Discussed] Skip Those Not Having a Symbol
                   AND t84.t84_id = t19_map.old_umsg_share_detail_id(+))
    LOOP
        BEGIN
            IF i.new_umsg_share_detail_id IS NULL
            THEN
                l_u_message_detail_id := l_u_message_detail_id + 1;

                INSERT
                  INTO dfn_ntp.t19_c_umessage_share_details (
                           t19_id,
                           t19_t18_id,
                           t19_exchange,
                           t19_symbol,
                           t19_isin_9719,
                           t19_shares_53,
                           t19_shares_available_9957,
                           t19_shares_pledge_9958,
                           t19_position_date_9720,
                           t19_change_date_9721,
                           t19_net_holding,
                           t19_institute_id_m02,
                           t19_symbol_id_m20)
                VALUES (l_u_message_detail_id, -- t19_id
                        i.new_umessage_id, -- t19_t18_id
                        i.exchange, -- t19_exchange
                        i.t84_symbol, -- t19_symbol
                        i.t84_isin_9719, -- t19_isin_9719
                        i.t84_shares_53, -- t19_shares_53
                        i.t84_shares_available_9957, -- t19_shares_available_9957
                        i.t84_shares_pledge_9958, -- t19_shares_pledge_9958
                        i.t84_position_date_9720, -- t19_position_date_9720
                        i.t84_change_date_9721, -- t19_change_date_9721
                        i.t84_net_holding, -- t19_net_holding
                        i.t18_institute_id_m02, -- t19_institute_id_m02
                        i.m20_id -- t19_symbol_id_m20
                                );

                INSERT
                  INTO t19_umsg_share_detail_mappings (
                           old_umsg_share_detail_id,
                           new_umsg_share_detail_id)
                VALUES (i.t84_id, l_u_message_detail_id);
            ELSE
                UPDATE dfn_ntp.t19_c_umessage_share_details
                   SET t19_t18_id = i.new_umessage_id, -- t19_t18_id
                       t19_exchange = i.exchange, -- t19_exchange
                       t19_symbol = i.t84_symbol, -- t19_symbol
                       t19_isin_9719 = i.t84_isin_9719, -- t19_isin_9719
                       t19_shares_53 = i.t84_shares_53, -- t19_shares_53
                       t19_shares_available_9957 = i.t84_shares_available_9957, -- t19_shares_available_9957
                       t19_shares_pledge_9958 = i.t84_shares_pledge_9958, -- t19_shares_pledge_9958
                       t19_position_date_9720 = i.t84_position_date_9720, -- t19_position_date_9720
                       t19_change_date_9721 = i.t84_change_date_9721, -- t19_change_date_9721
                       t19_net_holding = i.t84_net_holding, -- t19_net_holding
                       t19_institute_id_m02 = i.t18_institute_id_m02, -- t19_institute_id_m02
                       t19_symbol_id_m20 = i.m20_id -- t19_symbol_id_m20
                 WHERE t19_id = i.new_umsg_share_detail_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T19_C_UMESSAGE_SHARE_DETAILS',
                                i.t84_id,
                                CASE
                                    WHEN i.new_umsg_share_detail_id IS NULL
                                    THEN
                                        l_u_message_detail_id
                                    ELSE
                                        i.new_umsg_share_detail_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_umsg_share_detail_id IS NULL
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
