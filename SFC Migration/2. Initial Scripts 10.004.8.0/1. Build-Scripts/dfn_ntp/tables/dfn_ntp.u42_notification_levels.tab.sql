CREATE TABLE dfn_ntp.u42_notification_levels
(
    u42_id                     NUMBER (10),
    u42_notify_config_id_u41   NUMBER (10),
    u42_level                  NUMBER (2),
    u42_days                   NUMBER (5)
)
/

COMMENT ON COLUMN dfn_ntp.u42_notification_levels.u42_notify_config_id_u41 IS
    'fk u41_id'
/

ALTER TABLE dfn_ntp.u42_notification_levels
 ADD (
  u42_custom_type VARCHAR2 (50)
 )
/
