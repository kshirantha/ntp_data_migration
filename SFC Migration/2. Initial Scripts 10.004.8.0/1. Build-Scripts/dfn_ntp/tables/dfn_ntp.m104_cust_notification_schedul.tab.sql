-- Table DFN_NTP.M104_CUST_NOTIFICATION_SCHEDUL

CREATE TABLE dfn_ntp.m104_cust_notification_schedul
(
    m104_id                        NUMBER (10, 0),
    m104_customer_id_u01           NUMBER (18, 0),
    m104_subitem_shedule_id_m103   NUMBER (2, 0),
    m104_created_by_id_u17         NUMBER (20, 0),
    m104_created_date              DATE,
    m104_modified_by_id_u17        NUMBER (20, 0) DEFAULT NULL,
    m104_modified_date             DATE DEFAULT NULL,
    m104_is_live                   NUMBER (1, 0) DEFAULT 1
)
/

-- Constraints for  DFN_NTP.M104_CUST_NOTIFICATION_SCHEDUL


  ALTER TABLE dfn_ntp.m104_cust_notification_schedul ADD CONSTRAINT pk_m104_id PRIMARY KEY (m104_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m104_cust_notification_schedul MODIFY (m104_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m104_cust_notification_schedul MODIFY (m104_customer_id_u01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m104_cust_notification_schedul MODIFY (m104_subitem_shedule_id_m103 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m104_cust_notification_schedul MODIFY (m104_modified_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m104_cust_notification_schedul MODIFY (m104_is_live NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M104_CUST_NOTIFICATION_SCHEDUL

COMMENT ON COLUMN dfn_ntp.m104_cust_notification_schedul.m104_subitem_shedule_id_m103 IS
    'fk from m103'
/
-- End of DDL Script for Table DFN_NTP.M104_CUST_NOTIFICATION_SCHEDUL

alter table dfn_ntp.M104_CUST_NOTIFICATION_SCHEDUL
	add M104_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m104_cust_notification_schedul
 MODIFY (
  m104_modified_date NULL
 )
/

ALTER TABLE dfn_ntp.M104_CUST_NOTIFICATION_SCHEDUL 
 MODIFY (
  M104_SUBITEM_SHEDULE_ID_M103 NUMBER (4, 0)

 )
/