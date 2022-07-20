CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_exchange_order_types
(
    v06_type_id,
    v06_description_1,
    v06_description_2,
    v06_default,
    v06_is_regular_order_type,
    v06_is_available_in_fix,
    enabled
)
AS
    SELECT a.v06_type_id,
           a.v06_description_1,
           a.v06_description_2,
           a.v06_default,
           a.v06_is_regular_order_type,
           a.v06_is_available_in_fix,
           0 AS enabled
      FROM v06_order_type a;
/
