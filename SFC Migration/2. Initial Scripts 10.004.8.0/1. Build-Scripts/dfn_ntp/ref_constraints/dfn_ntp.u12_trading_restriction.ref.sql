-- Foreign Key for  DFN_NTP.U12_TRADING_RESTRICTION


  ALTER TABLE dfn_ntp.u12_trading_restriction ADD CONSTRAINT fk_u07 FOREIGN KEY (u12_restriction_type_id_v31)
   REFERENCES dfn_ntp.v31_restriction (v31_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U12_TRADING_RESTRICTION
