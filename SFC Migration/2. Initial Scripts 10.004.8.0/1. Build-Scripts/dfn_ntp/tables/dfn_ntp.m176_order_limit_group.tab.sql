CREATE TABLE dfn_ntp.m176_order_limit_group
(
    m176_id                         NUMBER (10, 0) NOT NULL,
    m176_group_name                 VARCHAR2 (255 BYTE) NOT NULL,
    m176_buy_order_limit            NUMBER (18, 5) NOT NULL,
    m176_sell_order_limit           NUMBER (18, 5) NOT NULL,
    m176_frequency_id_v01           NUMBER (1, 0) NOT NULL,
    m176_is_default                 NUMBER (1, 0),
    m176_status_id_v01              NUMBER (5, 0),
    m176_created_by_id_u17          NUMBER (10, 0),
    m176_created_date               DATE,
    m176_status_changed_by_id_u17   NUMBER (10, 0),
    m176_status_changed_date        DATE,
    m176_modified_by_id_u17         NUMBER (10, 0),
    m176_modified_date              DATE,
    m176_custom_type                VARCHAR2 (50 BYTE),
    m176_institute_id_m02           NUMBER (3, 0)
)
/

ALTER TABLE dfn_ntp.m176_order_limit_group
ADD CONSTRAINT pk_m176 PRIMARY KEY (m176_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m176_order_limit_group.m176_frequency_id_v01 IS
    '1 - Cumulative | 2 -  Per Transaction'
/

ALTER TABLE dfn_ntp.M176_ORDER_LIMIT_GROUP 
 ADD (
  M176_enable_category_limit NUMBER (1) DEFAULT 0,
  M176_online_BUY_ORDER_LIMIT NUMBER (18, 5) DEFAULT 0,
  M176_online_SELL_ORDER_LIMIT NUMBER (18, 5) DEFAULT 0,
  M176_offline_BUY_ORDER_LIMIT NUMBER (18, 5) DEFAULT 0,
  M176_offline_SELL_ORDER_LIMIT NUMBER (18, 5) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.M176_ORDER_LIMIT_GROUP.M176_enable_category_limit IS '0- Disable 1- Enable'
/