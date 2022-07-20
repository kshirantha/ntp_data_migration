-- Foreign Key for  DFN_NTP.M73_MARGIN_PRODUCTS


  ALTER TABLE dfn_ntp.m73_margin_products ADD CONSTRAINT fk_m73_modified_by_m06 FOREIGN KEY (m73_modified_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE NOVALIDATE
/

  ALTER TABLE dfn_ntp.m73_margin_products ADD CONSTRAINT fk_m73_status_changed_by_m06 FOREIGN KEY (m73_status_changed_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE NOVALIDATE
/

  ALTER TABLE dfn_ntp.m73_margin_products ADD CONSTRAINT fk_m73_created_by_m06 FOREIGN KEY (m73_created_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE NOVALIDATE
/
-- End of REF DDL Script for Table DFN_NTP.M73_MARGIN_PRODUCTS
