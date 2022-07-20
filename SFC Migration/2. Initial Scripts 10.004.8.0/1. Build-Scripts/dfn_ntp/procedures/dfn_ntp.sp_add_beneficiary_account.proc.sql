CREATE OR REPLACE PROCEDURE dfn_ntp.sp_add_beneficiary_account (
    p_key                        OUT NUMBER,
    p_u01_id                  IN     NUMBER,
    p_u01_first_name          IN     u01_customer.u01_first_name%TYPE,
    p_u08_iban_no             IN     u08_customer_beneficiary_acc.u08_iban_no%TYPE,
    p_user_id                 IN     NUMBER,
    p_institution_id          IN     NUMBER,
    p_default_currency_code   IN     VARCHAR2,
    p_default_currency_id     IN     NUMBER)
IS
    l_sysid          VARCHAR2 (50);
    l_error_reason   NVARCHAR2 (4000);
    ----------------------
    l_u08_id         NUMBER;
    l_m16_id         NUMBER;
    l_bank_cnt       NUMBER;
    l_m03_id         NUMBER;
BEGIN
    SELECT COUNT (m16_id)
      INTO l_bank_cnt
      FROM m16_bank
     WHERE     m16_bank_identifier = TRIM (SUBSTR (p_u08_iban_no, 5, 2))
           AND m16_institute_id_m02 = p_institution_id;

    IF l_bank_cnt = 0
    THEN
        l_m16_id := fn_get_next_sequnce (pseq_name => 'M16_BANK');

        INSERT INTO m16_bank (m16_id,
                              m16_name,
                              m16_name_lang,
                              m16_bank_identifier,
                              m16_swift_code,
                              m16_institute_id_m02,
                              m16_created_by_id_u17,
                              m16_created_date,
                              m16_status_id_v01,
                              m16_status_changed_by_id_u17,
                              m16_status_changed_date,
                              m16_custom_type)
             VALUES (l_m16_id,
                     'UNKNOWN BANK ' || LPAD (l_m16_id, 3, '0'),
                     'UNKNOWN BANK ' || LPAD (l_m16_id, 3, '0'),
                     TRIM (SUBSTR (p_u08_iban_no, 5, 2)),
                     'XXXX' || TRIM (SUBSTR (p_u08_iban_no, 1, 2)) || 'XX',
                     p_institution_id,
                     p_user_id,
                     SYSDATE,
                     2,
                     p_user_id,
                     SYSDATE,
                     1);
    END IF;

    l_u08_id :=
        fn_get_next_sequnce (pseq_name => 'U08_CUSTOMER_BENEFICIARY_ACC');



    IF (p_u08_iban_no IS NOT NULL)
    THEN
        INSERT INTO u08_customer_beneficiary_acc (u08_id,
                                                  u08_institute_id_m02,
                                                  u08_customer_id_u01,
                                                  u08_bank_id_m16,
                                                  u08_account_no,
                                                  u08_iban_no,
                                                  u08_account_type_v01_id,
                                                  u08_currency_code_m03,
                                                  u08_currency_id_m03,
                                                  u08_account_name,
                                                  u08_is_default,
                                                  u08_bank_account_type_v01,
                                                  u08_created_by_id_u17,
                                                  u08_created_date,
                                                  u08_status_id_v01,
                                                  u08_custom_type)
             VALUES (
                        l_u08_id,
                        p_institution_id,
                        p_u01_id,
                        l_m16_id,
                        NVL (
                            LPAD (TRIM (SUBSTR (p_u08_iban_no, 13)), 12, '0'),
                            p_u08_iban_no),
                        p_u08_iban_no,
                        2,     -- u08_account_type_v01_id -- brokerage account
                        p_default_currency_code,                   -- currency
                        p_default_currency_id,
                        NVL (p_u01_first_name, p_u01_id),
                        1,
                        3,          -- u08_bank_account_type_v01 -- investment
                        p_user_id,
                        SYSDATE,
                        2,
                        1);
    END IF;

    p_key := l_u08_id;
END;
/
