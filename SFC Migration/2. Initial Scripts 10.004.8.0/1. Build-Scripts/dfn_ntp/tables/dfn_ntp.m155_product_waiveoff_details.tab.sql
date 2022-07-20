CREATE TABLE dfn_ntp.m155_product_waiveoff_details
(
    m155_id                         NUMBER (5, 0),
    m155_group_id_m154              NUMBER (5, 0),
    m155_product_id_m152            NUMBER (5, 0),
    m155_currency_code_m03          VARCHAR2 (3 BYTE),
    m155_currency_id_m03            VARCHAR2 (3 BYTE),
    m155_service_fee_waiveof_amnt   NUMBER (18, 5) DEFAULT 0,
    m155_service_fee_waiveof_pct    NUMBER (18, 5) DEFAULT 0,
    m155_broker_fee_waiveof_amnt    NUMBER (18, 5) DEFAULT 0,
    m155_broker_fee_waiveof_pct     NUMBER (18, 5) DEFAULT 0,
    m155_created_date               DATE DEFAULT SYSDATE,
    m155_created_by_id_u17          NUMBER (10, 0) NOT NULL,
    m155_modified_date              DATE DEFAULT SYSDATE,
    m155_modified_by_id_u17         NUMBER (10, 0),
    m155_custom_type                VARCHAR2 (20 BYTE) DEFAULT 1,
    m155_status_id_v01              NUMBER (5, 0),
    m155_status_changed_by_id_u17   NUMBER (10, 0),
    m155_status_changed_date        DATE
)
/



ALTER TABLE dfn_ntp.m155_product_waiveoff_details
    ADD CONSTRAINT m155_pk PRIMARY KEY (m155_id) USING INDEX
/


ALTER TABLE dfn_ntp.m155_product_waiveoff_details
    ADD CONSTRAINT m155_fk_m154 FOREIGN KEY (m155_group_id_m154)
             REFERENCES dfn_ntp.m154_subscription_waiveoff_grp (m154_id)
/