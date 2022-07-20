-- Foreign Key for  DFN_NTP.U52_POA_TRAD_PRIVILEGE_PENDING


  ALTER TABLE dfn_ntp.u52_poa_trad_privilege_pending ADD CONSTRAINT fk_u52_u47_id FOREIGN KEY (u52_poa_id_u47)
   REFERENCES dfn_ntp.u47_power_of_attorney (u47_id) ENABLE
/

  ALTER TABLE dfn_ntp.u52_poa_trad_privilege_pending ADD CONSTRAINT fk_u52_u07_id FOREIGN KEY (u52_trading_account_id_u07)
   REFERENCES dfn_ntp.u07_trading_account (u07_id) ENABLE
/

  ALTER TABLE dfn_ntp.u52_poa_trad_privilege_pending ADD CONSTRAINT fk_u52_u17_id_status_chg FOREIGN KEY (u52_status_changed_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U52_POA_TRAD_PRIVILEGE_PENDING
