DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_symbol_id              NUMBER;
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

    DELETE FROM error_log
          WHERE mig_table = 'M20_SYMBOL_EXTENDED';

    FOR i
        IN (SELECT m20_map.new_symbol_id,
                   m77.m77_maturity_day,
                   m77.m77_maturity_myear,
                   CASE
                       WHEN m77.m77_fund_type = 1 THEN 2
                       WHEN m77.m77_fund_type = 2 THEN 3
                       WHEN m77.m77_fund_type = 3 THEN 4
                   END
                       AS fund_type,
                   TO_CHAR (m77.m77_cutofftime, 'HH:MI') AS m77_cutofftime,
                   m77.m77_amc,
                   m77.m77_short_name,
                   m77.m77_issuer_name,
                   m77.m77_issue_size,
                   map06_sec_domicile.map06_ntp_id AS sec_domicile_id,
                   m77.m77_security_currency,
                   m77.m77_price_update_code, -- [SAME IDs]
                   m77.m77_industry, -- [SAME IDs]
                   m77.m77_issue_date,
                   CASE
                       WHEN m77.m77_instrument_type IN ('BN') -- Only for BN Maturity Date Is Generated
                       THEN
                           TO_DATE (
                               m77.m77_maturity_myear || m77.m77_maturity_day,
                               'yyyymmdd')
                       ELSE
                           m77.m77_maturity_date
                   END
                       AS maturity_date,
                   m77.m77_divident_date,
                   m77.m77_int_payment_date,
                   m77.m77_accrual_start_date,
                   m77.m77_no_of_payment, -- [SAME IDs]
                   m77.m77_bond_trade_type, -- [SAME IDs]
                   m77.m77_margin_control,
                   m77.m77_safe_custody_code, -- [SAME IDs]
                   m77.m77_interest_rate,
                   m77.m77_interest_day_basis, -- [SAME IDs]
                   m77.m77_default_depository,
                   m77.m77_share_register,
                   m77.m77_euro_clear_no,
                   m77.m77_cedel_no,
                   m77.m77_sedol_no,
                   m77.m77_quoted_listed_no,
                   m77.m77_risk_ccy,
                   map06_risk.map06_ntp_id AS risk_country_id,
                   m77.m77_rating, -- [SAME IDs]
                   m77.m77_municipal_gvt,
                   m03_security.m03_id AS security_currency_id,
                   m01_municipal.m01_id AS municipal_gvt_id,
                   m01_depository.m01_id AS default_depository_id,
                   m03_risk.m03_id AS risk_currency_id,
                   NVL (map16_stock.map16_ntp_code, m77.m77_stock_exchange)
                       AS stock_exchange,
                   m01_stock.m01_id AS stock_exchange_id,
                   m77.m77_category_id, -- [SAME IDs]
                   m77.m77_id,
                   sym_map.first_subs_startdate AS m77_session_1_start_date,
                   sym_map.first_subs_expdate AS m77_session_1_end_date,
                   CASE
                       WHEN sym_map.first_subs_startdate IS NOT NULL
                       THEN
                           dfn_ntp.fn_get_hijri_gregorian_date (
                               TO_CHAR (sym_map.first_subs_startdate,
                                        'dd/mm/yyyy'),
                               0)
                       ELSE
                           NULL
                   END
                       AS m77_session_1_hijri_start_date,
                   CASE
                       WHEN sym_map.first_subs_expdate IS NOT NULL
                       THEN
                           dfn_ntp.fn_get_hijri_gregorian_date (
                               TO_CHAR (sym_map.first_subs_expdate,
                                        'dd/mm/yyyy'),
                               0)
                       ELSE
                           NULL
                   END
                       AS m77_session_1_hijri_end_date,
                   sym_map.sec_subs_startdate AS m77_session_2_start_date,
                   sym_map.sec_subs_expdate AS m77_session_2_end_date,
                   CASE
                       WHEN sym_map.sec_subs_startdate IS NOT NULL
                       THEN
                           dfn_ntp.fn_get_hijri_gregorian_date (
                               TO_CHAR (sym_map.sec_subs_startdate,
                                        'dd/mm/yyyy'),
                               0)
                       ELSE
                           NULL
                   END
                       AS m77_session_2_hijri_start_date,
                   CASE
                       WHEN sym_map.sec_subs_expdate IS NOT NULL
                       THEN
                           dfn_ntp.fn_get_hijri_gregorian_date (
                               TO_CHAR (sym_map.sec_subs_expdate,
                                        'dd/mm/yyyy'),
                               0)
                       ELSE
                           NULL
                   END
                       AS m77_session_2_hijri_end_date,
                   m20_ex.m20_id
              FROM mubasher_oms.m77_symbols@mubasher_db_link m77
                   LEFT JOIN map16_optional_exchanges_m01 map16_municipal
                       ON m77.m77_municipal_gvt =
                              map16_municipal.map16_oms_code
                   LEFT JOIN map16_optional_exchanges_m01 map16_depository
                       ON m77.m77_default_depository =
                              map16_depository.map16_oms_code
                   LEFT JOIN map16_optional_exchanges_m01 map16_stock
                       ON m77.m77_stock_exchange = map16_stock.map16_oms_code
                   LEFT JOIN m20_symbol_mappings m20_map
                       ON m77.m77_id = m20_map.old_symbol_id
                   LEFT JOIN map06_country_m05 map06_sec_domicile
                       ON m77.m77_security_domicile =
                              map06_sec_domicile.map06_oms_id
                   LEFT JOIN map06_country_m05 map06_risk
                       ON m77.m77_risk_country = map06_risk.map06_oms_id
                   LEFT JOIN (SELECT m01_id, m01_exchange_code
                                FROM dfn_ntp.m01_exchanges
                               WHERE m01_institute_id_m02 =
                                         l_primary_institute_id) m01_municipal
                       ON NVL (map16_municipal.map16_ntp_code,
                               m77.m77_municipal_gvt) =
                              m01_municipal.m01_exchange_code
                   LEFT JOIN (SELECT m01_id, m01_exchange_code
                                FROM dfn_ntp.m01_exchanges
                               WHERE m01_institute_id_m02 =
                                         l_primary_institute_id) m01_depository
                       ON NVL (map16_depository.map16_ntp_code,
                               m77.m77_default_depository) =
                              m01_depository.m01_exchange_code
                   LEFT JOIN (SELECT m01_id, m01_exchange_code
                                FROM dfn_ntp.m01_exchanges
                               WHERE m01_institute_id_m02 =
                                         l_primary_institute_id) m01_stock
                       ON NVL (map16_stock.map16_ntp_code,
                               m77.m77_stock_exchange) =
                              m01_stock.m01_exchange_code
                   LEFT JOIN dfn_ntp.m03_currency m03_security
                       ON m77.m77_security_currency = m03_security.m03_code
                   LEFT JOIN dfn_ntp.m03_currency m03_risk
                       ON m77.m77_risk_ccy = m03_risk.m03_code
                   LEFT JOIN dfn_ntp.m20_symbol_extended m20_ex
                       ON m20_map.new_symbol_id = m20_ex.m20_id
                   LEFT JOIN mubasher_price.esp_symbolmap@mubasher_price_link sym_map
                       ON     m77.m77_exchange = sym_map.exchange
                          AND m77.m77_symbol = sym_map.symbol
             WHERE m77.m77_instrument_type IN ('RHT', 'BN', 'MF'))
    LOOP
        BEGIN
            IF i.new_symbol_id IS NULL
            THEN
                raise_application_error (-20001, 'Invalid Symbol', TRUE);
            END IF;

            IF i.m20_id IS NULL
            THEN
                INSERT
                  INTO dfn_ntp.m20_symbol_extended (
                           m20_id,
                           m20_maturity_day,
                           m20_maturity_myear,
                           m20_fund_type_v01,
                           m20_cutofftime,
                           m20_amc,
                           m20_short_name,
                           m20_issuer_name,
                           m20_issue_size,
                           m20_security_domicile_id_m05,
                           m20_security_currency_code_m03,
                           m20_price_update_code_v23,
                           m20_industry_v24,
                           m20_issue_date,
                           m20_maturity_date,
                           m20_divident_date,
                           m20_int_payment_date,
                           m20_accrual_start_date,
                           m20_no_of_payment_v25,
                           m20_bond_trade_type,
                           m20_margin_control,
                           m20_safe_custody_code,
                           m20_interest_rate,
                           m20_interest_day_basis_id_v26,
                           m20_def_depository_code_m01,
                           m20_share_register,
                           m20_euro_clear_no,
                           m20_cedel_no,
                           m20_sedol_no,
                           m20_quoted_listed_no,
                           m20_risk_currency_code_m03,
                           m20_risk_country_id_m05,
                           m20_rating_v27,
                           m20_municipal_gvt_code_m01,
                           m20_security_currency_id_m03,
                           m20_municipal_gvt_id_m01,
                           m20_default_depository_id_m01,
                           m20_session_1_start_date,
                           m20_session_1_end_date,
                           m20_session_2_start_date,
                           m20_session_2_end_date,
                           m20_session_1_hijri_strt_date,
                           m20_session_1_hijri_end_date,
                           m20_session_2_hijri_strt_date,
                           m20_session_2_hijri_end_date,
                           m20_risk_currency_id_m03,
                           m20_stock_exchange_code_m01,
                           m20_stock_exchange_id_m01,
                           m20_sub_asset_type_id_v08,
                           m20_charge_type,
                           m20_custom_type)
                VALUES (i.new_symbol_id, -- m20_id
                        i.m77_maturity_day, -- m20_maturity_day
                        i.m77_maturity_myear, -- m20_maturity_myear
                        i.fund_type, -- m20_fund_type_v01
                        i.m77_cutofftime, -- m20_cutofftime
                        i.m77_amc, -- m20_amc | Updating in the Post Migration Script
                        i.m77_short_name, -- m20_short_name
                        i.m77_issuer_name, -- m20_issuer_name
                        i.m77_issue_size, -- m20_issue_size
                        i.sec_domicile_id, -- m20_security_domicile_id_m05
                        i.m77_security_currency, -- m20_security_currency_code_m03
                        i.m77_price_update_code, -- m20_price_update_code_v23
                        i.m77_industry, -- m20_industry_v24
                        i.m77_issue_date, -- m20_issue_date
                        i.maturity_date, -- m20_maturity_date
                        i.m77_divident_date, -- m20_divident_date
                        i.m77_int_payment_date, -- m20_int_payment_date
                        i.m77_accrual_start_date, -- m20_accrual_start_date
                        i.m77_no_of_payment, -- m20_no_of_payment_v25
                        i.m77_bond_trade_type, -- m20_bond_trade_type
                        i.m77_margin_control, -- m20_margin_control
                        i.m77_safe_custody_code, -- m20_safe_custody_code
                        i.m77_interest_rate, -- m20_interest_rate
                        i.m77_interest_day_basis, -- m20_interest_day_basis_id_v26
                        i.m77_default_depository, -- m20_def_depository_code_m01
                        i.m77_share_register, -- m20_share_register
                        i.m77_euro_clear_no, -- m20_euro_clear_no
                        i.m77_cedel_no, -- m20_cedel_no
                        i.m77_sedol_no, -- m20_sedol_no
                        i.m77_quoted_listed_no, -- m20_quoted_listed_no
                        i.m77_risk_ccy, -- m20_risk_currency_code_m03
                        i.risk_country_id, -- m20_risk_country_id_m05
                        i.m77_rating, -- m20_rating_v27
                        i.m77_municipal_gvt, -- m20_municipal_gvt_code_m01
                        i.security_currency_id, -- m20_security_currency_id_m03
                        i.municipal_gvt_id, -- m20_municipal_gvt_id_m01
                        i.default_depository_id, -- m20_default_depository_id_m01
                        i.m77_session_1_start_date, -- m20_session_1_start_date
                        i.m77_session_1_end_date, -- m20_session_1_end_date
                        i.m77_session_2_start_date, -- m20_session_2_start_date
                        i.m77_session_2_end_date, -- m20_session_2_end_date
                        i.m77_session_1_hijri_start_date, -- m20_session_1_hijri_strt_date
                        i.m77_session_1_hijri_end_date, -- m20_session_1_hijri_end_date
                        i.m77_session_2_hijri_start_date, -- m20_session_2_hijri_strt_date
                        i.m77_session_2_hijri_end_date, -- m20_session_2_hijri_end_date
                        i.risk_currency_id, -- m20_risk_currency_id_m03
                        i.stock_exchange, -- m20_stock_exchange_code_m01
                        i.stock_exchange_id, -- m20_stock_exchange_id_m01
                        i.m77_category_id, -- m20_sub_asset_type_id_v08
                        0, -- m20_charge_type | Not Available
                        '1' -- m20_custom_type
                           );
            ELSE
                UPDATE dfn_ntp.m20_symbol_extended
                   SET m20_maturity_day = i.m77_maturity_day, -- m20_maturity_day
                       m20_maturity_myear = i.m77_maturity_myear, -- m20_maturity_myear
                       m20_fund_type_v01 = i.fund_type, -- m20_fund_type_v01
                       m20_cutofftime = i.m77_cutofftime, -- m20_cutofftime
                       m20_amc = i.m77_amc, -- m20_amc | Updating in the Post Migration Script
                       m20_short_name = i.m77_short_name, -- m20_short_name
                       m20_issuer_name = i.m77_issuer_name, -- m20_issuer_name
                       m20_issue_size = i.m77_issue_size, -- m20_issue_size
                       m20_security_domicile_id_m05 = i.sec_domicile_id, -- m20_security_domicile_id_m05
                       m20_security_currency_code_m03 =
                           i.m77_security_currency, -- m20_security_currency_code_m03
                       m20_price_update_code_v23 = i.m77_price_update_code, -- m20_price_update_code_v23
                       m20_industry_v24 = i.m77_industry, -- m20_industry_v24
                       m20_issue_date = i.m77_issue_date, -- m20_issue_date
                       m20_maturity_date = i.maturity_date, -- m20_maturity_date
                       m20_divident_date = i.m77_divident_date, -- m20_divident_date
                       m20_int_payment_date = i.m77_int_payment_date, -- m20_int_payment_date
                       m20_accrual_start_date = i.m77_accrual_start_date, -- m20_accrual_start_date
                       m20_no_of_payment_v25 = i.m77_no_of_payment, -- m20_no_of_payment_v25
                       m20_bond_trade_type = i.m77_bond_trade_type, -- m20_bond_trade_type
                       m20_margin_control = i.m77_margin_control, -- m20_margin_control
                       m20_safe_custody_code = i.m77_safe_custody_code, -- m20_safe_custody_code
                       m20_interest_rate = i.m77_interest_rate, -- m20_interest_rate
                       m20_interest_day_basis_id_v26 =
                           i.m77_interest_day_basis, -- m20_interest_day_basis_id_v26
                       m20_def_depository_code_m01 = i.m77_default_depository, -- m20_def_depository_code_m01
                       m20_share_register = i.m77_share_register, -- m20_share_register
                       m20_euro_clear_no = i.m77_euro_clear_no, -- m20_euro_clear_no
                       m20_cedel_no = i.m77_cedel_no, -- m20_cedel_no
                       m20_sedol_no = i.m77_sedol_no, -- m20_sedol_no
                       m20_quoted_listed_no = i.m77_quoted_listed_no, -- m20_quoted_listed_no
                       m20_risk_currency_code_m03 = i.m77_risk_ccy, -- m20_risk_currency_code_m03
                       m20_risk_country_id_m05 = i.risk_country_id, -- m20_risk_country_id_m05
                       m20_rating_v27 = i.m77_rating, -- m20_rating_v27
                       m20_municipal_gvt_code_m01 = i.m77_municipal_gvt, -- m20_municipal_gvt_code_m01
                       m20_security_currency_id_m03 = i.security_currency_id, -- m20_security_currency_id_m03
                       m20_municipal_gvt_id_m01 = i.municipal_gvt_id, -- m20_municipal_gvt_id_m01
                       m20_default_depository_id_m01 = i.default_depository_id, -- m20_default_depository_id_m01
                       m20_session_1_start_date = i.m77_session_1_start_date, -- m20_session_1_start_date
                       m20_session_1_end_date = i.m77_session_1_end_date, -- m20_session_1_end_date
                       m20_session_2_start_date = i.m77_session_2_start_date, -- m20_session_2_start_date
                       m20_session_2_end_date = i.m77_session_2_end_date, -- m20_session_2_end_date
                       m20_session_1_hijri_strt_date =
                           i.m77_session_1_hijri_start_date, -- m20_session_1_hijri_strt_date
                       m20_session_1_hijri_end_date =
                           i.m77_session_1_hijri_end_date, -- m20_session_1_hijri_end_date
                       m20_session_2_hijri_strt_date =
                           i.m77_session_2_hijri_start_date, -- m20_session_2_hijri_strt_date
                       m20_session_2_hijri_end_date =
                           i.m77_session_2_hijri_end_date, -- m20_session_2_hijri_end_date
                       m20_risk_currency_id_m03 = i.risk_currency_id, -- m20_risk_currency_id_m03
                       m20_stock_exchange_code_m01 = i.stock_exchange, -- m20_stock_exchange_code_m01
                       m20_stock_exchange_id_m01 = i.stock_exchange_id, -- m20_stock_exchange_id_m01
                       m20_sub_asset_type_id_v08 = i.m77_category_id -- m20_sub_asset_type_id_v08
                 WHERE m20_id = i.m20_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M20_SYMBOL_EXTENDED',
                                i.m77_id,
                                CASE
                                    WHEN i.m20_id IS NULL
                                    THEN
                                        i.new_symbol_id
                                    ELSE
                                        i.m20_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.m20_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/