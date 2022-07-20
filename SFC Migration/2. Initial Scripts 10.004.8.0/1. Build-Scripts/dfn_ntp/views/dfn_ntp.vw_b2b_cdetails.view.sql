/* Formatted on 8/5/2020 3:07:10 PM (QP5 v5.206) */
CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_b2b_cdetails
(
    portfolio,
    custname,
    custname_lang,
    account_name,
    address,
    market,
    trade_currency,
    settle_currency,
    u06_investment_account_no,
    u01_customer_no,
    u06_currency_code_m03,
    u06_iban_no,
    u02_mobile,
    settle_balance,
    u06_customer_id_u01,
    u01_institute_id_m02,
    m02_code,
    m02_vat_no
)
AS
    (SELECT u07_exchange_account_no AS portfolio,
            u01.u01_display_name custname,
            u01_display_name_lang AS custname_lang,
            UNISTR (REPLACE (u07.u07_exchange_customer_name, '\u', '\'))
                AS account_name,
            (   u02_po_box
             || ' , '
             || u02_address_line1
             || ' , '
             || u02_address_line2
             || ' , '
             || m06.m06_name
             || ','
             || m05.m05_name)
                AS address,
            'KSA' AS market,
            'SAR' AS trade_currency,
            'SAR' AS settle_currency,
            u06.u06_investment_account_no,
            u01.u01_customer_no,
            u06.u06_currency_code_m03,
            u06.u06_iban_no,
            u02.u02_mobile,
            (  u06.u06_balance
             - u06.u06_receivable_amount
             + u06.u06_payable_blocked)
                settle_balance,
            u06.u06_customer_id_u01,
            u01.u01_institute_id_m02,
            m02.m02_code,
            m02_vat_no
       FROM u07_trading_account u07
            INNER JOIN u06_cash_account u06
                ON u06.u06_id = u07.u07_cash_account_id_u06
            INNER JOIN u01_customer u01
                ON u01.u01_id = u06.u06_customer_id_u01
            INNER JOIN u02_customer_contact_info u02
                ON u02.u02_customer_id_u01 = u01.u01_id
            INNER JOIN m05_country m05
                ON m05.m05_id = u02.u02_country_id_m05
            INNER JOIN m06_city m06
                ON m06.m06_id = u02.u02_city_id_m06
            INNER JOIN m02_institute m02
                ON m02.m02_id = u01_institute_id_m02)
/
