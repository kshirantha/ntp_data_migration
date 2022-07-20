-- Table DFN_NTP.M57_EXCHANGE_ORDER_TYPES

CREATE TABLE dfn_ntp.m57_exchange_order_types
(
    m57_id                  NUMBER (4, 0),
    m57_exchange_id_m01     NUMBER (10, 0),
    m57_order_type_id_v06   NUMBER (2, 0),
    m57_exchange_code_m01   VARCHAR2 (10)
)
/

-- Constraints for  DFN_NTP.M57_EXCHANGE_ORDER_TYPES


  ALTER TABLE dfn_ntp.m57_exchange_order_types ADD CONSTRAINT m57_exchange_order_types_uk UNIQUE (m57_exchange_id_m01, m57_order_type_id_v06) DISABLE
/

  ALTER TABLE dfn_ntp.m57_exchange_order_types ADD CONSTRAINT m57_pk PRIMARY KEY (m57_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m57_exchange_order_types MODIFY (m57_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m57_exchange_order_types MODIFY (m57_exchange_id_m01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m57_exchange_order_types MODIFY (m57_order_type_id_v06 NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M57_EXCHANGE_ORDER_TYPES

COMMENT ON COLUMN dfn_ntp.m57_exchange_order_types.m57_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.m57_exchange_order_types.m57_exchange_id_m01 IS
    'fk from m01'
/
COMMENT ON COLUMN dfn_ntp.m57_exchange_order_types.m57_order_type_id_v06 IS
    'fk from v06'
/
COMMENT ON TABLE dfn_ntp.m57_exchange_order_types IS
    'this table keeps all the order types used in exchange'
/
-- End of DDL Script for Table DFN_NTP.M57_EXCHANGE_ORDER_TYPES

alter table dfn_ntp.M57_EXCHANGE_ORDER_TYPES
	add M57_CUSTOM_TYPE varchar2(50) default 1
/
