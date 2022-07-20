CREATE TABLE dfn_ntp.m144_subscription_products
(
    m144_id                   NUMBER (5, 0),
    m144_product_id_v35       VARCHAR2 (5 BYTE),
    m144_product_name         VARCHAR2 (20 BYTE),
    m144_product_name_lang    VARCHAR2 (50 BYTE),
    m144_retry_month          NUMBER (3, 0),
    m144_status_id_v01        NUMBER (1, 0),
    m144_rank                 NUMBER (2, 0),
    m144_premium_product      NUMBER (1, 0),
    m144_price_product_code   VARCHAR2 (100 BYTE)
)
/

ALTER TABLE dfn_ntp.m144_subscription_products
ADD CONSTRAINT m144_pk PRIMARY KEY (m144_id)
USING INDEX
/
