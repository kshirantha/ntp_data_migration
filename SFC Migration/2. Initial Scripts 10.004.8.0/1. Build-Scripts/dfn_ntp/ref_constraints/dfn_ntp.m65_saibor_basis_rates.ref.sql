-- Foreign Key for  DFN_NTP.M65_SAIBOR_BASIS_RATES


  ALTER TABLE dfn_ntp.m65_saibor_basis_rates ADD CONSTRAINT m65_duration_m267_fk FOREIGN KEY (m65_duration_id_m64)
   REFERENCES dfn_ntp.m64_saibor_basis_durations (m64_id) ENABLE
/

  ALTER TABLE dfn_ntp.m65_saibor_basis_rates ADD CONSTRAINT m65_inst_m02_fk FOREIGN KEY (m65_institution_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M65_SAIBOR_BASIS_RATES
