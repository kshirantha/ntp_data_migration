CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_institute_order_channels
(
    m68_id,
    m68_channel_id_v29,
    m68_institution_id_m02,
    m68_ignore_commision_discount
)
AS
    (SELECT m68.m68_id,
            m68.m68_channel_id_v29,
            m68.m68_institution_id_m02,
            m68.m68_ignore_commision_discount
       FROM m68_institute_order_channels m68);
/
