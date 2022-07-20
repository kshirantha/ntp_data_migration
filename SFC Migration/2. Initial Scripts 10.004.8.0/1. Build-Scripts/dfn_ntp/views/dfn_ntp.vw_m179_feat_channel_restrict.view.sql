CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m179_feat_channel_restrict
(
    m179_id,
    m179_restriction_id_v31,
    m179_channel_id_v29,
    m179_status,
    m179_status_id_v01,
    status,
    feature_des,
    channel_name
)
AS
    ( (SELECT m179.m179_id,
              m179.m179_restriction_id_v31,
              m179.m179_channel_id_v29,
              m179.m179_status,
              m179.m179_status_id_v01,
              vw_status_list.v01_description AS status,
              v31.v31_name AS feature_des,
              v29.v29_description AS channel_name
         FROM m179_feature_channel_restrict m179
              LEFT JOIN v31_restriction v31
                  ON     v31.v31_type = 7
                     AND v31.v31_id = m179.m179_restriction_id_v31
              LEFT JOIN v29_order_channel v29
                  ON v29.v29_id = m179.m179_channel_id_v29
              LEFT JOIN vw_status_list
                  ON m179.m179_status_id_v01 = vw_status_list.v01_id))
/