CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_v29_order_channel
(
    v29_id,
    v29_description,
    v29_order_channel_category,
    ignore_commision_discount,
    is_active
)
AS
    SELECT v29.v29_id,
           v29.v29_description,
           v29.v29_order_channel_category,
           0 AS ignore_commision_discount,
           0 AS is_active
      FROM v29_order_channel v29
/