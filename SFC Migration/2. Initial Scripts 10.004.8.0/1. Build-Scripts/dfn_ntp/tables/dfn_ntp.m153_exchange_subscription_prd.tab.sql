CREATE TABLE dfn_ntp.m153_exchange_subscription_prd
(
    m153_id                   NUMBER (5, 0),
    m153_exchange_id_m01      NUMBER (5, 0) NOT NULL,
    m153_exchange_code_m01    VARCHAR2 (10 BYTE) NOT NULL,
    m153_institution_id_m02   NUMBER (3, 0),
    m153_customer_type        NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m153_premium_product      NUMBER (1, 0) DEFAULT 1,
    m153_is_active            NUMBER (1, 0) NOT NULL,
    m153_duration             NUMBER (2, 0),
    m153_exchange_fee         NUMBER (18, 5) DEFAULT 0,
    m153_vat_pct              NUMBER (8, 5) DEFAULT 0,
    m153_currency_code_m03    VARCHAR2 (3 BYTE),
    m153_currency_id_m03      NUMBER (5, 0),
    m153_created_date         DATE DEFAULT SYSDATE,
    m153_created_by_id_u17    NUMBER (10, 0) NOT NULL,
    m153_modified_date        DATE DEFAULT SYSDATE,
    m153_modified_by_id_u17   NUMBER (10, 0),
    m153_custom_type          VARCHAR2 (20 BYTE) DEFAULT 1
)
/


ALTER TABLE dfn_ntp.m153_exchange_subscription_prd
ADD CONSTRAINT m153_pk PRIMARY KEY (m153_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m153_exchange_subscription_prd.m153_customer_type IS
    '0=Business,1=private'
/
