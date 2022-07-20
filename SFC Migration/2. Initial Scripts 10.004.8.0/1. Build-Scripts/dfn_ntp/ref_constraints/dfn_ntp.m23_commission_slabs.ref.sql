-- Foreign Key for  DFN_NTP.M23_COMMISSION_SLABS


  ALTER TABLE dfn_ntp.m23_commission_slabs ADD CONSTRAINT m23_commission_group_id_m22_fk FOREIGN KEY (m23_commission_group_id_m22)
   REFERENCES dfn_ntp.m22_commission_group (m22_id) ENABLE
/

  ALTER TABLE dfn_ntp.m23_commission_slabs ADD CONSTRAINT m23_currency_code_m03_fk FOREIGN KEY (m23_currency_code_m03)
   REFERENCES dfn_ntp.m03_currency (m03_code) ENABLE
/

  ALTER TABLE dfn_ntp.m23_commission_slabs ADD CONSTRAINT m23_v09_fk FOREIGN KEY (m23_instrument_type_v09)
   REFERENCES dfn_ntp.v09_instrument_types (v09_code) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M23_COMMISSION_SLABS
