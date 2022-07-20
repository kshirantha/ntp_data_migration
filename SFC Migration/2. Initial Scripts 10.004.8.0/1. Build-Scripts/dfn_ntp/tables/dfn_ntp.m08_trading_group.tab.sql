-- Table DFN_NTP.M08_TRADING_GROUP

CREATE TABLE dfn_ntp.m08_trading_group
(
    m08_id                         NUMBER (5, 0),
    m08_institute_id_m02           NUMBER (3, 0),
    m08_name                       VARCHAR2 (100),
    m08_name_lang                  VARCHAR2 (100),
    m08_created_by_id_u17          NUMBER (10, 0),
    m08_created_date               TIMESTAMP (6),
    m08_status_id_v01              NUMBER (5, 0),
    m08_modified_by_id_u17         NUMBER (10, 0),
    m08_modified_date              TIMESTAMP (6),
    m08_status_changed_by_id_u17   NUMBER (10, 0),
    m08_status_changed_date        TIMESTAMP (6),
    m08_external_ref               VARCHAR2 (20),
    m08_additional_details         VARCHAR2 (400),
    m08_rank                       NUMBER (1, 0),
    m08_is_default                 NUMBER (1, 0),
    PRIMARY KEY (m08_id) ENABLE
)
ORGANIZATION INDEX
NOCOMPRESS
/

-- Constraints for  DFN_NTP.M08_TRADING_GROUP


  ALTER TABLE dfn_ntp.m08_trading_group ADD CONSTRAINT institute_name UNIQUE (m08_institute_id_m02, m08_name)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m08_trading_group MODIFY (m08_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m08_trading_group MODIFY (m08_institute_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m08_trading_group MODIFY (m08_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m08_trading_group MODIFY (m08_name_lang NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m08_trading_group MODIFY (m08_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m08_trading_group MODIFY (m08_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m08_trading_group MODIFY (m08_status_id_v01 NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M08_TRADING_GROUP

alter table dfn_ntp.M08_TRADING_GROUP
	add M08_CUSTOM_TYPE varchar2(50) default 1
/
