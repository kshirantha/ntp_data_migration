CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_oms_account_details (
    p_view                 OUT SYS_REFCURSOR,
    prows                  OUT NUMBER,
    p_cust_id                  NUMBER,
    p_trading_account_id       NUMBER,
    p_exchange_code            VARCHAR2                      -- exchange_id ??
                                       )
IS
BEGIN
    OPEN p_view FOR
        SELECT u07.u07_exchange_code_m01,
               --u06.u06_security_ac_id,
               u07.u07_exchange_account_no,
               u02.u02_address_line1 AS address1,
               u02.u02_address_line2 AS address2,
               m06.m06_name,
               u02.u02_po_box,
               u02.u02_country_id_m05,
               -- m128.m128_ac_type,
               -- m128.m128_ac_no AS m128_ac_no,

               -- m36.m36_swift_code || m128.m128_iban_no AS bank_account_no,
               --u06.u06_iban_no AS bank_account_no,
               m16.m16_swift_code || u06.u06_iban_no AS bank_account_no, -- TODO: Check
               u01.u01_first_name,                       -- m01_c1_other_names
               u01.u01_last_name,
               u01.u01_second_name,
               u01.u01_third_name,
               -- m01.m01_cl_nin,
               u01.u01_gender,
               m05.m05_name,
               m05.m05_code,
               /*CASE
                   WHEN u01.u01_account_category_id_v01 = '2'
                   THEN
                       m01.m01_ca_registration_no
                   WHEN m05.m30_nationality_category = '3'
                   THEN
                       m01.m01_iqama
                   WHEN m30.m30_nationality_category = '2'
                   THEN
                       m01.m01_c1_passport_number
                   ELSE
                       m01.m01_c1_nin
               END
                   AS nin_iqama*/
               u05.u05_id_no AS nin_iqama
          -- m128_forgn.m128_acc_name AS foreignbankaccname,
          -- m128_forgn.m128_ac_no AS foreignbankaccno,
          -- m128_forgn.m128_iban_no AS foreignbankacciban,
          -- m36_forgn.m36_bank_name_1 AS foreignbankname,
          -- (m128_forgn.m128_bank_branch_name || m36_forgn.m36_address) AS foreignbankaddress,
          -- m36_forgn.m36_swift_code AS foreignbankswift,
          -- m36_forgn.m36_aba_routing_no AS foreignbankaba
          FROM u07_trading_account u07,                             -- updated
               u01_customer u01,                                    -- updated
               u02_customer_contact_info u02,                           -- new
               m06_city m06,                                            -- new
               u06_cash_account u06,                                    -- new
               -- m128_customer_bank_accounts m128,
               m60_institute_banks m60,
               m16_bank m16,
               -- m128_customer_bank_accounts m128_forgn,
               m05_country m05,                                     -- updated
               -- m36_banks m36,
               -- m36_banks m36_forgn
               u05_customer_identification u05
         WHERE     u07.u07_id = p_trading_account_id
               AND u07.u07_exchange_code_m01 = p_exchange_code
               AND u01.u01_id = p_cust_id
               -- AND u06.u06_bank_account = m128.m128_id(+)
               AND u02.u02_country_id_m05 = m05.m05_id(+) -- m06_country_id_m05 ??
               AND u01.u01_nationality_id_m05 = m05.m05_id         --(+) -- ??
               AND u06.u06_iban_no = m60.m60_id(+)              -- TODO: Check
               AND m60.m60_bank_id_m16 = m16.m16_id(+)          -- TODO: Check
               -- AND u07.u07_id = NVL (p_trading_account_id, u07.u07_id)

               -- AND m128.m128_bank_id = m36.m36_bank_id(+)
               -- AND u06.u06_forgn_bank_account = m128_forgn.m128_id(+)
               -- AND m128_forgn.m128_bank_id = m36_forgn.m36_bank_id(+)

               AND u01.u01_id = u02.u02_customer_id_u01(+)
               AND u02.u02_is_default = 1
               AND u02.u02_city_id_m06 = m06.m06_id(+)
               AND u07.u07_cash_account_id_u06 = u06.u06_id             -- (+)
               AND u01.u01_id = u05.u05_customer_id_u01(+)
               AND u05.u05_is_default = 1;
END;
/
/
