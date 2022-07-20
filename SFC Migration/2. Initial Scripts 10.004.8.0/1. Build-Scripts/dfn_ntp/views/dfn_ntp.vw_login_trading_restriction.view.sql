CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_login_trading_restriction
(
    u21_id,
    u21_restriction_type_id_v31,
    u21_login_id_u10,
    u21_narration,
    u21_narration_lang,
    v31_name,
    v31_name_lang
)
AS
    (SELECT u21.u21_id,
            u21.u21_restriction_type_id_v31,
            u21.u21_login_id_u10,
            u21.u21_narration,
            u21.u21_narration_lang,
            v31.v31_name,
            v31.v31_name_lang
       FROM     u21_login_trading_restriction u21
            INNER JOIN
                v31_restriction v31
            ON v31.v31_id = u21.u21_restriction_type_id_v31);
/
