-- Table DFN_NTP.M04_CURRENCY_RATE

CREATE TABLE dfn_ntp.m04_currency_rate
(
    m04_from_currency_code_m03     CHAR (3),
    m04_to_currency_code_m03       CHAR (3),
    m04_rate                       NUMBER (13, 8),
    m04_buy_rate                   NUMBER (13, 8),
    m04_sell_rate                  NUMBER (13, 8),
    m04_spread                     NUMBER (13, 8),
    m04_institute_id_m02           NUMBER (3, 0),
    m04_created_by_id_u17          NUMBER (10, 0),
    m04_created_date               TIMESTAMP (6),
    m04_status_id_v01              NUMBER (5, 0),
    m04_modified_by_id_u17         NUMBER (10, 0),
    m04_modified_date              TIMESTAMP (6),
    m04_status_changed_by_id_u17   NUMBER (10, 0),
    m04_status_changed_date        TIMESTAMP (6),
    m04_id                         NUMBER (5, 0),
    m04_from_currency_id_m03       NUMBER (5, 0),
    m04_to_currency_id_m03         NUMBER (5, 0)
)
/

-- Constraints for  DFN_NTP.M04_CURRENCY_RATE


  ALTER TABLE dfn_ntp.m04_currency_rate ADD CONSTRAINT pk PRIMARY KEY (m04_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m04_currency_rate MODIFY (m04_from_currency_code_m03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m04_currency_rate MODIFY (m04_to_currency_code_m03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m04_currency_rate MODIFY (m04_rate NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m04_currency_rate MODIFY (m04_buy_rate NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m04_currency_rate MODIFY (m04_sell_rate NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m04_currency_rate MODIFY (m04_spread NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m04_currency_rate MODIFY (m04_institute_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m04_currency_rate MODIFY (m04_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m04_currency_rate MODIFY (m04_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m04_currency_rate MODIFY (m04_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m04_currency_rate MODIFY (m04_from_currency_id_m03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m04_currency_rate MODIFY (m04_to_currency_id_m03 NOT NULL ENABLE)
/

-- Indexes for  DFN_NTP.M04_CURRENCY_RATE


CREATE INDEX dfn_ntp.m04_m04_from_m03_code
    ON dfn_ntp.m04_currency_rate (m04_from_currency_code_m03)
/

CREATE INDEX dfn_ntp.m04_m04_to_m03_code
    ON dfn_ntp.m04_currency_rate (m04_to_currency_code_m03)
/

CREATE INDEX dfn_ntp.m04_m04_modified_date
    ON dfn_ntp.m04_currency_rate (m04_modified_date)
/


-- End of DDL Script for Table DFN_NTP.M04_CURRENCY_RATE

alter table dfn_ntp.M04_CURRENCY_RATE
	add M04_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m04_currency_rate
 MODIFY (
  m04_rate NUMBER (18, 8),
  m04_buy_rate NUMBER (18, 8),
  m04_sell_rate NUMBER (18, 8),
  m04_spread NUMBER (18, 8),
  m04_id NUMBER (15, 0)
 )
/

ALTER TABLE dfn_ntp.m04_currency_rate
 ADD (
  m04_category_m89 NUMBER (5) DEFAULT 0
 )
/

COMMENT ON COLUMN dfn_ntp.m04_currency_rate.m04_category_m89 IS
    'fk m89_id | 0 - Default | 1 - Staff'
/

ALTER TABLE dfn_ntp.m04_currency_rate
RENAME COLUMN m04_category_m89 TO m04_category_v01
/

COMMENT ON COLUMN dfn_ntp.m04_currency_rate.m04_category_v01 IS
    'v01_type = 86 | 0 - Default | 1 - Staff'
/
