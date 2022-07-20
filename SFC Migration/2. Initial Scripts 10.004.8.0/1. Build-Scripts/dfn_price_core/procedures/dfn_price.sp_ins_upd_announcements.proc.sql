
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_INS_UPD_ANNOUNCEMENTS (
    p_variable_id       IN announcements.id%TYPE,
    p_symbol            IN announcements.symbol%TYPE,
    p_exchangecode      IN announcements.exchangecode%TYPE,
    p_ref_code          IN announcements.ref_code%TYPE,
    p_time              IN announcements.time%TYPE,
    p_heading_1         IN announcements.heading_1%TYPE,
    p_heading_2         IN announcements.heading_2%TYPE,
    p_body_1            IN announcements.body_1%TYPE,
    p_body_2            IN announcements.body_2%TYPE,
    p_body_3            IN announcements.body_3%TYPE,
    p_url               IN announcements.url%TYPE,
    p_company_code_1    IN announcements.company_code_1%TYPE,
    p_company_code_2    IN announcements.company_code_2%TYPE,
    p_company_name_1    IN announcements.company_name_1%TYPE,
    p_company_name_2    IN announcements.company_name_2%TYPE,
    p_timestampcloumn   IN announcements.timestamp_a%TYPE,
    p_attach_url_1      IN announcements.attach_url_1%TYPE,
    p_attach_url_2      IN announcements.attach_url_2%TYPE,
    p_is_company        IN announcements.is_company%TYPE,
    p_lang              IN CHAR)
AS
    v_announcements_id   announcements.id%TYPE;
BEGIN
    SELECT seq_announcements_id.NEXTVAL INTO v_announcements_id FROM DUAL;

    UPDATE announcements
       SET symbol = p_symbol,
           exchangecode = p_exchangecode,
           ref_code = p_ref_code,
           time = p_time,
           heading_1 =
               CASE
                   WHEN (UPPER (p_lang) = 'EN') THEN p_heading_1
                   ELSE heading_1
               END,
           heading_2 =
               CASE
                   WHEN (UPPER (p_lang) = 'EN') THEN heading_2
                   ELSE p_heading_2
               END,
           body_1 =
               CASE
                   WHEN (UPPER (p_lang) = 'EN') THEN p_body_1
                   ELSE body_1
               END,
           body_2 =
               CASE
                   WHEN (UPPER (p_lang) = 'EN') THEN body_2
                   ELSE p_body_2
               END,
           body_3 =
               CASE
                   WHEN (UPPER (p_lang) = 'EN') THEN body_3
                   ELSE p_body_3
               END,
           url = p_url,
           company_code_1 =
               CASE
                   WHEN (UPPER (p_lang) = 'EN') THEN p_company_code_1
                   ELSE company_code_1
               END,
           company_code_2 =
               CASE
                   WHEN (UPPER (p_lang) = 'EN') THEN company_code_2
                   ELSE p_company_code_2
               END,
           company_name_1 =
               CASE
                   WHEN (UPPER (p_lang) = 'EN') THEN p_company_name_1
                   ELSE company_name_1
               END,
           company_name_2 =
               CASE
                   WHEN (UPPER (p_lang) = 'EN') THEN company_name_2
                   ELSE p_company_name_2
               END,
           timestamp_a = p_timestampcloumn,
           attach_url_1 = p_attach_url_1,
           attach_url_2 = p_attach_url_2,
           is_company = p_is_company
     WHERE (original_id = p_variable_id);

    /*Here, we have to put id instead of original_id if the ann table's is not getting auto incremented*/
    IF (SQL%ROWCOUNT = 0)
    THEN
        INSERT INTO announcements (id,
                                   symbol,
                                   exchangecode,
                                   ref_code,
                                   time,
                                   heading_1,
                                   heading_2,
                                   body_1,
                                   body_2,
                                   body_3,
                                   url,
                                   company_code_1,
                                   company_code_2,
                                   company_name_1,
                                   company_name_2,
                                   timestamp_a,
                                   original_id,
                                   attach_url_1,
                                   attach_url_2,
                                   is_company)
             VALUES (v_announcements_id,
                     p_symbol,
                     p_exchangecode,
                     p_ref_code,
                     p_time,
                     p_heading_1,
                     p_heading_2,
                     p_body_1,
                     p_body_2,
                     p_body_3,
                     p_url,
                     p_company_code_1,
                     p_company_code_2,
                     p_company_name_1,
                     p_company_name_2,
                     p_timestampcloumn,
                     p_variable_id,
                     p_attach_url_1,
                     p_attach_url_2,
                     p_is_company);
    /*p_variable_id should come as the id as well..*/
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        RAISE;
END;
/
/
