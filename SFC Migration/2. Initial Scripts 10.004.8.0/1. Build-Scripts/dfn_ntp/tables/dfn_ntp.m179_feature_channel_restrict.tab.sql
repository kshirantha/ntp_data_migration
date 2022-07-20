CREATE TABLE dfn_ntp.m179_feature_channel_restrict
(
    m179_id                   NUMBER (15, 0) NOT NULL,
    m179_restriction_id_v31   NUMBER (5, 0) NOT NULL,
    m179_channel_id_v29       NUMBER (5, 0) NOT NULL,
    m179_status               NUMBER (2, 0) NOT NULL,
    m179_custom_type          VARCHAR2 (50 BYTE)
)
/

COMMENT ON COLUMN dfn_ntp.m179_feature_channel_restrict.m179_status IS
    '1 - Enable | 2 - Disable'
/

ALTER TABLE dfn_ntp.m179_feature_channel_restrict
 ADD (
  m179_status_id_v01 NUMBER (5)
 )
/ 