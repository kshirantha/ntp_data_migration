-- Table DFN_NTP.M97_TRANSACTION_CODES

CREATE TABLE dfn_ntp.m97_transaction_codes
(
    m97_id                         NUMBER (5, 0),
    m97_code                       VARCHAR2 (10),
    m97_description                VARCHAR2 (100),
    m97_description_lang           VARCHAR2 (100),
    m97_category                   NUMBER (5, 0),
    m97_b2b_enabled                NUMBER (1, 0) DEFAULT 0,
    m97_visible                    NUMBER (1, 0) DEFAULT 1,
    m97_statement                  NUMBER (1, 0) DEFAULT 0,
    m97_charge_type                NUMBER (1, 0) DEFAULT 0,
    m97_created_by_id_u17          NUMBER (5, 0),
    m97_created_date               DATE,
    m97_modified_by_id_u17         NUMBER (5, 0),
    m97_modified_date              DATE,
    m97_status_id_v01              NUMBER (5, 0),
    m97_status_changed_by_id_u17   NUMBER (5, 0),
    m97_status_changed_date        DATE,
    m97_txn_impact_type            NUMBER (1, 0) DEFAULT 2
)
/

-- Constraints for  DFN_NTP.M97_TRANSACTION_CODES


  ALTER TABLE dfn_ntp.m97_transaction_codes MODIFY (m97_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m97_transaction_codes MODIFY (m97_code NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m97_transaction_codes MODIFY (m97_description NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m97_transaction_codes MODIFY (m97_category NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m97_transaction_codes MODIFY (m97_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m97_transaction_codes MODIFY (m97_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m97_transaction_codes MODIFY (m97_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m97_transaction_codes MODIFY (m97_status_changed_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m97_transaction_codes MODIFY (m97_status_changed_date NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M97_TRANSACTION_CODES

COMMENT ON COLUMN dfn_ntp.m97_transaction_codes.m97_category IS
    '1 - Charge | 2 - Refund'
/
COMMENT ON COLUMN dfn_ntp.m97_transaction_codes.m97_b2b_enabled IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m97_transaction_codes.m97_visible IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m97_transaction_codes.m97_statement IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m97_transaction_codes.m97_charge_type IS
    '0 - None | 1 - Broker Only | 2 - Exchange and Broker Both'
/
COMMENT ON COLUMN dfn_ntp.m97_transaction_codes.m97_txn_impact_type IS
    '1: Order(i.e. Order + Cash + Holding) | 2: Cash Only | 3: Holding Only'
/
-- End of DDL Script for Table DFN_NTP.M97_TRANSACTION_CODES

alter table dfn_ntp.M97_TRANSACTION_CODES
	add M97_CUSTOM_TYPE varchar2(50) default 1
/

COMMENT ON COLUMN dfn_ntp.M97_TRANSACTION_CODES.M97_CHARGE_TYPE IS
 '0 - None | 1 - Broker Only | 2 - Exchange and Broker Both | 3 - Interest Charge'
/