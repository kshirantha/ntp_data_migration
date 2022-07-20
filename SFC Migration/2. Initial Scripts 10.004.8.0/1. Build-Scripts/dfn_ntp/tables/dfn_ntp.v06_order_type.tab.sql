-- Table DFN_NTP.V06_ORDER_TYPE

CREATE TABLE dfn_ntp.v06_order_type
(
    v06_type_id                 VARCHAR2 (2),
    v06_description_1           NVARCHAR2 (50),
    v06_description_2           NVARCHAR2 (50),
    v06_default                 NUMBER (1, 0) DEFAULT 0,
    v06_is_regular_order_type   NUMBER (1, 0) DEFAULT 0,
    v06_is_available_in_fix     NUMBER (1, 0) DEFAULT 0,
    v06_id                      NUMBER (2, 0)
)
/

-- Constraints for  DFN_NTP.V06_ORDER_TYPE


  ALTER TABLE dfn_ntp.v06_order_type MODIFY (v06_description_1 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v06_order_type MODIFY (v06_description_2 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v06_order_type MODIFY (v06_default NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v06_order_type MODIFY (v06_is_regular_order_type NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v06_order_type MODIFY (v06_is_available_in_fix NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v06_order_type MODIFY (v06_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v06_order_type ADD CONSTRAINT un_type_id UNIQUE (v06_type_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.v06_order_type ADD CONSTRAINT v06_pk PRIMARY KEY (v06_id)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.V06_ORDER_TYPE

COMMENT ON COLUMN dfn_ntp.v06_order_type.v06_default IS
    'is this a default order type which needs to be added to an exchange when exchange is created'
/
COMMENT ON COLUMN dfn_ntp.v06_order_type.v06_is_regular_order_type IS
    'is this order type available for regular orders'
/
-- End of DDL Script for Table DFN_NTP.V06_ORDER_TYPE
