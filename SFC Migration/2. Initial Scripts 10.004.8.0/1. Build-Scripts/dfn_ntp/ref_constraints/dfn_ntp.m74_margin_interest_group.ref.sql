-- Foreign Key for  DFN_NTP.M74_MARGIN_INTEREST_GROUP


  ALTER TABLE dfn_ntp.m74_margin_interest_group ADD CONSTRAINT fk_m74_m02_id FOREIGN KEY (m74_institution_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/

  ALTER TABLE dfn_ntp.m74_margin_interest_group ADD CONSTRAINT fk_m74_m65_id FOREIGN KEY (m74_saibor_basis_group_id_m65)
   REFERENCES dfn_ntp.m65_saibor_basis_rates (m65_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M74_MARGIN_INTEREST_GROUP
