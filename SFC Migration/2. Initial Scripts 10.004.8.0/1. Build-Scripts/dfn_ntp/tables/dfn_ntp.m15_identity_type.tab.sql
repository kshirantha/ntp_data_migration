-- Table DFN_NTP.M15_IDENTITY_TYPE

CREATE TABLE dfn_ntp.m15_identity_type
(
    m15_id                           NUMBER (5, 0),
    m15_name                         VARCHAR2 (50),
    m15_name_lang                    VARCHAR2 (50),
    m15_account_frozen_type          NUMBER (1, 0),
    m15_frozen_days                  NUMBER (5, 0),
    m15_applicable_acc_type_id_v01   NUMBER (1, 0),
    m15_created_by_id_u17            NUMBER (10, 0),
    m15_created_date                 DATE,
    m15_status_id_v01                NUMBER (5, 0),
    m15_modified_by_id_u17           NUMBER (10, 0),
    m15_modified_date                DATE,
    m15_status_changed_by_id_u17     NUMBER (10, 0),
    m15_status_changed_date          DATE,
    m15_external_ref                 VARCHAR2 (20),
    m15_id_number_length             NUMBER (10, 0),
    PRIMARY KEY (m15_id) ENABLE
)
ORGANIZATION INDEX
NOCOMPRESS
/

-- Constraints for  DFN_NTP.M15_IDENTITY_TYPE


  ALTER TABLE dfn_ntp.m15_identity_type MODIFY (m15_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m15_identity_type MODIFY (m15_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m15_identity_type MODIFY (m15_name_lang NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m15_identity_type MODIFY (m15_account_frozen_type NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m15_identity_type MODIFY (m15_applicable_acc_type_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m15_identity_type MODIFY (m15_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m15_identity_type MODIFY (m15_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m15_identity_type MODIFY (m15_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m15_identity_type ADD CONSTRAINT uk_m15_identity_type UNIQUE (m15_name)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.M15_IDENTITY_TYPE

COMMENT ON COLUMN dfn_ntp.m15_identity_type.m15_account_frozen_type IS
    '0- None, 1- Freez Immdiately, 2 - Freez After 90 Days'
/
COMMENT ON COLUMN dfn_ntp.m15_identity_type.m15_applicable_acc_type_id_v01 IS
    'V01 Type 16'
/
-- End of DDL Script for Table DFN_NTP.M15_IDENTITY_TYPE

alter table dfn_ntp.M15_IDENTITY_TYPE
	add M15_CUSTOM_TYPE varchar2(50) default 1
/

COMMENT ON COLUMN dfn_ntp.m15_identity_type.m15_account_frozen_type IS
    '1- None | 2- Freez Immdiately | 3 - Freez After Frozen Days'
/

CREATE UNIQUE INDEX dfn_ntp.idx_m15_fast
    ON dfn_ntp.m15_identity_type (m15_id, m15_name, m15_name_lang)
/
