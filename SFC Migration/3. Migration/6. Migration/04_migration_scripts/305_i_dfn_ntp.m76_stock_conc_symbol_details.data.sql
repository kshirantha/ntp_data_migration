DECLARE
    l_stk_conc_symbol_id   NUMBER;
    l_sqlerrm              VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m76_id), 0)
      INTO l_stk_conc_symbol_id
      FROM dfn_ntp.m76_stock_conc_symbol_details;

    DELETE FROM error_log
          WHERE mig_table = 'M76_STOCK_CONC_SYMBOL_DETAILS';

    FOR i
        IN (SELECT m75.m75_id,
                   m75.m75_global_concentration_pct,
                   m75.m75_exchange_id_m01,
                   m75.m75_exchange_code_m01,
                   stock_conc_symbol.m78_symbol_id_m20,
                   stock_conc_symbol.m78_symbol_code_m20,
                   m76.m76_id
              FROM dfn_ntp.m75_stock_concentration_group m75,
                   (SELECT DISTINCT
                           m73_stock_concent_grp_id_m75,
                           m78.m78_symbol_id_m20,
                           m78_symbol_code_m20
                      FROM dfn_ntp.m73_margin_products m73,
                           dfn_ntp.m78_symbol_marginability m78
                     WHERE m73.m73_symbol_margblty_grp_id_m77 =
                               m78.m78_sym_margin_group_m77) stock_conc_symbol, -- Marginable Symbols Considered for Stock Concentration Groups's Symbol as Old System Only Links a Stock Concentration Group to a Margin Product
                   dfn_ntp.m76_stock_conc_symbol_details m76
             WHERE     m75.m75_id =
                           stock_conc_symbol.m73_stock_concent_grp_id_m75
                   AND m75.m75_id = m76.m76_stock_conc_grp_id_m75(+)
                   AND m75.m75_exchange_id_m01 = m76.m76_exchange_id_m01(+)
                   AND stock_conc_symbol.m78_symbol_id_m20 =
                           m76.m76_symbol_id_m20(+))
    LOOP
        BEGIN
            IF i.m76_id IS NULL
            THEN
                l_stk_conc_symbol_id := l_stk_conc_symbol_id + 1;

                INSERT
                  INTO dfn_ntp.m76_stock_conc_symbol_details (
                           m76_id,
                           m76_stock_conc_grp_id_m75,
                           m76_symbol_code_m20,
                           m76_symbol_id_m20,
                           m76_percentage,
                           m76_sell_allowed,
                           m76_buy_allowed,
                           m76_exchange_id_m01,
                           m76_exchange_code_m01,
                           m76_created_by_id_u17,
                           m76_created_date,
                           m76_modified_by_id_u17,
                           m76_modified_date,
                           m76_custom_type)
                VALUES (l_stk_conc_symbol_id, -- m76_id
                        i.m75_id, -- m76_stock_conc_grp_id_m75
                        i.m78_symbol_code_m20, -- m76_symbol_code_m20
                        i.m78_symbol_id_m20, -- m76_symbol_id_m20
                        i.m75_global_concentration_pct, -- m76_percentage
                        0, -- m76_sell_allowed
                        0, -- m76_buy_allowed
                        i.m75_exchange_id_m01, -- m76_exchange_id_m01
                        i.m75_exchange_code_m01, -- m76_exchange_code_m01
                        0, -- m76_created_by_id_u17
                        SYSDATE, -- m76_created_date
                        NULL, -- m76_modified_by_id_u17
                        NULL, -- m76_modified_date
                        '1' -- m76_custom_type
                           );
            ELSE
                UPDATE dfn_ntp.m76_stock_conc_symbol_details
                   SET m76_stock_conc_grp_id_m75 = i.m75_id, -- m76_stock_conc_grp_id_m75
                       m76_symbol_code_m20 = i.m78_symbol_code_m20, -- m76_symbol_code_m20
                       m76_symbol_id_m20 = i.m78_symbol_id_m20, -- m76_symbol_id_m20
                       m76_percentage = i.m75_global_concentration_pct, -- m76_percentage
                       m76_exchange_id_m01 = i.m75_exchange_id_m01, -- m76_exchange_id_m01
                       m76_exchange_code_m01 = i.m75_exchange_code_m01 -- m76_exchange_code_m01
                 WHERE m76_id = i.m76_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M76_STOCK_CONC_SYMBOL_DETAILS',
                                   'Stock Conc. Group: '
                                || i.m75_id
                                || ' Symbol: '
                                || i.m78_symbol_id_m20
                                || ' Exchange: '
                                || i.m75_exchange_id_m01,
                                CASE
                                    WHEN i.m76_id IS NULL
                                    THEN
                                        l_stk_conc_symbol_id
                                    ELSE
                                        i.m76_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.m75_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/