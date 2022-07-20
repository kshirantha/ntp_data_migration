CREATE TABLE dfn_ntp.m188_order_limit_group_slabs
(
    m188_id                         NUMBER (10, 0) NOT NULL,
    m188_group_id_m176              VARCHAR2 (255 BYTE) NOT NULL,
    m188_channel_id_v29             NUMBER (5, 0),
    m188_buy_order_limit            NUMBER (18, 5) NOT NULL,
    m188_sell_order_limit           NUMBER (18, 5) NOT NULL,
    m188_status_id_v01              NUMBER (5, 0),
    m188_created_by_id_u17          NUMBER (10, 0),
    m188_created_date               DATE,
    m188_status_changed_by_id_u17   NUMBER (10, 0),
    m188_status_changed_date        DATE,
    m188_modified_by_id_u17         NUMBER (10, 0),
    m188_modified_date              DATE,
    m188_custom_type                VARCHAR2 (50 BYTE)
)
/

ALTER TABLE dfn_ntp.m188_order_limit_group_slabs
ADD CONSTRAINT pk_m188 PRIMARY KEY (m188_id)
USING INDEX
/