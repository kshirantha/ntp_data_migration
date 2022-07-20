DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_market_id              NUMBER;
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

    SELECT NVL (MAX (m29_id), 0) INTO l_market_id FROM dfn_ntp.m29_markets;

    DELETE FROM error_log
          WHERE mig_table = 'M29_MARKETS';

    FOR i
        IN (SELECT NVL (map16.map16_ntp_code, m115.m115_exchange) AS exchange,
                   m115.m115_market_code,
                   m115.m115_is_default,
                   m115.m115_is_active,
                   m01.m01_id,
                   m29.m29_id
              FROM mubasher_oms.m115_sub_markets@mubasher_db_link m115,
                   map16_optional_exchanges_m01 map16,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   (SELECT m29_id, m29_exchange_code_m01, m29_market_code
                      FROM dfn_ntp.m29_markets m29
                     WHERE m29_primary_institution_id_m02 =
                               l_primary_institute_id) m29
             WHERE     m115.m115_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, m115.m115_exchange) =
                           m01.m01_exchange_code(+)
                   AND NVL (map16.map16_ntp_code, m115.m115_exchange) =
                           m29.m29_exchange_code_m01(+)
                   AND m115.m115_market_code = m29.m29_market_code(+))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.m29_id IS NULL
            THEN
                l_market_id := l_market_id + 1;

                INSERT
                  INTO dfn_ntp.m29_markets (m29_exchange_code_m01,
                                            m29_current_mkt_status_id_v19,
                                            m29_market_code,
                                            m29_last_status_updated,
                                            m29_is_default,
                                            m29_is_active,
                                            m29_status_id_v01,
                                            m29_id,
                                            m29_exchange_id_m01,
                                            m29_preopen_allowed,
                                            m29_last_preopened_date,
                                            m29_last_eod_date,
                                            m29_status_changed_by_id_u17,
                                            m29_status_changed_date,
                                            m29_created_by_id_u17,
                                            m29_created_date,
                                            m29_modified_by_id_u17,
                                            m29_modified_date,
                                            m29_is_active_process,
                                            m29_manual_suspend,
                                            m29_custom_type,
                                            m29_primary_institution_id_m02,
                                            m29_price_market_code)
                VALUES (i.exchange, -- m29_exchange_code_m01
                        3, -- m29_current_mkt_status_id_v19
                        i.m115_market_code, -- m29_market_code
                        SYSDATE, -- m29_last_status_updated
                        i.m115_is_default, -- m29_is_default
                        i.m115_is_active, -- m29_is_active
                        2, -- m29_status_id_v01 | Not Available
                        l_market_id, -- m29_id
                        i.m01_id, -- m29_exchange_id_m01
                        0, -- m29_preopen_allowed [Updated via Post Migration]
                        SYSDATE, -- m29_last_preopened_date
                        SYSDATE, -- m29_last_eod_date
                        0, -- m29_status_changed_by_id_u17
                        SYSDATE, -- m29_status_changed_date
                        0, -- m29_created_by_id_u17
                        SYSDATE, -- m29_created_date
                        0, -- m29_modified_by_id_u17
                        SYSDATE, -- m29_modified_date
                        'NONE', -- m29_is_active_process
                        0, -- m29_manual_suspend
                        '1', -- m29_custom_type
                        l_primary_institute_id, -- m29_primary_institution_id_m02
                        i.m115_market_code -- m29_price_market_code
                                          );
            ELSE
                UPDATE dfn_ntp.m29_markets
                   SET m29_is_default = i.m115_is_default, -- m29_is_default
                       m29_is_active = i.m115_is_active, -- m29_is_active
                       m29_exchange_id_m01 = i.m01_id, -- m29_exchange_id_m01
                       m29_price_market_code = i.m115_market_code, -- m29_price_market_code
                       m29_modified_by_id_u17 = 0, -- m29_modified_by_id_u17
                       m29_modified_date = SYSDATE -- m29_modified_date
                 WHERE m29_id = i.m29_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M29_MARKETS',
                                   'Exchange : '
                                || i.exchange
                                || ' | Market Code : '
                                || i.m115_market_code,
                                CASE
                                    WHEN i.m29_id IS NULL THEN l_market_id
                                    ELSE i.m29_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.m29_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;

    COMMIT;

    -- Set Default True for One & Only One Market for Any Given Exchange. Need to Check & Set Default Manually for Exchanges having Multiple Markets

    MERGE INTO dfn_ntp.m29_markets m29
         USING ( (SELECT *
                    FROM dfn_ntp.m29_markets m29
                   WHERE m29.m29_exchange_code_m01 IN
                             (  SELECT m29_exchange_code_m01
                                  FROM dfn_ntp.m29_markets
                                 WHERE     m29_primary_institution_id_m02 =
                                               l_primary_institute_id
                                       AND m29_is_default = 0
                              GROUP BY m29_exchange_code_m01
                                HAVING COUNT (*) = 1))) m29_default
            ON (m29.m29_id = m29_default.m29_id)
    WHEN MATCHED
    THEN
        UPDATE SET m29.m29_is_default = 1;

    -- Temporary Solution for Getting Default Market for 'TDWL' Exchange

    UPDATE dfn_ntp.m29_markets m29
       SET m29_is_default = 1
     WHERE     m29.m29_primary_institution_id_m02 = l_primary_institute_id
           AND m29.m29_exchange_code_m01 = 'TDWL'
           AND m29_market_code = 'SAEQ';
END;
/