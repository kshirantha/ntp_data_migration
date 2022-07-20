CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_order_limit_group_slabs
(
    m188_id,
    m188_group_id_m176,
    m188_channel_id_v29,
    m188_buy_order_limit,
    m188_sell_order_limit,
    m188_status_id_v01,
    m188_created_by_id_u17,
    m188_created_date,
    m188_status_changed_by_id_u17,
    m188_status_changed_date,
    m188_modified_by_id_u17,
    m188_modified_date,
    m188_custom_type
)
AS
    SELECT m188.m188_id,
           m188.m188_group_id_m176,
           m188.m188_channel_id_v29,
           m188.m188_buy_order_limit,
           m188.m188_sell_order_limit,
           m188.m188_status_id_v01,
           m188.m188_created_by_id_u17,
           m188.m188_created_date,
           m188.m188_status_changed_by_id_u17,
           m188.m188_status_changed_date,
           m188.m188_modified_by_id_u17,
           m188.m188_modified_date,
           m188.m188_custom_type
      FROM m188_order_limit_group_slabs m188
/
