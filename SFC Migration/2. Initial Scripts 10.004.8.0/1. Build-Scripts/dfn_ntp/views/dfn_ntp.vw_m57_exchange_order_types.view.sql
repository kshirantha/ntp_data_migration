CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m57_exchange_order_types
(
    v06_type_id,
    v06_description_1,
    v06_description_2,
    m57_id,
    m57_exchange_id_m01,
    m57_order_type_id_v06,
    enabled
)
AS
    SELECT v06.v06_type_id,
           v06.v06_description_1,
           v06.v06_description_2,
           m57.m57_id,
           m57.m57_exchange_id_m01,
           m57.m57_order_type_id_v06,
           CASE WHEN m57.m57_id IS NULL THEN 0 ELSE 1 END AS enabled
      FROM     v06_order_type v06
           LEFT JOIN
               m57_exchange_order_types m57
           ON v06.v06_type_id = m57.m57_order_type_id_v06;
/
