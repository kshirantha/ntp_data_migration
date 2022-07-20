CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_cash_restriction
(
    u11_id,
    u11_restriction_type_id_v31,
    u11_cash_account_id_u06,
    u11_narration,
    u11_narration_lang,
    v31_name,
    v31_name_lang
)
AS
    (SELECT u11.u11_id,
            u11.u11_restriction_type_id_v31,
            u11.u11_cash_account_id_u06,
            u11.u11_narration,
            u11.u11_narration_lang,
            v31.v31_name,
            v31.v31_name_lang
       FROM     u11_cash_restriction u11
            INNER JOIN
                v31_restriction v31
            ON v31.v31_id = u11.u11_restriction_type_id_v31
      WHERE u11.u11_restriction_source = 0);
/
