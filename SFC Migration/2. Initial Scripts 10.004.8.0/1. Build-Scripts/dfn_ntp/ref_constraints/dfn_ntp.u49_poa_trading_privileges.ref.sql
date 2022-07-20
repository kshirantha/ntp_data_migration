-- Foreign Key for  DFN_NTP.U49_POA_TRADING_PRIVILEGES


  ALTER TABLE dfn_ntp.u49_poa_trading_privileges ADD CONSTRAINT fk_u49_u47_id FOREIGN KEY (u49_poa_id_u47)
   REFERENCES dfn_ntp.u47_power_of_attorney (u47_id) ENABLE
/

  ALTER TABLE dfn_ntp.u49_poa_trading_privileges ADD CONSTRAINT fk_u49_u07_id FOREIGN KEY (u49_trading_account_id_u07)
   REFERENCES dfn_ntp.u07_trading_account (u07_id) ENABLE
/

  ALTER TABLE dfn_ntp.u49_poa_trading_privileges ADD CONSTRAINT fk_u49_v31_id FOREIGN KEY (u49_privilege_type_id_v31)
   REFERENCES dfn_ntp.v31_restriction (v31_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U49_POA_TRADING_PRIVILEGES
