DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_m54_id                 NUMBER (5) := 1;
    l_m32_id                 NUMBER (5) := 1;
    l_m59_id                 NUMBER (5) := 1;
    l_m30_id                 NUMBER (5) := 1;
    l_m29_id                 NUMBER (5)
        := dfn_ntp.fn_get_next_sequnce (pseq_name => 'M29_MARKETS');
    l_current_m29_id         NUMBER (5);
    l_main_m29_id            NUMBER;
    l_sadf_m29_id            NUMBER;
    l_rec_count              NUMBER (5) := 0;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    DELETE FROM dfn_ntp.m54_boards
          WHERE m54_exchange_code_m01 = 'TDWL';

    DELETE FROM dfn_ntp.m32_ex_board_status_tif
          WHERE m32_exchange_code_m01 = 'TDWL';

    DELETE FROM dfn_ntp.m59_exchange_board_status
          WHERE m59_exchange_code_m01 = 'TDWL';

    DELETE FROM dfn_ntp.m30_ex_board_permissions
          WHERE m30_exchange_code_m01 = 'TDWL';

    SELECT NVL (MAX (m54_id), 0) + 1 INTO l_m54_id FROM dfn_ntp.m54_boards;

    SELECT NVL (MAX (m32_id), 0) + 1
      INTO l_m32_id
      FROM dfn_ntp.m32_ex_board_status_tif;

    SELECT NVL (MAX (m59_id), 0) + 1
      INTO l_m59_id
      FROM dfn_ntp.m59_exchange_board_status;

    SELECT NVL (MAX (m30_id), 0) + 1
      INTO l_m30_id
      FROM dfn_ntp.m30_ex_board_permissions;

    UPDATE dfn_ntp.m29_markets
       SET m29_price_market_code = NULL
     WHERE     m29_exchange_code_m01 = 'TDWL'
           AND m29_price_market_code IN ('1')
           AND m29_market_code NOT IN ('MAIN');

    UPDATE dfn_ntp.m29_markets
       SET m29_price_market_code = NULL
     WHERE     m29_exchange_code_m01 = 'TDWL'
           AND m29_price_market_code IN ('2')
           AND m29_market_code NOT IN ('NOMU');

    FOR i
        IN (SELECT m01_id, m01_institute_id_m02
              FROM dfn_ntp.m01_exchanges m01
             WHERE     m01_exchange_code = 'TDWL'
                   AND m01.m01_institute_id_m02 = l_primary_institute_id)
    LOOP
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
             VALUES (l_m54_id,
                     'TDWL',
                     i.m01_id,
                     'SAEQ',
                     3,
                     NULL,
                     1,
                     1,
                     1,
                     NULL,
                     NULL,
                     2,
                     0,
                     SYSDATE,
                     0,
                     SYSDATE,
                     NULL,
                     NULL,
                     '1',
                     l_primary_institute_id,
                     NULL,
                     1,
                     'NONE',
                     NULL,
                     NULL,
                     SYSDATE - 1,
                     SYSDATE - 1);

        l_m54_id := l_m54_id + 1;

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
             VALUES (l_m54_id,
                     'TDWL',
                     i.m01_id,
                     'SAEQ_U',
                     3,
                     NULL,
                     1,
                     1,
                     1,
                     NULL,
                     NULL,
                     2,
                     0,
                     SYSDATE,
                     0,
                     SYSDATE,
                     NULL,
                     NULL,
                     '1',
                     l_primary_institute_id,
                     NULL,
                     1,
                     'NONE',
                     NULL,
                     NULL,
                     SYSDATE - 1,
                     SYSDATE - 1);

        l_m54_id := l_m54_id + 1;

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
             VALUES (l_m54_id,
                     'TDWL',
                     i.m01_id,
                     'SAOE',
                     3,
                     NULL,
                     0,
                     1,
                     0,
                     NULL,
                     NULL,
                     2,
                     0,
                     SYSDATE,
                     0,
                     SYSDATE,
                     NULL,
                     NULL,
                     '1',
                     l_primary_institute_id,
                     NULL,
                     2,
                     'NONE',
                     NULL,
                     NULL,
                     SYSDATE - 1,
                     SYSDATE - 1);

        l_m54_id := l_m54_id + 1;

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
             VALUES (l_m54_id,
                     'TDWL',
                     i.m01_id,
                     'SABE',
                     3,
                     NULL,
                     0,
                     1,
                     1,
                     NULL,
                     NULL,
                     2,
                     0,
                     SYSDATE,
                     0,
                     SYSDATE,
                     NULL,
                     NULL,
                     '1',
                     l_primary_institute_id,
                     NULL,
                     1,
                     'NONE',
                     NULL,
                     NULL,
                     SYSDATE - 1,
                     SYSDATE - 1);

        l_m54_id := l_m54_id + 1;

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
             VALUES (l_m54_id,
                     'TDWL',
                     i.m01_id,
                     'SAFI',
                     3,
                     NULL,
                     0,
                     1,
                     1,
                     NULL,
                     NULL,
                     2,
                     0,
                     SYSDATE,
                     0,
                     SYSDATE,
                     NULL,
                     NULL,
                     '1',
                     l_primary_institute_id,
                     NULL,
                     1,
                     'NONE',
                     NULL,
                     NULL,
                     SYSDATE - 1,
                     SYSDATE - 1);

        l_m54_id := l_m54_id + 1;

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
             VALUES (l_m54_id,
                     'TDWL',
                     i.m01_id,
                     'SAOD',
                     3,
                     NULL,
                     0,
                     1,
                     0,
                     NULL,
                     NULL,
                     2,
                     0,
                     SYSDATE,
                     0,
                     SYSDATE,
                     NULL,
                     NULL,
                     '1',
                     l_primary_institute_id,
                     NULL,
                     2,
                     'NONE',
                     NULL,
                     NULL,
                     SYSDATE - 1,
                     SYSDATE - 1);

        l_m54_id := l_m54_id + 1;

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
             VALUES (l_m54_id,
                     'TDWL',
                     i.m01_id,
                     'SABD',
                     3,
                     NULL,
                     0,
                     1,
                     1,
                     NULL,
                     NULL,
                     2,
                     0,
                     SYSDATE,
                     0,
                     SYSDATE,
                     NULL,
                     NULL,
                     '1',
                     l_primary_institute_id,
                     NULL,
                     1,
                     'NONE',
                     NULL,
                     NULL,
                     SYSDATE - 1,
                     SYSDATE - 1);

        l_m54_id := l_m54_id + 1;

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
        VALUES (l_m32_id,
                0,
                2,
                1,
                'SAEQ',
                2,
                'TDWL',
                i.m01_id,
                NULL,
                '1');

        l_m32_id := l_m32_id + 1;

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
        VALUES (l_m32_id,
                0,
                2,
                1,
                'SAEQ',
                3,
                'TDWL',
                i.m01_id,
                NULL,
                '1');

        l_m32_id := l_m32_id + 1;

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
        VALUES (l_m32_id,
                0,
                2,
                1,
                'SAEQ',
                4,
                'TDWL',
                i.m01_id,
                NULL,
                '1');

        l_m32_id := l_m32_id + 1;

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
        VALUES (l_m32_id,
                0,
                2,
                1,
                'SAEQ',
                5,
                'TDWL',
                i.m01_id,
                NULL,
                '1');

        l_m32_id := l_m32_id + 1;

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
        VALUES (l_m32_id,
                0,
                2,
                2,
                'SAEQ',
                2,
                'TDWL',
                i.m01_id,
                NULL,
                '1');

        l_m32_id := l_m32_id + 1;

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
        VALUES (l_m32_id,
                0,
                2,
                2,
                'SAEQ',
                3,
                'TDWL',
                i.m01_id,
                NULL,
                '1');

        l_m32_id := l_m32_id + 1;

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
        VALUES (l_m32_id,
                0,
                2,
                2,
                'SAEQ',
                4,
                'TDWL',
                i.m01_id,
                NULL,
                '1');

        l_m32_id := l_m32_id + 1;

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
        VALUES (l_m32_id,
                0,
                2,
                2,
                'SAEQ',
                5,
                'TDWL',
                i.m01_id,
                NULL,
                '1');

        l_m32_id := l_m32_id + 1;

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
        VALUES (l_m32_id,
                6,
                2,
                1,
                'SAEQ',
                2,
                'TDWL',
                i.m01_id,
                NULL,
                '1');

        l_m32_id := l_m32_id + 1;

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
        VALUES (l_m32_id,
                6,
                2,
                1,
                'SAEQ',
                3,
                'TDWL',
                i.m01_id,
                NULL,
                '1');

        l_m32_id := l_m32_id + 1;

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
        VALUES (l_m32_id,
                6,
                2,
                1,
                'SAEQ',
                4,
                'TDWL',
                i.m01_id,
                NULL,
                '1');

        l_m32_id := l_m32_id + 1;

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
        VALUES (l_m32_id,
                6,
                2,
                1,
                'SAEQ',
                5,
                'TDWL',
                i.m01_id,
                NULL,
                '1');

        l_m32_id := l_m32_id + 1;

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
        VALUES (l_m32_id,
                6,
                2,
                2,
                'SAEQ',
                2,
                'TDWL',
                i.m01_id,
                NULL,
                '1');

        l_m32_id := l_m32_id + 1;

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
        VALUES (l_m32_id,
                6,
                2,
                2,
                'SAEQ',
                3,
                'TDWL',
                i.m01_id,
                NULL,
                '1');

        l_m32_id := l_m32_id + 1;

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
        VALUES (l_m32_id,
                6,
                2,
                2,
                'SAEQ',
                4,
                'TDWL',
                i.m01_id,
                NULL,
                '1');

        l_m32_id := l_m32_id + 1;

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
        VALUES (l_m32_id,
                6,
                2,
                2,
                'SAEQ',
                5,
                'TDWL',
                i.m01_id,
                NULL,
                '1');

        l_m32_id := l_m32_id + 1;


        INSERT
          INTO dfn_ntp.m59_exchange_board_status (m59_id,
                                                  m59_exchange_id_m01,
                                                  m59_exchange_code_m01,
                                                  m59_board_status_id_v19,
                                                  m59_custom_type)
        VALUES (l_m59_id,
                i.m01_id,
                'TDWL',
                2,
                '1');

        l_m59_id := l_m59_id + 1;

        INSERT
          INTO dfn_ntp.m59_exchange_board_status (m59_id,
                                                  m59_exchange_id_m01,
                                                  m59_exchange_code_m01,
                                                  m59_board_status_id_v19,
                                                  m59_custom_type)
        VALUES (l_m59_id,
                i.m01_id,
                'TDWL',
                3,
                '1');

        l_m59_id := l_m59_id + 1;

        INSERT
          INTO dfn_ntp.m59_exchange_board_status (m59_id,
                                                  m59_exchange_id_m01,
                                                  m59_exchange_code_m01,
                                                  m59_board_status_id_v19,
                                                  m59_custom_type)
        VALUES (l_m59_id,
                i.m01_id,
                'TDWL',
                4,
                '1');

        l_m59_id := l_m59_id + 1;

        INSERT
          INTO dfn_ntp.m59_exchange_board_status (m59_id,
                                                  m59_exchange_id_m01,
                                                  m59_exchange_code_m01,
                                                  m59_board_status_id_v19,
                                                  m59_custom_type)
        VALUES (l_m59_id,
                i.m01_id,
                'TDWL',
                5,
                '1');

        l_m59_id := l_m59_id + 1;


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
        VALUES (l_m30_id,
                'SAEQ',
                2,
                'TDWL',
                i.m01_id,
                1,
                1,
                1,
                1,
                '1');

        l_m30_id := l_m30_id + 1;

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
        VALUES (l_m30_id,
                'SAEQ',
                3,
                'TDWL',
                i.m01_id,
                1,
                1,
                0,
                2,
                '1');

        l_m30_id := l_m30_id + 1;

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
        VALUES (l_m30_id,
                'SAEQ',
                4,
                'TDWL',
                i.m01_id,
                1,
                1,
                1,
                3,
                '1');

        l_m30_id := l_m30_id + 1;

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
        VALUES (l_m30_id,
                'SAEQ',
                5,
                'TDWL',
                i.m01_id,
                1,
                1,
                1,
                4,
                '1');

        l_m30_id := l_m30_id + 1;

        SELECT COUNT (*)
          INTO l_rec_count
          FROM dfn_ntp.m29_markets
         WHERE     m29_market_code = 'MAIN'
               AND m29_exchange_id_m01 = i.m01_id
               AND m29_primary_institution_id_m02 = l_primary_institute_id;

        IF l_rec_count = 0
        THEN
            INSERT INTO dfn_ntp.m29_markets (m29_exchange_code_m01,
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
                 VALUES ('TDWL',
                         3,
                         'MAIN',
                         NULL,
                         0,
                         1,
                         2,
                         l_m29_id,
                         i.m01_id,
                         NULL,
                         NULL,
                         NULL,
                         NULL,
                         NULL,
                         0,
                         SYSDATE,
                         NULL,
                         NULL,
                         'NONE',
                         0,
                         '1',
                         l_primary_institute_id,
                         '1');

            UPDATE dfn_ntp.m20_symbol
               SET m20_market_code_m29 = 'MAIN', m20_market_id_m29 = l_m29_id
             WHERE     m20_exchange_code_m01 = 'TDWL'
                   AND m20_exchange_id_m01 = i.m01_id
                   AND m20_institute_id_m02 = i.m01_institute_id_m02
                   AND m20_market_segment != 2;

            UPDATE dfn_ntp.m31_exec_broker_routing
               SET m31_market_code = 'MAIN', m31_market_id_m29 = l_m29_id
             WHERE     m31_exchange_code_m01 = 'TDWL'
                   AND m31_exchange_id_m01 = i.m01_id;

            -- Update with TDWL Trader ID for Dealer Exchanges for MAIN Market

            FOR j
                IN (SELECT u28.u28_id, m06.m06_tdwl_trader_id
                      FROM dfn_ntp.u28_employee_exchanges u28,
                           u17_employee_mappings u17_map,
                           mubasher_oms.m06_employees@mubasher_db_link m06
                     WHERE     u28.u28_employee_id_u17 =
                                   u17_map.new_employee_id
                           AND u17_map.old_employee_id = m06.m06_id
                           AND u28.u28_exchange_code_m01 = 'TDWL'
                           AND u28.u28_exchange_id_m01 = i.m01_id)
            LOOP
                UPDATE dfn_ntp.u28_employee_exchanges
                   SET u28_market_id_m29 = l_m29_id,
                       u28_dealer_exchange_code = j.m06_tdwl_trader_id
                 WHERE u28_id = j.u28_id;
            END LOOP;

            l_main_m29_id := l_m29_id;
            l_m29_id := l_m29_id + 1;
        ELSE
            SELECT m29_id
              INTO l_current_m29_id
              FROM dfn_ntp.m29_markets
             WHERE     m29_market_code = 'MAIN'
                   AND m29_exchange_id_m01 = i.m01_id
                   AND m29_primary_institution_id_m02 =
                           l_primary_institute_id;

            l_main_m29_id := l_current_m29_id;

            UPDATE dfn_ntp.m20_symbol
               SET m20_market_code_m29 = 'MAIN',
                   m20_market_id_m29 = l_current_m29_id
             WHERE     m20_exchange_code_m01 = 'TDWL'
                   AND m20_exchange_id_m01 = i.m01_id
                   AND m20_institute_id_m02 = i.m01_institute_id_m02
                   AND m20_market_segment != 2;

            UPDATE dfn_ntp.m31_exec_broker_routing
               SET m31_market_code = 'MAIN',
                   m31_market_id_m29 = l_current_m29_id
             WHERE     m31_exchange_code_m01 = 'TDWL'
                   AND m31_exchange_id_m01 = i.m01_id;

            -- Update with TDWL Trader ID for Dealer Exchanges for MAIN Market

            FOR j
                IN (SELECT u28.u28_id, m06.m06_tdwl_trader_id
                      FROM dfn_ntp.u28_employee_exchanges u28,
                           u17_employee_mappings u17_map,
                           mubasher_oms.m06_employees@mubasher_db_link m06
                     WHERE     u28.u28_employee_id_u17 =
                                   u17_map.new_employee_id
                           AND u17_map.old_employee_id = m06.m06_id
                           AND u28.u28_exchange_code_m01 = 'TDWL'
                           AND u28.u28_exchange_id_m01 = i.m01_id
                           AND u28.u28_market_id_m29 = l_current_m29_id)
            LOOP
                UPDATE dfn_ntp.u28_employee_exchanges
                   SET u28_dealer_exchange_code = j.m06_tdwl_trader_id
                 WHERE u28_id = j.u28_id;
            END LOOP;
        END IF;

        SELECT COUNT (*)
          INTO l_rec_count
          FROM dfn_ntp.m29_markets
         WHERE     m29_market_code = 'NOMU'
               AND m29_exchange_id_m01 = i.m01_id
               AND m29_primary_institution_id_m02 = l_primary_institute_id;

        IF l_rec_count = 0
        THEN
            INSERT INTO dfn_ntp.m29_markets (m29_exchange_code_m01,
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
                 VALUES ('TDWL',
                         3,
                         'NOMU',
                         NULL,
                         0,
                         1,
                         2,
                         l_m29_id,
                         i.m01_id,
                         NULL,
                         NULL,
                         NULL,
                         NULL,
                         NULL,
                         0,
                         SYSDATE,
                         NULL,
                         NULL,
                         'NONE',
                         0,
                         '1',
                         l_primary_institute_id,
                         '2');

            UPDATE dfn_ntp.m20_symbol
               SET m20_market_code_m29 = 'NOMU', m20_market_id_m29 = l_m29_id
             WHERE     m20_exchange_code_m01 = 'TDWL'
                   AND m20_exchange_id_m01 = i.m01_id
                   AND m20_institute_id_m02 = i.m01_institute_id_m02
                   AND m20_market_segment = 2;

            -- Copy of TDWL MAIN Market Dealer Exchanges Added Under NOMU Market with TDWL Trader ID

            FOR j
                IN (SELECT u28.u28_id,
                           u28.u28_employee_id_u17,
                           m06.m06_tdwl_trader_id
                      FROM dfn_ntp.u28_employee_exchanges u28,
                           u17_employee_mappings u17_map,
                           mubasher_oms.m06_employees@mubasher_db_link m06
                     WHERE     u28.u28_employee_id_u17 =
                                   u17_map.new_employee_id
                           AND u17_map.old_employee_id = m06.m06_id
                           AND u28.u28_exchange_code_m01 = 'TDWL'
                           AND u28.u28_exchange_id_m01 = i.m01_id
                           AND u28.u28_market_id_m29 = l_main_m29_id -- Copy of Main Market
                                                                    )
            LOOP
                INSERT
                  INTO dfn_ntp.u28_employee_exchanges (
                           u28_id,
                           u28_exchange_code_m01,
                           u28_employee_id_u17,
                           u28_created_by_id_u17,
                           u28_created_date,
                           u28_modified_by_id_u17,
                           u28_modified_date,
                           u28_status_id_v01,
                           u28_status_changed_by_id_u17,
                           u28_status_changed_date,
                           u28_dealer_exchange_code,
                           u28_price_subscribed,
                           u28_custom_type,
                           u28_exchange_id_m01,
                           u28_market_id_m29)
                VALUES (
                           dfn_ntp.fn_get_next_sequnce (
                               pseq_name => 'U28_EMPLOYEE_EXCHANGES'),
                           'TDWL',
                           j.u28_employee_id_u17,
                           0,
                           SYSDATE,
                           NULL,
                           NULL,
                           2,
                           0,
                           SYSDATE,
                           j.m06_tdwl_trader_id,
                           1,
                           '1',
                           i.m01_id,
                           l_m29_id);
            END LOOP;

            l_m29_id := l_m29_id + 1;
        ELSE
            SELECT m29_id
              INTO l_current_m29_id
              FROM dfn_ntp.m29_markets
             WHERE     m29_market_code = 'NOMU'
                   AND m29_exchange_id_m01 = i.m01_id
                   AND m29_primary_institution_id_m02 =
                           l_primary_institute_id;

            UPDATE dfn_ntp.m20_symbol
               SET m20_market_code_m29 = 'NOMU',
                   m20_market_id_m29 = l_current_m29_id
             WHERE     m20_exchange_code_m01 = 'TDWL'
                   AND m20_exchange_id_m01 = i.m01_id
                   AND m20_institute_id_m02 = i.m01_institute_id_m02
                   AND m20_market_segment = 2;

            -- Update with TDWL Trader ID for Dealer Exchanges Under NOMU Market

            FOR j
                IN (SELECT u28.u28_id, m06.m06_tdwl_trader_id
                      FROM dfn_ntp.u28_employee_exchanges u28,
                           u17_employee_mappings u17_map,
                           mubasher_oms.m06_employees@mubasher_db_link m06
                     WHERE     u28.u28_employee_id_u17 =
                                   u17_map.new_employee_id
                           AND u17_map.old_employee_id = m06.m06_id
                           AND u28.u28_exchange_code_m01 = 'TDWL'
                           AND u28.u28_exchange_id_m01 = i.m01_id
                           AND u28.u28_market_id_m29 = l_current_m29_id)
            LOOP
                UPDATE dfn_ntp.u28_employee_exchanges
                   SET u28_dealer_exchange_code = j.m06_tdwl_trader_id
                 WHERE u28_id = j.u28_id;
            END LOOP;
        END IF;

        SELECT COUNT (*)
          INTO l_rec_count
          FROM dfn_ntp.m29_markets
         WHERE     m29_market_code = 'SADF'
               AND m29_exchange_id_m01 = i.m01_id
               AND m29_primary_institution_id_m02 = l_primary_institute_id;

        IF l_rec_count = 0
        THEN
            INSERT INTO dfn_ntp.m29_markets (m29_exchange_code_m01,
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
                 VALUES ('TDWL',
                         3,
                         'SADF',
                         NULL,
                         0,
                         1,
                         2,
                         l_m29_id,
                         i.m01_id,
                         NULL,
                         NULL,
                         NULL,
                         NULL,
                         NULL,
                         0,
                         SYSDATE,
                         NULL,
                         NULL,
                         'NONE',
                         0,
                         '1',
                         l_primary_institute_id,
                         '2');

            l_sadf_m29_id := l_m29_id;
        ELSE
            SELECT m29_id
              INTO l_current_m29_id
              FROM dfn_ntp.m29_markets
             WHERE     m29_market_code = 'SADF'
                   AND m29_exchange_id_m01 = i.m01_id
                   AND m29_primary_institution_id_m02 =
                           l_primary_institute_id;

            l_sadf_m29_id := l_current_m29_id;
        END IF;

        -- SADF Market May Exist. Creating Dealer Exchanges (Copy of MAIN Market) for Derivative Trader ID.

        SELECT COUNT (*)
          INTO l_rec_count
          FROM dfn_ntp.u28_employee_exchanges u28,
               u17_employee_mappings u17_map,
               mubasher_oms.m06_employees@mubasher_db_link m06
         WHERE     u28.u28_employee_id_u17 = u17_map.new_employee_id
               AND u17_map.old_employee_id = m06.m06_id
               AND u28.u28_exchange_code_m01 = 'TDWL'
               AND u28.u28_exchange_id_m01 = i.m01_id
               AND u28.u28_market_id_m29 = l_sadf_m29_id;

        IF l_rec_count = 0
        THEN
            FOR j
                IN (SELECT u28.u28_id,
                           u28.u28_employee_id_u17,
                           m06.m06_tdwl_derivative_trader_id
                      FROM dfn_ntp.u28_employee_exchanges u28,
                           u17_employee_mappings u17_map,
                           mubasher_oms.m06_employees@mubasher_db_link m06
                     WHERE     u28.u28_employee_id_u17 =
                                   u17_map.new_employee_id
                           AND u17_map.old_employee_id = m06.m06_id
                           AND u28.u28_exchange_code_m01 = 'TDWL'
                           AND u28.u28_exchange_id_m01 = i.m01_id
                           AND u28.u28_market_id_m29 = l_main_m29_id -- Copy of Main Market
                                                                    )
            LOOP
                INSERT
                  INTO dfn_ntp.u28_employee_exchanges (
                           u28_id,
                           u28_exchange_code_m01,
                           u28_employee_id_u17,
                           u28_created_by_id_u17,
                           u28_created_date,
                           u28_modified_by_id_u17,
                           u28_modified_date,
                           u28_status_id_v01,
                           u28_status_changed_by_id_u17,
                           u28_status_changed_date,
                           u28_dealer_exchange_code,
                           u28_price_subscribed,
                           u28_custom_type,
                           u28_exchange_id_m01,
                           u28_market_id_m29)
                VALUES (
                           dfn_ntp.fn_get_next_sequnce (
                               pseq_name => 'U28_EMPLOYEE_EXCHANGES'),
                           'TDWL',
                           j.u28_employee_id_u17,
                           0,
                           SYSDATE,
                           NULL,
                           NULL,
                           2,
                           0,
                           SYSDATE,
                           j.m06_tdwl_derivative_trader_id,
                           1,
                           '1',
                           i.m01_id,
                           l_sadf_m29_id);
            END LOOP;
        ELSE
            FOR j
                IN (SELECT u28.u28_id, m06.m06_tdwl_derivative_trader_id
                      FROM dfn_ntp.u28_employee_exchanges u28,
                           u17_employee_mappings u17_map,
                           mubasher_oms.m06_employees@mubasher_db_link m06
                     WHERE     u28.u28_employee_id_u17 =
                                   u17_map.new_employee_id
                           AND u17_map.old_employee_id = m06.m06_id
                           AND u28.u28_exchange_code_m01 = 'TDWL'
                           AND u28.u28_exchange_id_m01 = i.m01_id
                           AND u28.u28_market_id_m29 = l_sadf_m29_id)
            LOOP
                UPDATE dfn_ntp.u28_employee_exchanges
                   SET u28_dealer_exchange_code =
                           j.m06_tdwl_derivative_trader_id
                 WHERE u28_id = j.u28_id;
            END LOOP;
        END IF;

        COMMIT;
    END LOOP;

    UPDATE dfn_ntp.m30_ex_market_permissions
       SET m30_market_code_m29 = 'MAIN'
     WHERE m30_exchange_code_m01 = 'TDWL';

    COMMIT;

    UPDATE dfn_ntp.m32_ex_market_status_tif
       SET m32_market_code_m29 = 'MAIN'
     WHERE m32_exchange_code_m01 = 'TDWL';

    COMMIT;

    UPDATE dfn_ntp.t01_order
       SET t01_market_code_m29 = 'MAIN'
     WHERE t01_exchange_code_m01 = 'TDWL';

    COMMIT;

    UPDATE dfn_ntp.t09_txn_single_entry_v3
       SET t09_market_code_m29 = 'MAIN'
     WHERE t09_exchange_m01 = 'TDWL';

    COMMIT;

    UPDATE dfn_ntp.t52_desk_orders
       SET t52_market_code_m29 = 'MAIN'
     WHERE t52_exchange_code_m01 = 'TDWL';

    COMMIT;

    UPDATE dfn_ntp.m20_symbol
       SET m20_trade_type_v01 = 1;

    COMMIT;

    DELETE FROM dfn_ntp.m29_markets
          WHERE     m29_exchange_code_m01 = 'TDWL'
                AND m29_market_code NOT IN ('MAIN', 'NOMU', 'SADF');

    COMMIT;
END;
/

COMMIT;