-- Foreign Key for  DFN_NTP.U23_CUSTOMER_MARGIN_PRODUCT


  ALTER TABLE dfn_ntp.u23_customer_margin_product ADD CONSTRAINT u23_margin_product_m73 FOREIGN KEY (u23_margin_product_m73)
   REFERENCES dfn_ntp.m73_margin_products (m73_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U23_CUSTOMER_MARGIN_PRODUCT
