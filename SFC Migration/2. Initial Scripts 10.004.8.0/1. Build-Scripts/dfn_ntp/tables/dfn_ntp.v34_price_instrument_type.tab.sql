-- Table DFN_NTP.V34_PRICE_INSTRUMENT_TYPE

CREATE TABLE dfn_ntp.v34_price_instrument_type
(
    v34_id                          NUMBER (10, 0),
    v34_inst_id_v09                 NUMBER (10, 0),
    v34_inst_code_v09               VARCHAR2 (100),
    v34_price_inst_type_id          NUMBER (10, 0),
    v34_price_inst_type_desc        VARCHAR2 (100),
    v34_price_inst_type_desc_lang   VARCHAR2 (100)
)
/

-- Constraints for  DFN_NTP.V34_PRICE_INSTRUMENT_TYPE


  ALTER TABLE dfn_ntp.v34_price_instrument_type ADD CONSTRAINT pk_v34 PRIMARY KEY (v34_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.v34_price_instrument_type MODIFY (v34_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v34_price_instrument_type MODIFY (v34_inst_id_v09 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v34_price_instrument_type MODIFY (v34_inst_code_v09 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v34_price_instrument_type MODIFY (v34_price_inst_type_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v34_price_instrument_type MODIFY (v34_price_inst_type_desc NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.V34_PRICE_INSTRUMENT_TYPE

COMMENT ON COLUMN dfn_ntp.v34_price_instrument_type.v34_inst_id_v09 IS
    'fk from v09'
/
COMMENT ON COLUMN dfn_ntp.v34_price_instrument_type.v34_inst_code_v09 IS
    'fk from v09'
/
-- End of DDL Script for Table DFN_NTP.V34_PRICE_INSTRUMENT_TYPE
