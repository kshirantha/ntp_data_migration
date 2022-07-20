-- Table DFN_NTP.M96_HOLIDAYS

CREATE TABLE dfn_ntp.m96_holidays
(
    m96_id                         NUMBER (10, 0),
    m96_exchange_id_m01            NUMBER (10, 0),
    m96_exchange_code_m01          VARCHAR2 (10),
    m96_d1                         DATE,
    m96_description                VARCHAR2 (50),
    m96_instrument_type_code_v09   VARCHAR2 (4),
    m96_institution_m02            NUMBER (10, 0) DEFAULT 1,
    m96_created_by_id_u17          NUMBER (5, 0),
    m96_modified_by_id_u17         NUMBER (5, 0),
    m96_instrument_type_id_v09     NUMBER (10, 0)
)
/

-- Constraints for  DFN_NTP.M96_HOLIDAYS


  ALTER TABLE dfn_ntp.m96_holidays ADD CONSTRAINT m96_pk PRIMARY KEY (m96_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m96_holidays MODIFY (m96_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m96_holidays MODIFY (m96_exchange_code_m01 NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M96_HOLIDAYS

COMMENT ON COLUMN dfn_ntp.m96_holidays.m96_instrument_type_code_v09 IS
    'fk from v09'
/
-- End of DDL Script for Table DFN_NTP.M96_HOLIDAYS

alter table dfn_ntp.M96_HOLIDAYS
	add M96_CUSTOM_TYPE varchar2(50) default 1
/