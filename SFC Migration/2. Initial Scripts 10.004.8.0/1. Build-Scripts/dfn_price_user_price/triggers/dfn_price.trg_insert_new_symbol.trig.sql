CREATE OR REPLACE TRIGGER dfn_price.trg_insert_new_symbol
    AFTER INSERT
    ON dfn_price.esp_symbolmap
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
DECLARE
    l_exchange_id                  NUMBER;
    l_count                        NUMBER;
    l_market_code                  VARCHAR (10);
    l_market_id                    NUMBER;
    l_sector_id                    NUMBER;
    l_currency_id                  NUMBER;
    l_sector_code                  VARCHAR (50);
    l_natinality                   VARCHAR (10);
    l_natinality_id                NUMBER;
    l_is_local                     NUMBER;
    l_instrument_type_id           NUMBER;
    l_instrument_type_code         VARCHAR (10);
    l_price_instrument_type_code   VARCHAR (10);
    l_price_instrument_type_id     NUMBER;
    i_errorcode                    VARCHAR2 (4000);
    i_errormessage                 VARCHAR2 (4000);
BEGIN
    SELECT COUNT (m01_id)
      INTO l_count
      FROM dfn_ntp.m01_exchanges
     WHERE m01_exchange_code IN (:new.exchange);

    IF l_count > 0
    THEN
        FOR i
            IN (SELECT m150_primary_institute_id_m02
                  FROM dfn_ntp.m150_broker
                 WHERE     m150_primary_institute_id_m02 IS NOT NULL
                       AND m150_primary_institute_id_m02 <> 0) -- added bcz of the exceptions for master data not found
        LOOP
            SELECT COUNT (m20_id)
              INTO l_count
              FROM dfn_ntp.m20_symbol
             WHERE        m20_institute_id_m02 =
                              i.m150_primary_institute_id_m02
                      AND (    m20_symbol_code = :new.symbol
                           AND m20_exchange_code_m01 = :new.exchange)
                   OR (    m20_price_symbol_code_m20 = :new.symbol
                       AND m20_price_exchange_code_m01 = :new.exchange);

            IF (    l_count = 0 --Symbol not exsist for current primary institute
                AND :new.currency IS NOT NULL
                AND LENGTH (:new.currency) > 2)
            THEN
                IF (:new.is_active = 1 AND :new.instrumenttype <> 7)
                THEN
                    IF TRIM (:new.market_code) IS NOT NULL
                    THEN
                        SELECT COUNT (m29_market_code)
                          INTO l_count
                          FROM dfn_ntp.m29_markets
                         WHERE     m29_primary_institution_id_m02 =
                                       i.m150_primary_institute_id_m02
                               AND m29_exchange_code_m01 = :new.exchange
                               AND m29_price_market_code = :new.market_code;

                        IF l_count = 1
                        THEN
                            SELECT m29_market_code, m29_id
                              INTO l_market_code, l_market_id
                              FROM dfn_ntp.m29_markets
                             WHERE     m29_primary_institution_id_m02 =
                                           i.m150_primary_institute_id_m02
                                   AND m29_exchange_code_m01 = :new.exchange
                                   AND m29_price_market_code =
                                           :new.market_code;
                        ELSE
                            SELECT MAX (m29_market_code), MAX (m29_id)
                              INTO l_market_code, l_market_id
                              FROM dfn_ntp.m29_markets
                             WHERE     m29_primary_institution_id_m02 =
                                           i.m150_primary_institute_id_m02
                                   AND m29_exchange_code_m01 = :new.exchange
                                   AND m29_is_default = 1;
                        END IF;
                    ELSE
                        SELECT MAX (m29_market_code), MAX (m29_id)
                          INTO l_market_code, l_market_id
                          FROM dfn_ntp.m29_markets
                         WHERE     m29_primary_institution_id_m02 =
                                       i.m150_primary_institute_id_m02
                               AND m29_exchange_code_m01 = :new.exchange
                               AND m29_is_default = 1;
                    END IF;

                    SELECT MAX (m63_id), MAX (m63_sector_code)
                      INTO l_sector_id, l_sector_code
                      FROM dfn_ntp.m63_sectors
                     WHERE     m63_institute_id_m02 =
                                   i.m150_primary_institute_id_m02
                           AND m63_sector_code = :new.sector
                           AND m63_exchange_code_m01 = :new.exchange;

                    SELECT MAX (m01_is_local),
                           MAX (m01_id),
                           MAX (m01_country_id_m05)
                      INTO l_is_local, l_exchange_id, l_natinality_id
                      FROM dfn_ntp.m01_exchanges
                     WHERE     m01_institute_id_m02 =
                                   i.m150_primary_institute_id_m02
                           AND m01_exchange_code = :new.exchange;

                    IF l_exchange_id IS NULL
                    THEN
                        CONTINUE;
                    END IF;

                    SELECT MAX (m03_id)
                      INTO l_currency_id
                      FROM dfn_ntp.m03_currency
                     WHERE m03_code = :new.currency;

                    SELECT COUNT (v34_id)
                      INTO l_count
                      FROM dfn_ntp.v34_price_instrument_type
                     WHERE v34_price_inst_type_id = :new.instrumenttype;

                    IF l_count = 0
                    THEN
                        INSERT
                          INTO dfn_ntp.a22_insert_new_symbol_audit (
                                   a22_date,
                                   a22_exchange,
                                   a22_symbol,
                                   a22_instrument_type,
                                   a22_currency,
                                   a22_status_id_v01,
                                   a22_exception)
                        VALUES (
                                   SYSDATE,                         --a22_date
                                   :new.exchange,               --a22_exchange
                                   :new.symbol,                   --a22_symbol
                                   :new.instrumenttype,  --a22_instrument_type
                                   :new.currency,               --a22_currency
                                   3,           --a22_status_id_v01 | Rejected
                                      'Price Instrument Type('
                                   || :new.instrumenttype
                                   || ') not Found'            --a22_exception
                                                   );
                    ELSE
                        SELECT v34_id,
                               v34_inst_id_v09,
                               v34_price_inst_type_id,
                               v34_inst_code_v09
                          INTO l_price_instrument_type_id,
                               l_instrument_type_id,
                               l_price_instrument_type_code,
                               l_instrument_type_code
                          FROM dfn_ntp.v34_price_instrument_type
                         WHERE v34_price_inst_type_id = :new.instrumenttype;

                        INSERT
                          INTO dfn_ntp.m20_symbol (
                                   m20_id,
                                   m20_institute_id_m02,
                                   m20_exchange_id_m01,
                                   m20_exchange_code_m01,
                                   m20_price_exchange_code_m01,
                                   m20_isincode,
                                   m20_symbol_code,
                                   m20_exchange_symbol_code_m20,
                                   m20_price_symbol_code_m20,
                                   m20_instrument_type_id_v09,
                                   m20_instrument_type_code_v09,
                                   m20_price_instrument_id_v34,
                                   m20_price_instrument_code_v34,
                                   m20_sectors_id_m63,
                                   m20_currency_id_m03,
                                   m20_currency_code_m03,
                                   m20_status_id_v01,
                                   m20_trading_status_id_v22,
                                   m20_access_level_id_v01,
                                   m20_country_m05_id,
                                   m20_created_date,
                                   m20_created_by_id_u17,
                                   m20_status_changed_date,
                                   m20_status_changed_by_id_u17,
                                   m20_price_ratio,
                                   m20_market_id_m29,
                                   m20_market_code_m29,
                                   m20_lot_size,
                                   m20_small_orders,
                                   m20_short_description,
                                   m20_short_description_lang,
                                   m20_long_description,
                                   m20_long_description_lang,
                                   m20_market_segment,
                                   m20_option_type,
                                   m20_trading_allowed,
                                   m20_online_trading_allowed)
                        VALUES (
                                   dfn_ntp.fn_get_next_sequnce ('M20_SYMBOL'), --m20_id
                                   i.m150_primary_institute_id_m02, --m20_institute_id_m02
                                   l_exchange_id,        --m20_exchange_id_m01
                                   :new.exchange,      --m20_exchange_code_m01
                                   :new.exchange, --m20_price_exchange_code_m01
                                   :new.isincode,               --m20_isincode
                                   :new.symbol,              --m20_symbol_code
                                   :new.symbol, --m20_exchange_symbol_code_m20
                                   :new.symbol,    --m20_price_symbol_code_m20
                                   l_instrument_type_id, --m20_instrument_type_id_v09
                                   l_instrument_type_code, --m20_instrument_type_code_v09
                                   l_price_instrument_type_id, --m20_price_instrument_id_v34
                                   l_price_instrument_type_code, --m20_price_instrument_code_v34
                                   l_sector_id,           --m20_sectors_id_m63
                                   l_currency_id,        --m20_currency_id_m03
                                   :new.currency,      --m20_currency_code_m03
                                   2,                      --m20_status_id_v01
                                   17,             --m20_trading_status_id_v22
                                   CASE WHEN l_is_local = 1 THEN 1 ELSE 2 END, --m20_access_level_id_v01
                                   l_natinality_id,       --m20_country_m05_id
                                   SYSDATE,                 --m20_created_date
                                   0,                  --m20_created_by_id_u17
                                   SYSDATE,          --m20_status_changed_date
                                   0,           --m20_status_changed_by_id_u17
                                   CASE
                                       WHEN :new.exchange IN ('KSE')
                                       THEN
                                           0.001
                                       ELSE
                                           1
                                   END,                      --m20_price_ratio
                                   l_market_id,            --m20_market_id_m29
                                   l_market_code,        --m20_market_code_m29
                                   CASE
                                       WHEN    :new.lot_size IS NULL
                                            OR :new.lot_size <= 0
                                       THEN
                                           1
                                       ELSE
                                           :new.lot_size
                                   END,                         --m20_lot_size
                                   1,                       --m20_small_orders
                                   :new.symbolshortdescription_1, --m20_short_description
                                   :new.symbolshortdescription_2, --m20_short_description_lang
                                   :new.symboldescription_1, --m20_long_description
                                   :new.symboldescription_2, --m20_long_description_lang
                                   CASE
                                       WHEN :new.exchange = 'TDWL'
                                       THEN
                                           (CASE
                                                WHEN :new.market_code = '1'
                                                THEN
                                                    1
                                                WHEN :new.market_code = '2'
                                                THEN
                                                    2
                                                ELSE
                                                    0
                                            END)
                                       ELSE
                                           0
                                   END,                   --m20_market_segment
                                   :new.option_type,        --m20_option_type,
                                   1,                  -- m20_trading_allowed,
                                   1              --m20_online_trading_allowed
                                    );
                    END IF;
                ELSE
                    INSERT
                      INTO dfn_ntp.a22_insert_new_symbol_audit (
                               a22_date,
                               a22_exchange,
                               a22_symbol,
                               a22_instrument_type,
                               a22_currency,
                               a22_status_id_v01,
                               a22_exception)
                    VALUES (
                               SYSDATE,                             --a22_date
                               :new.exchange,                   --a22_exchange
                               :new.symbol,                       --a22_symbol
                               :new.instrumenttype,      --a22_instrument_type
                               :new.currency,                   --a22_currency
                               3,               --a22_status_id_v01 | Rejected
                                  'Symbol is not Active('
                               || :new.is_active
                               || ') or Invalid Instrument Type('
                               || :new.instrumenttype
                               || ')'                          --a22_exception
                                     );
                END IF;
            ELSE
                INSERT
                  INTO dfn_ntp.a22_insert_new_symbol_audit (
                           a22_date,
                           a22_exchange,
                           a22_symbol,
                           a22_instrument_type,
                           a22_currency,
                           a22_status_id_v01,
                           a22_exception)
                VALUES (SYSDATE,                                    --a22_date
                        :new.exchange,                          --a22_exchange
                        :new.symbol,                              --a22_symbol
                        :new.instrumenttype,             --a22_instrument_type
                        :new.currency,                          --a22_currency
                        3,                      --a22_status_id_v01 | Rejected
                        'Currency(' || :new.currency || ') is Empty/Invalid' --a22_exception
                                                                            );
            END IF;
        END LOOP;
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        i_errorcode := SQLCODE;
        i_errormessage :=
            TO_CHAR (i_errorcode, '9999.9') || SUBSTR (SQLERRM, 1, 3000);

        INSERT INTO dfn_ntp.a22_insert_new_symbol_audit (a22_date,
                                                         a22_exchange,
                                                         a22_symbol,
                                                         a22_instrument_type,
                                                         a22_currency,
                                                         a22_status_id_v01,
                                                         a22_exception)
             VALUES (SYSDATE,                                       --a22_date
                     :new.exchange,                             --a22_exchange
                     :new.symbol,                                 --a22_symbol
                     :new.instrumenttype,                --a22_instrument_type
                     :new.currency,                             --a22_currency
                     31,                          --a22_status_id_v01 | Failed
                     i_errormessage);
END;
/

