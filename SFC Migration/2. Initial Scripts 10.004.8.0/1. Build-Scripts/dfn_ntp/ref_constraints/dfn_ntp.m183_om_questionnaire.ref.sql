ALTER TABLE dfn_ntp.m183_om_questionnaire
ADD CONSTRAINT fk_m183_product_id_m73 FOREIGN KEY (m183_product_id_m73)
REFERENCES dfn_ntp.m73_margin_products (m73_id)
/