CREATE TABLE dfn_ntp.m100_notification_sub_items
(
    m100_id            NUMBER (5, 0),
    m100_item_id       NUMBER (3, 0),
    m100_description   VARCHAR2 (75 BYTE)
)
/



COMMENT ON COLUMN dfn_ntp.m100_notification_sub_items.m100_item_id IS
    'fk m99_id'
/

COMMENT ON TABLE dfn_ntp.m100_notification_sub_items IS
    'Use IDs greater than 1000 for customizations'
/

ALTER TABLE dfn_ntp.m100_notification_sub_items
 ADD (
  m100_item_type NUMBER (1) DEFAULT 0
 )
/

COMMENT ON COLUMN dfn_ntp.m100_notification_sub_items.m100_item_type IS
    '0 - None | 1 - Notification Levels'
/
