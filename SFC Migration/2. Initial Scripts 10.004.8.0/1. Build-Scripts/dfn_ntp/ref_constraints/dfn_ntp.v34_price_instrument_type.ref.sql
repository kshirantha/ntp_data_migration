-- Foreign Key for  DFN_NTP.V34_PRICE_INSTRUMENT_TYPE


  ALTER TABLE dfn_ntp.v34_price_instrument_type ADD CONSTRAINT fk_v34_inst_id_v09 FOREIGN KEY (v34_inst_code_v09)
   REFERENCES dfn_ntp.v09_instrument_types (v09_code) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.V34_PRICE_INSTRUMENT_TYPE
