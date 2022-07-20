CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u51_poa_symbol_restriction
(
    u51_poa_id_u47,
    u51_symbol_id_m20,
    u51_buy_restrict,
    u51_sell_restrict
)
AS
      SELECT MAX (u51_poa_id_u47) AS u51_poa_id_u47,
             u51_symbol_id_m20,
             MAX (buy) AS u51_buy_restrict,
             MAX (sell) AS u51_sell_restrict
        FROM (SELECT u51_poa_id_u47,
                     u51_symbol_id_m20,
                     CASE
                         WHEN u51_restriction_id_v31 = 1 THEN 1
                         WHEN u51_restriction_id_v31 = 3 THEN 1
                         ELSE 0
                     END
                         AS buy,
                     CASE
                         WHEN u51_restriction_id_v31 = 2 THEN 1
                         WHEN u51_restriction_id_v31 = 3 THEN 1
                         ELSE 0
                     END
                         AS sell
                FROM u51_poa_symbol_restriction)
    GROUP BY u51_symbol_id_m20;
/
