
CREATE OR REPLACE PROCEDURE dfn_ntp.sp_process_customer_file (
    p_key                  OUT NUMBER,
    p_counts               OUT VARCHAR,
    p_exchange_id       IN     NUMBER,
    p_user_id           IN     NUMBER,
    p_is_ipo_customer   IN     NUMBER,
    p_institution_id    IN     NUMBER DEFAULT 1,
    p_batch_id          IN     NUMBER)
IS
    l_total_cnt                      NUMBER := 0;
    l_cust_cnt                       NUMBER := 0;
    l_benefi_acc_cnt                 NUMBER := 0;
    l_cash_acc_cnt                   NUMBER := 0;
    l_trad_acc_cnt                   NUMBER := 0;
    ------------
    l_new_cust_cnt                   NUMBER := 0;
    l_new_benefi_acc_cnt             NUMBER := 0;
    l_new_cash_acc_cnt               NUMBER := 0;
    l_new_trad_acc_cnt               NUMBER := 0;
    --------------------

    l_test                           NUMBER := 0;
    l_p_key                          NUMBER;
    l_error_reason                   NVARCHAR2 (4000);
    ------------

    l_u01_id                         NUMBER := 0;
    l_u01_customer_no                u01_customer.u01_customer_no%TYPE;
    l_u01_display_name               u01_customer.u01_display_name%TYPE;
    l_u09_id                         NUMBER;
    l_change_pwd_first_login         NUMBER;
    l_u01_date_of_birth              u01_customer.u01_date_of_birth%TYPE;
    l_u01_title_id_v01               NUMBER;
    l_nationality_default            NUMBER;
    l_issue_location_default         NUMBER;
    l_u08_id                         NUMBER := 0;
    l_u06_id                         NUMBER := 0;
    l_u06_display_name               VARCHAR (100);
    l_u07_id                         NUMBER := 0;
    l_default_currency_code          VARCHAR2 (50);
    l_default_currency_id            NUMBER;
    l_u07_sharia_compliant           NUMBER;
    l_u07_trading_group_id_m08       NUMBER;
    l_u07_commission_group_id_m22    NUMBER;
    l_u07_cust_settle_group_id_m35   NUMBER;
    l_m01_id                         NUMBER;
    l_exchange_code                  VARCHAR (50);
    ---------------
    l_commit_blk_size                NUMBER (5) := 5000;
    l_rec_count                      NUMBER (18) := 0;
    l_count                          NUMBER;
BEGIN
    l_rec_count := 0;

    SELECT m02.m02_change_pwd_on_fir_log
      INTO l_change_pwd_first_login
      FROM m02_institute m02
     WHERE m02.m02_id = p_institution_id;

    SELECT MIN (m05_id)
      INTO l_nationality_default
      FROM m05_country m05
     WHERE m05_code = 'SA';

    SELECT MAX (m14_id)
      INTO l_issue_location_default
      FROM m14_issue_location
     WHERE     m14_country_id_m05 = l_nationality_default
           AND m14_institute_id_m02 = p_institution_id;

    SELECT m03_id, m03_code
      INTO l_default_currency_id, l_default_currency_code
      FROM m03_currency
     WHERE m03_code = 'SAR';

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
        SELECT m01_exchange_code
          INTO l_exchange_code
          FROM m01_exchanges
         WHERE m01_id = p_exchange_id;
    ELSE
        p_key := -20003;
        l_error_reason := 'Exchange not found';
        raise_application_error (-20003, l_error_reason);
    END IF;

    FOR i
        IN (SELECT a.*,
                   NVL (u07.u07_exchange_account_no, -1) AS account_oms,
                   identification_number_oms,
                   NVL (customer_id_oms, -1) AS customer_id_oms,
                   customer_no_oms,
                   customer_display_name_oms,
                   NVL (m05_id, l_nationality_default) AS nationality,
                   NVL (issue_location, l_issue_location_default)
                       AS issue_location,
                   m06_name_oms
              FROM                 (SELECT t84_member AS MEMBER,
                                           LPAD (
                                               TRIM (
                                                   REPLACE (t84_account,
                                                            '"',
                                                            '')),
                                               10,
                                               '0')
                                               AS account,
                                           SUBSTR (t84_reference, 1, 15)
                                               AS reference,
                                           t84_identification_number
                                               AS identification_number,
                                           t84_registry_ident
                                               AS registry_ident,
                                           t84_birth_date AS birth_date,
                                           t84_title AS title,
                                           NVL (t84_long_name, 'UNKNOWN')
                                               AS long_name,
                                           t84_guardian_ident_number
                                               AS guardian_ident_number,
                                           t84_guardian AS guardian,
                                           t84_address_line_one
                                               AS address_line_one,
                                           t84_address_line_two
                                               AS address_line_two,
                                           t84_address_line_three
                                               AS address_line_three,
                                           t84_postal_code AS postal_code,
                                           t84_city AS city,
                                           t84_tax_collection_point
                                               AS tax_collection_point,
                                           t84_country_code AS country_code,
                                           t84_guard_address_line_one
                                               AS guard_address_line_one,
                                           t84_postal_code2 AS postal_code2,
                                           t84_city2 AS city2,
                                           t84_tax_collection_point2
                                               AS tax_collection_point2,
                                           t84_country_code2 AS country_code2,
                                           t84_phone_number_one
                                               AS phone_number_one,
                                           t84_bank_account AS bank_account,
                                           t84_individual_id_one
                                               AS individual_id_one,
                                           t84_individual_id_two
                                               AS individual_id_two,
                                           t84_individual_id_three
                                               AS individual_id_three,
                                           t84_corporate_id_one
                                               AS corporate_id_one,
                                           t84_corporate_id_two
                                               AS corporate_id_two,
                                           t84_citizenship AS citizenship,
                                           t84_gender AS gender,
                                           t84_change_date AS change_date
                                      FROM t84_customer_f
                                     WHERE t84_batch_id_t80 = p_batch_id) a
                               LEFT OUTER JOIN
                                   (SELECT *
                                      FROM u07_trading_account
                                     WHERE u07_exchange_id_m01 =
                                               p_exchange_id) u07
                               ON u07.u07_exchange_account_no = a.account
                           LEFT OUTER JOIN
                               (  SELECT u05_id_no AS identification_number_oms,
                                         u01_institute_id_m02,
                                         MAX (u01_id) AS customer_id_oms,
                                         MAX (u01_customer_no)
                                             AS customer_no_oms,
                                         MAX (u01_display_name)
                                             AS customer_display_name_oms
                                    FROM     u01_customer u01
                                         JOIN
                                             u05_customer_identification u05
                                         ON     u01.u01_id =
                                                    u05.u05_customer_id_u01
                                            AND u05.u05_identity_type_id_m15 =
                                                    1
                                   WHERE u01_institute_id_m02 =
                                             p_institution_id
                                GROUP BY u05_id_no, u01_institute_id_m02) u01
                           ON u01.identification_number_oms =
                                  a.identification_number
                       LEFT OUTER JOIN
                               (  SELECT m05_external_ref,
                                         MAX (m05_id) AS m05_id
                                    FROM m05_country m05
                                GROUP BY m05_external_ref) m05
                           LEFT OUTER JOIN
                               (  SELECT m14_country_id_m05,
                                         m14_institute_id_m02,
                                         MAX (m14_id) AS issue_location
                                    FROM m14_issue_location
                                   WHERE m14_institute_id_m02 =
                                             p_institution_id
                                GROUP BY m14_country_id_m05,
                                         m14_institute_id_m02) m14
                           ON m14.m14_country_id_m05 = m05.m05_id
                       ON m05.m05_external_ref = a.country_code
                   LEFT OUTER JOIN
                       (  SELECT m06_country_id_m05,
                                 UPPER (m06_name) AS m06_name_oms
                            FROM m06_city m06
                        GROUP BY m06_country_id_m05, UPPER (m06_name)) m06
                   ON     m06.m06_country_id_m05 = m05.m05_id
                      AND UPPER (m06_name_oms) = UPPER (a.city))
    LOOP
        -- check trading accounts
        /*  SELECT COUNT (u07.u07_exchange_account_no)
            INTO l_trad_acc_cnt
            FROM u07_trading_account u07
           WHERE     u07.u07_exchange_id_m01 = p_exchange_id
                 AND u07.u07_exchange_account_no = i.account;*/

        l_total_cnt := l_total_cnt + 1;


        IF i.account_oms = -1
        THEN
            --  l_u01_id := -1;

            -- check customer
            /*  FOR j IN (SELECT u01_id, u01_customer_no, u01_display_name
                          FROM     u01_customer u01
                               JOIN
                                   u05_customer_identification u05
                               ON     u01.u01_id = u05.u05_customer_id_u01
                                  AND u05.u05_id_no = i.identification_number
                                  AND u05.u05_identity_type_id_m15 = 1 -- TODO need to check ID type
                                  AND u01.u01_institute_id_m02 =
                                          p_institution_id)
              LOOP
                  -- assign existing customer detail
                  l_u01_id := j.u01_id;
                  l_u01_customer_no := j.u01_customer_no;
                  l_u01_display_name := j.u01_display_name;
              END LOOP;
  */


            IF i.customer_id_oms = -1
            THEN
                l_u01_date_of_birth :=
                    CASE
                        WHEN i.birth_date IS NULL THEN TRUNC (SYSDATE)
                        WHEN i.birth_date = 0 THEN TRUNC (SYSDATE)
                        ELSE TO_DATE (TO_CHAR (i.birth_date), 'yyyymmdd')
                    END;



                dfn_ntp.sp_add_customer_account (
                    p_key                         => l_p_key,
                    p_u01_id                      => l_u01_id,
                    p_u01_customer_no             => l_u01_customer_no,
                    p_u09_id                      => l_u09_id,
                    p_u05_id_no                   => i.identification_number,
                    p_u01_external_ref_no         => i.reference,
                    p_institution_id              => p_institution_id,
                    p_u01_first_name              => i.long_name,
                    p_u01_last_name               => i.long_name,
                    p_u09_is_first_time           => l_change_pwd_first_login,
                    p_u02_mobile                  => i.phone_number_one,
                    p_u02_address_line1           => i.address_line_one,
                    p_u02_address_line2           => i.address_line_two,
                    p_u02_zip_code                => i.postal_code,
                    p_country_code                => i.country_code,
                    p_u02_city                    => i.m06_name_oms,
                    p_u01_gender                  => TO_CHAR (i.gender),
                    p_u01_title                   => i.title,
                    p_u01_date_of_birth           => l_u01_date_of_birth,
                    p_user_id                     => p_user_id,
                    p_is_ipo_customer             => p_is_ipo_customer,
                    p_nationality                 => i.nationality,
                    p_u05_issue_location_id_m14   => i.issue_location);


                l_new_cust_cnt := l_new_cust_cnt + 1;
                dfn_ntp.sp_add_beneficiary_account (
                    p_key                     => l_p_key,
                    p_u01_id                  => l_u01_id,
                    p_u01_first_name          => i.long_name,
                    p_u08_iban_no             => i.bank_account,
                    p_user_id                 => p_user_id,
                    p_institution_id          => p_institution_id,
                    p_default_currency_code   => l_default_currency_code,
                    p_default_currency_id     => l_default_currency_id);

                l_new_benefi_acc_cnt := l_new_benefi_acc_cnt + 1;


                dfn_ntp.sp_add_cash_account (
                    p_key                     => l_p_key,
                    p_u06_id                  => l_u06_id,
                    p_u06_display_name        => l_u06_display_name,
                    p_u01_id                  => l_u01_id,
                    p_u01_customer_no         => l_u01_customer_no,
                    p_u01_display_name        => i.long_name || ' ' || i.long_name,
                    p_u01_default_id_no       => NULL,
                    p_user_id                 => p_user_id,
                    p_institution_id          => p_institution_id,
                    p_default_currency_code   => l_default_currency_code,
                    p_default_currency_id     => l_default_currency_id);


                l_new_cash_acc_cnt := l_new_cash_acc_cnt + 1;


                dfn_ntp.sp_add_trading_account (
                    p_key                            => p_key,
                    p_u07_id                         => l_u07_id,
                    p_u01_id                         => l_u01_id,
                    p_u06_id                         => l_u06_id,
                    p_u07_exchange_account_no        => i.account,
                    p_exchange_id                    => p_exchange_id,
                    p_u06_display_name               => l_u06_display_name,
                    p_u01_customer_no                => l_u01_customer_no,
                    p_u01_display_name               => i.long_name,
                    p_u01_default_id_no              => i.identification_number,
                    p_user_id                        => p_user_id,
                    p_institution_id                 => p_institution_id,
                    p_u07_sharia_compliant           => l_u07_sharia_compliant,
                    p_u07_trading_group_id_m08       => l_u07_trading_group_id_m08,
                    p_u07_commission_group_id_m22    => l_u07_commission_group_id_m22,
                    p_u07_cust_settle_group_id_m35   => l_u07_cust_settle_group_id_m35,
                    p_exchange_code                  => l_exchange_code);


                l_new_trad_acc_cnt := l_new_trad_acc_cnt + 1;
            ELSE
                -- check beneficiary accounts
                SELECT COUNT (u08.u08_id)
                  INTO l_benefi_acc_cnt
                  FROM u08_customer_beneficiary_acc u08
                 WHERE     u08.u08_iban_no = i.bank_account
                       AND u08.u08_customer_id_u01 = l_u01_id;


                IF l_benefi_acc_cnt > 0
                THEN
                    -- assign existing beneficiary account
                    SELECT MAX (u08.u08_id)
                      INTO l_u08_id
                      FROM u08_customer_beneficiary_acc u08
                     WHERE     u08.u08_iban_no = i.bank_account
                           AND u08.u08_customer_id_u01 = l_u01_id;
                ELSE
                    -- create beneficiary account

                    dfn_ntp.sp_add_beneficiary_account (
                        p_key                     => l_p_key,
                        p_u01_id                  => l_u01_id,
                        p_u01_first_name          => i.long_name,
                        p_u08_iban_no             => i.bank_account,
                        p_user_id                 => p_user_id,
                        p_institution_id          => p_institution_id,
                        p_default_currency_code   => l_default_currency_code,
                        p_default_currency_id     => l_default_currency_id);

                    l_new_benefi_acc_cnt := l_new_benefi_acc_cnt + 1;
                END IF;


                -- create cash and trading account

                dfn_ntp.sp_add_cash_account (
                    p_key                     => l_p_key,
                    p_u06_id                  => l_u06_id,
                    p_u06_display_name        => l_u06_display_name,
                    p_u01_id                  => l_u01_id,
                    p_u01_customer_no         => l_u01_customer_no,
                    p_u01_display_name        => l_u01_display_name,
                    p_u01_default_id_no       => i.identification_number,
                    p_user_id                 => p_user_id,
                    p_institution_id          => p_institution_id,
                    p_default_currency_code   => l_default_currency_code,
                    p_default_currency_id     => l_default_currency_id);

                l_new_cash_acc_cnt := l_new_cash_acc_cnt + 1;


                dfn_ntp.sp_add_trading_account (
                    p_key                            => l_p_key,
                    p_u07_id                         => l_u07_id,
                    p_u01_id                         => l_u01_id,
                    p_u06_id                         => l_u06_id,
                    p_u07_exchange_account_no        => i.account,
                    p_exchange_id                    => p_exchange_id,
                    p_u06_display_name               => l_u06_display_name,
                    p_u01_customer_no                => l_u01_customer_no,
                    p_u01_display_name               => l_u01_display_name,
                    p_u01_default_id_no              => i.identification_number,
                    p_user_id                        => p_user_id,
                    p_institution_id                 => p_institution_id,
                    p_u07_sharia_compliant           => l_u07_sharia_compliant,
                    p_u07_trading_group_id_m08       => l_u07_trading_group_id_m08,
                    p_u07_commission_group_id_m22    => l_u07_commission_group_id_m22,
                    p_u07_cust_settle_group_id_m35   => l_u07_cust_settle_group_id_m35,
                    p_exchange_code                  => l_exchange_code);

                l_new_trad_acc_cnt := l_new_trad_acc_cnt + 1;
            END IF;
        END IF;

        --end logic

        l_rec_count := l_rec_count + 1;

        IF MOD (l_rec_count, l_commit_blk_size) = 0
        THEN
            COMMIT;
        END IF;
    END LOOP;

    COMMIT;


    p_key := 1;

    p_counts :=
           l_total_cnt
        || '|'
        || l_new_cust_cnt
        || '|'
        || l_new_benefi_acc_cnt
        || '|'
        || l_new_cash_acc_cnt
        || '|'
        || l_new_trad_acc_cnt;
EXCEPTION
    WHEN OTHERS
    THEN
        ROLLBACK;
        l_error_reason := SUBSTR (SQLERRM, 1, 512);
        DBMS_OUTPUT.put_line (p_key);

        IF (p_key > 0)
        THEN
            p_key := -1;
        END IF;
END;
/
