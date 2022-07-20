CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_trading_restriction
(
    u12_id,
    u12_restriction_type_id_v31,
    u12_trading_account_id_u07,
    u12_narration,
    u12_narration_lang,
    v31_name,
    v31_name_lang
)
AS
    (SELECT u12.u12_id,
            u12.u12_restriction_type_id_v31,
            u12.u12_trading_account_id_u07,
            u12.u12_narration,
            u12.u12_narration_lang,
            v31.v31_name,
            v31.v31_name_lang
       FROM     u12_trading_restriction u12
            INNER JOIN
                v31_restriction v31
            ON v31.v31_id = u12.u12_restriction_type_id_v31
      WHERE u12.u12_restriction_source = 0);
/
