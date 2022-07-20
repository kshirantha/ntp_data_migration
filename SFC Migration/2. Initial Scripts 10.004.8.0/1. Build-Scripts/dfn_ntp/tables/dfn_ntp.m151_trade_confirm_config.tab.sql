CREATE TABLE dfn_ntp.m151_trade_confirm_config
(
    m151_id                         NUMBER (5, 0) NOT NULL,
    m151_name                       VARCHAR2 (100 BYTE) NOT NULL,
    m151_code                       VARCHAR2 (50 BYTE) NOT NULL,
    m151_is_default                 NUMBER (1, 0) DEFAULT 0,
    m151_is_clearing                NUMBER (1, 0) DEFAULT 0,
    m151_is_symbol                  NUMBER (1, 0) DEFAULT 0,
    m151_is_market                  NUMBER (1, 0) DEFAULT 0,
    m151_is_order_side              NUMBER (1, 0) DEFAULT 0,
    m151_is_custodian               NUMBER (1, 0) DEFAULT 0,
    m151_status_id_v01              NUMBER (20, 0),
    m151_created_by_id_u17          NUMBER (10, 0),
    m151_created_date               DATE,
    m151_modified_by_id_u17         NUMBER (10, 0),
    m151_modified_date              DATE,
    m151_status_changed_by_id_u17   NUMBER (10, 0),
    m151_status_changed_date        DATE,
    m151_institute_id_m02           NUMBER (3, 0) DEFAULT 1,
    m151_custom_type                VARCHAR2 (50 BYTE),
    m151_trade_confirm_format_v12   NUMBER (4, 0)
)
/

------ constraints for m151_trade_confirm_config

ALTER TABLE dfn_ntp.m151_trade_confirm_config
ADD CONSTRAINT pk_m151 PRIMARY KEY (m151_id)
USING INDEX ENABLE
/


