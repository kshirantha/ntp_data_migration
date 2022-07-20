ALTER TABLE dfn_ntp.m505_product_wise_waiveoff_c
    ADD CONSTRAINT fk_m505_m154 FOREIGN KEY (m505_waive_off_grp_id_m154)
    REFERENCES dfn_ntp.m154_subscription_waiveoff_grp (m154_id)
/
