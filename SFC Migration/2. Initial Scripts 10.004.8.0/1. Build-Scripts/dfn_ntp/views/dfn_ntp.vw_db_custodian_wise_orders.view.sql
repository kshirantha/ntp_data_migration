CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_db_custodian_wise_orders
(
    institute,
    custodian_type,
    custoian_count
)
AS
      SELECT orders.t01_institution_id_m02 AS institute,
             custodian_type,
             COUNT (*) AS custoian_count
        FROM vw_order_list orders
    GROUP BY orders.t01_institution_id_m02, orders.custodian_type
/

DROP VIEW dfn_ntp.vw_db_custodian_wise_orders
/