-- Foreign Key for  DFN_NTP.M57_EXCHANGE_ORDER_TYPES


  ALTER TABLE dfn_ntp.m57_exchange_order_types ADD CONSTRAINT fk_from_v06 FOREIGN KEY (m57_order_type_id_v06)
   REFERENCES dfn_ntp.v06_order_type (v06_id) ENABLE
/

  ALTER TABLE dfn_ntp.m57_exchange_order_types ADD CONSTRAINT m57_m01_exchange_id FOREIGN KEY (m57_exchange_id_m01)
   REFERENCES dfn_ntp.m01_exchanges (m01_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M57_EXCHANGE_ORDER_TYPES
