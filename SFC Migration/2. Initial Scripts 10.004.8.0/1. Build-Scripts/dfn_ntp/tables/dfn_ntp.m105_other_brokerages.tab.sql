-- Table DFN_NTP.M105_OTHER_BROKERAGES

CREATE TABLE dfn_ntp.m105_other_brokerages
(
    m105_id                         NUMBER (5, 0),
    m105_broker_code                VARCHAR2 (30),
    m105_broker_name                VARCHAR2 (100),
    m105_address                    VARCHAR2 (400),
    m105_created_by_id_u17          NUMBER (20, 0),
    m105_created_date               DATE,
    m105_modified_by_id_u17         NUMBER (20, 0),
    m105_modified_date              DATE,
    m105_status_id_v01              NUMBER (20, 0),
    m105_status_changed_by_id_u17   NUMBER (20, 0),
    m105_status_changed_date        DATE,
    m105_exchange_id_m01            NUMBER (5, 0)
)
/

-- Constraints for  DFN_NTP.M105_OTHER_BROKERAGES


  ALTER TABLE dfn_ntp.m105_other_brokerages ADD CONSTRAINT m105_pk PRIMARY KEY (m105_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m105_other_brokerages MODIFY (m105_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m105_other_brokerages MODIFY (m105_broker_name NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M105_OTHER_BROKERAGES

COMMENT ON COLUMN dfn_ntp.m105_other_brokerages.m105_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.m105_other_brokerages.m105_broker_code IS
    'code given to broker by exchange'
/
COMMENT ON COLUMN dfn_ntp.m105_other_brokerages.m105_broker_name IS
    'name of the broker'
/
COMMENT ON COLUMN dfn_ntp.m105_other_brokerages.m105_address IS
    'address of the broker'
/
COMMENT ON TABLE dfn_ntp.m105_other_brokerages IS
    'this table keeps all the brokers regsitered under an exchange defined in m11'
/
-- End of DDL Script for Table DFN_NTP.M105_OTHER_BROKERAGES

alter table dfn_ntp.M105_OTHER_BROKERAGES
	add M105_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m105_other_brokerages
 ADD (
  m105_institute_id_m02 NUMBER (3, 0)
 )
/


ALTER TABLE dfn_ntp.m105_other_brokerages
    MODIFY (m105_institute_id_m02 DEFAULT 1)
/
