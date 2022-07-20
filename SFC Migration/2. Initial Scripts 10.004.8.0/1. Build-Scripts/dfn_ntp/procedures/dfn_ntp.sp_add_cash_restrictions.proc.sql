CREATE OR REPLACE PROCEDURE dfn_ntp.sp_add_cash_restrictions (
    pu11_restriction_type_id   IN NUMBER,
    pu06_id                    IN NUMBER,
    pu11_narration             IN VARCHAR,
    pu11_narration_lang        IN VARCHAR,
    pu11_restriction_source    IN NUMBER)
IS
    l_pkey   NUMBER;
BEGIN
    DELETE FROM u11_cash_restriction
          WHERE     u11_cash_account_id_u06 = pu06_id
                AND u11_restriction_type_id_v31 = pu11_restriction_type_id
                AND u11_restriction_source = pu11_restriction_source;

    SELECT app_seq_value + 1
      INTO l_pkey
      FROM app_seq_store
     WHERE app_seq_name = 'U11_CASH_RESTRICTION';

    UPDATE app_seq_store
       SET app_seq_value = l_pkey
     WHERE app_seq_name = 'U11_CASH_RESTRICTION';

    INSERT INTO u11_cash_restriction (u11_id,
                                      u11_restriction_type_id_v31,
                                      u11_cash_account_id_u06,
                                      u11_narration,
                                      u11_narration_lang,
                                      u11_restriction_source)
         VALUES (l_pkey,
                 pu11_restriction_type_id,
                 pu06_id,
                 pu11_narration,
                 pu11_narration_lang,
                 pu11_restriction_source);
END;
/