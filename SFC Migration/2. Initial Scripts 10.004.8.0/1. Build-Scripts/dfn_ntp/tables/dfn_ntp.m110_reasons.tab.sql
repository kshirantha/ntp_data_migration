-- Table DFN_NTP.M110_REASONS

CREATE TABLE dfn_ntp.m110_reasons
(
    m110_id                         NUMBER (10, 0),
    m110_type                       NUMBER (2, 0),
    m110_reason_text                VARCHAR2 (200),
    m110_created_by_id_u17          NUMBER (10, 0),
    m110_created_date               DATE,
    m110_modified_by_id_u17         NUMBER (10, 0),
    m110_modified_date              DATE,
    m110_status_id_v01              NUMBER (20, 0),
    m110_status_changed_by_id_u17   NUMBER (10, 0),
    m110_status_changed_date        DATE,
    m110_eod_operation              NUMBER (2, 0) DEFAULT 0
)
/

-- Constraints for  DFN_NTP.M110_REASONS


  ALTER TABLE dfn_ntp.m110_reasons ADD CONSTRAINT pk_m110 PRIMARY KEY (m110_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m110_reasons ADD CONSTRAINT uk_m110 UNIQUE (m110_type, m110_reason_text)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.M110_REASONS

COMMENT ON COLUMN dfn_ntp.m110_reasons.m110_type IS
    '1 - Cash Transfer Block, 2 - Holding Pledge, 3 - Cash Transfer, 4 - Customer Suspension, 5 - Cash Transaction Block, 6 - Stock Transation Block, 7 - Stock Transfer Block, 8 - Pledge Block, 9 - Trading'
/
COMMENT ON COLUMN dfn_ntp.m110_reasons.m110_created_by_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.m110_reasons.m110_modified_by_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.m110_reasons.m110_status_changed_by_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.m110_reasons.m110_eod_operation IS
    '0 - User Defined | 1 - Customer ID Expiry | 2 - Customer Account Freez | 3 - POA Expiry | 4 - POA ID Expiry | 5 - CMA Details Expiry | 6 - Liquidation | 7 - Minor to Major | 8 - Underage to Minor | 9 - Authorized Person ID Expiry | 10 - Inactive account | 11 - Dormant Account | 12 - Account Closure | 13 - Margin Equation | 14 - Nafith File Process'
/
-- End of DDL Script for Table DFN_NTP.M110_REASONS

alter table dfn_ntp.M110_REASONS
	add M110_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m110_reasons
 ADD (
  m110_institute_id_m02 NUMBER (3, 0)
 )
/

ALTER TABLE dfn_ntp.m110_reasons
    MODIFY (m110_institute_id_m02 DEFAULT 1)
/

ALTER TABLE dfn_ntp.m110_reasons
    DROP CONSTRAINT uk_m110 DROP INDEX
/

ALTER TABLE dfn_ntp.m110_reasons
    ADD CONSTRAINT uk_m110 UNIQUE
            (m110_type, m110_reason_text, m110_institute_id_m02)
            USING INDEX ENABLE
/