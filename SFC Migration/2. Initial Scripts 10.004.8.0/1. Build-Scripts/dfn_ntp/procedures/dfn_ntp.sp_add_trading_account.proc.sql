CREATE OR REPLACE PROCEDURE dfn_ntp.sp_add_trading_account (
    p_key                               OUT NOCOPY NUMBER,
    p_u07_id                            OUT        NUMBER,
    p_u01_id                         IN            NUMBER,
    p_u06_id                         IN            NUMBER,
    p_u07_exchange_account_no        IN            u07_trading_account.u07_exchange_account_no%TYPE,
    p_exchange_id                    IN            NUMBER,
    p_u06_display_name               IN            VARCHAR,
    p_u01_customer_no                IN            u01_customer.u01_customer_no%TYPE,
    p_u01_display_name               IN            u01_customer.u01_display_name%TYPE,
    p_u01_default_id_no              IN            u01_customer.u01_default_id_no%TYPE,
    p_user_id                        IN            NUMBER,
    p_institution_id                 IN            NUMBER,
    p_u07_sharia_compliant           IN            NUMBER,
    p_u07_trading_group_id_m08       IN            NUMBER,
    p_u07_commission_group_id_m22    IN            NUMBER,
    p_u07_cust_settle_group_id_m35   IN            NUMBER,
    p_exchange_code                  IN            VARCHAR)
IS
    /*  l_u07_sharia_compliant           NUMBER;
      l_u07_trading_group_id_m08       NUMBER;
      l_u07_commission_group_id_m22    NUMBER;
      l_u07_cust_settle_group_id_m35   NUMBER;
      l_m01_id                         NUMBER;
      l_exchange_code                  VARCHAR (50);*/
    l_error_reason   NVARCHAR2 (4000);
    l_count          NUMBER;
BEGIN
    p_u07_id := fn_get_next_sequnce (pseq_name => 'U07_TRADING_ACCOUNT');

    /*
        SELECT NVL (m02_enable_sharia_compliant, 0)
          INTO l_u07_sharia_compliant
          FROM m02_institute
         WHERE m02_id = p_institution_id;

        SELECT COUNT (m08_id)
          INTO l_count
          FROM m08_trading_group
         WHERE m08_institute_id_m02 = p_institution_id AND m08_is_default = 1;

        IF (l_count > 0)
        THEN
            SELECT m08_id
              INTO l_u07_trading_group_id_m08
              FROM m08_trading_group
             WHERE m08_institute_id_m02 = p_institution_id AND m08_is_default = 1;
        ELSE
            p_key := -20000;
            l_error_reason := 'Default trading group not found';
            raise_application_error (-20000, l_error_reason);
        END IF;


        SELECT COUNT (m22_id)
          INTO l_count
          FROM m22_commission_group
         WHERE m22_is_default = 1 AND m22_exchange_id_m01 = p_exchange_id;

        IF (l_count > 0)
        THEN
            SELECT m22_id
              INTO l_u07_commission_group_id_m22
              FROM m22_commission_group
             WHERE m22_is_default = 1 AND m22_exchange_id_m01 = p_exchange_id;
        ELSE
            p_key := -20001;
            l_error_reason := 'Default Commission group not found';
            raise_application_error (-20000, l_error_reason);
        END IF;



        SELECT COUNT (m35_id)
          INTO l_count
          FROM m35_customer_settl_group
         WHERE m35_institute_id_m02 = p_institution_id AND m35_is_default = 1;

        IF (l_count > 0)
        THEN
            SELECT m35_id
              INTO l_u07_cust_settle_group_id_m35
              FROM m35_customer_settl_group
             WHERE m35_institute_id_m02 = p_institution_id AND m35_is_default = 1;
        ELSE
            p_key := -20002;
            l_error_reason := 'Default settlement group not found';
            raise_application_error (-20002, l_error_reason);
        END IF;


        SELECT COUNT (m01_id)
          INTO l_count
          FROM m01_exchanges
         WHERE m01_id = p_exchange_id;

        IF (l_count > 0)
        THEN
            SELECT m01_id, m01_exchange_code
              INTO l_m01_id, l_exchange_code
              FROM m01_exchanges
             WHERE m01_id = p_exchange_id;
        ELSE
            p_key := -20003;
            l_error_reason := 'Exchange not found';
            raise_application_error (-20003, l_error_reason);
        END IF;*/


    INSERT INTO u07_trading_account (u07_id,
                                     u07_institute_id_m02,
                                     u07_customer_id_u01,
                                     u07_cash_account_id_u06,
                                     u07_exchange_code_m01,
                                     u07_exchange_id_m01,
                                     u07_display_name_u06,
                                     u07_customer_no_u01,
                                     u07_display_name_u01,
                                     u07_default_id_no_u01,
                                     u07_is_default,
                                     u07_type,
                                     u07_account_category,
                                     u07_trading_enabled,
                                     u07_sharia_compliant,
                                     u07_trading_group_id_m08,
                                     u07_created_by_id_u17,
                                     u07_created_date,
                                     u07_status_id_v01,
                                     u07_status_changed_by_id_u17,
                                     u07_status_changed_date,
                                     u07_commission_group_id_m22,
                                     u07_cust_settle_group_id_m35,
                                     u07_exchange_account_no,
                                     u07_discount_prec_from_date,
                                     u07_custom_type)
         VALUES (p_u07_id,
                 p_institution_id,
                 p_u01_id,
                 p_u06_id,
                 p_exchange_code,
                 p_exchange_id,
                 p_u06_display_name,
                 p_u01_customer_no,
                 p_u01_display_name,
                 p_u01_default_id_no,
                 1,                                          --u07_is_default,
                 1,                             --u07_type, -- fully disclosed
                 2,                    -- u07AccountCategory -- member account
                 1,                                     --u07_trading_enabled,
                 p_u07_sharia_compliant,
                 p_u07_trading_group_id_m08,
                 p_user_id,
                 SYSDATE,
                 2,
                 p_user_id,
                 SYSDATE,
                 p_u07_commission_group_id_m22,
                 p_u07_cust_settle_group_id_m35,
                 p_u07_exchange_account_no,
                 TRUNC (SYSDATE),
                 1                                           --U07_CUSTOM_TYPE
                  );



    p_key := p_u07_id;
END;
/
