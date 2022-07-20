CREATE OR REPLACE PACKAGE dfn_ntp.pkg_dc_synchronize
IS
    PROCEDURE sp_add_customer (pkey                            OUT VARCHAR,
                               p_ret_sts                       OUT NUMBER, -- default to failure
                               p_ret_msg                       OUT VARCHAR2,
                               p_u01_id                        OUT NUMBER,
                               pu01_customer_no             IN     VARCHAR2,
                               pu01_display_name            IN     VARCHAR2,
                               pu01_display_name_lang       IN     VARCHAR2,
                               pu01_gender                  IN     VARCHAR2,
                               pu01_date_of_birth           IN     VARCHAR2,
                               pu01_is_ipo_customer         IN     VARCHAR2,
                               pu01_vat_waive_off           IN     VARCHAR2,
                               pu01_tax_ref                 IN     VARCHAR2,
                               pu02_mobile                  IN     VARCHAR2,
                               pu02_email                   IN     VARCHAR2,
                               pu01_category_m89            IN     VARCHAR2,
                               pu01_kyc_next_review         IN     VARCHAR2,
                               pu05_id_no                   IN     VARCHAR2,
                               pu02_address_line1           IN     VARCHAR2,
                               pu02_address_line2           IN     VARCHAR2,
                               pu02_address_line3           IN     VARCHAR2,
                               pu02_address_line4           IN     VARCHAR2,
                               pu02_address_line1_lang      IN     VARCHAR2,
                               pu02_address_line2_lang      IN     VARCHAR2,
                               pu02_address_line3_lang      IN     VARCHAR2,
                               pu02_address_line4_lang      IN     VARCHAR2,
                               pu02_zip_code                IN     VARCHAR2,
                               pu02_po_box                  IN     VARCHAR2,
                               pu05_expiry_date             IN     VARCHAR2,
                               pu01_nationality_id_m05      IN     VARCHAR2,
                               pu01_preferred_lang_id_v01   IN     VARCHAR2,
                               pu02_country_id_m05          IN     VARCHAR2,
                               pu17_id                      IN     NUMBER,
                               pu01_customer_blk_cd         IN     NUMBER,
                               pu01_customer_type           IN     VARCHAR2,
                               pu01_customer_sub_type       IN     VARCHAR2,
                               pu05_identity_type_id_m15    IN     VARCHAR2,
                               pcism_ro_cd                  IN     VARCHAR2,
                               pcism_seq_nb                 IN     VARCHAR2);

    PROCEDURE sp_update_customer (
        p_ret_sts                       OUT NUMBER,      -- default to failure
        p_ret_msg                       OUT VARCHAR2,
        p_u01_id                        OUT NUMBER,
        pu01_customer_no             IN     VARCHAR2,
        pu01_display_name            IN     VARCHAR2,
        pu01_display_name_lang       IN     VARCHAR2,
        pu01_gender                  IN     VARCHAR2,
        pu01_date_of_birth           IN     VARCHAR2,
        pu01_is_ipo_customer         IN     VARCHAR2,
        pu01_vat_waive_off           IN     VARCHAR2,
        pu01_tax_ref                 IN     VARCHAR2,
        pu02_mobile                  IN     VARCHAR2,
        pu02_email                   IN     VARCHAR2,
        pu01_category_m89            IN     VARCHAR2,
        pu01_kyc_next_review         IN     VARCHAR2,
        pu05_id_no                   IN     VARCHAR2,
        pu05_identity_type_id_m15    IN     VARCHAR2,
        pu02_address_line1           IN     VARCHAR2,
        pu02_address_line2           IN     VARCHAR2,
        pu02_address_line3           IN     VARCHAR2,
        pu02_address_line4           IN     VARCHAR2,
        pu02_address_line1_lang      IN     VARCHAR2,
        pu02_address_line2_lang      IN     VARCHAR2,
        pu02_address_line3_lang      IN     VARCHAR2,
        pu02_address_line4_lang      IN     VARCHAR2,
        pu02_zip_code                IN     VARCHAR2,
        pu02_po_box                  IN     VARCHAR2,
        pu05_expiry_date             IN     VARCHAR2,
        pu01_nationality_id_m05      IN     VARCHAR2,
        pu01_preferred_lang_id_v01   IN     VARCHAR2,
        pu02_country_id_m05          IN     VARCHAR2,
        pu17_id                      IN     NUMBER,
        pu01_customer_blk_cd         IN     NUMBER,
        pu01_customer_type           IN     VARCHAR2,
        pu01_customer_sub_type       IN     VARCHAR2,
        pcism_seq_nb                 IN     VARCHAR2);

    PROCEDURE add_cism_log (
        pa50_message             IN VARCHAR2,
        pa50_status              IN VARCHAR2,
        pa50_update_code         IN VARCHAR2 DEFAULT NULL,
        pa50_created_by_id_u17   IN NUMBER DEFAULT NULL,
        pa50_account_no          IN VARCHAR2 DEFAULT NULL,
        pa50_message_id          IN VARCHAR2 DEFAULT NULL);


    PROCEDURE sp_add_audit (pa06_user_id_u17       IN NUMBER,
                            pa06_activity_id_m82   IN NUMBER,
                            pa06_description       IN VARCHAR,
                            pa06_reference_no      IN VARCHAR,
                            pa06_customer_id_u01      NUMBER,
                            pa06_login_id_u09      IN NUMBER);



    PROCEDURE sp_create_cash_account (
        pkey                            OUT VARCHAR,
        p_ret_sts                       OUT NUMBER,      -- default to failure
        p_ret_msg                       OUT VARCHAR2,
        p_u01_id                        OUT NUMBER,
        p_u06_id                        OUT NUMBER,
        pcustomer_no                 IN     VARCHAR,
        pu06_currency                IN     VARCHAR2,
        pu06_investment_account_no   IN     VARCHAR2,
        pu01_vat_waive_off           IN     VARCHAR2,
        pcism_trn_typ                IN     VARCHAR2,
        pcism_seq_nb                 IN     VARCHAR2,
        pu06_block_status_b          IN     NUMBER,
        pu17_id                      IN     NUMBER,
        pcism_open_port              IN     VARCHAR2);


    PROCEDURE sp_update_cash_account (
        pkey                            OUT VARCHAR,
        p_ret_sts                       OUT NUMBER,      -- default to failure
        p_ret_msg                       OUT VARCHAR2,
        p_u01_id                        OUT NUMBER,
        p_u06_id                        OUT NUMBER,
        pcustomer_no                 IN     VARCHAR,
        pu06_investment_account_no   IN     VARCHAR2,
        pu01_vat_waive_off           IN     VARCHAR2,
        pcism_trn_typ                IN     VARCHAR2,
        pcism_seq_nb                 IN     VARCHAR2,
        pu06_block_status_b          IN     NUMBER,
        pu17_id                      IN     NUMBER);


    PROCEDURE sp_update_power_of_attorney (
        pkey                     OUT VARCHAR,
        p_ret_sts                OUT NUMBER,             -- default to failure
        p_ret_msg                OUT VARCHAR2,
        p_u01_id                 OUT NUMBER,
        p_u47_id                 OUT NUMBER,
        pu17_id               IN     NUMBER,
        pu01_customer_no      IN     VARCHAR2,
        pcism_trn_typ         IN     VARCHAR2,
        pcism_seq_nb          IN     VARCHAR2,
        pu47_poa_name         IN     VARCHAR2,
        pu47_id_no            IN     VARCHAR2,
        pu47_id_expiry_date   IN     VARCHAR2,
        pu49_privilege        IN     VARCHAR2,
        pu08_status_id_v01    IN     VARCHAR2);

    PROCEDURE sp_beneficiary_acc_inq (pcism_trn_typ   IN     VARCHAR2, --v_inq_typ,
                                      p08_id          IN     NUMBER,
                                      pu08_iban_no    IN     VARCHAR2, --v_cust_acc_nb,
                                      p_ret_sts          OUT NUMBER, -- default to failure
                                      p_ret_msg          OUT VARCHAR2);


    PROCEDURE sp_customer_block (pkey                  OUT VARCHAR,
                                 p_ret_sts             OUT NUMBER, -- default to failure
                                 p_ret_msg             OUT VARCHAR2,
                                 p_u01_id              OUT NUMBER,
                                 pu01_customer_no   IN     VARCHAR,
                                 pcism_seq_nb       IN     VARCHAR,
                                 p_block_code       IN     NUMBER,
                                 pu17_id            IN     NUMBER);

    PROCEDURE sp_account_block (pkey                            OUT VARCHAR,
                                p_ret_sts                       OUT NUMBER, -- default to failure
                                p_ret_msg                       OUT VARCHAR2,
                                p_u01_id                        OUT NUMBER,
                                p_u06_id                        OUT NUMBER,
                                pu01_customer_no             IN     VARCHAR,
                                pu06_investment_account_no   IN     VARCHAR2,
                                pcism_seq_nb                 IN     VARCHAR,
                                p_block_code                 IN     NUMBER,
                                pu17_id                      IN     NUMBER);



    PROCEDURE sp_add_beneficiary_account (
        pkey                       OUT VARCHAR,
        p_ret_sts                  OUT NUMBER,           -- default to failure
        p_ret_msg                  OUT VARCHAR2,
        p_u01_id                   OUT NUMBER,
        p_u06_id                   OUT NUMBER,
        p_u08_id                   OUT NUMBER,
        pu01_customer_no        IN     VARCHAR2,
        pu08_sequence_no_b      IN     VARCHAR2,
        pcism_seq_nb            IN     VARCHAR2,
        u06_currency_code_m03   IN     VARCHAR2,
        pu08_status_id_v01      IN     VARCHAR2,
        pu08_bank_id_m16        IN     VARCHAR2,
        pu08_iban_no            IN     VARCHAR2,
        pu08_bank_branch_name   IN     VARCHAR2,
        pu08_account_name       IN     VARCHAR2,
        pcism_trn_typ           IN     VARCHAR2,
        pu17_id                 IN     NUMBER,
        pm08_id                 IN     NUMBER,
        pu05_id_no              IN     VARCHAR2);

    PROCEDURE sp_sync_customer_master (cism_seq_nb   IN     VARCHAR2,
                                       p_ret_sts        OUT NUMBER, -- default to failure
                                       p_ret_msg        OUT VARCHAR2,
                                       p_u01_id         OUT NUMBER,
                                       p_u06_id         OUT NUMBER,
                                       p_u47_id         OUT NUMBER,
                                       p_u08_id         OUT NUMBER);

    PROCEDURE sp_update_currency_rate;

    PROCEDURE sp_int_manua_customer_update (
        paccount_number     IN     VARCHAR2,
        ptransaction_code   IN     VARCHAR2,
        puser_id            IN     NUMBER,
        pis_customer_no     IN     NUMBER DEFAULT 1,
        pcash_account_id       OUT NUMBER,
        pcus_account_id        OUT NUMBER,
        pmessage               OUT VARCHAR2,
        pkey                   OUT VARCHAR2);
END;
/


CREATE OR REPLACE PACKAGE BODY dfn_ntp.pkg_dc_synchronize
IS
    PROCEDURE add_cism_log (
        pa50_message             IN VARCHAR2,
        pa50_status              IN VARCHAR2,
        pa50_update_code         IN VARCHAR2 DEFAULT NULL,
        pa50_created_by_id_u17   IN NUMBER DEFAULT NULL,
        pa50_account_no          IN VARCHAR2 DEFAULT NULL,
        pa50_message_id          IN VARCHAR2 DEFAULT NULL)
    IS
        l_user_id   NUMBER := 0;
    BEGIN
        l_user_id := pa50_created_by_id_u17;

        IF pa50_created_by_id_u17 IS NULL
        THEN
            SELECT u17.u17_id
              INTO l_user_id
              FROM u17_employee u17
             WHERE u17.u17_login_name = 'INTEGRATION_USER';
        END IF;

        INSERT INTO a50_integration_messages_b (a50_id,
                                                a50_message_id,
                                                a50_message,
                                                a50_status,
                                                a50_created_date,
                                                a50_created_by_id_u17,
                                                a50_update_code,
                                                a50_account_no)
             VALUES (seq_a50_id_b.NEXTVAL,
                     DECODE (pa50_message_id, NULL, 'CISM', pa50_message_id),
                     pa50_message,
                     pa50_status,
                     SYSDATE,
                     l_user_id,
                     pa50_update_code,
                     pa50_account_no);
    END;

    PROCEDURE sp_add_beneficiary_account (
        pkey                       OUT VARCHAR,
        p_ret_sts                  OUT NUMBER,           -- default to failure
        p_ret_msg                  OUT VARCHAR2,
        p_u01_id                   OUT NUMBER,
        p_u06_id                   OUT NUMBER,
        p_u08_id                   OUT NUMBER,
        pu01_customer_no        IN     VARCHAR2,
        pu08_sequence_no_b      IN     VARCHAR2,
        pcism_seq_nb            IN     VARCHAR2,
        u06_currency_code_m03   IN     VARCHAR2,
        pu08_status_id_v01      IN     VARCHAR2,
        pu08_bank_id_m16        IN     VARCHAR2,
        pu08_iban_no            IN     VARCHAR2,
        pu08_bank_branch_name   IN     VARCHAR2,
        pu08_account_name       IN     VARCHAR2,
        pcism_trn_typ           IN     VARCHAR2,
        pu17_id                 IN     NUMBER,
        pm08_id                 IN     NUMBER,
        pu05_id_no              IN     VARCHAR2)
    IS
        l_cust_count      NUMBER := 0;
        l_u08_id          NUMBER := 0;
        l_m16_id          NUMBER := 0;
        l_m03_id          NUMBER := 0;
        l_ben_curr        VARCHAR (10);
        l_reject_reason   VARCHAR (100);
    BEGIN
        SELECT COUNT (*)
          INTO l_cust_count
          FROM u01_customer u01
         WHERE u01_customer_no = pu01_customer_no;

        p_ret_sts := 0;

        IF (l_cust_count = 0)
        THEN
            p_ret_msg := 'Customer Not Found';
            add_cism_log (
                   'sequence no >> '
                || pcism_seq_nb
                || 'Block Customer, '
                || p_ret_msg,
                l_cust_count);
            p_ret_sts := 1;

            RETURN;
        END IF;

        IF (   pcism_trn_typ = 'CRTBEN'
            OR pcism_trn_typ = 'UPDBEN'
            OR pcism_trn_typ = 'REFBEN')
        THEN
            SELECT u01_id
              INTO p_u01_id
              FROM u01_customer u01
             WHERE u01_customer_no = pu01_customer_no;


            SELECT COUNT (u08_iban_no)
              INTO l_cust_count
              FROM u08_customer_beneficiary_acc a
             WHERE     a.u08_customer_id_u01 = p_u01_id
                   AND u08_sequence_no_b = pu08_sequence_no_b
                   AND u08_status_id_v01 = 2;

            SELECT a.m03_id
              INTO l_m03_id
              FROM m03_currency a
             WHERE a.m03_code = u06_currency_code_m03;

            IF (l_cust_count > 0 AND pcism_trn_typ = 'CRTBEN')
            THEN
                p_ret_msg := 'Beneficiay Account Already Available';
                add_cism_log (
                       'sequence no >> '
                    || pcism_seq_nb
                    || 'Beneficiay Account, '
                    || p_ret_msg
                    || ' Sequence '
                    || pu08_sequence_no_b
                    || ' IBAN No '
                    || pu08_iban_no,
                    l_cust_count);
                p_ret_sts := 1;

                RETURN;
            END IF;



            SELECT m16_id
              INTO l_m16_id
              FROM m16_bank
             WHERE m16_external_ref = pu08_bank_id_m16;


            IF (pcism_trn_typ = 'CRTBEN')
            THEN
                SELECT fn_get_next_sequnce ('U08_CUSTOMER_BENEFICIARY_ACC')
                  INTO l_u08_id
                  FROM DUAL;

                INSERT
                  INTO u08_customer_beneficiary_acc (
                           u08_id,
                           u08_institute_id_m02,
                           u08_customer_id_u01,
                           u08_bank_id_m16,
                           u08_account_no,
                           u08_account_type_v01_id,
                           u08_currency_code_m03,
                           u08_account_name,
                           u08_is_default,
                           u08_created_by_id_u17,
                           u08_created_date,
                           u08_status_id_v01,
                           u08_iban_no,
                           u08_status_changed_by_id_u17,
                           u08_status_changed_date,
                           u08_currency_id_m03,
                           u08_bank_account_type_v01,
                           u08_is_foreign_bank_acc,
                           u08_custom_type,
                           u08_bank_branch_name,
                           u08_sequence_no_b,
                           u08_id_type_m15,
                           u08_id_no)
                VALUES (l_u08_id,                                     --u08_id
                        1,                              --u08_institute_id_m02
                        p_u01_id,                        --u08_customer_id_u01
                        l_m16_id,                            --u08_bank_id_m16
                        pu08_iban_no,                         --u08_account_no
                        DECODE (pu08_bank_id_m16,  '55', 2,  '00', 1,  3), --u08_account_type_v01_id
                        u06_currency_code_m03,         --u08_currency_code_m03
                        pu08_account_name,                  --u08_account_name
                        0,                                    --u08_is_default
                        pu17_id,                       --u08_created_by_id_u17
                        SYSDATE,                            --u08_created_date
                        DECODE (pu08_status_id_v01, 'Y', 2, 1), --u08_status_id_v01
                        pu08_iban_no,                            --u08_iban_no
                        pu17_id,                --u08_status_changed_by_id_u17
                        SYSDATE,                     --u08_status_changed_date
                        l_m03_id,                        --u08_currency_id_m03
                        1,                         --u08_bank_account_type_v01
                        0,                           --u08_is_foreign_bank_acc
                        '1',                                 --u08_custom_type
                        pu08_bank_branch_name,          --u08_bank_branch_name
                        pu08_sequence_no_b,                --u08_sequence_no_b
                        1,                                   --U08_ID_TYPE_M15
                        pu05_id_no                                 --U08_ID_NO
                                  );

                p_u08_id := l_u08_id;
                sp_add_audit (
                    pu17_id,
                    346,
                       'sequence no >> '
                    || pcism_seq_nb
                    || 'Customer Beneficiery Account Created from CRM '
                    || pu08_iban_no,
                    p_u01_id,
                    p_u01_id,
                    0);
            ELSE
                UPDATE u08_customer_beneficiary_acc
                   SET u08_status_id_v01 =
                           CASE
                               WHEN pu08_status_id_v01 = 'Y' THEN 2
                               ELSE 3
                           END,
                       u08_account_no = pu08_iban_no,
                       u08_iban_no = pu08_iban_no,
                       u08_account_name = pu08_account_name,
                       u08_status_changed_date = SYSDATE,
                       u08_status_changed_by_id_u17 = pu17_id
                 WHERE     u08_sequence_no_b = pu08_sequence_no_b
                       AND u08_customer_id_u01 = p_u01_id;

                SELECT u08_id
                  INTO p_u08_id
                  FROM u08_customer_beneficiary_acc a
                 WHERE     a.u08_customer_id_u01 = p_u01_id
                       AND u08_sequence_no_b = pu08_sequence_no_b
                       AND u08_status_id_v01 = 2;


                sp_add_audit (
                    pu17_id,
                    347,
                       'sequence no >> '
                    || pcism_seq_nb
                    || 'Update Beneficiary Account '
                    || pu08_iban_no
                    || ' '
                    || l_reject_reason,
                    p_u01_id,
                    p_u01_id,
                    0);
            END IF;
        ELSIF (pcism_trn_typ = 'DELBEN')
        THEN
            SELECT u01_id
              INTO p_u01_id
              FROM u01_customer u01
             WHERE u01_customer_no = pu01_customer_no;

            SELECT u08_id
              INTO p_u08_id
              FROM u08_customer_beneficiary_acc a
             WHERE     a.u08_customer_id_u01 = p_u01_id
                   AND u08_sequence_no_b = pu08_sequence_no_b
                   AND u08_status_id_v01 = 2;

            UPDATE u08_customer_beneficiary_acc
               SET u08_status_id_v01 = 5,
                   u08_status_changed_date = SYSDATE,
                   u08_status_changed_by_id_u17 = pu17_id
             WHERE     u08_sequence_no_b = pu08_sequence_no_b
                   AND u08_customer_id_u01 = p_u01_id;

            sp_add_audit (
                pu17_id,
                347,
                   'sequence no >> '
                || pcism_seq_nb
                || 'Delete Beneficiary Account '
                || pu08_iban_no,
                p_u01_id,
                p_u01_id,
                0);
        ELSE
            IF (pu08_status_id_v01 = 'A')
            THEN
                l_reject_reason :=
                    'Invalid Beneficiary Account or Account Not Found.';
            ELSIF (pu08_status_id_v01 = 'C')
            THEN
                l_reject_reason := 'Invalid Customer Code.';
            ELSIF (pu08_status_id_v01 = 'J')
            THEN
                l_reject_reason :=
                    'Beneficiary Account Validation Process Failed.';
            ELSIF (pu08_status_id_v01 = 'E')
            THEN
                l_reject_reason :=
                    'Error in Beneficiary A/c Validation process.';
            END IF;

            sp_add_audit (
                pu17_id,
                347,
                   'sequence no >> '
                || pcism_seq_nb
                || 'Update Beneficiary Account '
                || pu08_iban_no
                || ' '
                || l_reject_reason,
                p_u01_id,
                p_u01_id,
                0);

            UPDATE u08_customer_beneficiary_acc
               SET u08_account_no = pu08_iban_no,
                   u08_iban_no = pu08_iban_no,
                   u08_account_name = pu08_account_name,
                   u08_status_id_v01 =
                       CASE WHEN pu08_status_id_v01 = 'Y' THEN 2 ELSE 3 END,
                   u08_remarks = l_reject_reason,
                   u08_id_no = pu05_id_no,
                   u08_status_changed_date = SYSDATE,
                   u08_status_changed_by_id_u17 = pu17_id
             WHERE u08_id = pm08_id;

            SELECT u08_id
              INTO p_u08_id
              FROM u08_customer_beneficiary_acc a
             WHERE     a.u08_customer_id_u01 = p_u01_id
                   AND u08_sequence_no_b = pu08_sequence_no_b
                   AND u08_status_id_v01 = 2;
        END IF;

        IF pu08_bank_id_m16 = 55 AND l_u08_id > 0
        THEN
            pkg_dc_synchronize.sp_beneficiary_acc_inq (pcism_trn_typ,
                                                       l_u08_id,
                                                       pu08_iban_no,
                                                       p_ret_sts,
                                                       p_ret_msg);
        END IF;

        pkey := p_u01_id || ',' || TRIM (0);
    END;


    PROCEDURE sp_account_block (pkey                            OUT VARCHAR,
                                p_ret_sts                       OUT NUMBER, -- default to failure
                                p_ret_msg                       OUT VARCHAR2,
                                p_u01_id                        OUT NUMBER,
                                p_u06_id                        OUT NUMBER,
                                pu01_customer_no             IN     VARCHAR,
                                pu06_investment_account_no   IN     VARCHAR2,
                                pcism_seq_nb                 IN     VARCHAR,
                                p_block_code                 IN     NUMBER,
                                pu17_id                      IN     NUMBER)
    IS
        l_block_code   NUMBER (10);
        l_cust_count   NUMBER := 0;
    BEGIN
        l_block_code := NVL (p_block_code, 2);  --NULL consider as debit block



        SELECT COUNT (*)
          INTO l_cust_count
          FROM u01_customer u01
         WHERE u01_customer_no = pu01_customer_no;

        IF (l_cust_count = 0)
        THEN
            p_ret_msg := 'Customer Not Found';
            add_cism_log (
                   'sequence no >> '
                || pcism_seq_nb
                || 'Block Customer, '
                || p_ret_msg,
                l_cust_count);
            p_ret_sts := 1;

            RETURN;
        END IF;


        SELECT COUNT (u06_investment_account_no)
          INTO l_cust_count
          FROM u06_cash_account a
         WHERE a.u06_investment_account_no = pu06_investment_account_no;

        IF (l_cust_count = 0)
        THEN
            p_ret_msg := 'Cash Account Not Found';
            add_cism_log (
                   'sequence no >> '
                || pcism_seq_nb
                || 'Block Cash Account, '
                || p_ret_msg,
                l_cust_count);
            p_ret_sts := 1;

            RETURN;
        END IF;

        -- block status restriction pending


        UPDATE u06_cash_account
           SET u06_block_status_b = l_block_code
         WHERE u06_investment_account_no = pu06_investment_account_no;

        SELECT u01.u01_id, u06.u06_id
          INTO p_u01_id, p_u06_id
          FROM u01_customer u01, u06_cash_account u06
         WHERE     u01_customer_no = pu01_customer_no
               AND u06.u06_customer_id_u01 = u01.u01_id
               AND u06.u06_investment_account_no = pu06_investment_account_no;

        IF (l_block_code != 1)
        THEN
            sp_add_cash_restrictions (10,
                                      p_u06_id,
                                      'Restricted from CRM Integration',
                                      NULL,
                                      9);
            sp_add_cash_restrictions (11,
                                      p_u06_id,
                                      'Restricted from CRM Integration',
                                      NULL,
                                      9);

            sp_add_audit (
                pu17_id,
                363,
                   'sequence no >> '
                || pcism_seq_nb
                || 'Restricted from CRM Integration  '
                || pu06_investment_account_no
                || ' - '
                || l_block_code,
                p_u01_id,
                p_u01_id,
                0);

            FOR i IN (SELECT u07.u07_id
                        FROM     u07_trading_account u07
                             INNER JOIN
                                 u06_cash_account u06
                             ON u06.u06_id = u07.u07_cash_account_id_u06)
            LOOP
                sp_add_trading_restrictions (
                    7,
                    i.u07_id,
                    'Restricted from CRM Integration',
                    NULL,
                    9);
                sp_add_trading_restrictions (
                    8,
                    i.u07_id,
                    'Restricted from CRM Integration',
                    NULL,
                    9);



                IF (l_block_code = 4)
                THEN
                    sp_add_trading_restrictions (
                        1,
                        i.u07_id,
                        'Restricted from CRM Integration',
                        NULL,
                        9);
                    sp_add_trading_restrictions (
                        2,
                        i.u07_id,
                        'Restricted from CRM Integration',
                        NULL,
                        9);
                ELSIF (l_block_code = 5)
                THEN
                    sp_add_trading_restrictions (
                        1,
                        i.u07_id,
                        'Restricted from CRM Integration',
                        NULL,
                        9);
                END IF;

                sp_add_audit (
                    pu17_id,
                    366,
                       'sequence no >> '
                    || pcism_seq_nb
                    || 'Restricted from CRM Integration  '
                    || pu06_investment_account_no
                    || ' - '
                    || l_block_code,
                    p_u01_id,
                    p_u01_id,
                    0);
            END LOOP;
        ELSE
            DELETE FROM u11_cash_restriction
                  WHERE     u11_cash_account_id_u06 = p_u06_id
                        AND u11_restriction_type_id_v31 IN (10, 11)
                        AND u11_restriction_source = 9;

            sp_add_audit (
                pu17_id,
                364,
                   'sequence no >> '
                || pcism_seq_nb
                || 'Remove Restriction from CRM Integration  '
                || pu06_investment_account_no
                || ' - '
                || l_block_code,
                p_u01_id,
                p_u01_id,
                0);

            FOR i IN (SELECT u07.u07_id
                        FROM     u07_trading_account u07
                             INNER JOIN
                                 u06_cash_account u06
                             ON u06.u06_id = u07.u07_cash_account_id_u06)
            LOOP
                DELETE FROM u12_trading_restriction
                      WHERE     u12_trading_account_id_u07 = i.u07_id
                            AND u12_restriction_source = 9;

                sp_add_audit (
                    pu17_id,
                    367,
                       'sequence no >> '
                    || pcism_seq_nb
                    || 'Restricted from CRM Integration  '
                    || pu06_investment_account_no
                    || ' - '
                    || l_block_code,
                    p_u01_id,
                    p_u01_id,
                    0);
            END LOOP;
        END IF;

        pkey := p_u01_id || ',' || TRIM (0);
    END;

    PROCEDURE sp_customer_block (pkey                  OUT VARCHAR,
                                 p_ret_sts             OUT NUMBER, -- default to failure
                                 p_ret_msg             OUT VARCHAR2,
                                 p_u01_id              OUT NUMBER,
                                 pu01_customer_no   IN     VARCHAR,
                                 pcism_seq_nb       IN     VARCHAR,
                                 p_block_code       IN     NUMBER,
                                 pu17_id            IN     NUMBER)
    /*
    1 - Open | 2 - Debit Block | 3 - Close | 4 - Full Block | 5 - DB Freeze | Null Consider As Debit Block
    */
    IS
        l_block_code   NUMBER (10);
        l_cust_count   NUMBER := 0;
    BEGIN
        l_block_code := NVL (p_block_code, 2);  --NULL consider as debit block



        SELECT COUNT (*)
          INTO l_cust_count
          FROM u01_customer u01
         WHERE u01_customer_no = pu01_customer_no;

        IF (l_cust_count = 0)
        THEN
            p_ret_msg := 'Customer Not Found';
            add_cism_log (
                   'sequence no >> '
                || pcism_seq_nb
                || 'Block Customer, '
                || p_ret_msg,
                l_cust_count);
            p_ret_sts := 1;

            RETURN;
        END IF;

        UPDATE u01_customer
           SET u01_block_status_b = l_block_code
         WHERE u01_customer_no = pu01_customer_no;

        SELECT u01.u01_id
          INTO p_u01_id
          FROM u01_customer u01
         WHERE u01_customer_no = pu01_customer_no;

        pkey := p_u01_id || ',' || TRIM (0);
    END;


    PROCEDURE sp_add_audit (pa06_user_id_u17       IN NUMBER,
                            pa06_activity_id_m82   IN NUMBER,
                            pa06_description       IN VARCHAR,
                            pa06_reference_no      IN VARCHAR,
                            pa06_customer_id_u01      NUMBER,
                            pa06_login_id_u09      IN NUMBER)
    IS
    BEGIN
        INSERT INTO a06_audit (a06_id,
                               a06_date,
                               a06_user_id_u17,
                               a06_activity_id_m82,
                               a06_description,
                               a06_reference_no,
                               a06_channel_v29,
                               a06_customer_id_u01,
                               a06_login_id_u09,
                               a06_user_login_id_u17,
                               a06_ip,
                               a06_connected_machine,
                               a06_custom_type,
                               a06_institute_id_m02)
             VALUES (fn_get_next_sequnce ('A06_AUDIT'),
                     SYSDATE,
                     pa06_user_id_u17,
                     pa06_activity_id_m82,
                     pa06_description,
                     'ID:' || pa06_reference_no,
                     101,
                     pa06_customer_id_u01,
                     pa06_login_id_u09,
                     0,
                     '',
                     NULL,
                     '1',
                     1);
    END;

    PROCEDURE sp_update_cash_account (
        pkey                            OUT VARCHAR,
        p_ret_sts                       OUT NUMBER,      -- default to failure
        p_ret_msg                       OUT VARCHAR2,
        p_u01_id                        OUT NUMBER,
        p_u06_id                        OUT NUMBER,
        pcustomer_no                 IN     VARCHAR,
        pu06_investment_account_no   IN     VARCHAR2,
        pu01_vat_waive_off           IN     VARCHAR2,
        pcism_trn_typ                IN     VARCHAR2,
        pcism_seq_nb                 IN     VARCHAR2,
        pu06_block_status_b          IN     NUMBER,
        pu17_id                      IN     NUMBER)
    IS
        l_id_count   NUMBER := 0;
    BEGIN
        SELECT COUNT (u06_investment_account_no)
          INTO l_id_count
          FROM u06_cash_account u06
         WHERE u06.u06_investment_account_no = pu06_investment_account_no;

        IF l_id_count = 0
        THEN
            p_ret_sts := 1;
            p_ret_msg := 'Cash Account not available';
            add_cism_log (
                'sequence no >> ' || pcism_seq_nb || ' >> ' || p_ret_msg,
                l_id_count);
            RETURN;
        END IF;

        SELECT COUNT (*)
          INTO l_id_count
          FROM u01_customer u01
         WHERE u01_customer_no = pcustomer_no;

        IF l_id_count = 0
        THEN
            p_ret_sts := 1;
            p_ret_msg := 'Customer not available for create account';
            add_cism_log (
                   'sequence no >> '
                || pcism_seq_nb
                || 'Customer not available for create account',
                l_id_count);
            RETURN;
        END IF;


        UPDATE u06_cash_account u06
           SET u06_vat_waive_off = DECODE (pu01_vat_waive_off, 'N', 1, 0),
               u06_block_status_b = pu06_block_status_b,
               u06_status_id_v01 = 2
         WHERE u06.u06_investment_account_no = pu06_investment_account_no;

        add_cism_log (
            'sequence no >> ' || pcism_seq_nb || ' >>  Update Cash Account',
            l_id_count);

        SELECT u01.u01_id, u06.u06_id
          INTO p_u01_id, p_u06_id
          FROM u01_customer u01, u06_cash_account u06
         WHERE     u06.u06_customer_id_u01 = u01.u01_id
               AND u06.u06_investment_account_no = pu06_investment_account_no;
    END;

    PROCEDURE sp_create_cash_account (
        pkey                            OUT VARCHAR,
        p_ret_sts                       OUT NUMBER,      -- default to failure
        p_ret_msg                       OUT VARCHAR2,
        p_u01_id                        OUT NUMBER,
        p_u06_id                        OUT NUMBER,
        pcustomer_no                 IN     VARCHAR,
        pu06_currency                IN     VARCHAR2,
        pu06_investment_account_no   IN     VARCHAR2,
        pu01_vat_waive_off           IN     VARCHAR2,
        pcism_trn_typ                IN     VARCHAR2,
        pcism_seq_nb                 IN     VARCHAR2,
        pu06_block_status_b          IN     NUMBER,
        pu17_id                      IN     NUMBER,
        pcism_open_port              IN     VARCHAR2)
    IS
        p_iban_no              VARCHAR2 (50);
        l_cash_acc_id          NUMBER := 0;
        l_m03_id               NUMBER := 0;
        l_id_count             NUMBER := 0;
        l_u01_display_name     VARCHAR2 (200);
        l_u01_default_id_no    VARCHAR2 (20);
        l_u01_id               NUMBER := 0;
        l_u07_id               NUMBER := 0;
        l_u07_count            NUMBER := 0;
        l_u01_category         NUMBER := 0;
        l_m22_id               NUMBER := 0;
        l_m08_id               NUMBER := 0;
        l_tdwl_u07_id          NUMBER := 0;
        l_tdwl_m01_id          NUMBER := 0;
        l_tdwl_exchange_code   VARCHAR2 (20);
        l_m117_id              NUMBER := 0;
        l_iban                 VARCHAR2 (50);
    BEGIN
        /* still trading restriction and trade enable pending, IBAN */

        p_ret_sts := 0;

        BEGIN
            -- proc_get_iban (p_iban_no, pt03_external_reference);
            SELECT COUNT (u06_investment_account_no)
              INTO l_id_count
              FROM u06_cash_account u06
             WHERE u06.u06_investment_account_no = pu06_investment_account_no;

            IF l_id_count > 0
            THEN
                p_ret_sts := 1;
                p_ret_msg := 'Account already exist for the customer';
                add_cism_log (
                       'sequence no >> '
                    || pcism_seq_nb
                    || ' >> Account already exist for the customer',
                    l_id_count);
                RETURN;
            ELSE
                SELECT COUNT (*)
                  INTO l_id_count
                  FROM u01_customer u01
                 WHERE u01_customer_no = pcustomer_no;

                IF l_id_count = 0
                THEN
                    p_ret_sts := 1;
                    p_ret_msg := 'Customer not available for create account';
                    add_cism_log (
                           'sequence no >> '
                        || pcism_seq_nb
                        || 'Customer not available for create account',
                        l_id_count);
                    RETURN;
                END IF;

                SELECT COUNT (*)
                  INTO l_id_count
                  FROM u01_customer u01, u06_cash_account u06
                 WHERE     u01_customer_no = pcustomer_no
                       AND u01.u01_id = u06.u06_customer_id_u01
                       AND u06.u06_currency_code_m03 = pu06_currency
                       AND u06.u06_is_ipo_customer = 1;

                IF l_id_count > 0
                THEN
                    SELECT u06.u06_id,
                           u01.u01_id,
                           u01.u01_default_id_no,
                           u01.u01_display_name
                      INTO p_u06_id,
                           p_u01_id,
                           l_u01_default_id_no,
                           l_u01_display_name
                      FROM u01_customer u01, u06_cash_account u06
                     WHERE     u01_customer_no = pcustomer_no
                           AND u01.u01_id = u06.u06_customer_id_u01
                           AND u06.u06_currency_code_m03 = pu06_currency
                           AND u06.u06_is_ipo_customer = 1;



                    UPDATE u06_cash_account u06
                       SET u06_vat_waive_off =
                               DECODE (pu01_vat_waive_off, 'N', 1, 0),
                           u06_block_status_b = pu06_block_status_b,
                           u06_investment_account_no =
                               pu06_investment_account_no,
                           u06_display_name = pu06_investment_account_no,
                           u06_display_name_u01 = l_u01_display_name,
                           u06_default_id_no_u01 = l_u01_default_id_no,
                           u06_status_id_v01 = 2,
                           u06_is_ipo_customer = 0
                     WHERE u06.u06_id = p_u06_id;

                    add_cism_log (
                           'sequence no >> '
                        || pcism_seq_nb
                        || 'Customer Cash Account with IPO',
                        l_id_count);

                    RETURN;
                END IF;
            END IF;

            SELECT u01.u01_default_id_no,
                   u01.u01_display_name,
                   u01.u01_id,
                   u01.u01_category_v01
              INTO l_u01_default_id_no,
                   l_u01_display_name,
                   l_u01_id,
                   l_u01_category
              FROM u01_customer u01
             WHERE u01_customer_no = pcustomer_no;

            p_u01_id := l_u01_id;


            SELECT fn_get_next_sequnce ('U06_CASH_ACCOUNT')
              INTO l_cash_acc_id
              FROM DUAL;

            SELECT m03_id
              INTO l_m03_id
              FROM m03_currency
             WHERE m03_code = pu06_currency;

            BEGIN
                SELECT m117_id
                  INTO l_m117_id
                  FROM m117_charge_groups
                 WHERE     m117_status_id_v01 = 2
                       AND m117_is_default = 1
                       AND m117_institute_id_m02 = 1;
            EXCEPTION
                WHEN OTHERS
                THEN
                    l_m117_id := 1;
            END;


            SELECT fn_get_sfc_iban ('55', pu06_investment_account_no, 'SA')
              INTO l_iban
              FROM DUAL;


            INSERT INTO u06_cash_account (u06_id,
                                          u06_institute_id_m02,
                                          u06_customer_id_u01,
                                          u06_customer_no_u01,
                                          u06_display_name_u01,
                                          u06_default_id_no_u01,
                                          u06_currency_code_m03,
                                          u06_is_default,
                                          u06_created_by_id_u17,
                                          u06_created_date,
                                          u06_status_id_v01,
                                          u06_display_name,
                                          u06_currency_id_m03,
                                          u06_external_ref_no,
                                          u06_investment_account_no,
                                          u06_account_type_v01,
                                          u06_iban_no,
                                          u06_vat_waive_off,
                                          u06_charges_group_m117,
                                          u06_custom_type,
                                          u06_block_status_b,
                                          u06_status_changed_by_id_u17)
                 VALUES (l_cash_acc_id,                               --u06_id
                         1,                             --u06_institute_id_m02
                         l_u01_id,                      -- u06_customer_id_u01
                         pcustomer_no,                  -- u06_customer_no_u01
                         l_u01_display_name,            --u06_display_name_u01
                         l_u01_default_id_no,         -- u06_default_id_no_u01
                         pu06_currency,               -- u06_currency_code_m03
                         1,                                --   u06_is_default
                         pu17_id,                      --u06_created_by_id_u17
                         SYSDATE,                           --u06_created_date
                         2,                                --u06_status_id_v01
                         pu06_investment_account_no,        --u06_display_name
                         l_m03_id,                       --u06_currency_id_m03
                         NULL,                           --u06_external_ref_no
                         pu06_investment_account_no, --u06_investment_account_no,
                         1,                           -- u06_account_type_v01,
                         l_iban,                                --u06_iban_no,
                         DECODE (pu01_vat_waive_off, 'N', 1, 0), --u06_vat_waive_off,
                         l_m117_id,                  --u06_charges_group_m117,
                         '1',                              -- u06_custom_type,
                         pu06_block_status_b,             --u06_block_status_b
                         pu17_id                --u06_status_changed_by_id_u17
                                );

            add_cism_log (
                'sequence no >> ' || pcism_seq_nb || 'Create Cash Account',
                l_id_count);



            sp_add_audit (pu17_id,
                          334,
                          'Customer Cash Account Created from CRM',
                          l_u01_id,
                          l_u01_id,
                          0);

            p_u06_id := l_cash_acc_id;
            p_ret_sts := 0;
            p_ret_msg := l_cash_acc_id || '';

            IF (pu06_currency <> 'SAR')
            THEN
                SELECT MAX (u07_id) INTO l_u07_id FROM u07_trading_account;

                SELECT COUNT (*)
                  INTO l_u07_count
                  FROM u07_trading_account u07
                 WHERE     u07_exchange_code_m01 <> 'TDWL'
                       AND u07_customer_id_u01 = l_u01_id;

                SELECT m08_id
                  INTO l_m08_id
                  FROM m08_trading_group
                 WHERE m08_external_ref = 999;


                FOR i
                    IN (SELECT u07.u07_id u07_id,
                               m01.m01_id,
                               u07_exchange_code_m01 m01_exchange_code
                          FROM dfn_ntp.v20_default_master_data v20
                               INNER JOIN u06_cash_account u06
                                   ON     u06.u06_customer_id_u01 = v20_value
                                      AND u06.u06_currency_code_m03 =
                                         pu06_currency
                                      AND u06_status_id_v01 = 2
                               INNER JOIN u07_trading_account u07
                                   ON     u07.u07_cash_account_id_u06 =
                                              u06.u06_id
                                      AND u07.u07_status_id_v01 = 2
                               INNER JOIN m01_exchanges m01
                                   ON m01.m01_exchange_code =
                                          u07_exchange_code_m01
                         WHERE     v20_institute_id_m02 = 1
                               AND v20_tag = 'masterAccounts')
                LOOP
                    DECLARE
                    BEGIN
                        IF (l_u01_category = 0)
                        THEN
                            SELECT m22.m22_id
                              INTO l_m22_id
                              FROM m22_commission_group m22
                             WHERE     m22_exchange_code_m01 =
                                           i.m01_exchange_code
                                   AND m22.m22_category_v01 = 0      --Default
                                   AND m22.m22_status_id_v01 = 2
                                   AND m22.m22_institute_id_m02 = 1
                                   AND m22.m22_currency_m03 = pu06_currency;
                        ELSE
                            SELECT m22.m22_id
                              INTO l_m22_id
                              FROM m22_commission_group m22
                             WHERE     m22_exchange_code_m01 =
                                           i.m01_exchange_code
                                   AND m22.m22_category_v01 = 1        --Staff
                                   AND m22.m22_status_id_v01 = 2
                                   AND m22.m22_institute_id_m02 = 1
                                   AND m22.m22_currency_m03 = pu06_currency;
                        END IF;
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            l_m22_id := -1;
                    END;

                    IF (l_m22_id > 0)
                    THEN
                        l_u07_id := l_u07_id + 1;
                        l_u07_count := l_u07_count + 1;

                        INSERT
                          INTO u07_trading_account (
                                   u07_id,
                                   u07_institute_id_m02,
                                   u07_customer_id_u01,
                                   u07_cash_account_id_u06,
                                   u07_exchange_code_m01,
                                   u07_display_name_u06,
                                   u07_customer_no_u01,
                                   u07_display_name_u01,
                                   u07_default_id_no_u01,
                                   u07_is_default,
                                   u07_type,
                                   u07_trading_enabled,
                                   u07_trading_group_id_m08,
                                   u07_created_by_id_u17,
                                   u07_created_date,
                                   u07_status_id_v01,
                                   u07_commission_group_id_m22,
                                   u07_display_name,
                                   u07_cust_settle_group_id_m35,
                                   u07_exchange_id_m01,
                                   u07_external_ref_no,
                                   u07_market_segment_v01,
                                   u07_account_category,
                                   u07_parent_trading_acc_id_u07,
                                   u07_status_changed_by_id_u17,
                                   u07_status_changed_date)
                        VALUES (
                                   l_u07_id,                         -- u07_id
                                   1,                  -- u07_institute_id_m02
                                   l_u01_id,            -- u07_customer_id_u01
                                   l_cash_acc_id,   -- u07_cash_account_id_u06
                                   i.m01_exchange_code, -- u07_exchange_code_m01
                                   l_u01_display_name, -- u07_display_name_u06
                                   pcustomer_no,        -- u07_customer_no_u01
                                   l_u01_display_name,  --u07_display_name_u01
                                   l_u01_default_id_no, --u07_default_id_no_u01
                                   0,                         --u07_is_default
                                   2,                               --u07_type
                                   1,                    --u07_trading_enabled
                                   l_m08_id,        --u07_trading_group_id_m08
                                   pu17_id,           -- u07_created_by_id_u17
                                   SYSDATE,                 --u07_created_date
                                   2,                      --u07_status_id_v01
                                   l_m22_id,     --u07_commission_group_id_m22
                                      pcustomer_no
                                   || ' - '
                                   || LPAD (l_u07_count, 3, '0')
                                   || ' -'
                                   || i.m01_exchange_code,  --u07_display_name
                                   1,           --u07_cust_settle_group_id_m35
                                   i.m01_id,             --u07_exchange_id_m01
                                   l_u07_id,             --u07_external_ref_no
                                   1,                 --u07_market_segment_v01
                                   1,                   --u07_account_category
                                   i.u07_id,   --u07_parent_trading_acc_id_u07
                                   pu17_id,     --u07_status_changed_by_id_u17
                                   SYSDATE           --u07_status_changed_date
                                          );

                        sp_add_audit (
                            pu17_id,
                            338,
                               'Customer Trading Account created with cash account creation request from CRM - '
                            || i.m01_exchange_code,
                            l_u01_id,
                            l_u01_id,
                            0);
                    END IF;
                END LOOP;

                UPDATE app_seq_store
                   SET app_seq_value = l_u07_id
                 WHERE app_seq_name = 'U07_TRADING_ACCOUNT';
            ELSE
                IF (pcism_open_port IS NOT NULL AND pcism_open_port = 'Y')
                THEN
                    SELECT MAX (u07_id)
                      INTO l_u07_id
                      FROM u07_trading_account;

                      SELECT MAX (u07.u07_id) u07_id,
                             m01.m01_id,
                             u07_exchange_code_m01 m01_exchange_code
                        INTO l_tdwl_u07_id, l_tdwl_m01_id, l_tdwl_exchange_code
                        FROM dfn_ntp.v20_default_master_data v20
                             INNER JOIN u06_cash_account u06
                                 ON     u06.u06_customer_id_u01 = v20_value
                                    AND u06.u06_currency_code_m03 =
                                     pu06_currency
                                    AND u06_status_id_v01 = 2
                             INNER JOIN u07_trading_account u07
                                 ON     u07.u07_cash_account_id_u06 =
                                            u06.u06_id
                                    AND u07.u07_status_id_v01 = 2
                             INNER JOIN m01_exchanges m01
                                 ON     m01.m01_exchange_code =
                                            u07_exchange_code_m01
                             AND m01_exchange_code = 'TDWL'
                       WHERE     v20_institute_id_m02 = 1
                             AND v20_tag = 'masterAccounts'
                    GROUP BY m01_id, m01_exchange_code;


                    SELECT m08_id
                      INTO l_m08_id
                      FROM m08_trading_group
                     WHERE m08_external_ref = 998;

                    DECLARE
                    BEGIN
                        IF (l_u01_category = 0)
                        THEN
                            SELECT m22.m22_id
                              INTO l_m22_id
                              FROM dfn_ntp.m89_customer_category m89,
                                   m22_commission_group m22
                             WHERE     m22_exchange_code_m01 = 'TDWL'
                                   AND m22.m22_category_v01 = 0      --Default
                                   AND m22.m22_status_id_v01 = 2
                                   AND m22.m22_institute_id_m02 = 1
                                   AND m22.m22_currency_m03 = pu06_currency;
                        ELSE
                            SELECT m22.m22_id
                              INTO l_m22_id
                              FROM dfn_ntp.m89_customer_category m89,
                                   m22_commission_group m22
                             WHERE     m22_exchange_code_m01 = 'TDWL'
                                   AND m22.m22_category_v01 = 1        --Staff
                                   AND m22.m22_status_id_v01 = 2
                                   AND m22.m22_institute_id_m02 = 1
                                   AND m22.m22_currency_m03 = pu06_currency;
                        END IF;
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            l_m22_id := -1;
                    END;

                    IF (l_m22_id > 0)
                    THEN
                        l_u07_id := l_u07_id + 1;

                        INSERT
                          INTO u07_trading_account (
                                   u07_id,
                                   u07_institute_id_m02,
                                   u07_customer_id_u01,
                                   u07_cash_account_id_u06,
                                   u07_exchange_code_m01,
                                   u07_display_name_u06,
                                   u07_customer_no_u01,
                                   u07_display_name_u01,
                                   u07_default_id_no_u01,
                                   u07_is_default,
                                   u07_type,
                                   u07_trading_enabled,
                                   u07_trading_group_id_m08,
                                   u07_created_by_id_u17,
                                   u07_created_date,
                                   u07_status_id_v01,
                                   u07_commission_group_id_m22,
                                   u07_cust_settle_group_id_m35,
                                   u07_exchange_id_m01,
                                   u07_external_ref_no,
                                   u07_market_segment_v01,
                                   u07_account_category,
                                   u07_parent_trading_acc_id_u07,
                                   u07_status_changed_by_id_u17,
                                   u07_status_changed_date)
                        VALUES (l_u07_id,                            -- u07_id
                                1,                     -- u07_institute_id_m02
                                l_u01_id,               -- u07_customer_id_u01
                                l_cash_acc_id,      -- u07_cash_account_id_u06
                                l_tdwl_exchange_code, -- u07_exchange_code_m01
                                l_u01_display_name,    -- u07_display_name_u06
                                pcustomer_no,           -- u07_customer_no_u01
                                l_u01_display_name,     --u07_display_name_u01
                                l_u01_default_id_no,   --u07_default_id_no_u01
                                0,                            --u07_is_default
                                2,                                  --u07_type
                                1,                       --u07_trading_enabled
                                l_m08_id,           --u07_trading_group_id_m08
                                pu17_id,              -- u07_created_by_id_u17
                                SYSDATE,                    --u07_created_date
                                1,                         --u07_status_id_v01
                                l_m22_id,        --u07_commission_group_id_m22
                                1,              --u07_cust_settle_group_id_m35
                                l_tdwl_m01_id,           --u07_exchange_id_m01
                                l_u07_id,                --u07_external_ref_no
                                1,                    --u07_market_segment_v01
                                1,                      --u07_account_category
                                l_tdwl_u07_id, --u07_parent_trading_acc_id_u07
                                pu17_id,        --u07_status_changed_by_id_u17
                                SYSDATE              --u07_status_changed_date
                                       );

                        sp_add_audit (
                            pu17_id,
                            338,
                            'Customer Trading Account created with cash account creation request from CRM - TDWL',
                            l_u01_id,
                            l_u01_id,
                            0);

                        UPDATE app_seq_store
                           SET app_seq_value = l_u07_id
                         WHERE app_seq_name = 'U07_TRADING_ACCOUNT';
                    END IF;
                END IF;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                pkey := '0|' || SUBSTR (SQLERRM, 1, 512);
        END;
    END;


    PROCEDURE sp_update_customer (
        p_ret_sts                       OUT NUMBER,      -- default to failure
        p_ret_msg                       OUT VARCHAR2,
        p_u01_id                        OUT NUMBER,
        pu01_customer_no             IN     VARCHAR2,
        pu01_display_name            IN     VARCHAR2,
        pu01_display_name_lang       IN     VARCHAR2,
        pu01_gender                  IN     VARCHAR2,
        pu01_date_of_birth           IN     VARCHAR2,
        pu01_is_ipo_customer         IN     VARCHAR2,
        pu01_vat_waive_off           IN     VARCHAR2,
        pu01_tax_ref                 IN     VARCHAR2,
        pu02_mobile                  IN     VARCHAR2,
        pu02_email                   IN     VARCHAR2,
        pu01_category_m89            IN     VARCHAR2,
        pu01_kyc_next_review         IN     VARCHAR2,
        pu05_id_no                   IN     VARCHAR2,
        pu05_identity_type_id_m15    IN     VARCHAR2,
        pu02_address_line1           IN     VARCHAR2,
        pu02_address_line2           IN     VARCHAR2,
        pu02_address_line3           IN     VARCHAR2,
        pu02_address_line4           IN     VARCHAR2,
        pu02_address_line1_lang      IN     VARCHAR2,
        pu02_address_line2_lang      IN     VARCHAR2,
        pu02_address_line3_lang      IN     VARCHAR2,
        pu02_address_line4_lang      IN     VARCHAR2,
        pu02_zip_code                IN     VARCHAR2,
        pu02_po_box                  IN     VARCHAR2,
        pu05_expiry_date             IN     VARCHAR2,
        pu01_nationality_id_m05      IN     VARCHAR2,
        pu01_preferred_lang_id_v01   IN     VARCHAR2,
        pu02_country_id_m05          IN     VARCHAR2,
        pu17_id                      IN     NUMBER,
        pu01_customer_blk_cd         IN     NUMBER,
        pu01_customer_type           IN     VARCHAR2,
        pu01_customer_sub_type       IN     VARCHAR2,
        pcism_seq_nb                 IN     VARCHAR2)
    IS
        l_u01_id                      NUMBER := 0;
        l_u09_id                      NUMBER := 0;
        l_master_acc_no               NUMBER := 0;
        l_cust_count                  NUMBER := 0;
        l_customer_login_id           NUMBER := 0;
        l_contact_id                  NUMBER := 0;
        l_identification_id           NUMBER := 0;
        l_u01_nationality_id_m05      NUMBER := 0;
        l_u02_country_id_m05          NUMBER := 0;
        l_u01_preferred_lang_id_v01   NUMBER := 0;
        l_m15_id                      NUMBER := 0;
    BEGIN
        p_ret_sts := 0;

        SELECT COUNT (*)
          INTO l_cust_count
          FROM u01_customer u01, u09_customer_login u09
         WHERE     u01_customer_no = pu01_customer_no
               AND u09.u09_customer_id_u01 = u01.u01_id;



        SELECT m05_id
          INTO l_u01_nationality_id_m05
          FROM m05_country
         WHERE m05_external_ref = pu01_nationality_id_m05;

        SELECT m05_id
          INTO l_u02_country_id_m05
          FROM m05_country
         WHERE m05_external_ref = pu02_country_id_m05;


        BEGIN
            SELECT v01_id
              INTO l_u01_preferred_lang_id_v01
              FROM v01_system_master_data
             WHERE     v01_type = 14
                   AND SUBSTR (v01_description, 0, 1) =
                           pu01_preferred_lang_id_v01;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_u01_preferred_lang_id_v01 := 2;
        END;

        SELECT m15_id
          INTO l_m15_id
          FROM m15_identity_type
         WHERE m15_external_ref = pu05_identity_type_id_m15;


        IF (l_cust_count = 0)
        THEN
            add_cism_log (
                   'sequence no >> '
                || pcism_seq_nb
                || 'Customer  Login Not Found ',
                l_cust_count);

            SELECT fn_get_next_sequnce ('U09_CUSTOMER_LOGIN')
              INTO l_customer_login_id
              FROM DUAL;

            INSERT INTO u09_customer_login (u09_id,
                                            u09_customer_id_u01,
                                            u09_login_name,
                                            u09_login_password,
                                            u09_mobile_no,
                                            u09_email,
                                            u09_failed_attempts,
                                            u09_login_status_id_v01,
                                            u09_login_auth_type_id_v01,
                                            u09_trans_auth_type_id_v01,
                                            u09_password_expiry_date,
                                            u09_created_by_id_u17,
                                            u09_created_date,
                                            u09_status_id_v01,
                                            u09_institute_id_m02,
                                            u09_preferred_lang_id_v01,
                                            u09_idle_session_time_out)
                 VALUES (l_customer_login_id,                         --u09_id
                         l_u01_id,                       --u09_customer_id_u01
                         pu01_customer_no,                    --u09_login_name
                         '*',                             --u09_login_password
                         pu02_mobile,                          --u09_mobile_no
                         pu02_email,                               --u09_email
                         0,                              --u09_failed_attempts
                         1,                          --u09_login_status_id_v01
                         2,                       --u09_login_auth_type_id_v01
                         1,                       --u09_trans_auth_type_id_v01
                         SYSDATE + 100,             --u09_password_expiry_date
                         pu17_id,                      --u09_created_by_id_u17
                         SYSDATE,                           --u09_created_date
                         2,                                --u09_status_id_v01
                         1,                             --u09_institute_id_m02
                         l_u01_preferred_lang_id_v01, --u09_preferred_lang_id_v01
                         15                        --u09_idle_session_time_out
                           );



            sp_add_audit (pu17_id,
                          325,
                          'Customer Login Created from CRM',
                          l_u01_id,
                          l_u01_id,
                          l_customer_login_id);
        END IF;


        SELECT u01_id, u09.u09_id
          INTO l_u01_id, l_u09_id
          FROM u01_customer u01, u09_customer_login u09
         WHERE     u01_customer_no = pu01_customer_no
               AND u09.u09_customer_id_u01 = u01.u01_id;

        p_u01_id := l_u01_id;

        UPDATE u01_customer
           SET u01_first_name =
                   NVL (REGEXP_SUBSTR (pu01_display_name, '(\S*)'),
                        u01_first_name),
               u01_first_name_lang =
                   NVL (REGEXP_SUBSTR (pu01_display_name_lang, '(\S*)'),
                        u01_first_name_lang),
               u01_second_name =
                   NVL (REGEXP_SUBSTR (pu01_display_name,
                                       '(\S*)',
                                       1,
                                       2),
                        u01_second_name),
               u01_second_name_lang =
                   NVL (REGEXP_SUBSTR (pu01_display_name_lang,
                                       '(\S*)',
                                       1,
                                       2),
                        u01_second_name_lang),
               u01_third_name =
                   NVL (REGEXP_SUBSTR (pu01_display_name,
                                       '(\S*)',
                                       1,
                                       3),
                        u01_third_name),
               u01_third_name_lang =
                   NVL (REGEXP_SUBSTR (pu01_display_name_lang,
                                       '(\S*)',
                                       1,
                                       3),
                        u01_third_name_lang),
               u01_last_name =
                   NVL (REGEXP_SUBSTR (pu01_display_name,
                                       '(\S*)',
                                       1,
                                       4),
                        u01_last_name),
               u01_last_name_lang =
                   NVL (REGEXP_SUBSTR (pu01_display_name_lang,
                                       '(\S*)',
                                       1,
                                       4),
                        u01_last_name_lang),
               u01_display_name = NVL (pu01_display_name, u01_display_name),
               u01_display_name_lang =
                   NVL (pu01_display_name_lang, u01_display_name_lang),
               u01_gender = NVL (pu01_gender, u01_gender),
               u01_date_of_birth =
                   TO_DATE (
                       fn_get_hijri_gregorian_date (pu01_date_of_birth, 1),
                       'dd/mm/yyyy'),
               u01_birth_country_id_m05 = l_u01_nationality_id_m05,
               u01_preferred_lang_id_v01 = l_u01_preferred_lang_id_v01,
               u01_is_ipo_customer =
                   NVL (DECODE (pu01_is_ipo_customer, 'N', 0, 1),
                        u01_is_ipo_customer),
               u01_status_id_v01 = 2,
               u01_relationship_mngr_id_m10 = 1,
               u01_nationality_id_m05 = l_u01_nationality_id_m05,
               u01_trading_enabled = 1,
               u01_online_trading_enabled = 1,
               u01_preferred_name =
                   NVL (pu01_display_name, u01_preferred_name),
               u01_preferred_name_lang =
                   NVL (pu01_display_name_lang, u01_preferred_name_lang),
               u01_full_name = NVL (pu01_display_name, u01_full_name),
               u01_full_name_lang =
                   NVL (pu01_display_name_lang, u01_full_name_lang),
               u01_vat_waive_off =
                   NVL (DECODE (pu01_vat_waive_off, 'N', 1, 0),
                        u01_vat_waive_off),
               u01_tax_ref = NVL (pu01_tax_ref, u01_tax_ref),
               u01_def_mobile = NVL (pu02_mobile, u01_def_mobile),
               u01_def_email = NVL (pu02_email, u01_def_email),
               u01_category_v01 =
                   NVL (DECODE (pu01_category_m89, 'B', 1, 0),
                        u01_category_v01),
               u01_kyc_next_review =
                   TO_DATE (pu01_kyc_next_review, 'DD/MM/YYYY'),
               u01_block_status_b =
                   NVL (pu01_customer_blk_cd, u01_block_status_b),
               u01_customer_no = NVL (pu01_customer_no, u01_customer_no)
         WHERE u01_id = p_u01_id;


        UPDATE u02_customer_contact_info
           SET u02_mobile = NVL (pu02_mobile, u02_mobile),
               u02_email = NVL (pu02_email, u02_email),
               u02_po_box = NVL (pu02_po_box, u02_po_box),
               u02_zip_code = NVL (pu02_zip_code, u02_zip_code),
               u02_city_id_m06 = 1,
               u02_country_id_m05 = l_u02_country_id_m05,
               u02_address_line1 =
                   pu02_address_line1 || ' ' || pu02_address_line2,
               u02_address_line1_lang =
                   pu02_address_line1_lang || ' ' || pu02_address_line2_lang,
               u02_address_line2 =
                   pu02_address_line3 || ' ' || pu02_address_line4,
               u02_address_line2_lang =
                   pu02_address_line3_lang || ' ' || pu02_address_line4_lang
         WHERE u02_customer_id_u01 = p_u01_id;

        UPDATE u05_customer_identification
           SET u05_identity_type_id_m15 = l_m15_id,
               u05_id_no = NVL (pu05_id_no, u05_id_no),
               u05_expiry_date = pu05_expiry_date
         WHERE u05_customer_id_u01 = p_u01_id;
    EXCEPTION
        WHEN OTHERS
        THEN
            p_ret_sts := 1;
            p_ret_msg := 'Master Data Mismatched';
    END;

    PROCEDURE sp_add_customer (pkey                            OUT VARCHAR,
                               p_ret_sts                       OUT NUMBER, -- default to failure
                               p_ret_msg                       OUT VARCHAR2,
                               p_u01_id                        OUT NUMBER,
                               pu01_customer_no             IN     VARCHAR2,
                               pu01_display_name            IN     VARCHAR2,
                               pu01_display_name_lang       IN     VARCHAR2,
                               pu01_gender                  IN     VARCHAR2,
                               pu01_date_of_birth           IN     VARCHAR2,
                               pu01_is_ipo_customer         IN     VARCHAR2,
                               pu01_vat_waive_off           IN     VARCHAR2,
                               pu01_tax_ref                 IN     VARCHAR2,
                               pu02_mobile                  IN     VARCHAR2,
                               pu02_email                   IN     VARCHAR2,
                               pu01_category_m89            IN     VARCHAR2,
                               pu01_kyc_next_review         IN     VARCHAR2,
                               pu05_id_no                   IN     VARCHAR2,
                               pu02_address_line1           IN     VARCHAR2,
                               pu02_address_line2           IN     VARCHAR2,
                               pu02_address_line3           IN     VARCHAR2,
                               pu02_address_line4           IN     VARCHAR2,
                               pu02_address_line1_lang      IN     VARCHAR2,
                               pu02_address_line2_lang      IN     VARCHAR2,
                               pu02_address_line3_lang      IN     VARCHAR2,
                               pu02_address_line4_lang      IN     VARCHAR2,
                               pu02_zip_code                IN     VARCHAR2,
                               pu02_po_box                  IN     VARCHAR2,
                               pu05_expiry_date             IN     VARCHAR2,
                               pu01_nationality_id_m05      IN     VARCHAR2,
                               pu01_preferred_lang_id_v01   IN     VARCHAR2,
                               pu02_country_id_m05          IN     VARCHAR2,
                               pu17_id                      IN     NUMBER,
                               pu01_customer_blk_cd         IN     NUMBER,
                               pu01_customer_type           IN     VARCHAR2,
                               pu01_customer_sub_type       IN     VARCHAR2,
                               pu05_identity_type_id_m15    IN     VARCHAR2,
                               pcism_ro_cd                  IN     VARCHAR2,
                               pcism_seq_nb                 IN     VARCHAR2)
    IS
        l_u01_id                      NUMBER := 0;
        l_u09_id                      NUMBER := 0;
        l_master_acc_no               NUMBER := 0;
        l_cust_count                  NUMBER := 0;
        l_customer_login_id           NUMBER := 0;
        l_contact_id                  NUMBER := 0;
        l_identification_id           NUMBER := 0;
        l_u01_nationality_id_m05      NUMBER := 0;
        l_u02_country_id_m05          NUMBER := 0;
        l_u01_preferred_lang_id_v01   NUMBER := 0;
        l_m15_id                      NUMBER := 0;
        l_m10_id                      NUMBER := 0;
        l_m162_id                     NUMBER := 0;
        l_m07_id                      NUMBER := 0;
    BEGIN
        p_ret_sts := 0;

        SELECT m05_id
          INTO l_u01_nationality_id_m05
          FROM m05_country
         WHERE m05_external_ref = pu01_nationality_id_m05;

        SELECT m05_id
          INTO l_u02_country_id_m05
          FROM m05_country
         WHERE m05_external_ref = pu02_country_id_m05;

        SELECT m07_id
          INTO l_m07_id
          FROM m07_location
         WHERE m07_external_ref = '0';

        BEGIN
            SELECT v01_id
              INTO l_u01_preferred_lang_id_v01
              FROM v01_system_master_data
             WHERE     v01_type = 14
                   AND SUBSTR (v01_description, 0, 1) =
                           pu01_preferred_lang_id_v01;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_u01_preferred_lang_id_v01 := 2;
        END;

        SELECT m15_id
          INTO l_m15_id
          FROM m15_identity_type
         WHERE m15_external_ref = pu05_identity_type_id_m15;

        SELECT COUNT (*)
          INTO l_cust_count
          FROM u05_customer_identification u05,
               u01_customer u01,
               u09_customer_login u09
         WHERE     u05_id_no = pu05_id_no
               AND u05_identity_type_id_m15 = l_m15_id
               AND u01.u01_id = u05.u05_customer_id_u01
               AND u01.u01_is_ipo_customer = 1
               AND u09.u09_customer_id_u01 = u01.u01_id;

        BEGIN
            SELECT m10_id
              INTO l_m10_id
              FROM m10_relationship_manager a
             WHERE a.m10_external_ref = pcism_ro_cd;
        EXCEPTION
            WHEN OTHERS
            THEN
                SELECT fn_get_next_sequnce ('M10_RELATIONSHIP_MANAGER')
                  INTO l_m10_id
                  FROM DUAL;


                SELECT a.m162_id
                  INTO l_m162_id
                  FROM m162_incentive_group a
                 WHERE     m162_group_type_id_v01 = 1
                       AND m162_is_default = 1
                       AND m162_status_id_v01 = 2;

                INSERT
                  INTO dfn_ntp.m10_relationship_manager (
                           m10_id,
                           m10_institute_id_m02,
                           m10_name,
                           m10_name_lang,
                           m10_created_by_id_u17,
                           m10_created_date,
                           m10_status_id_v01,
                           m10_modified_by_id_u17,
                           m10_modified_date,
                           m10_status_changed_by_id_u17,
                           m10_status_changed_date,
                           m10_external_ref,
                           m10_code,
                           m10_location_id_m07,
                           m10_telephone,
                           m10_fax,
                           m10_custom_type,
                           m10_incentive_group_id_m162)
                VALUES (l_m10_id,
                        1,
                        pcism_ro_cd,
                        pcism_ro_cd,
                        1,
                        SYSDATE,
                        2,
                        1,
                        SYSDATE,
                        1,
                        SYSDATE,
                        pcism_ro_cd,
                        pcism_ro_cd,
                        0,
                        NULL,
                        NULL,
                        '1',
                        l_m162_id);
        END;

        IF (l_cust_count > 0)
        THEN
            add_cism_log (
                'sequence no >> ' || pcism_seq_nb || 'IPO Customer',
                l_cust_count);

            SELECT u01_id, u09.u09_id
              INTO l_u01_id, l_u09_id
              FROM u05_customer_identification u05,
                   u01_customer u01,
                   u09_customer_login u09
             WHERE     u05_id_no = pu05_id_no
                   AND u05_identity_type_id_m15 = pu05_identity_type_id_m15
                   AND u01.u01_id = u05.u05_customer_id_u01
                   AND u01.u01_is_ipo_customer = 1
                   AND u09.u09_customer_id_u01 = u01.u01_id;

            -- Update customer status to Active
            sp_update_customer (p_ret_sts,
                                p_ret_msg,
                                p_u01_id,
                                pu01_customer_no,
                                pu01_display_name,
                                pu01_display_name_lang,
                                pu01_gender,
                                pu01_date_of_birth,
                                pu01_is_ipo_customer,
                                pu01_vat_waive_off,
                                pu01_tax_ref,
                                pu02_mobile,
                                pu02_email,
                                pu01_category_m89,
                                pu01_kyc_next_review,
                                pu05_id_no,
                                pu05_identity_type_id_m15,
                                pu02_address_line1,
                                pu02_address_line2,
                                pu02_address_line3,
                                pu02_address_line4,
                                pu02_address_line1_lang,
                                pu02_address_line2_lang,
                                pu02_address_line3_lang,
                                pu02_address_line4_lang,
                                pu02_zip_code,
                                pu02_po_box,
                                pu05_expiry_date,
                                pu01_nationality_id_m05,
                                pu01_preferred_lang_id_v01,
                                pu02_country_id_m05,
                                pu17_id,
                                pu01_customer_blk_cd,
                                pu01_customer_type,
                                pu01_customer_sub_type,
                                pcism_seq_nb);
            pkey := l_u01_id || ',' || TRIM (0);
            p_ret_sts := 0;
            p_u01_id := l_u01_id;
            RETURN;
        END IF;

        SELECT v20_value
          INTO l_master_acc_no
          FROM dfn_ntp.v20_default_master_data v20
         WHERE v20_institute_id_m02 = 1 AND v20_tag = 'masterAccounts';

        IF l_master_acc_no = 0
        THEN
            p_ret_sts := 1;
            p_ret_msg :=
                'Master account has not created or not configure in system table !';
            RETURN;
        END IF;



        SELECT fn_get_next_sequnce ('U01_CUSTOMER') INTO l_u01_id FROM DUAL;

        p_u01_id := l_u01_id;

        INSERT INTO u01_customer (u01_id,
                                  u01_customer_no,
                                  u01_institute_id_m02,
                                  u01_account_category_id_v01,
                                  u01_first_name,
                                  u01_first_name_lang,
                                  u01_second_name,
                                  u01_second_name_lang,
                                  u01_third_name,
                                  u01_third_name_lang,
                                  u01_last_name,
                                  u01_last_name_lang,
                                  u01_display_name,
                                  u01_display_name_lang,
                                  u01_gender,
                                  u01_date_of_birth,
                                  u01_birth_country_id_m05,
                                  u01_default_id_no,
                                  u01_default_id_type_m15,
                                  u01_preferred_lang_id_v01,
                                  u01_is_ipo_customer,
                                  u01_created_by_id_u17,
                                  u01_created_date,
                                  u01_status_id_v01,
                                  u01_signup_location_id_m07,
                                  u01_service_location_id_m07,
                                  u01_relationship_mngr_id_m10,
                                  u01_nationality_id_m05,
                                  u01_trading_enabled,
                                  u01_online_trading_enabled,
                                  u01_preferred_name,
                                  u01_preferred_name_lang,
                                  u01_full_name,
                                  u01_full_name_lang,
                                  u01_external_ref_no,
                                  u01_account_type_id_v01,
                                  u01_master_account_id_u01,
                                  u01_vat_waive_off,
                                  u01_tax_ref,
                                  u01_def_mobile,
                                  u01_def_email,
                                  u01_category_v01,
                                  u01_kyc_next_review,
                                  u01_block_status_b,
                                  u01_is_black_listed,
                                  u01_status_changed_by_id_u17,
                                  u01_customer_type_b,
                                  u01_customer_sub_type_b)
             VALUES (
                        l_u01_id,                                     --u01_id
                        pu01_customer_no,                    --u01_customer_no
                        1,                              --u01_institute_id_m02
                        DECODE (pu01_customer_type,  'PVI', 1,  'BUS', 2,  1), --u01_account_category_id_v01
                        REGEXP_SUBSTR (pu01_display_name, '(\S*)'), --u01_first_name
                        REGEXP_SUBSTR (pu01_display_name_lang, '(\S*)'), --u01_first_name_lang
                        REGEXP_SUBSTR (pu01_display_name,
                                       '(\S*)',
                                       1,
                                       2),                   --u01_second_name
                        REGEXP_SUBSTR (pu01_display_name_lang,
                                       '(\S*)',
                                       1,
                                       2),              --u01_second_name_lang
                        REGEXP_SUBSTR (pu01_display_name,
                                       '(\S*)',
                                       1,
                                       3),                    --u01_third_name
                        REGEXP_SUBSTR (pu01_display_name_lang,
                                       '(\S*)',
                                       1,
                                       3),               --u01_third_name_lang
                        REGEXP_SUBSTR (pu01_display_name,
                                       '(\S*)',
                                       1,
                                       4),                     --u01_last_name
                        REGEXP_SUBSTR (pu01_display_name_lang,
                                       '(\S*)',
                                       1,
                                       4),                --u01_last_name_lang
                        pu01_display_name,                  --u01_display_name
                        pu01_display_name_lang,        --u01_display_name_lang
                        pu01_gender,                              --u01_gender
                        TO_DATE (
                            fn_get_hijri_gregorian_date (pu01_date_of_birth,
                                                         1),
                            'dd/mm/yyyy'),                 --u01_date_of_birth
                        l_u02_country_id_m05,       --u01_birth_country_id_m05
                        pu05_id_no,                        --u01_default_id_no
                        l_m15_id,                    --u01_default_id_type_m15
                        l_u01_preferred_lang_id_v01, --u01_preferred_lang_id_v01
                        DECODE (pu01_is_ipo_customer, 'N', 0, 1), --u01_is_ipo_customer
                        pu17_id,                       --u01_created_by_id_u17
                        SYSDATE,                            --u01_created_date
                        2,                                 --u01_status_id_v01
                        l_m07_id,                 --u01_signup_location_id_m07
                        l_m07_id,                --u01_service_location_id_m07
                        l_m10_id,               --u01_relationship_mngr_id_m10
                        l_u01_nationality_id_m05,     --u01_nationality_id_m05
                        1,                               --u01_trading_enabled
                        1,                        --u01_online_trading_enabled
                        pu01_display_name,                --u01_preferred_name
                        pu01_display_name_lang,      --u01_preferred_name_lang
                        pu01_display_name,                     --u01_full_name
                        pu01_display_name_lang,           --u01_full_name_lang
                        pu01_customer_no,                --u01_external_ref_no
                        2,                           --u01_account_type_id_v01
                        l_master_acc_no,           --u01_master_account_id_u01
                        DECODE (pu01_vat_waive_off, 'N', 1, 0), --u01_vat_waive_off
                        pu01_tax_ref,                            --u01_tax_ref
                        pu02_mobile,                          --u01_def_mobile
                        pu02_email,                            --u01_def_email
                        DECODE (pu01_category_m89, 'B', 1, 0), --u01_is_staff_b
                        DECODE (pu01_kyc_next_review,
                                NULL, NULL,
                                TO_DATE (pu01_kyc_next_review, 'DD/MM/YYYY')), --u01_kyc_next_review
                        pu01_customer_blk_cd,
                        0,
                        pu17_id,
                        pu01_customer_type,
                        pu01_customer_sub_type);

        SELECT fn_get_next_sequnce ('U09_CUSTOMER_LOGIN')
          INTO l_customer_login_id
          FROM DUAL;

        INSERT INTO u09_customer_login (u09_id,
                                        u09_customer_id_u01,
                                        u09_login_name,
                                        u09_login_password,
                                        u09_mobile_no,
                                        u09_email,
                                        u09_failed_attempts,
                                        u09_login_status_id_v01,
                                        u09_login_auth_type_id_v01,
                                        u09_trans_auth_type_id_v01,
                                        u09_password_expiry_date,
                                        u09_created_by_id_u17,
                                        u09_created_date,
                                        u09_status_id_v01,
                                        u09_institute_id_m02,
                                        u09_preferred_lang_id_v01,
                                        u09_idle_session_time_out)
             VALUES (l_customer_login_id,                             --u09_id
                     l_u01_id,                           --u09_customer_id_u01
                     pu01_customer_no,                        --u09_login_name
                     '*',                                 --u09_login_password
                     pu02_mobile,                              --u09_mobile_no
                     pu02_email,                                   --u09_email
                     0,                                  --u09_failed_attempts
                     1,                              --u09_login_status_id_v01
                     2,                           --u09_login_auth_type_id_v01
                     1,                           --u09_trans_auth_type_id_v01
                     SYSDATE + 100,                 --u09_password_expiry_date
                     pu17_id,                          --u09_created_by_id_u17
                     SYSDATE,                               --u09_created_date
                     2,                                    --u09_status_id_v01
                     1,                                 --u09_institute_id_m02
                     l_u01_preferred_lang_id_v01,  --u09_preferred_lang_id_v01
                     15                            --u09_idle_session_time_out
                       );



        sp_add_audit (pu17_id,
                      325,
                      'Customer Created from CRM',
                      l_u01_id,
                      l_u01_id,
                      l_customer_login_id);


        SELECT fn_get_next_sequnce ('U02_CUSTOMER_CONTACT_INFO')
          INTO l_contact_id
          FROM DUAL;


        INSERT INTO u02_customer_contact_info (u02_id,
                                               u02_customer_id_u01,
                                               u02_is_default,
                                               u02_mobile,
                                               u02_email,
                                               u02_po_box,
                                               u02_zip_code,
                                               u02_address_line1,
                                               u02_address_line1_lang,
                                               u02_address_line2,
                                               u02_address_line2_lang,
                                               u02_created_by_id_u17,
                                               u02_created_date,
                                               u02_city_id_m06,
                                               u02_country_id_m05,
                                               u02_status_id_v01)
             VALUES (
                        l_contact_id,                                 --u02_id
                        l_u01_id,                        --u02_customer_id_u01
                        1,                                    --u02_is_default
                        pu02_mobile,                              --u02_mobile
                        pu02_email,                                --u02_email
                        pu02_po_box,                              --u02_po_box
                        pu02_zip_code,                          --u02_zip_code
                        pu02_address_line1 || ' ' || pu02_address_line2, --u02_address_line1
                           pu02_address_line1_lang
                        || ' '
                        || pu02_address_line2_lang,   --u02_address_line1_lang
                        pu02_address_line3 || ' ' || pu02_address_line4, --u02_address_line2
                           pu02_address_line3_lang
                        || ' '
                        || pu02_address_line4_lang,   --u02_address_line2_lang
                        pu17_id,                       --u02_created_by_id_u17
                        SYSDATE,                            --u02_created_date
                        1,                                   --u02_city_id_m06
                        l_u02_country_id_m05,             --u02_country_id_m05
                        2                                  --u02_status_id_v01
                         );



        sp_add_audit (pu17_id,
                      328,
                      'Customer Contact Created',
                      l_u01_id,
                      l_u01_id,
                      l_customer_login_id);

        SELECT fn_get_next_sequnce ('U05_CUSTOMER_IDENTIFICATION')
          INTO l_identification_id
          FROM DUAL;

        INSERT
          INTO u05_customer_identification (u05_id,
                                                 u05_identity_type_id_m15,
                                                 u05_customer_id_u01,
                                                 u05_id_no,
                                                 u05_expiry_date,
                                                 u05_is_default,
                                                 u05_created_by_id_u17,
                                                 u05_created_date,
                                                 u05_status_id_v01,
                                                 u05_issue_date,
                                            u05_issue_location_id_m14,
                                            u05_status_changed_by_id_u17,
                                            u05_status_changed_date)
             VALUES (l_identification_id,                             --u05_id
                     l_m15_id,                      --u05_identity_type_id_m15
                     l_u01_id,                           --u05_customer_id_u01
                     pu05_id_no,                                   --u05_id_no
                     pu05_expiry_date,                       --u05_expiry_date
                     1,                                       --u05_is_default
                     pu17_id,                          --u05_created_by_id_u17
                     SYSDATE,                               --u05_created_date
                2,                                         --u05_status_id_v01
                     SYSDATE,                                -- u05_issue_date
                1,                                 --u05_issue_location_id_m14
                pu17_id,                        --u05_status_changed_by_id_u17
                SYSDATE                              --u05_status_changed_date
                      );
    END;



    PROCEDURE sp_sync_customer_master (cism_seq_nb   IN     VARCHAR2,
                                       p_ret_sts        OUT NUMBER, -- default to failure
                                       p_ret_msg        OUT VARCHAR2,
                                       p_u01_id         OUT NUMBER,
                                       p_u06_id         OUT NUMBER,
                                       p_u47_id         OUT NUMBER,
                                       p_u08_id         OUT NUMBER)
    IS
        l_record_count          NUMBER := 0;

        l_id_count              NUMBER;
        pkey                    VARCHAR2 (50);
        l_customer_id           NUMBER;
        l_mubasher_no           VARCHAR2 (50);
        l_cashac_id             NUMBER;
        l_secac_id              NUMBER;
        l_master_cashac_id      NUMBER;
        l_master_secac_id       NUMBER;
        pcism_seq_nb            VARCHAR2 (50);
        l_ben_curr              VARCHAR (50);
        l_cust_count            NUMBER := 0;
        l_ipo_cashac_id         NUMBER;
        l_ipo_accountno         VARCHAR2 (20);
        l_commission_grp        NUMBER;
        l_user_id               NUMBER;
        l_m01_external_ref_no   VARCHAR2 (50);
        l_t58_id                NUMBER := 0;
    BEGIN
        pcism_seq_nb := cism_seq_nb;

        SELECT u17.u17_id
          INTO l_user_id
          FROM u17_employee u17
         WHERE u17.u17_login_name = 'INTEGRATION_USER';

        FOR i
            IN (SELECT a.cism_cust_nb AS u01_customer_no,
                       CASE
                           WHEN a.cism_cust_blk_cd = 'OP' THEN 1
                           WHEN a.cism_cust_blk_cd = 'DB' THEN 2
                           WHEN a.cism_cust_blk_cd = 'CL' THEN 3
                           WHEN a.cism_cust_blk_cd = 'FB' THEN 4
                           WHEN a.cism_cust_blk_cd = 'DF' THEN 5
                           ELSE NULL
                       END
                           AS pu01_customer_blk_cd,
                       CASE
                           WHEN a.cism_acc_blk_cd = 'OP' THEN 1
                           WHEN a.cism_acc_blk_cd = 'DB' THEN 2
                           WHEN a.cism_acc_blk_cd = 'CL' THEN 3
                           WHEN a.cism_acc_blk_cd = 'FB' THEN 4
                           WHEN a.cism_acc_blk_cd = 'DF' THEN 5
                           ELSE NULL
                       END
                           AS u06_block_status_b,
                       TRIM (a.cism_acc_ename) AS pu01_display_name,
                       TRIM (a.cism_acc_aname) AS pu01_display_name_lang,
                       a.cism_addr_aline1 AS pu02_address_line1_lang,
                       a.cism_addr_aline2 AS pu02_address_line2_lang,
                       a.cism_addr_aline4 AS pu02_address_line4_lang,
                       a.cism_addr_aline3 AS pu02_address_line3_lang,
                       a.cism_addr_eline4 AS pu02_address_line4,
                       a.cism_addr_eline3 AS pu02_address_line3,
                       a.cism_addr_eline2 AS pu02_address_line2,
                       a.cism_addr_eline1 AS pu02_address_line1,
                       a.cism_country_cd AS pu02_country_id_m05,
                       a.cism_postal_cd AS pu02_zip_code,
                       a.cism_po_box AS pu02_po_box,
                       a.cism_city AS pu02_city_id_m06,
                       a.cism_nin_nb AS pu05_id_no,
                       a.cism_nin_typ AS pu05_identity_type_id_m15,
                       a.cism_phone_mobile AS pu02_mobile,
                       a.cism_email AS pu02_email,
                       a.cism_nationality AS pu01_nationality_id_m05,
                       a.cism_link_status AS pu08_status_id_v01,
                       a.cism_gender AS pu01_gender,
                       a.cism_acc_nb AS u06_investment_account_no,
                       NVL (a.cism_currency, 'SAR') AS u06_currency_code_m03,
                       a.cism_acc_typ AS pu01_category_m89,
                       a.cism_brn_cd,
                       a.cism_cust_typ AS pu01_customer_type,
                       a.cism_cust_sub_typ AS pu01_customer_sub_type,
                       a.cism_ro_cd,
                       u01.u01_id,
                       a.cism_trn_typ AS cism_trn_typ,
                       a.cism_cust_lang AS pu01_preferred_lang_id_v01,
                       a.cism_rltn_flag AS pu01_is_ipo_customer,
                       CASE
                           WHEN (    (    a.cism_trn_typ != 'UPDCUS'
                                      AND a.cism_trn_typ != 'CRTCUS'
                                      AND a.cism_trn_typ != 'QRYCUS'
                                      AND a.cism_trn_typ != 'REFCUS'
                                      AND a.cism_trn_typ != 'BLKCUS'
                                      AND a.cism_trn_typ != 'DLKCUS'
                                      AND a.cism_trn_typ != 'BENINQ'
                                      AND a.cism_trn_typ != 'CRTBEN'
                                      AND a.cism_trn_typ != 'UPDBEN'
                                      AND a.cism_trn_typ != 'REFBEN'
                                      AND a.cism_trn_typ != 'DELBEN')
                                 AND a.cism_cust_nb IS NULL)
                           THEN
                               'Invalid Cash Account Number'
                           WHEN     (   a.cism_trn_typ = 'CRTCUS'
                                     OR a.cism_trn_typ = 'UPDCUS'
                                     OR a.cism_trn_typ = 'QRYCUS'
                                     OR a.cism_trn_typ = 'REFCUS')
                                AND m05b.m05_id IS NULL
                           THEN
                                  'Country {'
                               || TO_CHAR (a.cism_country_cd)
                               || '} not in OMS'
                           WHEN     u01.u01_id IS NULL
                                AND NOT (   a.cism_trn_typ = 'CRTCUS'
                                         OR a.cism_trn_typ = 'QRYCUS'
                                         OR a.cism_trn_typ = 'BENINQ')
                           THEN
                               'Customer not exist in OMS'
                           WHEN     u01.u01_id IS NOT NULL
                                AND (   a.cism_trn_typ = 'CRTCUS'
                                     OR a.cism_trn_typ = 'QRYCUS')
                           THEN
                               'Customer already exist in OMS'
                           WHEN u01.u01_id IS NULL
                           THEN
                               'New'
                           WHEN u01.u01_id IS NOT NULL
                           THEN
                               'Update'
                       END
                           AS row_status,
                       a.cism_ben_seq AS u08_sequence_no_b,
                       a.cism_poa_exp_dt AS u47_id_expiry_date,
                       a.cism_auth_list AS poa_priviledge,
                       a.cism_bank_cd AS pu08_bank_id_m16,
                       a.cism_branch_name AS pu08_bank_branch_name,
                       a.cism_acc_title AS pu08_account_name,
                       a.cism_iban AS pu08_iban_no,
                       cism_vat_flg AS pu01_vat_waive_off,
                       cism_id_exp AS pu05_expiry_date,
                       cism_kyc_exp AS pu01_kyc_next_review,
                       cism_vat_tin AS pu01_tax_ref,
                       TO_CHAR (TO_DATE (cism_dob, 'yyyymmdd'), 'DD/MM/YYYY')
                           AS pu01_date_of_birth,
                       cism_benf_nb pm08_id,
                       cism_open_port
                  FROM cism_syno a
                       LEFT OUTER JOIN u01_customer u01
                           ON a.cism_cust_nb = u01.u01_customer_no
                       LEFT OUTER JOIN m05_country m05a
                           ON a.cism_country_cd = m05a.m05_external_ref
                       LEFT OUTER JOIN m05_country m05b
                           ON a.cism_nationality = m05b.m05_external_ref
                 WHERE a.cism_seq_nb = pcism_seq_nb)
        LOOP
            add_cism_log (
                   'Initial Request sequence no >> '
                            || pcism_seq_nb
                            || ' >> i.row_status='
                            || i.row_status,
                l_cust_count);



            BEGIN
                IF (i.row_status = 'New')
                THEN
                    sp_add_customer (pkey,
                                     p_ret_sts,
                                     p_ret_msg,
                                     p_u01_id,
                                     i.u01_customer_no,
                                     i.pu01_display_name,
                                     i.pu01_display_name_lang,
                                     i.pu01_gender,
                                     i.pu01_date_of_birth,
                                     i.pu01_is_ipo_customer,
                                     i.pu01_vat_waive_off,
                                     i.pu01_tax_ref,
                                     i.pu02_mobile,
                                     i.pu02_email,
                                     i.pu01_category_m89,
                                     i.pu01_kyc_next_review,
                                     i.pu05_id_no,
                                     i.pu02_address_line1,
                                     i.pu02_address_line2,
                                     i.pu02_address_line3,
                                     i.pu02_address_line4,
                                     i.pu02_address_line1_lang,
                                     i.pu02_address_line2_lang,
                                     i.pu02_address_line3_lang,
                                     i.pu02_address_line4_lang,
                                     i.pu02_zip_code,
                                     i.pu02_po_box,
                                     i.pu05_expiry_date,
                                     i.pu01_nationality_id_m05,
                                     i.pu01_preferred_lang_id_v01,
                                     i.pu02_country_id_m05,
                                     l_user_id,
                                     i.pu01_customer_blk_cd,
                                     i.pu01_customer_type,
                                     i.pu01_customer_sub_type,
                                     i.pu05_identity_type_id_m15,
                                     i.cism_ro_cd,
                                     pcism_seq_nb);
                ELSE
                    IF i.row_status = 'Update'
                    THEN
                        IF (   i.cism_trn_typ = 'REFCUS'
                            OR i.cism_trn_typ = 'UPDCUS')   --Customer refresh
                        THEN
                            sp_update_customer (p_ret_sts,
                                                p_ret_msg,
                                                p_u01_id,
                                                i.u01_customer_no,
                                                i.pu01_display_name,
                                                i.pu01_display_name_lang,
                                                i.pu01_gender,
                                                i.pu01_date_of_birth,
                                                i.pu01_is_ipo_customer,
                                                i.pu01_vat_waive_off,
                                                i.pu01_tax_ref,
                                                i.pu02_mobile,
                                                i.pu02_email,
                                                i.pu01_category_m89,
                                                i.pu01_kyc_next_review,
                                                i.pu05_id_no,
                                                i.pu05_identity_type_id_m15,
                                                i.pu02_address_line1,
                                                i.pu02_address_line2,
                                                i.pu02_address_line3,
                                                i.pu02_address_line4,
                                                i.pu02_address_line1_lang,
                                                i.pu02_address_line2_lang,
                                                i.pu02_address_line3_lang,
                                                i.pu02_address_line4_lang,
                                                i.pu02_zip_code,
                                                i.pu02_po_box,
                                                i.pu05_expiry_date,
                                                i.pu01_nationality_id_m05,
                                                i.pu01_preferred_lang_id_v01,
                                                i.pu02_country_id_m05,
                                                l_user_id,
                                                i.pu01_customer_blk_cd,
                                                i.pu01_customer_type,
                                                i.pu01_customer_sub_type,
                                                pcism_seq_nb);
                        ELSIF (   i.cism_trn_typ = 'CRTACC'
                               OR i.cism_trn_typ = 'QRYACC')
                        THEN
                            -- Create new account

                            sp_create_cash_account (
                                pkey,
                                p_ret_sts,
                                p_ret_msg,
                                p_u01_id,
                                p_u06_id,
                                i.u01_customer_no,
                                i.u06_currency_code_m03,
                                i.u06_investment_account_no,
                                i.pu01_vat_waive_off,
                                i.cism_trn_typ,
                                pcism_seq_nb,
                                i.u06_block_status_b,
                                l_user_id,
                                i.cism_open_port);
                        ELSIF (   i.cism_trn_typ = 'UPDACC'
                               OR i.cism_trn_typ = 'REFACC')
                        THEN
                            sp_update_cash_account (
                                pkey,
                                p_ret_sts,
                                p_ret_msg,
                                p_u01_id,
                                p_u06_id,
                                i.u01_customer_no,
                                i.u06_investment_account_no,
                                i.u06_block_status_b,
                                i.cism_trn_typ,
                                pcism_seq_nb,
                                i.pu01_vat_waive_off,
                                l_user_id);
                        ELSIF (   i.cism_trn_typ = 'BLKCUS'
                               OR i.cism_trn_typ = 'DLKCUS')  --Block Customer
                        THEN
                            sp_customer_block (pkey,
                                               p_ret_sts,
                                               p_ret_msg,
                                               p_u01_id,
                                               i.u01_customer_no,
                                               pcism_seq_nb,
                                               i.pu01_customer_blk_cd,
                                               l_user_id);
                        --Block Customer end

                        --------------------------------------------------------------------------------
                        ELSIF (   i.cism_trn_typ = 'BLKACC'
                               OR i.cism_trn_typ = 'DLKACC')   --Block Account
                        THEN
                            sp_account_block (pkey,
                                              p_ret_sts,
                                              p_ret_msg,
                                              p_u01_id,
                                              p_u06_id,
                                              i.u01_customer_no,
                                              i.u06_investment_account_no,
                                              pcism_seq_nb,
                                              i.pu01_customer_blk_cd,
                                              l_user_id);
                        ELSIF (   i.cism_trn_typ = 'CRTBEN'
                               OR i.cism_trn_typ = 'UPDBEN'
                               OR i.cism_trn_typ = 'REFBEN'
                               OR i.cism_trn_typ = 'DELBEN'
                               OR i.cism_trn_typ = 'BENINQ') --Add Update Benificiary
                        THEN
                            sp_add_beneficiary_account (
                                pkey,
                                p_ret_sts,
                                p_ret_msg,
                                p_u01_id,
                                p_u06_id,
                                p_u08_id,
                                i.u01_customer_no,
                                i.u08_sequence_no_b,
                                pcism_seq_nb,
                                i.u06_currency_code_m03,
                                i.pu08_status_id_v01,
                                i.pu08_bank_id_m16,
                                i.pu08_iban_no,
                                i.pu08_bank_branch_name,
                                i.pu08_account_name,
                                i.cism_trn_typ,
                                l_user_id,
                                i.pm08_id,
                                i.pu05_id_no);
                        ELSIF (   i.cism_trn_typ = 'CRTPOA'
                               OR i.cism_trn_typ = 'UPDPOA'
                               OR i.cism_trn_typ = 'REFPOA'
                               OR i.cism_trn_typ = 'BLKPOA'
                               OR i.cism_trn_typ = 'DELPOA')
                        THEN
                            sp_update_power_of_attorney (
                                pkey,
                                p_ret_sts,
                                p_ret_msg,
                                p_u01_id,
                                p_u47_id,
                                l_user_id,
                                i.u01_customer_no,
                                i.cism_trn_typ,
                                pcism_seq_nb,
                                i.pu01_display_name,
                                i.pu05_id_no,
                                i.pu05_expiry_date,
                                i.poa_priviledge,
                                i.pu08_status_id_v01);
                        ELSE
                            p_ret_sts := 1;
                            p_ret_msg := i.row_status;
                        END IF;
                    ELSE
                        p_ret_sts := 1;
                        p_ret_msg := i.row_status;
                    END IF;
                END IF;
            END;
        END LOOP;

        SELECT NVL (MAX (t58_id), 0)
          INTO l_t58_id
          FROM t58_cache_clear_request;

        IF (p_u01_id > 0)
        THEN
            l_t58_id := l_t58_id + 1;

            INSERT INTO dfn_ntp.t58_cache_clear_request (t58_id,
                                                         t58_table_id,
                                                         t58_store_keys_json,
                                                         t58_clear_all,
                                                         t58_custom_type,
                                                         t58_status,
                                                         t58_created_date,
                                                         t58_priority,
                                                         t58_server_id)
                 VALUES (l_t58_id,
                         'U01_CUSTOMER',
                         '{"u01_id":' || p_u01_id || '}',
                         0,
                         1,
                         0,
                         SYSDATE,
                         0,
                         NULL);
        END IF;

        IF (p_u06_id > 0)
        THEN
            l_t58_id := l_t58_id + 1;

            INSERT INTO dfn_ntp.t58_cache_clear_request (t58_id,
                                                         t58_table_id,
                                                         t58_store_keys_json,
                                                         t58_clear_all,
                                                         t58_custom_type,
                                                         t58_status,
                                                         t58_created_date,
                                                         t58_priority,
                                                         t58_server_id)
                 VALUES (l_t58_id,
                         'U06_CASH_ACCOUNT',
                         '{"u06_id":' || p_u06_id || '}',
                         0,
                         1,
                         0,
                         SYSDATE,
                         0,
                         NULL);
        END IF;

        IF (p_u08_id > 0)
        THEN
            l_t58_id := l_t58_id + 1;

            INSERT INTO dfn_ntp.t58_cache_clear_request (t58_id,
                                                         t58_table_id,
                                                         t58_store_keys_json,
                                                         t58_clear_all,
                                                         t58_custom_type,
                                                         t58_status,
                                                         t58_created_date,
                                                         t58_priority,
                                                         t58_server_id)
                 VALUES (
                            l_t58_id,
                            'U08_CUSTOMER_BENEFICIARY_ACC',
                               '{"u01_id":'
                            || p_u01_id
                            || ',"u08_id":'
                            || p_u08_id
                            || '}',
                            0,
                            1,
                            0,
                            SYSDATE,
                            0,
                            NULL);
        END IF;

        IF (p_u47_id > 0)
        THEN
            l_t58_id := l_t58_id + 1;

            INSERT INTO dfn_ntp.t58_cache_clear_request (t58_id,
                                                         t58_table_id,
                                                         t58_store_keys_json,
                                                         t58_clear_all,
                                                         t58_custom_type,
                                                         t58_status,
                                                         t58_created_date,
                                                         t58_priority,
                                                         t58_server_id)
                 VALUES (l_t58_id,
                         'U47_POWER_OF_ATTORNEY',
                         '{"u47_id":' || p_u47_id || '}',
                         0,
                         1,
                         0,
                         SYSDATE,
                         0,
                         NULL);
        END IF;

        UPDATE app_seq_store
           SET app_seq_value = l_t58_id
         WHERE app_seq_name = 'T58_CACHE_CLEAR_REQUEST';
    END;

    PROCEDURE sp_update_currency_rate
    IS
        l_u17_id                   NUMBER := 0;
        l_u17_institution_id_m02   NUMBER := 1;
    BEGIN
        SELECT u17_id, u17_institution_id_m02
          INTO l_u17_id, l_u17_institution_id_m02
          FROM u17_employee u17
         WHERE u17_login_name = 'INTEGRATION_USER';


        FOR i
            IN (SELECT crat_buy_rate,
                       crat_sell_rate,
                       crat_curr_cd,
                       crat_rate_typ
                  FROM crat_syno
                 WHERE     crat_curr_cd <> 'EGP'
                       AND crat_rate_typ = 'C'
                       AND crat_buy_rate > 0
                       AND crat_sell_rate > 0)
        LOOP
            UPDATE m04_currency_rate
               SET m04_rate =
                       ROUND ( (i.crat_buy_rate + i.crat_sell_rate) / 2, 5),
                   m04_buy_rate = i.crat_buy_rate,
                   m04_sell_rate = i.crat_sell_rate,
                   m04_modified_by_id_u17 = l_u17_id,
                   m04_modified_date = SYSDATE
             WHERE     m04_from_currency_code_m03 = i.crat_curr_cd
                   AND m04_to_currency_code_m03 = 'SAR'
                   AND m04_category_v01 = 0;

            UPDATE m04_currency_rate
               SET m04_rate =
                       ROUND (2 / (i.crat_buy_rate + i.crat_sell_rate), 5),
                   m04_buy_rate = ROUND (1 / i.crat_buy_rate, 5),
                   m04_sell_rate = ROUND (1 / i.crat_sell_rate, 5),
                   m04_modified_by_id_u17 = l_u17_id,
                   m04_modified_date = SYSDATE
             WHERE     m04_from_currency_code_m03 = 'SAR'
                   AND m04_to_currency_code_m03 = i.crat_curr_cd
                   AND m04_category_v01 = 0;
        END LOOP;


        FOR i
            IN (SELECT crat_buy_rate,
                       crat_sell_rate,
                       crat_curr_cd,
                       crat_rate_typ
                  FROM crat_syno
                 WHERE     crat_curr_cd <> 'EGP'
                       AND crat_rate_typ = 'C'
                       AND crat_buy_rate > 0
                       AND crat_sell_rate > 0)
        LOOP
            FOR j
                IN (SELECT crat_buy_rate,
                           crat_sell_rate,
                           crat_curr_cd,
                           crat_rate_typ
                      FROM crat_syno
                     WHERE     crat_curr_cd <> 'EGP'
                           AND crat_rate_typ = 'C'
                           AND crat_buy_rate > 0
                           AND crat_sell_rate > 0)
            LOOP
                UPDATE m04_currency_rate
                   SET m04_rate =
                           ROUND (
                                 (j.crat_buy_rate + j.crat_sell_rate)
                               / (i.crat_buy_rate + i.crat_sell_rate),
                               5),
                       m04_buy_rate = j.crat_buy_rate / i.crat_buy_rate,
                       m04_sell_rate = j.crat_sell_rate / i.crat_sell_rate,
                       m04_modified_by_id_u17 = l_u17_id,
                       m04_modified_date = SYSDATE
                 WHERE     m04_from_currency_code_m03 = j.crat_curr_cd
                       AND m04_to_currency_code_m03 = i.crat_curr_cd
                       AND m04_category_v01 = 0;
            END LOOP;
        END LOOP;

        FOR i
            IN (SELECT crat_buy_rate,
                       crat_sell_rate,
                       crat_curr_cd,
                       crat_rate_typ
                  FROM crat_syno
                 WHERE     crat_curr_cd <> 'EGP'
                       AND crat_rate_typ = 'S'
                       AND crat_buy_rate > 0
                       AND crat_sell_rate > 0)
        LOOP
            UPDATE m04_currency_rate
               SET m04_rate =
                       ROUND ( (i.crat_buy_rate + i.crat_sell_rate) / 2, 5),
                   m04_buy_rate = i.crat_buy_rate,
                   m04_sell_rate = i.crat_sell_rate,
                   m04_modified_by_id_u17 = l_u17_id,
                   m04_modified_date = SYSDATE
             WHERE     m04_from_currency_code_m03 = i.crat_curr_cd
                   AND m04_to_currency_code_m03 = 'SAR'
                   AND m04_category_v01 = 1;

            UPDATE m04_currency_rate
               SET m04_rate =
                       ROUND (2 / (i.crat_buy_rate + i.crat_sell_rate), 5),
                   m04_buy_rate = ROUND (1 / i.crat_buy_rate, 5),
                   m04_sell_rate = ROUND (1 / i.crat_sell_rate, 5),
                   m04_modified_by_id_u17 = l_u17_id,
                   m04_modified_date = SYSDATE
             WHERE     m04_from_currency_code_m03 = 'SAR'
                   AND m04_to_currency_code_m03 = i.crat_curr_cd
                   AND m04_category_v01 = 1;
        END LOOP;


        FOR i
            IN (SELECT crat_buy_rate,
                       crat_sell_rate,
                       crat_curr_cd,
                       crat_rate_typ
                  FROM crat_syno
                 WHERE     crat_curr_cd <> 'EGP'
                       AND crat_rate_typ = 'S'
                       AND crat_buy_rate > 0
                       AND crat_sell_rate > 0)
        LOOP
            FOR j
                IN (SELECT crat_buy_rate,
                           crat_sell_rate,
                           crat_curr_cd,
                           crat_rate_typ
                      FROM crat_syno
                     WHERE     crat_curr_cd <> 'EGP'
                           AND crat_rate_typ = 'S'
                           AND crat_buy_rate > 0
                           AND crat_sell_rate > 0)
            LOOP
                UPDATE m04_currency_rate
                   SET m04_rate =
                           ROUND (
                                 (j.crat_buy_rate + j.crat_sell_rate)
                               / (i.crat_buy_rate + i.crat_sell_rate),
                               5),
                       m04_buy_rate = j.crat_buy_rate / i.crat_buy_rate,
                       m04_sell_rate = j.crat_sell_rate / i.crat_sell_rate,
                       m04_modified_by_id_u17 = l_u17_id,
                       m04_modified_date = SYSDATE
                 WHERE     m04_from_currency_code_m03 = j.crat_curr_cd
                       AND m04_to_currency_code_m03 = i.crat_curr_cd
                       AND m04_category_v01 = 1;
            END LOOP;
        END LOOP;
    END;


    PROCEDURE sp_update_power_of_attorney (
        pkey                     OUT VARCHAR,
        p_ret_sts                OUT NUMBER,             -- default to failure
        p_ret_msg                OUT VARCHAR2,
        p_u01_id                 OUT NUMBER,
        p_u47_id                 OUT NUMBER,
        pu17_id               IN     NUMBER,
        pu01_customer_no      IN     VARCHAR2,
        pcism_trn_typ         IN     VARCHAR2,
        pcism_seq_nb          IN     VARCHAR2,
        pu47_poa_name         IN     VARCHAR2,
        pu47_id_no            IN     VARCHAR2,
        pu47_id_expiry_date   IN     VARCHAR2,
        pu49_privilege        IN     VARCHAR2,
        pu08_status_id_v01    IN     VARCHAR2)
    IS
        l_cust_count   NUMBER := 0;
        l_u47_id       NUMBER := 0;
        l_u49_id       NUMBER := 0;
    BEGIN
        SELECT COUNT (*)
          INTO l_cust_count
          FROM u01_customer u01
         WHERE u01_customer_no = pu01_customer_no;

        IF (l_cust_count = 0)
        THEN
            p_ret_msg := 'Customer Not Found';
            add_cism_log (
                   'sequence no >> '
                || pcism_seq_nb
                || 'POA Creation Customer, '
                || p_ret_msg
                || ' '
                || pu47_id_no,
                l_cust_count);
            p_ret_sts := 1;

            RETURN;
        END IF;


        SELECT u01_id
          INTO p_u01_id
          FROM u01_customer u01
         WHERE u01_customer_no = pu01_customer_no;

        BEGIN
            SELECT u47_id
              INTO l_u47_id
              FROM u47_power_of_attorney
             WHERE u47_customer_id_u01 = p_u01_id AND u47_id_no = pu47_id_no;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_u47_id := 0;
        END;

        p_u47_id := l_u47_id;

        IF (pcism_trn_typ = 'CRTPOA')
        THEN
            SELECT fn_get_next_sequnce ('U47_POWER_OF_ATTORNEY')
              INTO l_u47_id
              FROM DUAL;

            INSERT INTO u47_power_of_attorney (u47_id,
                                               u47_customer_id_u01,
                                               u47_poa_name,
                                               u47_id_type_m15,
                                               u47_id_no,
                                               u47_id_expiry_date,
                                               u47_created_by_id_u17,
                                               u47_created_date,
                                               u47_status_id_v01,
                                               u47_institute_id_m02,
                                               u47_status_changed_by_id_u17,
                                               u47_status_changed_date)
                 VALUES (l_u47_id,
                         p_u01_id,
                         pu47_poa_name,
                         1,
                         pu47_id_no,
                         TO_DATE (pu47_id_expiry_date, 'DD/MM/YYYY'),
                         pu17_id,
                         SYSDATE,
                         DECODE (pu08_status_id_v01, 'Y', 2, 3),
                         1,
                         pu17_id,
                         SYSDATE);


            p_u47_id := l_u47_id;

            sp_add_audit (pu17_id,
                          20001,
                          'Customer POA Created from CRM',
                          p_u01_id,
                          p_u01_id,
                          0);



            SELECT MAX (u49_id) INTO l_u49_id FROM u49_poa_trading_privileges;

            FOR i IN (SELECT u07_id
                        FROM u07_trading_account
                       WHERE u07_customer_id_u01 = p_u01_id)
            LOOP
                l_u49_id := l_u49_id + 1;

                IF (INSTR (pu49_privilege, 'BS') > 0)
                THEN
                    INSERT
                      INTO u49_poa_trading_privileges (
                               u49_id,
                               u49_poa_id_u47,
                               u49_trading_account_id_u07,
                               u49_privilege_type_id_v31,
                               u49_issue_date,
                               u49_poa_expiry_date)
                    VALUES (l_u49_id,
                            l_u47_id,
                            i.u07_id,
                            20,
                            SYSDATE,
                            TO_DATE (pu47_id_expiry_date, 'DD/MM/YYYY'));

                    sp_add_audit (pu17_id,
                                  419,
                                  'POA Restriction Added',
                                  p_u01_id,
                                  p_u01_id,
                                  0);

                    INSERT
                      INTO u52_poa_trad_privilege_pending (
                               u52_id,
                               u52_poa_id_u47,
                               u52_trading_account_id_u07,
                               u52_status_id_v01,
                               u52_status_changed_by_id_u17,
                               u52_status_changed_date,
                               u52_custom_type)
                    VALUES (
                               fn_get_next_sequnce (
                                   'U52_POA_TRAD_PRIVILEGE_PENDING'),
                               l_u47_id,
                               i.u07_id,
                               2,
                               pu17_id,
                               SYSDATE,
                               '1');
                ELSIF (INSTR (pu49_privilege, 'SS') > 0)
                THEN
                    INSERT
                      INTO u49_poa_trading_privileges (
                               u49_id,
                               u49_poa_id_u47,
                               u49_trading_account_id_u07,
                               u49_privilege_type_id_v31,
                               u49_issue_date,
                               u49_poa_expiry_date)
                    VALUES (l_u49_id,
                            l_u47_id,
                            i.u07_id,
                            21,
                            SYSDATE,
                            TO_DATE (pu47_id_expiry_date, 'DD/MM/YYYY'));

                    sp_add_audit (pu17_id,
                                  419,
                                  'POA Restriction Added',
                                  p_u01_id,
                                  p_u01_id,
                                  0);

                    INSERT
                      INTO u52_poa_trad_privilege_pending (
                               u52_id,
                               u52_poa_id_u47,
                               u52_trading_account_id_u07,
                               u52_status_id_v01,
                               u52_status_changed_by_id_u17,
                               u52_status_changed_date,
                               u52_custom_type)
                    VALUES (
                               fn_get_next_sequnce (
                                   'U52_POA_TRAD_PRIVILEGE_PENDING'),
                               l_u47_id,
                               i.u07_id,
                               2,
                               pu17_id,
                               SYSDATE,
                               '1');
                ELSIF (INSTR (pu49_privilege, 'CT') > 0)
                THEN
                    INSERT
                      INTO u49_poa_trading_privileges (
                               u49_id,
                               u49_poa_id_u47,
                               u49_trading_account_id_u07,
                               u49_privilege_type_id_v31,
                               u49_issue_date,
                               u49_poa_expiry_date)
                    VALUES (l_u49_id,
                            l_u47_id,
                            i.u07_id,
                            25,
                            SYSDATE,
                            TO_DATE (pu47_id_expiry_date, 'DD/MM/YYYY'));

                    sp_add_audit (pu17_id,
                                  419,
                                  'POA Restriction Added',
                                  p_u01_id,
                                  p_u01_id,
                                  0);

                    INSERT
                      INTO u52_poa_trad_privilege_pending (
                               u52_id,
                               u52_poa_id_u47,
                               u52_trading_account_id_u07,
                               u52_status_id_v01,
                               u52_status_changed_by_id_u17,
                               u52_status_changed_date,
                               u52_custom_type)
                    VALUES (
                               fn_get_next_sequnce (
                                   'U52_POA_TRAD_PRIVILEGE_PENDING'),
                               l_u47_id,
                               i.u07_id,
                               2,
                               pu17_id,
                               SYSDATE,
                               '1');
                END IF;
            END LOOP;

            UPDATE app_seq_store
               SET app_seq_value = l_u49_id
             WHERE app_seq_name = 'U49_POA_TRADING_PRIVILEGES';
        ELSIF (   pcism_trn_typ = 'UPDPOA'
               OR pcism_trn_typ = 'REFPOA'
               OR pcism_trn_typ = 'BLKPOA'
               OR pcism_trn_typ = 'DELPOA')
        THEN
            IF (l_u47_id = 0)
            THEN
                p_ret_msg := 'POA Not Found';
                add_cism_log (
                       'sequence no >> '
                    || pcism_seq_nb
                    || 'POA Update, '
                    || p_ret_msg
                    || ' '
                    || pu47_id_no,
                    l_cust_count);
            END IF;

            SELECT MAX (u49_id) INTO l_u49_id FROM u49_poa_trading_privileges;

            p_u47_id := l_u47_id;

            IF (pcism_trn_typ = 'UPDPOA' OR pcism_trn_typ = 'REFPOA')
            THEN
                UPDATE u47_power_of_attorney
                   SET u47_status_id_v01 =
                           DECODE (pu08_status_id_v01, 'Y', 2, 3),
                       u47_modified_by_id_u17 = pu17_id,
                       u47_modified_date = SYSDATE
                 WHERE u47_id = l_u47_id;

                sp_add_audit (pu17_id,
                              406,
                              'Customer POA Modified',
                              p_u01_id,
                              p_u01_id,
                              0);
            ELSE
                UPDATE u47_power_of_attorney
                   SET u47_status_id_v01 = 3,
                       u47_modified_by_id_u17 = pu17_id,
                       u47_modified_date = SYSDATE
                 WHERE u47_id = l_u47_id;

                sp_add_audit (pu17_id,
                              406,
                              'Customer POA Modified',
                              p_u01_id,
                              p_u01_id,
                              0);
            END IF;

            IF (INSTR (pu49_privilege, 'BS') > 0)
            THEN
                BEGIN
                    SELECT u49_id
                      INTO l_u49_id
                      FROM u49_poa_trading_privileges
                     WHERE     u49_poa_id_u47 = l_u47_id
                           AND u49_privilege_type_id_v31 = 1;
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        l_u49_id := 0;
                END;

                IF (l_u49_id = 0)
                THEN
                    FOR i IN (SELECT u07_id
                                FROM u07_trading_account
                               WHERE u07_customer_id_u01 = p_u01_id)
                    LOOP
                        l_u49_id := l_u49_id + 1;

                        INSERT
                          INTO u49_poa_trading_privileges (
                                   u49_id,
                                   u49_poa_id_u47,
                                   u49_trading_account_id_u07,
                                   u49_privilege_type_id_v31,
                                   u49_issue_date,
                                   u49_poa_expiry_date)
                        VALUES (l_u49_id,
                                l_u47_id,
                                i.u07_id,
                                1,
                                SYSDATE,
                                TO_DATE (pu47_id_expiry_date, 'DD/MM/YYYY'));

                        sp_add_audit (pu17_id,
                                      419,
                                      'POA Restriction Added',
                                      p_u01_id,
                                      p_u01_id,
                                      0);
                    END LOOP;
                END IF;
            ELSE
                BEGIN
                    SELECT u49_id
                      INTO l_u49_id
                      FROM u49_poa_trading_privileges
                     WHERE     u49_poa_id_u47 = l_u47_id
                           AND u49_privilege_type_id_v31 = 1;
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        l_u49_id := 0;
                END;

                IF (l_u49_id > 0)
                THEN
                    UPDATE u49_poa_trading_privileges
                       SET u49_is_active = 0
                     WHERE     u49_poa_id_u47 = l_u47_id
                           AND u49_privilege_type_id_v31 = 1;

                    sp_add_audit (pu17_id,
                                  415,
                                  'POA Restriction Added',
                                  p_u01_id,
                                  p_u01_id,
                                  0);
                END IF;
            END IF;

            IF (INSTR (pu49_privilege, 'SS') > 0)
            THEN
                BEGIN
                    SELECT u49_id
                      INTO l_u49_id
                      FROM u49_poa_trading_privileges
                     WHERE     u49_poa_id_u47 = l_u47_id
                           AND u49_privilege_type_id_v31 = 2;
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        l_u49_id := 0;
                END;

                IF (l_u49_id = 0)
                THEN
                    FOR i IN (SELECT u07_id
                                FROM u07_trading_account
                               WHERE u07_customer_id_u01 = p_u01_id)
                    LOOP
                        l_u49_id := l_u49_id + 1;

                        INSERT
                          INTO u49_poa_trading_privileges (
                                   u49_id,
                                   u49_poa_id_u47,
                                   u49_trading_account_id_u07,
                                   u49_privilege_type_id_v31,
                                   u49_issue_date,
                                   u49_poa_expiry_date)
                        VALUES (l_u49_id,
                                l_u47_id,
                                i.u07_id,
                                2,
                                SYSDATE,
                                TO_DATE (pu47_id_expiry_date, 'DD/MM/YYYY'));

                        sp_add_audit (pu17_id,
                                      419,
                                      'POA Restriction Added',
                                      p_u01_id,
                                      p_u01_id,
                                      0);
                    END LOOP;
                END IF;
            ELSE
                BEGIN
                    SELECT u49_id
                      INTO l_u49_id
                      FROM u49_poa_trading_privileges
                     WHERE     u49_poa_id_u47 = l_u47_id
                           AND u49_privilege_type_id_v31 = 2;
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        l_u49_id := 0;
                END;

                IF (l_u49_id > 0)
                THEN
                    UPDATE u49_poa_trading_privileges
                       SET u49_is_active = 0
                     WHERE     u49_poa_id_u47 = l_u47_id
                           AND u49_privilege_type_id_v31 = 2;

                    sp_add_audit (pu17_id,
                                  415,
                                  'POA Restriction Added',
                                  p_u01_id,
                                  p_u01_id,
                                  0);
                END IF;
            END IF;

            IF (INSTR (pu49_privilege, 'CT') > 0)
            THEN
                BEGIN
                    SELECT u49_id
                      INTO l_u49_id
                      FROM u49_poa_trading_privileges
                     WHERE     u49_poa_id_u47 = l_u47_id
                           AND u49_privilege_type_id_v31 = 11;
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        l_u49_id := 0;
                END;

                IF (l_u49_id = 0)
                THEN
                    FOR i IN (SELECT u07_id
                                FROM u07_trading_account
                               WHERE u07_customer_id_u01 = p_u01_id)
                    LOOP
                        l_u49_id := l_u49_id + 1;

                        INSERT
                          INTO u49_poa_trading_privileges (
                                   u49_id,
                                   u49_poa_id_u47,
                                   u49_trading_account_id_u07,
                                   u49_privilege_type_id_v31,
                                   u49_issue_date,
                                   u49_poa_expiry_date)
                        VALUES (l_u49_id,
                                l_u47_id,
                                i.u07_id,
                                11,
                                SYSDATE,
                                TO_DATE (pu47_id_expiry_date, 'DD/MM/YYYY'));

                        sp_add_audit (pu17_id,
                                      419,
                                      'POA Restriction Added',
                                      p_u01_id,
                                      p_u01_id,
                                      0);
                    END LOOP;
                END IF;
            ELSE
                BEGIN
                    SELECT u49_id
                      INTO l_u49_id
                      FROM u49_poa_trading_privileges
                     WHERE     u49_poa_id_u47 = l_u47_id
                           AND u49_privilege_type_id_v31 = 11;
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        l_u49_id := 0;
                END;

                IF (l_u49_id > 0)
                THEN
                    UPDATE u49_poa_trading_privileges
                       SET u49_is_active = 0
                     WHERE     u49_poa_id_u47 = l_u47_id
                           AND u49_privilege_type_id_v31 = 11;

                    sp_add_audit (pu17_id,
                                  415,
                                  'POA Restriction Added',
                                  p_u01_id,
                                  p_u01_id,
                                  0);
                END IF;
            END IF;

            UPDATE app_seq_store
               SET app_seq_value = l_u49_id
             WHERE app_seq_name = 'U49_POA_TRADING_PRIVILEGES';
        END IF;
    EXCEPTION
        WHEN OTHERS
        THEN
            pkey := -2;
    END;


    PROCEDURE sp_int_manua_customer_update (
        paccount_number     IN     VARCHAR2,
        ptransaction_code   IN     VARCHAR2,
        puser_id            IN     NUMBER,
        pis_customer_no     IN     NUMBER DEFAULT 1,
        pcash_account_id       OUT NUMBER,
        pcus_account_id        OUT NUMBER,
        pmessage               OUT VARCHAR2,
        pkey                   OUT VARCHAR2)
    IS
        l_next     NUMBER;
        l_status   NUMBER := 0;                    /*0 - Success | <> 0 Fail*/
    BEGIN
        pkey := 1;
        l_next := seq_a50_id_b.NEXTVAL;

        IF pis_customer_no = 1
        THEN
            SELECT u01_id
              INTO pcus_account_id
              FROM u01_customer
             WHERE u01_customer_no = paccount_number;
        ELSE
            SELECT u06_customer_id_u01, u06_id
              INTO pcus_account_id, pcash_account_id
              FROM u06_cash_account
             WHERE u06_investment_account_no = paccount_number;
        END IF;



        add_cism_log (pa50_message             => NULL,
                      pa50_status              => 1,
                      pa50_update_code         => ptransaction_code,
                      pa50_created_by_id_u17   => puser_id,
                      pa50_account_no          => paccount_number);

        dfn_ntp.prc_sfc_ams_idb_interface (p_mode      => ptransaction_code,
                                           p_cust      => paccount_number,
                                           p_retcd     => l_status,
                                           p_ret_msg   => pmessage);

        IF l_status <> 0
        THEN
            pkey := -2;
        END IF;
    EXCEPTION
        WHEN OTHERS
        THEN
            pkey := -2;
    END;

    PROCEDURE sp_beneficiary_acc_inq (pcism_trn_typ   IN     VARCHAR2, --v_inq_typ,
                                      p08_id          IN     NUMBER,
                                      pu08_iban_no    IN     VARCHAR2, --v_cust_acc_nb,
                                      p_ret_sts          OUT NUMBER, -- default to failure
                                      p_ret_msg          OUT VARCHAR2)
    IS
        v_user_cd   VARCHAR2 (100);
        v_brn_cd    NUMBER (10);
    BEGIN
        v_user_cd := NULL;
        v_brn_cd := 22;
        dfn_ntp.proc_benf_acc_inq (pcism_trn_typ,
                                   p08_id,
                                   pu08_iban_no,
                                   v_brn_cd,
                                   v_user_cd,
                                   p_ret_sts,
                                   p_ret_msg);
    END;
END;
/
