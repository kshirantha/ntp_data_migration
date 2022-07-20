CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m18_instrument
(
    m18_id,
    m18_code,
    m18_description,
    m18_margin_enable,
    m18_default_price_qty_type,
    m18_lot_size,
    m18_price_factor,
    m18_description_lang,
    m18_created_by,
    m18_created_date,
    m18_modified_by,
    m18_modified_date,
    m18_status_id,
    m18_status_changed_by,
    m18_status_changed_date
)
AS
    SELECT m18_id,
           m18_code,
           m18_description,
           m18_margin_enable,
           m18_default_price_qty_type,
           m18_lot_size,
           m18_price_factor,
           m18_description_lang,
           m18_created_by,
           m18_created_date,
           m18_modified_by,
           m18_modified_date,
           m18_status_id,
           m18_status_changed_by,
           m18_status_changed_date
      FROM m18_instrument;
/

DROP VIEW dfn_ntp.vw_m18_instrument
/