-- Table DFN_NTP.M103_NOTIFY_SUBITEM_SCHEDULE

CREATE TABLE dfn_ntp.m103_notify_subitem_schedule
(
    m103_id                       NUMBER (4, 0),
    m103_sub_item_id_m100         NUMBER (2, 0),
    m103_channel_id_m101          NUMBER (2, 0),
    m103_notify_shedule_id_m102   NUMBER (2, 0)
)
/

-- Constraints for  DFN_NTP.M103_NOTIFY_SUBITEM_SCHEDULE


  ALTER TABLE dfn_ntp.m103_notify_subitem_schedule MODIFY (m103_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m103_notify_subitem_schedule MODIFY (m103_sub_item_id_m100 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m103_notify_subitem_schedule MODIFY (m103_channel_id_m101 NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M103_NOTIFY_SUBITEM_SCHEDULE

COMMENT ON COLUMN dfn_ntp.m103_notify_subitem_schedule.m103_sub_item_id_m100 IS
    'fk from m100'
/
COMMENT ON COLUMN dfn_ntp.m103_notify_subitem_schedule.m103_channel_id_m101 IS
    'fk from m101'
/
COMMENT ON COLUMN dfn_ntp.m103_notify_subitem_schedule.m103_notify_shedule_id_m102 IS
    'fk from m102'
/
-- End of DDL Script for Table DFN_NTP.M103_NOTIFY_SUBITEM_SCHEDULE

COMMENT ON TABLE dfn_ntp.m103_notify_subitem_schedule IS
    'Use IDs greater than 1000 for customizations'
/

ALTER TABLE dfn_ntp.m103_notify_subitem_schedule
 MODIFY (
  m103_sub_item_id_m100 NUMBER (5, 0)

 )
/