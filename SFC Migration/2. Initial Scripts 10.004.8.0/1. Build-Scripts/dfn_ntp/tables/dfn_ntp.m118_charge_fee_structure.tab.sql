-- Table DFN_NTP.M118_CHARGE_FEE_STRUCTURE

CREATE TABLE dfn_ntp.m118_charge_fee_structure
(
    m118_id                   NUMBER (18, 0),
    m118_exchange_code_m01    VARCHAR2 (10),
    m118_exchange_id_m01      NUMBER (5, 0),
    m118_fee_type             NUMBER (3, 0) DEFAULT 0,
    m118_broker_fee           NUMBER (10, 5) DEFAULT 0,
    m118_exchange_fee         NUMBER (10, 5) DEFAULT 0,
    m118_group_id_m117        NUMBER (10, 0),
    m118_currency_code_m03    CHAR (3),
    m118_currency_id_m03      NUMBER (5, 0),
    m118_broker_vat           NUMBER (10, 5),
    m118_exchange_vat         NUMBER (10, 5),
    m118_charge_code_m97      VARCHAR2 (10),
    m118_created_by_id_u17    NUMBER (10, 0) DEFAULT NULL,
    m118_created_date         DATE DEFAULT NULL,
    m118_modified_by_id_u17   NUMBER (10, 0),
    m118_modified_date        DATE DEFAULT NULL
)
/



-- End of DDL Script for Table DFN_NTP.M118_CHARGE_FEE_STRUCTURE

alter table dfn_ntp.M118_CHARGE_FEE_STRUCTURE
	add M118_CUSTOM_TYPE varchar2(50) default 1
/
ALTER TABLE dfn_ntp.m118_charge_fee_structure
 ADD (
  m118_interest_rate NUMBER (10, 5)
 )
/
COMMENT ON COLUMN dfn_ntp.m118_charge_fee_structure.m118_interest_rate IS
    'Interest rate for OD and other '
/

ALTER TABLE dfn_ntp.m118_charge_fee_structure
 ADD (
  m118_institute_id_m02 NUMBER (3) DEFAULT 1
 )
/

ALTER TABLE dfn_ntp.m118_charge_fee_structure
    DROP COLUMN m118_fee_type
/