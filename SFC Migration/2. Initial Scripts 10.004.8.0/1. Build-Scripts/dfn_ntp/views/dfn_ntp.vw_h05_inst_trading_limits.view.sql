CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_h05_inst_trading_limits
(
    h05_id,
    h05_institution_id_m02,
    h05_od_limit,
    h05_margin_limit,
    h05_updated_date,
    h05_updated_by_id_u17,
    updated_by_by_full_name
)
AS
    ( (SELECT h05.h05_id,
              h05.h05_institution_id_m02,
              h05.h05_od_limit,
              h05.h05_margin_limit,
              h05.h05_updated_date,
              h05.h05_updated_by_id_u17,
              u17.u17_full_name AS updated_by_by_full_name
         FROM     h05_institute_trading_limits h05
              LEFT JOIN
                  u17_employee u17
              ON h05.h05_updated_by_id_u17 = u17.u17_id));
/
