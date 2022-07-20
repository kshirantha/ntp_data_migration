-- Foreign Key for  DFN_NTP.U11_CASH_RESTRICTION


  ALTER TABLE dfn_ntp.u11_cash_restriction ADD CONSTRAINT fk_u11_u06 FOREIGN KEY (u11_cash_account_id_u06)
   REFERENCES dfn_ntp.u06_cash_account (u06_id) ENABLE
/

  ALTER TABLE dfn_ntp.u11_cash_restriction ADD CONSTRAINT fk_u11_v31 FOREIGN KEY (u11_restriction_type_id_v31)
   REFERENCES dfn_ntp.v31_restriction (v31_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U11_CASH_RESTRICTION
