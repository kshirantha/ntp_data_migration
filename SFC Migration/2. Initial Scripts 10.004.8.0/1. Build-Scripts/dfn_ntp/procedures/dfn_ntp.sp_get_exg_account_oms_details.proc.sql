CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_exg_account_oms_details (
    p_view                 OUT SYS_REFCURSOR,
    prows                  OUT NUMBER,
    p_cust_id                  NUMBER,
    p_trading_account_id       NUMBER,
    p_exchange_code            VARCHAR2)
IS
BEGIN
    OPEN p_view FOR
        SELECT u07.u07_exchange_code_m01,
               u07.u07_exchange_account_no,
               u02.u02_address_line1 AS address1,
               u02.u02_address_line2 AS address2,
               m06.m06_name,
               u02.u02_po_box,
               u02.u02_country_id_m05,
               m16.m16_swift_code || u06.u06_iban_no AS bank_account_no,
               u01.u01_first_name,
               u01.u01_last_name,
               u01.u01_second_name,
               u01.u01_third_name,
               CASE
                   WHEN u01.u01_gender = 'M' THEN 'Male'
                   WHEN u01.u01_gender = 'F' THEN 'Female'
               END
                   AS u01_gender,
               m05.m05_name,
               m05.m05_code,
               u05.u05_id_no AS nin_iqama,
               u08.u08_account_name AS foreign_account_name,
               u08.u08_account_no AS foreign_account_number,
               u08.u08_iban_no AS foreign_account_iban,
               m16.m16_name AS foreign_bank_name,
               u08.u08_bank_branch_name || m16.m16_address
                   AS foreign_bank_address,
               m16.m16_swift_code AS foreign_bank_swift_bic,
               m16.m16_aba_routing_no AS foreign_bank_aba
          FROM u07_trading_account u07
               JOIN u01_customer u01
                   ON u07.u07_customer_id_u01 = u01.u01_id
               JOIN u02_customer_contact_info u02
                   ON     u01.u01_id = u02.u02_customer_id_u01
                      AND u02.u02_is_default = 1
               JOIN m05_country m05
                   ON u01.u01_birth_country_id_m05 = m05.m05_id
               JOIN m06_city m06
                   ON u01.u01_birth_city_id_m06 = m06.m06_id
               JOIN u06_cash_account u06
                   ON u07.u07_cash_account_id_u06 = u06.u06_id
               JOIN u05_customer_identification u05
                   ON     u01.u01_id = u05.u05_customer_id_u01
                      AND u05.u05_is_default = 1
               LEFT JOIN u08_customer_beneficiary_acc u08
                   ON     u08.u08_customer_id_u01 = u01.u01_id
                      AND u08.u08_is_default = 1
                      AND u08.u08_account_type_v01_id = 2
               LEFT JOIN m16_bank m16
                   ON     u08.u08_bank_id_m16 = m16.m16_id
                      AND u08.u08_is_foreign_bank_acc = 1
               LEFT JOIN u08_customer_beneficiary_acc u08_foreign
                   ON u07.u07_forgn_bank_account = u08_foreign.u08_id
               LEFT JOIN m16_bank m16_foreign
                   ON u08_foreign.u08_bank_id_m16 = m16_foreign.m16_id
         WHERE     u01.u01_id = p_cust_id
               AND u07.u07_id = p_trading_account_id
               AND u07.u07_exchange_code_m01 = p_exchange_code;
END;
/