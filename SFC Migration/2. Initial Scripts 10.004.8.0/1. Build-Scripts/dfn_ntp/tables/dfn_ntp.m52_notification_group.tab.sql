-- Table DFN_NTP.M52_NOTIFICATION_GROUP

CREATE TABLE dfn_ntp.m52_notification_group
(
    m52_id                         NUMBER (10, 0),
    m52_institute_id_m02           NUMBER (3, 0),
    m52_name                       VARCHAR2 (100),
    m52_name_lang                  VARCHAR2 (100),
    m52_description                VARCHAR2 (500),
    m52_created_by_id_u17          NUMBER (10, 0),
    m52_created_date               DATE,
    m52_status_id_v01              NUMBER (5, 0),
    m52_modified_by_id_u17         NUMBER (10, 0),
    m52_modified_date              DATE,
    m52_status_changed_by_id_u17   NUMBER (10, 0),
    m52_status_changed_date        DATE
)
/

-- Constraints for  DFN_NTP.M52_NOTIFICATION_GROUP


  ALTER TABLE dfn_ntp.m52_notification_group ADD CONSTRAINT m52_pk PRIMARY KEY (m52_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m52_notification_group MODIFY (m52_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m52_notification_group MODIFY (m52_institute_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m52_notification_group MODIFY (m52_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m52_notification_group MODIFY (m52_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m52_notification_group MODIFY (m52_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m52_notification_group MODIFY (m52_status_id_v01 NOT NULL ENABLE)
/

-- Indexes for  DFN_NTP.M52_NOTIFICATION_GROUP


CREATE INDEX dfn_ntp.idx_m52_m02_id_fk
    ON dfn_ntp.m52_notification_group (m52_institute_id_m02)
/

-- Comments for  DFN_NTP.M52_NOTIFICATION_GROUP

COMMENT ON COLUMN dfn_ntp.m52_notification_group.m52_id IS
    'Primary key of the notification group table'
/
COMMENT ON COLUMN dfn_ntp.m52_notification_group.m52_institute_id_m02 IS
    'Foreign key to M02_INSTITUTE table'
/
COMMENT ON COLUMN dfn_ntp.m52_notification_group.m52_name IS
    'name of the notification group'
/
COMMENT ON COLUMN dfn_ntp.m52_notification_group.m52_description IS
    'detailed content of the notification group'
/
COMMENT ON TABLE dfn_ntp.m52_notification_group IS
    'This table keeps all th notification groups attached to a institution. Notification groups are for users'
/
-- End of DDL Script for Table DFN_NTP.M52_NOTIFICATION_GROUP

ALTER TABLE dfn_ntp.M52_NOTIFICATION_GROUP
	ADD M52_CUSTOM_TYPE VARCHAR2(50) DEFAULT 1
/
