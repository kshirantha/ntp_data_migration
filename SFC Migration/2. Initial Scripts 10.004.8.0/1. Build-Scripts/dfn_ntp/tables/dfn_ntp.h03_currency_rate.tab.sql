-- Table DFN_NTP.H03_CURRENCY_RATE

CREATE TABLE dfn_ntp.h03_currency_rate
(
    h03_from_currency_code_m03   CHAR (3),
    h03_to_currency_code_m03     CHAR (3),
    h03_rate                     NUMBER (13, 8),
    h03_buy_rate                 NUMBER (13, 8),
    h03_sell_rate                NUMBER (13, 8),
    h03_spread                   NUMBER (13, 8),
    h03_institute_id_m02         NUMBER (3, 0),
    h03_status_id_v01            NUMBER (5, 0),
    h03_id                       NUMBER (5, 0),
    h03_from_currency_id_m03     NUMBER (5, 0),
    h03_to_currency_id_m03       NUMBER (5, 0),
    h03_date                     DATE
)
/

-- Constraints for  DFN_NTP.H03_CURRENCY_RATE


  ALTER TABLE dfn_ntp.h03_currency_rate MODIFY (h03_from_currency_code_m03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h03_currency_rate MODIFY (h03_to_currency_code_m03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h03_currency_rate MODIFY (h03_rate NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h03_currency_rate MODIFY (h03_buy_rate NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h03_currency_rate MODIFY (h03_sell_rate NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h03_currency_rate MODIFY (h03_spread NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h03_currency_rate MODIFY (h03_institute_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h03_currency_rate MODIFY (h03_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h03_currency_rate MODIFY (h03_from_currency_id_m03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.h03_currency_rate MODIFY (h03_to_currency_id_m03 NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.H03_CURRENCY_RATE


CREATE INDEX dfn_ntp.idx_h03_date
    ON dfn_ntp.h03_currency_rate (h03_date DESC)
/


ALTER TABLE dfn_ntp.h03_currency_rate
 MODIFY (
  h03_rate NUMBER (18, 8),
  h03_buy_rate NUMBER (18, 8),
  h03_sell_rate NUMBER (18, 8),
  h03_spread NUMBER (18, 8),
  h03_id NUMBER (15, 0)
 )
/

ALTER TABLE dfn_ntp.h03_currency_rate ADD CONSTRAINT pk_h03_id
  PRIMARY KEY (
  h03_id
)
 ENABLE
 VALIDATE
/

ALTER TABLE dfn_ntp.h03_currency_rate
 ADD (
  h03_category_m89 NUMBER (5) DEFAULT 0
 )
/

COMMENT ON COLUMN dfn_ntp.h03_currency_rate.h03_category_m89 IS
    'fk m89_id | 0 - Default | 1 - Staff'
/

ALTER TABLE dfn_ntp.h03_currency_rate
RENAME COLUMN h03_category_m89 TO h03_category_v01
/

COMMENT ON COLUMN dfn_ntp.h03_currency_rate.h03_category_v01 IS
    'v01_type = 86 | 0 - Default | 1 - Staff'
/
