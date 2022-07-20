CREATE TABLE dfn_ntp.m156_exchange_waiveoff_details
(
    m156_id                          NUMBER (5, 0),
    m156_group_id_m154               NUMBER (5, 0),
    m156_exchange_prd_id_m153        NUMBER (5, 0),
    m156_currency_code_m03           VARCHAR2 (3 BYTE),
    m156_currency_id_m03             VARCHAR2 (3 BYTE),
    m156_exchange_fee_waiveof_amnt   NUMBER (18, 5) DEFAULT 0,
    m156_exchange_fee_waiveof_pct    NUMBER (18, 5) DEFAULT 0,
    m156_created_date                DATE DEFAULT SYSDATE,
    m156_created_by_id_u17           NUMBER (10, 0) NOT NULL,
    m156_modified_date               DATE DEFAULT SYSDATE,
    m156_modified_by_id_u17          NUMBER (10, 0),
    m156_custom_type                 VARCHAR2 (20 BYTE) DEFAULT 1,
    m156_status_id_v01               NUMBER (5, 0),
    m156_status_changed_by_id_u17    NUMBER (10, 0),
    m156_status_changed_date         DATE
)
/



ALTER TABLE dfn_ntp.m156_exchange_waiveoff_details
    ADD CONSTRAINT m156_pk PRIMARY KEY (m156_id) USING INDEX
/


ALTER TABLE dfn_ntp.m156_exchange_waiveoff_details
    ADD CONSTRAINT m156_fk_m154 FOREIGN KEY (m156_group_id_m154)
             REFERENCES dfn_ntp.m154_subscription_waiveoff_grp (m154_id)
/