CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_ams_symbol_margin_list
(
    institution_id,
    mariginability,
    marginable_percentage,
    exchange,
    symbol,
    sym_margin_group,
    m78_symbol_id_m20
)
AS
    SELECT m78_institution_id_m02 AS institution_id,
           m78.m78_mariginability AS mariginability,
           m78_marginable_per AS marginable_percentage,
           m78_exchange_code_m01 AS exchange,
           m78_symbol_code_m20 AS symbol,
           m78_sym_margin_group_m77 AS sym_margin_group,
           m78.m78_symbol_id_m20
      FROM m78_symbol_marginability m78
     WHERE m78_status_id_v01 = 2
/
