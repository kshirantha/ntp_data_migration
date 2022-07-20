CREATE OR REPLACE PROCEDURE dfn_ntp.sp_add_trading_restrictions (
    pu12_restriction_type_id   IN NUMBER,
    pu07_id                    IN NUMBER,
    pu12_narration             IN VARCHAR,
    pu12_narration_lang        IN VARCHAR,
    pu12_restriction_source    IN NUMBER)
IS
    l_pkey   NUMBER;
BEGIN
    DELETE FROM u12_trading_restriction
          WHERE     u12_trading_account_id_u07 = pu07_id
                AND u12_restriction_type_id_v31 = pu12_restriction_type_id
                AND u12_restriction_source = pu12_restriction_source;

    SELECT app_seq_value + 1
      INTO l_pkey
      FROM app_seq_store
     WHERE app_seq_name = 'U12_TRADING_RESTRICTION';

    UPDATE app_seq_store
       SET app_seq_value = l_pkey
     WHERE app_seq_name = 'U12_TRADING_RESTRICTION';


    INSERT INTO u12_trading_restriction (u12_id,
                                         u12_restriction_type_id_v31,
                                         u12_trading_account_id_u07,
                                         u12_narration,
                                         u12_narration_lang,
                                         u12_restriction_source)
         VALUES (l_pkey,
                 pu12_restriction_type_id,
                 pu07_id,
                 pu12_narration,
                 pu12_narration_lang,
                 pu12_restriction_source);
END;
/