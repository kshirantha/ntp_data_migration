-- Table DFN_NTP.M17_BANK_BRANCHES

CREATE TABLE dfn_ntp.m17_bank_branches
(
    m17_id                  NUMBER (5, 0),
    m17_bank_id             NUMBER (5, 0),
    m17_branch_name         VARCHAR2 (100),
    m17_address             VARCHAR2 (255),
    m17_tel                 VARCHAR2 (20),
    m17_created_by_id_u17   NUMBER (10, 0),
    m17_created_date        TIMESTAMP (7),
    m17_updated_by_id_u17   NUMBER (10, 0),
    m17_updated_date        TIMESTAMP (7),
    m17_external_ref        VARCHAR2 (50)
)
/

-- Constraints for  DFN_NTP.M17_BANK_BRANCHES


  ALTER TABLE dfn_ntp.m17_bank_branches ADD CONSTRAINT m17_id_pk PRIMARY KEY (m17_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m17_bank_branches MODIFY (m17_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m17_bank_branches MODIFY (m17_bank_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m17_bank_branches MODIFY (m17_branch_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m17_bank_branches MODIFY (m17_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m17_bank_branches MODIFY (m17_created_date NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M17_BANK_BRANCHES

alter table dfn_ntp.M17_BANK_BRANCHES
	add M17_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.M17_BANK_BRANCHES 
 ADD (
  M17_STATUS_ID_V01 NUMBER (5, 0),
  M17_STATUS_CHANGED_BY_ID_U17 NUMBER (10, 0),
  M17_STATUS_CHANGED_DATE TIMESTAMP (7)
 )
/
