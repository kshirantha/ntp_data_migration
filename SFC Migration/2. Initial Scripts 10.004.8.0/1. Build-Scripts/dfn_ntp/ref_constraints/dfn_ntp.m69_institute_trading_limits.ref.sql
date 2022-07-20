-- Foreign Key for  DFN_NTP.M69_INSTITUTE_TRADING_LIMITS


  ALTER TABLE dfn_ntp.m69_institute_trading_limits ADD CONSTRAINT m69_institution_id_m02 FOREIGN KEY (m69_institution_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE NOVALIDATE
/

  ALTER TABLE dfn_ntp.m69_institute_trading_limits ADD CONSTRAINT m69_last_updated_by FOREIGN KEY (m69_last_updated_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE NOVALIDATE
/
-- End of REF DDL Script for Table DFN_NTP.M69_INSTITUTE_TRADING_LIMITS
