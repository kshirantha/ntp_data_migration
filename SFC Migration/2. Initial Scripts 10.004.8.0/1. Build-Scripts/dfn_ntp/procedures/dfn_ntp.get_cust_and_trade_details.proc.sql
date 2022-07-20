CREATE OR REPLACE PROCEDURE dfn_ntp.get_cust_and_trade_details (
    pu07_id   IN     NUMBER DEFAULT NULL,
    pu01_id   IN     NUMBER DEFAULT NULL,
    p_view       OUT SYS_REFCURSOR,
    prows        OUT NUMBER)
IS
BEGIN
    IF pu07_id IS NOT NULL
    THEN
        OPEN p_view FOR
            SELECT u07.u07_id,
                   u07.u07_exchange_account_no,
                   u07.u07_exchange_code_m01,
                   u07.u07_type,
                   u07.u07_account_category,
                   u07.u07_institute_id_m02,
                   u01.u01_customer_no,
                   u01.u01_account_category_id_v01,
                   u01.u01_default_id_no,
                   u02.u02_po_box,
                   u02.u02_zip_code,
                   u02.u02_address_line1,
                   u02.u02_address_line2,
                   m05.m05_code,
                   m06.m06_name,
                   u08.u08_account_name AS foreignaccountname,
                   u08.u08_account_no AS foreignaccountnumber,
                   u08.u08_iban_no AS foreignaccountiban,
                   m16.m16_name AS foreignbankname,
                   u08.u08_bank_branch_name || m16.m16_address
                       AS foreignbankaddress,
                   m16.m16_swift_code AS foreignbankswiftbic,
                   m16.m16_aba_routing_no AS foreignbankaba
              FROM u01_customer u01
                   INNER JOIN u07_trading_account u07
                       ON u01.u01_id = u07.u07_customer_id_u01
                   LEFT JOIN (SELECT *
                                FROM vw_customer_contact_info
                               WHERE u02_is_default = 1) u02
                       ON u01.u01_id = u02.u02_customer_id_u01
                   LEFT JOIN m05_country m05
                       ON u02.u02_country_id_m05 = m05.m05_id
                   LEFT JOIN m06_city m06 ON u02.u02_city_id_m06 = m06.m06_id
                   LEFT JOIN u08_customer_beneficiary_acc u08
                       ON u07.u07_forgn_bank_account = u08.u08_id
                   LEFT JOIN m16_bank m16 ON u08.u08_bank_id_m16 = m16.m16_id
             WHERE u07_id = pu07_id;
    ELSE
        IF pu01_id IS NOT NULL
        THEN
            OPEN p_view FOR
                SELECT u01.u01_id,
                       u01.u01_customer_no,
                       u01.u01_account_category_id_v01,
                       u01.u01_default_id_no,
                       u02.u02_po_box,
                       u02.u02_zip_code,
                       u02.u02_address_line1,
                       u02.u02_address_line2,
                       m05.m05_code,
                       m06.m06_name
                  FROM u01_customer u01
                       LEFT JOIN (SELECT *
                                    FROM vw_customer_contact_info
                                   WHERE u02_is_default = 1) u02
                           ON u01.u01_id = u02.u02_customer_id_u01
                       LEFT JOIN m05_country m05
                           ON u02.u02_country_id_m05 = m05.m05_id
                       LEFT JOIN m06_city m06
                           ON u02.u02_city_id_m06 = m06.m06_id
                 WHERE u01_id = pu01_id;
        END IF;
    END IF;
END;
/