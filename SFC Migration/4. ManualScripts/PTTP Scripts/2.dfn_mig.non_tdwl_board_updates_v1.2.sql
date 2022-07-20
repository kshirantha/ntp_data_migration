DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_pkey                   NUMBER (10) := 0;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (m54_id), 0) INTO l_pkey FROM dfn_ntp.m54_boards;

    FOR i IN (SELECT m29_exchange_code_m01,
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
                     m29_price_market_code
                FROM dfn_ntp.m29_markets
               WHERE m29_exchange_code_m01 <> 'TDWL')
    LOOP
        l_pkey := l_pkey + 1;

        INSERT INTO dfn_ntp.m54_boards (m54_id,
                                        m54_exchange_code_m01,
                                        m54_exchange_id_m01,
                                        m54_code,
                                        m54_exg_brd_status_id_v19,
                                        m54_exg_brd_sts_updated_date,
                                        m54_is_default,
                                        m54_is_active,
                                        m54_preopen_allowed,
                                        m54_last_preopened_date,
                                        m54_last_eod_date,
                                        m54_status_id_v01,
                                        m54_status_changed_by_id_u17,
                                        m54_status_changed_date,
                                        m54_created_by_id_u17,
                                        m54_created_date,
                                        m54_modified_by_id_u17,
                                        m54_modified_date,
                                        m54_custom_type,
                                        m54_primary_institution_id_m02,
                                        m54_price_brd_code,
                                        m54_trade_type_v01,
                                        m54_is_active_process,
                                        m54_manual_suspend,
                                        m54_price_fluctuation,
                                        m54_last_symbol_status_req_dat,
                                        m54_last_market_status_req_dat)
             VALUES (l_pkey, -- m54_id
                     i.m29_exchange_code_m01, -- m54_exchange_code_m01
                     i.m29_exchange_id_m01, -- m54_exchange_id_m01
                     i.m29_market_code, -- m54_code
                     i.m29_current_mkt_status_id_v19, -- m54_exg_brd_status_id_v19
                     NULL, -- m54_exg_brd_sts_updated_date
                     0, -- m54_is_default
                     1, -- m54_is_active
                     1, -- m54_preopen_allowed
                     NULL, -- m54_last_preopened_date
                     NULL, -- m54_last_eod_date
                     2, -- m54_status_id_v01
                     0, -- m54_status_changed_by_id_u17
                     SYSDATE, -- m54_status_changed_date
                     0, -- m54_created_by_id_u17
                     SYSDATE, -- m54_created_date
                     NULL, -- m54_modified_by_id_u17
                     NULL, -- m54_modified_date
                     '1', -- m54_custom_type
                     l_primary_institute_id, -- m54_primary_institution_id_m02
                     NULL, -- m54_price_brd_code
                     1, -- m54_trade_type_v01
                     'NONE', -- m54_is_active_process
                     NULL, -- m54_manual_suspend
                     NULL, -- m54_price_fluctuation
                     SYSDATE - 1, -- m54_last_symbol_status_req_dat
                     SYSDATE - 1 -- m54_last_market_status_req_dat
                                );
    END LOOP;
END;
/

COMMIT;

DECLARE
    l_pkey   NUMBER (10) := 0;
BEGIN
    SELECT NVL (MAX (m59_id), 0)
      INTO l_pkey
      FROM dfn_ntp.m59_exchange_board_status;

    FOR i IN (SELECT m59_id,
                     m59_exchange_id_m01,
                     m59_market_status_id_v19,
                     m59_exchange_code_m01,
                     m59_custom_type
                FROM dfn_ntp.m59_exchange_market_status
               WHERE m59_exchange_code_m01 <> 'TDWL')
    LOOP
        l_pkey := l_pkey + 1;

        INSERT
          INTO dfn_ntp.m59_exchange_board_status (m59_id,
                                                  m59_exchange_id_m01,
                                                  m59_exchange_code_m01,
                                                  m59_board_status_id_v19,
                                                  m59_custom_type)
        VALUES (l_pkey,
                i.m59_exchange_id_m01,
                i.m59_exchange_code_m01,
                i.m59_market_status_id_v19,
                '1');
    END LOOP;
END;
/

COMMIT;

DECLARE
    l_pkey   NUMBER (10) := 0;
BEGIN
    SELECT NVL (MAX (m30_id), 0)
      INTO l_pkey
      FROM dfn_ntp.m30_ex_board_permissions;

    FOR i IN (SELECT m30_market_code_m29,
                     m30_market_status_id_v19,
                     m30_exchange_code_m01,
                     m30_id,
                     m30_cancel_order_allowed,
                     m30_amend_order_allowed,
                     m30_create_order_allowed,
                     m30_exchange_id_m01,
                     m30_exchange_status_id_m59,
                     m30_custom_type
                FROM dfn_ntp.m30_ex_market_permissions
               WHERE m30_exchange_code_m01 <> 'TDWL')
    LOOP
        l_pkey := l_pkey + 1;

        INSERT
          INTO dfn_ntp.m30_ex_board_permissions (m30_id,
                                                 m30_code_m54,
                                                 m30_exg_brd_status_id_v19,
                                                 m30_exchange_code_m01,
                                                 m30_exchange_id_m01,
                                                 m30_cancel_order_allowed,
                                                 m30_amend_order_allowed,
                                                 m30_create_order_allowed,
                                                 m30_exchange_status_id_m59,
                                                 m30_custom_type)
        VALUES (l_pkey,
                i.m30_market_code_m29,
                i.m30_market_status_id_v19,
                i.m30_exchange_code_m01,
                i.m30_exchange_id_m01,
                i.m30_cancel_order_allowed,
                i.m30_amend_order_allowed,
                i.m30_create_order_allowed,
                i.m30_exchange_status_id_m59,
                '1');
    END LOOP;
END;
/

COMMIT;

DECLARE
    l_pkey   NUMBER (10) := 0;
BEGIN
    SELECT NVL (MAX (m32_id), 0)
      INTO l_pkey
      FROM dfn_ntp.m32_ex_board_status_tif;

    FOR i IN (SELECT m32_tif_type_id_v10,
                     m32_status_id_m30,
                     m32_order_type_id_v06,
                     m32_id,
                     m32_market_code_m29,
                     m32_market_status_id_v19,
                     m32_exchange_code_m01,
                     m32_exchange_id_m01,
                     m32_exchange_order_type_id_m57,
                     m32_custom_type
                FROM dfn_ntp.m32_ex_market_status_tif
               WHERE m32_exchange_code_m01 <> 'TDWL')
    LOOP
        l_pkey := l_pkey + 1;

        INSERT
          INTO dfn_ntp.m32_ex_board_status_tif (m32_id,
                                                m32_tif_type_id_v10,
                                                m32_status_id_m30,
                                                m32_order_type_id_v06,
                                                m32_board_code_m54,
                                                m32_brd_status_id_v19,
                                                m32_exchange_code_m01,
                                                m32_exchange_id_m01,
                                                m32_exchange_order_type_id_m57,
                                                m32_custom_type)
        VALUES (l_pkey,
                i.m32_tif_type_id_v10,
                i.m32_status_id_m30,
                i.m32_order_type_id_v06,
                i.m32_market_code_m29,
                i.m32_market_status_id_v19,
                i.m32_exchange_code_m01,
                i.m32_exchange_id_m01,
                i.m32_exchange_order_type_id_m57,
                '1');
    END LOOP;
END;
/

COMMIT;

MERGE INTO dfn_ntp.m125_exchange_instrument_type m125
     USING dfn_ntp.m54_boards m54
        ON (    m125_exchange_code_m01 = m54.m54_exchange_code_m01
            AND m54_exchange_code_m01 <> 'TDWL')
WHEN MATCHED
THEN
    UPDATE SET m125_board_code_m54 = m54_code, m125_board_id_m54 = m54_id;


COMMIT;

MERGE INTO dfn_ntp.m125_exchange_instrument_type m125
     USING dfn_ntp.m54_boards m54
        ON (    m125_exchange_code_m01 = m54.m54_exchange_code_m01
            AND m54_exchange_code_m01 = 'TDWL'
            AND m54_code = 'SAEQ')
WHEN MATCHED
THEN
    UPDATE SET m125_board_code_m54 = m54_code, m125_board_id_m54 = m54_id;


COMMIT;