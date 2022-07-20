CREATE OR REPLACE PROCEDURE dfn_ntp.sp_change_account_request (
    p_key                               OUT VARCHAR,
    p_t502_from_trading_acc_id_u07   IN     NUMBER,
    p_t502_from_cash_acc_id_u06      IN     NUMBER,
    p_t502_target_cash_acc_id_u06    IN     NUMBER,
    p_t502_status_id_v01             IN     NUMBER,
    p_t502_institute_id_m02          IN     NUMBER,
    p_t502_entered_by_id_u17         IN     NUMBER,
    p_t502_entered_date              IN     DATE,
    p_t502_last_changed_by_id_u17    IN     NUMBER,
    p_t502_last_changed_date         IN     DATE,
    p_t502_current_approval_level    IN     NUMBER DEFAULT 0)
IS
    l_count                        NUMBER;
    l_m29_current_mkt_status       NUMBER;
    l_blob_id                      NUMBER;
    l_u07_exchange_code_m01        VARCHAR2 (20);
    l_u06_currency_code_m03_from   VARCHAR2 (20);
    l_u06_currency_code_m03_to     VARCHAR2 (20);
    l_u06_margin_enabled           NUMBER;
    l_has_open_orders              NUMBER;
    l_has_blocking                 NUMBER;
    l_existing_pending             NUMBER;
    l_holdings_count               NUMBER;
BEGIN
    BEGIN
        SELECT COUNT (*)
          INTO l_count
          FROM u07_trading_account u07
         WHERE u07.u07_cash_account_id_u06 = p_t502_target_cash_acc_id_u06;

        IF l_count > 0
        THEN
            p_key := -2;
            RETURN;
        ELSIF l_count = 0
        THEN
            SELECT u07.u07_exchange_code_m01
              INTO l_u07_exchange_code_m01
              FROM u07_trading_account u07
             WHERE u07.u07_id = p_t502_from_trading_acc_id_u07 AND ROWNUM = 1;

            SELECT m29_current_mkt_status_id_v19
              INTO l_m29_current_mkt_status
              FROM m29_markets
             WHERE     m29_exchange_code_m01 = l_u07_exchange_code_m01
                   AND m29_market_code = 'ALL'
                   AND m29_primary_institution_id_m02 =
                           p_t502_institute_id_m02;

            IF l_m29_current_mkt_status NOT IN (0, 3)
            THEN
                p_key := -3;
                RETURN;
            END IF;


            SELECT COUNT (*)
              INTO l_existing_pending
              FROM t502_change_account_requests_c a
             WHERE     a.t502_from_trading_acc_id_u07 =
                           p_t502_from_trading_acc_id_u07
                   AND a.t502_status_id_v01 IN (101, 1, 0);

            IF l_existing_pending > 0
            THEN
                p_key := -4;
                RETURN;
            END IF;


            SELECT u06.u06_margin_enabled, u06.u06_currency_code_m03
              INTO l_u06_margin_enabled, l_u06_currency_code_m03_from
              FROM u06_cash_account u06
             WHERE u06.u06_id = p_t502_from_cash_acc_id_u06;

            IF l_u06_margin_enabled = 1
            THEN
                p_key := -5;
                RETURN;
            END IF;

            SELECT COUNT (*)
              INTO l_has_open_orders
              FROM t01_order t01
             WHERE     t01.t01_status_id_v30 IN
                           ('1',
                            '5',
                            'M',
                            'T',
                            'O',
                            '0',
                            'r',
                            'P',
                            'Q',
                            'E',
                            '6')
                   AND t01.t01_trading_acc_id_u07 =
                           p_t502_from_trading_acc_id_u07;

            IF l_has_open_orders > 0
            THEN
                p_key := -6;
                RETURN;
            END IF;

            SELECT COUNT (*)
              INTO l_has_blocking
              FROM u24_holdings u24
             WHERE     u24.u24_trading_acnt_id_u07 =
                           p_t502_from_trading_acc_id_u07
                   AND (   u24.u24_holding_block > 0
                        OR u24.u24_pledge_qty > 0
                        OR u24.u24_manual_block > 0);

            IF l_has_blocking = 0
            THEN
                --check pending transfer
                SELECT COUNT (*)
                  INTO l_has_blocking
                  FROM t12_share_transaction
                 WHERE     t12_trading_acc_id_u07 =
                               p_t502_from_trading_acc_id_u07
                       AND t12_status_id_v01 IN (1, 101);

                IF l_has_blocking > 0
                THEN
                    p_key := -7;
                    RETURN;
                END IF;
            ELSE
                p_key := -7;
                RETURN;
            END IF;

            SELECT u06.u06_currency_code_m03
              INTO l_u06_currency_code_m03_to
              FROM u06_cash_account u06
             WHERE u06.u06_id = p_t502_target_cash_acc_id_u06;

            IF l_u06_currency_code_m03_to <> l_u06_currency_code_m03_from
            THEN
                p_key := -8;
                RETURN;
            END IF;

            SELECT COUNT (*)
              INTO l_holdings_count
              FROM u24_holdings u24
             WHERE u24.u24_trading_acnt_id_u07 =
                       p_t502_from_trading_acc_id_u07;

            IF l_holdings_count = 0
            THEN
                p_key := -9;
                RETURN;
            END IF;
        END IF;

        SELECT a.app_seq_value + 1
          INTO p_key
          FROM app_seq_store a
         WHERE app_seq_name = 'T502_CHANGE_ACCOUNT_REQUESTS_C';

        UPDATE app_seq_store a
           SET app_seq_value = app_seq_value + 1
         WHERE app_seq_name = 'T502_CHANGE_ACCOUNT_REQUESTS_C';


        INSERT
          INTO dfn_ntp.t502_change_account_requests_c (
                   t502_id,
                   t502_from_trading_acc_id_u07,
                   t502_from_cash_acc_id_u06,
                   t502_target_cash_acc_id_u06,
                   t502_status_id_v01,
                   t502_institute_id_m02,
                   t502_entered_by_id_u17,
                   t502_entered_date,
                   t502_last_changed_by_id_u17,
                   t502_last_changed_date,
                   t502_current_approval_level,
                   t502_custom_type)
        VALUES (p_key,
                       p_t502_from_trading_acc_id_u07,
                       p_t502_from_cash_acc_id_u06,
                       p_t502_target_cash_acc_id_u06,
                       p_t502_status_id_v01,
                       p_t502_institute_id_m02,
                       p_t502_entered_by_id_u17,
                       p_t502_entered_date,
                       p_t502_last_changed_by_id_u17,
                       p_t502_last_changed_date,
                       p_t502_current_approval_level,
                       1);
    EXCEPTION
        WHEN OTHERS
        THEN
            p_key := -1;
    END;
END;
/