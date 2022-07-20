CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_v09_instrument_types
(
    v09_id,
    v09_code,
    v09_description,
    v09_margin_enable,
    margin_enable_desc,
    v09_default_price_qty_type,
    default_price_qty_type_desc,
    v09_lot_size,
    v09_price_factor,
    v09_status_id_v01,
    v01_description
)
AS
    SELECT v09.v09_id,
           v09.v09_code,
           v09.v09_description,
           v09.v09_margin_enable,
           DECODE (v09.v09_margin_enable,  0, 'No',  1, 'Yes')
               AS margin_enable_desc,
           v09.v09_default_price_qty_type,
           DECODE (v09.v09_default_price_qty_type,
                   0, 'Price',
                   1, 'Quantity')
               AS default_price_qty_type_desc,
           v09.v09_lot_size,
           v09.v09_price_factor,
           v09.v09_status_id_v01,
           status.v01_description
      FROM     v09_instrument_types v09
           JOIN
               vw_status_list status
           ON v09.v09_status_id_v01 = status.v01_id;
/
