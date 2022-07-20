CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_login_cash_restriction
(
    u20_id,
    u20_restriction_type_id_v31,
    u20_login_id_u30,
    u20_narration,
    u20_narration_lang,
    v31_name,
    v31_name_lang
)
AS
    (SELECT u20.u20_id,
            u20.u20_restriction_type_id_v31,
            u20.u20_login_id_u30,
            u20.u20_narration,
            u20.u20_narration_lang,
            v31.v31_name,
            v31.v31_name_lang
       FROM     u20_login_cash_restriction u20
            INNER JOIN
                v31_restriction v31
            ON v31.v31_id = u20.u20_restriction_type_id_v31);
/
