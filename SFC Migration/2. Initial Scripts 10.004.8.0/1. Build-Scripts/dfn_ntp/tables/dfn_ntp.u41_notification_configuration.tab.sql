CREATE TABLE dfn_ntp.u41_notification_configuration
(
    u41_id                         NUMBER (10, 0),
    u41_institution_id_m02         NUMBER (10, 0) NOT NULL,
    u41_notification_type_id_v01   NUMBER (2, 0) NOT NULL,
    u41_level1_notification        NUMBER (5, 0) DEFAULT 0,
    u41_level2_notification        NUMBER (5, 0) DEFAULT 0,
    u41_level3_notification        NUMBER (5, 0) DEFAULT 0,
    u41_status_id_v01              NUMBER (5, 0) DEFAULT 1,
    u41_modified_by_id_u17         NUMBER (10, 0),
    u41_notification_cc_list       VARCHAR2 (1000 BYTE),
    u41_modified_date              DATE,
    u41_created_by_id_u17          NUMBER (5, 0),
    u41_created_date               DATE,
    u41_status_changed_by_id_u17   NUMBER (5, 0),
    u41_status_changed_date        DATE,
    u41_date_from                  NUMBER (10, 0),
    u41_date_to                    NUMBER (10, 0),
    u41_custom_type                VARCHAR2 (20 BYTE),
    u41_notification_to_list       VARCHAR2 (1000 BYTE)
)
/



ALTER TABLE dfn_ntp.u41_notification_configuration
ADD CONSTRAINT pk_u41 PRIMARY KEY (u41_id)
USING INDEX
DISABLE NOVALIDATE
/

ALTER TABLE dfn_ntp.u41_notification_configuration
ADD CONSTRAINT uk_u41_composite UNIQUE (u41_institution_id_m02,
  u41_notification_type_id_v01)
USING INDEX
/


COMMENT ON COLUMN dfn_ntp.u41_notification_configuration.u41_custom_type IS
    'to support customization'
/
COMMENT ON COLUMN dfn_ntp.u41_notification_configuration.u41_institution_id_m02 IS
    'fk from m02'
/
COMMENT ON COLUMN dfn_ntp.u41_notification_configuration.u41_modified_by_id_u17 IS
    'fK u17_id'
/
COMMENT ON COLUMN dfn_ntp.u41_notification_configuration.u41_notification_type_id_v01 IS
    '1 - Customer ID Expiry, 2 - Customer Account Freez, 3 - POA Expiry, 4 - POA ID Expiry, 5 - CMA Details Expiry,  7- Minor to Major , 8 -underage to minor'
/
COMMENT ON COLUMN dfn_ntp.u41_notification_configuration.u41_status_id_v01 IS
    'fK from V01:'
/

ALTER TABLE dfn_ntp.u41_notification_configuration
RENAME COLUMN u41_notification_type_id_v01 TO u41_notification_type_id_m100
/
ALTER TABLE dfn_ntp.u41_notification_configuration
DROP COLUMN u41_level1_notification
/
ALTER TABLE dfn_ntp.u41_notification_configuration
DROP COLUMN u41_level2_notification
/
ALTER TABLE dfn_ntp.u41_notification_configuration
DROP COLUMN u41_level3_notification
/
ALTER TABLE dfn_ntp.u41_notification_configuration
DROP COLUMN u41_notification_to_list
/
ALTER TABLE dfn_ntp.u41_notification_configuration
DROP COLUMN u41_notification_cc_list
/

COMMENT ON COLUMN dfn_ntp.u41_notification_configuration.u41_institution_id_m02 IS
    'fk m02'
/
COMMENT ON COLUMN dfn_ntp.u41_notification_configuration.u41_notification_type_id_m100 IS
    ''
/
COMMENT ON COLUMN dfn_ntp.u41_notification_configuration.u41_status_id_v01 IS
    'fk v01'
/
COMMENT ON COLUMN dfn_ntp.u41_notification_configuration.u41_modified_by_id_u17 IS
    'fk u17_id'
/

ALTER TABLE dfn_ntp.u41_notification_configuration
 ADD (
  u41_notify_sms_cc_list VARCHAR2 (1000),
  u41_notify_email_cc_list VARCHAR2 (1000)
 )
/
