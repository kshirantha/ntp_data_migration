CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_customer_address (
    p_customer_id    NUMBER,
    p_with_name      NUMBER)
    RETURN VARCHAR2
IS
    l_address   VARCHAR2 (1000);
BEGIN
    SELECT    CASE
                  WHEN p_with_name = 1
                  THEN
                      DECODE (
                          DECODE (u01_preferred_lang_id_v01,
                                  1, u01_display_name,
                                  u01_display_name_lang),
                          NULL, '',
                             DECODE (u01_preferred_lang_id_v01,
                                     1, u01_display_name,
                                     u01_display_name_lang)
                          || CHR (13))
                  ELSE
                      ''
              END
           || DECODE (
                  u02_po_box,
                  NULL, '',
                     DECODE (
                         u01_preferred_lang_id_v01,
                         1, 'P.O. Box : ',
                         UNISTR (
                             TO_CHAR (
                                 REPLACE (
                                     '\u0635 \u0628: \u0635\u0646\u062F\u0648\u0642',
                                     '\u',
                                     '\'))))
                  || u02_po_box
                  || CHR (13))
           || DECODE (
                  u02_zip_code,
                  NULL, '',
                     DECODE (
                         u01_preferred_lang_id_v01,
                         1, 'Zip Code : ',
                         UNISTR (
                             TO_CHAR (
                                 REPLACE (
                                     '\u0627\u0644\u0631\u0645\u0632 \u0627\u0644\u0628\u0631\u064A\u062F\u064A',
                                     '\u',
                                     '\'))))
                  || u02_zip_code
                  || CHR (13))
           || DECODE (u02_additional_code,
                      NULL, '',
                      u02_additional_code || CHR (13))
           || DECODE (
                  DECODE (u01_preferred_lang_id_v01,
                          1, u02_address_line1,
                          u02_address_line1_lang),
                  NULL, '',
                     DECODE (u01_preferred_lang_id_v01,
                             1, u02_address_line1,
                             u02_address_line1_lang)
                  || CHR (13))
           || DECODE (
                  DECODE (u01_preferred_lang_id_v01,
                          1, u02_address_line2,
                          u02_address_line2_lang),
                  NULL, '',
                     DECODE (u01_preferred_lang_id_v01,
                             1, u02_address_line2,
                             u02_address_line2_lang)
                  || CHR (13))
           || DECODE (u01_preferred_lang_id_v01, 1, m06_name, m06_name_lang)
           || CHR (13)
           || DECODE (u01_preferred_lang_id_v01, 1, m05_name, m05_name_lang)
      INTO l_address
      FROM u01_customer
           JOIN u02_customer_contact_info
               ON u02_customer_id_u01 = u01_id
           JOIN m06_city
               ON u02_city_id_m06 = m06_id
           JOIN m05_country
               ON u02_country_id_m05 = m05_id
     WHERE u02_customer_id_u01 = p_customer_id AND u02_is_default = 1;

    RETURN l_address;
END;
/