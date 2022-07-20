CREATE OR REPLACE PROCEDURE dfn_ntp.sp_file_processing_unique_keys (
    p_config_id                   IN     NUMBER,
    p_create_customer             IN     NUMBER,
    p_create_contact_details      IN     NUMBER,
    p_create_id_details           IN     NUMBER,
    p_create_customer_login       IN     NUMBER,
    p_create_bank                 IN     NUMBER,
    p_create_beneficiary          IN     NUMBER,
    p_create_cash_account         IN     NUMBER,
    p_create_trading_account      IN     NUMBER,
    p_customer_id                    OUT NUMBER,
    p_customer_no                    OUT VARCHAR,
    p_identification_id              OUT NUMBER,
    p_contact_id                     OUT NUMBER,
    p_login_id                       OUT NUMBER,
    p_bank_id                        OUT NUMBER,
    p_beneficiary_id                 OUT NUMBER,
    p_cash_account_id                OUT NUMBER,
    p_trading_account_id             OUT NUMBER,
    p_cash_account_display_name      OUT VARCHAR)
IS
    l_cash_account_display_name   VARCHAR (100);
    l_default_currency_code       VARCHAR (5);
BEGIN
    SELECT default_currency_code
      INTO l_default_currency_code
      FROM (SELECT m41_config_id_m40, m41_key, m41_value
              FROM m41_file_processing_job_para
             WHERE m41_config_id_m40 = p_config_id) PIVOT (MAX (m41_value)
                                                    FOR m41_key
                                                    IN  ('DEFAULT_CURRENCY_CODE' default_currency_code));



    IF (p_create_customer = 1)
    THEN
        p_customer_id := fn_get_next_sequnce (pseq_name => 'U01_CUSTOMER');
        p_customer_no := fn_get_mubasher_number;
    ELSE
        p_customer_id := -1;
        p_customer_no := -1;
    END IF;

    IF (p_create_id_details = 1)
    THEN
        p_identification_id :=
            fn_get_next_sequnce (pseq_name => 'U05_CUSTOMER_IDENTIFICATION');
    ELSE
        p_identification_id := -1;
    END IF;

    IF (p_create_contact_details = 1)
    THEN
        p_contact_id :=
            fn_get_next_sequnce (pseq_name => 'U02_CUSTOMER_CONTACT_INFO');
    ELSE
        p_contact_id := -1;
    END IF;

    IF (p_create_customer_login = 1)
    THEN
        p_login_id := fn_get_next_sequnce (pseq_name => 'U09_CUSTOMER_LOGIN');
    ELSE
        p_login_id := -1;
    END IF;

    IF (p_create_bank = 1)
    THEN
        p_bank_id := fn_get_next_sequnce (pseq_name => 'M16_BANK');
    ELSE
        p_bank_id := -1;
    END IF;

    IF (p_create_beneficiary = 1)
    THEN
        p_beneficiary_id :=
            fn_get_next_sequnce (pseq_name => 'U08_CUSTOMER_BENEFICIARY_ACC');
    ELSE
        p_beneficiary_id := -1;
    END IF;

    IF (p_create_cash_account = 1)
    THEN
        p_cash_account_id :=
            fn_get_next_sequnce (pseq_name => 'U06_CASH_ACCOUNT');

        l_cash_account_display_name :=
            'C' || p_cash_account_id || '-' || l_default_currency_code;
        p_cash_account_display_name := l_cash_account_display_name;
    ELSE
        p_cash_account_id := -1;
    END IF;

    IF (p_create_trading_account = 1)
    THEN
        p_trading_account_id :=
            fn_get_next_sequnce (pseq_name => 'U07_TRADING_ACCOUNT');
    ELSE
        p_trading_account_id := -1;
    END IF;
END;
/
