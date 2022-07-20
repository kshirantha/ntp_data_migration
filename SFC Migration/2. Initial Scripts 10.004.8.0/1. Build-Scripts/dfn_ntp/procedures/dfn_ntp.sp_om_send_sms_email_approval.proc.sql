CREATE OR REPLACE PROCEDURE dfn_ntp.sp_om_send_sms_email_approval (
    pcustomer_id         IN     NUMBER,
    pinstitute_id        IN     NUMBER,
    prequest_id          IN     NUMBER,
    pmargin_product_id   IN     NUMBER,
    p_key                   OUT NUMBER)
IS
    l_cc_list               VARCHAR2 (1000);
    l_cc_list_count         NUMBER;
    l_mobile                VARCHAR2 (20);
    l_margin_mobile         VARCHAR2 (20);
    l_email                 VARCHAR2 (200);
    l_preferred_lang        VARCHAR2 (20);
    l_customer_no           NUMBER;
    l_customer_name         VARCHAR2 (1000);
    l_inst_email            VARCHAR2 (200);
    l_inst_email_count      NUMBER;
    l_id                    VARCHAR2 (10);
    l_loan_amount           NUMBER;
    l_final_approval        BLOB;
    l_final_approval_name   VARCHAR2 (200);
    l_message               VARCHAR2 (300);
BEGIN
    SELECT u01.u01_def_mobile,
           CASE
               WHEN    u01.u01_preferred_lang_id_v01 IS NULL
                    OR u01.u01_preferred_lang_id_v01 = 1
               THEN
                   'EN'
               ELSE
                   'AR'
           END
               AS preferred_language,
           CASE
               WHEN    u01.u01_preferred_lang_id_v01 IS NULL
                    OR u01.u01_preferred_lang_id_v01 = 1
               THEN
                   u01.u01_full_name
               ELSE
                   u01.u01_full_name_lang
           END
               AS customer_name,
           u01_customer_no
      INTO l_mobile,
           l_preferred_lang,
           l_customer_name,
           l_customer_no
      FROM u01_customer u01
     WHERE u01_id = pcustomer_id AND u01.u01_institute_id_m02 = pinstitute_id;

    SELECT t73_margin_notify_mobile,
           t73_margin_notify_email,
           t73_margin_final_approval_doc,
           t73_margin_final_appr_doc_name,
           t73_required_margin
      INTO l_margin_mobile,
           l_email,
           l_final_approval,
           l_final_approval_name,
           l_loan_amount
      FROM t73_om_margin_trading_request
     WHERE t73_id = prequest_id;

    l_message :=
           l_message
        || 'LoanAmount ='
        || TO_CHAR (l_loan_amount)
        || UNISTR ('\0001');

    IF l_margin_mobile IS NULL
    THEN
        l_margin_mobile := l_mobile;
    END IF;

    SELECT COUNT (m02_email)
      INTO l_inst_email_count
      FROM m02_institute
     WHERE m02_id = pinstitute_id;

    IF l_inst_email_count > 0
    THEN
        SELECT m02_email
          INTO l_inst_email
          FROM m02_institute
         WHERE m02_id = pinstitute_id;
    END IF;

    SELECT COUNT (u41_notify_email_cc_list)
      INTO l_cc_list_count
      FROM u41_notification_configuration
     WHERE     u41_institution_id_m02 = pinstitute_id
           AND u41_notification_type_id_m100 = 50;

    IF l_cc_list_count > 0
    THEN
        SELECT u41_notify_email_cc_list
          INTO l_cc_list
          FROM u41_notification_configuration
         WHERE     u41_institution_id_m02 = pinstitute_id
               AND u41_notification_type_id_m100 = 50;
    END IF;

    IF (l_margin_mobile IS NOT NULL)
    THEN
        sp_sms_email_add (pkey                  => l_id,
                          p_mobile_no           => l_margin_mobile,
                          p_lang                => l_preferred_lang,
                          p_event_id            => 57,
                          p_institution         => pinstitute_id,
                          p_custname            => l_customer_name,
                          p_notification_type   => 1,
                          p_message             => l_message,
                          p_date                => SYSDATE,
                          p_template_id         => 61);
    END IF;

    UPDATE t73_om_margin_trading_request
       SET t73_margin_sms_notifica_id_t13 = l_id
     WHERE t73_id = prequest_id;

    IF (l_final_approval IS NOT NULL AND l_final_approval_name IS NOT NULL)
    THEN
        IF (l_email IS NOT NULL)
        THEN
            sp_sms_email_add (pkey                  => l_id,
                              p_to_email            => l_email,
                              p_from_email          => l_inst_email,
                              p_lang                => l_preferred_lang,
                              p_event_id            => 57,
                              p_cc_emails           => l_cc_list,
                              p_institution         => pinstitute_id,
                              p_date                => SYSDATE,
                              p_custname            => l_customer_name,
                              p_notification_type   => 2,
                              p_message_subject     => '',
                              p_message             => l_message,
                              p_template_id         => 61);
        END IF;


        INSERT
          INTO t14_notification_data (t14_t13_id,
                                      t14_attachment_name,
                                      t14_attachment_data)
        VALUES (l_id, l_final_approval_name, l_final_approval);

        INSERT INTO t14_notification_data (t14_t13_id,
                                           t14_attachment_name,
                                           t14_attachment_data)
            SELECT l_id, 'Margin_Disclaimer.pdf', m73_margin_disclaimer
              FROM m73_margin_products
             WHERE m73_id = pmargin_product_id;

        INSERT INTO t14_notification_data (t14_t13_id,
                                           t14_attachment_name,
                                           t14_attachment_data)
            SELECT l_id, m66_document_name, m66_document
              FROM m66_institute_level_documents
             WHERE m66_institute_id_m02 = pinstitute_id AND m66_type = 1;

        UPDATE t73_om_margin_trading_request
           SET t73_margin_email_notifi_id_t13 = l_id
         WHERE t73_id = prequest_id;

        p_key := l_id;
    ELSE
        p_key := -1;
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        p_key := -2;
END;
/