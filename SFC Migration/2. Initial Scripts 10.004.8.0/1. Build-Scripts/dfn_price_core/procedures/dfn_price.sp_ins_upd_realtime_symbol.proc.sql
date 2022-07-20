
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_INS_UPD_REALTIME_SYMBOL (
    p_exchange                    IN esp_symbolmap.exchange%TYPE,
    p_symbol                      IN esp_symbolmap.symbol%TYPE,
    p_exchangecode                IN esp_symbolmap.exchangecode%TYPE,
    p_symbolcode                  IN esp_symbolmap.symbolcode%TYPE,
    p_instrumenttype              IN esp_symbolmap.instrumenttype%TYPE,
    p_category                    IN esp_symbolmap.category%TYPE,
    p_all_descriptions            IN NVARCHAR2, --'lang1,shortdesc1,longdesc1|lang2,shortdesc2,longdesc2|'
    p_sector                      IN esp_symbolmap.sector%TYPE,
    p_currency                    IN esp_symbolmap.currency%TYPE,
    p_is_active                   IN esp_symbolmap.is_active%TYPE,
    p_market_code                 IN esp_symbolmap.market_code%TYPE,
    p_price_modification_factor   IN esp_symbolmap.price_modification_factor%TYPE,
    p_decimal_places              IN esp_symbolmap.decimal_places%TYPE,
    p_dec_correction_factor       IN esp_symbolmap.dec_correction_factor%TYPE,
    p_lot_size                    IN esp_symbolmap.lot_size%TYPE,
    p_unit                        IN esp_symbolmap.unit%TYPE)
IS
    TYPE record_1 IS RECORD
    (
        exchange            esp_symbolmap_descriptions.exchange%TYPE,
        symbol              esp_symbolmap_descriptions.symbol%TYPE,
        instrument_type     esp_symbolmap_descriptions.instrumenttype%TYPE,
        language            esp_symbolmap_descriptions.language%TYPE,
        short_description   esp_symbolmap_descriptions.symbolshortdescription%TYPE,
        description         esp_symbolmap_descriptions.symboldescription%TYPE
    );

    TYPE t_record_1 IS TABLE OF record_1
        INDEX BY BINARY_INTEGER;

    l_record_1      t_record_1;
    l_all_desc      NVARCHAR2 (8000) := p_all_descriptions;
    l_count1        NUMBER := 0;
    l_big_element   NVARCHAR2 (4000);
    l_pos1          NUMBER;
    l_pos2          NUMBER;
    l_pos3          NUMBER;
    l_separator1    VARCHAR2 (10) := CHR (24);
    l_separator2    VARCHAR2 (10) := '|';
BEGIN
    BEGIN
        UPDATE esp_symbolmap
           SET exchangecode = NVL (p_exchangecode, exchangecode),
               symbolcode = NVL (p_symbolcode, symbolcode),
               category = NVL (p_category, category),
               sector = NVL (p_sector, sector),
               currency = NVL (p_currency, currency),
               lastupdated = SYSDATE,
               is_active = NVL (p_is_active, is_active),
               market_code = NVL (p_market_code, market_code),
               price_modification_factor =
                   NVL (p_price_modification_factor,
                        price_modification_factor),
               decimal_places =
                   (CASE
                        WHEN p_decimal_places > -2 THEN p_decimal_places
                        ELSE decimal_places
                    END),
               dec_correction_factor =
                   (CASE
                        WHEN p_dec_correction_factor > 0
                        THEN
                            p_dec_correction_factor
                        ELSE
                            dec_correction_factor
                    END),
               lot_size = NVL (p_lot_size, lot_size),
               unit = NVL (p_unit, unit)
         WHERE     exchange = p_exchange
               AND symbol = p_symbol
               AND instrumenttype = p_instrumenttype;

        IF (SQL%ROWCOUNT = 0)
        THEN
            BEGIN
                INSERT INTO esp_symbolmap (exchange,
                                           symbol,
                                           exchangecode,
                                           symbolcode,
                                           instrumenttype,
                                           category,
                                           sector,
                                           currency,
                                           lastupdated,
                                           is_active,
                                           market_code,
                                           price_modification_factor,
                                           decimal_places,
                                           increment_id,
                                           dec_correction_factor,
                                           lot_size,
                                           unit)
                     VALUES (p_exchange,
                             p_symbol,
                             p_exchangecode,
                             p_symbolcode,
                             p_instrumenttype,
                             p_category,
                             p_sector,
                             p_currency,
                             SYSDATE,
                             p_is_active,
                             p_market_code,
                             p_price_modification_factor,
                             p_decimal_places,
                             0,
                             p_dec_correction_factor,
                             p_lot_size,
                             p_unit);
            END;
        END IF;
    END;

    IF (INSTR (l_all_desc, l_separator2) > 0)
    THEN
        BEGIN
            WHILE INSTR (l_all_desc, l_separator2) > 0
            LOOP
                l_count1 := l_count1 + 1;
                l_big_element :=
                    SUBSTR (l_all_desc,
                            1,
                            INSTR (l_all_desc, l_separator2) - 1);
                l_pos3 := INSTR (l_all_desc, l_separator2);
                l_all_desc :=
                    SUBSTR (l_all_desc, INSTR (l_all_desc, l_separator2) + 1);
                l_pos1 :=
                    INSTR (l_big_element,
                           l_separator1,
                           1,
                           1);
                l_pos2 :=
                    INSTR (l_big_element,
                           l_separator1,
                           1,
                           2);
                --Setting up the Collection
                l_record_1 (l_count1).exchange := p_exchange;
                l_record_1 (l_count1).symbol := p_symbol;
                l_record_1 (l_count1).instrument_type := p_instrumenttype;
                l_record_1 (l_count1).language :=
                    UPPER (SUBSTR (l_big_element, 1, l_pos1 - 1));
                l_record_1 (l_count1).short_description :=
                    SUBSTR (l_big_element, l_pos1 + 1, (l_pos2 - l_pos1 - 1));
                l_record_1 (l_count1).description :=
                    SUBSTR (l_big_element, l_pos2 + 1, (l_pos3 - l_pos2 - 1));
            END LOOP;

            FOR i IN l_record_1.FIRST .. l_record_1.LAST
            LOOP
                BEGIN
                    UPDATE esp_symbolmap_descriptions a
                       SET a.symboldescription =
                               TRIM (
                                   UNISTR (
                                       ASCIISTR (l_record_1 (i).description))),
                           a.symbolshortdescription =
                               TRIM (
                                   UNISTR (
                                       ASCIISTR (
                                           l_record_1 (i).short_description)))
                     WHERE     a.exchange = l_record_1 (i).exchange
                           AND a.symbol = l_record_1 (i).symbol
                           AND a.instrumenttype =
                                   l_record_1 (i).instrument_type
                           AND a.language = l_record_1 (i).language;

                    IF (SQL%ROWCOUNT = 0)
                    THEN
                        BEGIN
                            INSERT
                              INTO esp_symbolmap_descriptions a (
                                       a.exchange,
                                       a.symbol,
                                       a.instrumenttype,
                                       a.language,
                                       a.symboldescription,
                                       a.symbolshortdescription)
                            VALUES (
                                       l_record_1 (i).exchange,
                                       l_record_1 (i).symbol,
                                       l_record_1 (i).instrument_type,
                                       l_record_1 (i).language,
                                       TRIM (
                                           UNISTR (
                                               ASCIISTR (
                                                   l_record_1 (i).description))),
                                       TRIM (
                                           UNISTR (
                                               ASCIISTR (
                                                   l_record_1 (i).short_description))));
                        END;
                    END IF;

                    IF (i = 1)
                    THEN
                        BEGIN
                            UPDATE esp_symbolmap b
                               SET b.symboldescription_1 =
                                       TRIM (
                                           UNISTR (
                                               ASCIISTR (
                                                   l_record_1 (i).description))),
                                   b.symbolshortdescription_1 =
                                       TRIM (
                                           UNISTR (
                                               ASCIISTR (
                                                   l_record_1 (i).short_description)))
                             WHERE     b.exchange = p_exchange
                                   AND b.symbol = p_symbol
                                   AND b.instrumenttype = p_instrumenttype;
                        END;
                    END IF;

                    IF (i = 2)
                    THEN
                        BEGIN
                            UPDATE esp_symbolmap b
                               SET b.symboldescription_2 =
                                       TRIM (
                                           UNISTR (
                                               ASCIISTR (
                                                   l_record_1 (i).description))),
                                   b.symbolshortdescription_2 =
                                       TRIM (
                                           UNISTR (
                                               ASCIISTR (
                                                   l_record_1 (i).short_description)))
                             WHERE     b.exchange = p_exchange
                                   AND b.symbol = p_symbol
                                   AND b.instrumenttype = p_instrumenttype;
                        END;
                    END IF;
                END;
            END LOOP;
        END;
    END IF;
END;
/
/
