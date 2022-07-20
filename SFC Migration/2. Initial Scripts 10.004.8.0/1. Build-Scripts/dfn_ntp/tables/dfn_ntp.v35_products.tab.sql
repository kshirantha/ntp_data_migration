CREATE TABLE dfn_ntp.v35_products
(
    v35_id                  NUMBER (3, 0) NOT NULL,
    v35_product_code        VARCHAR2 (100 BYTE),
    v35_product_name        VARCHAR2 (200 BYTE),
    v35_product_name_lang   VARCHAR2 (400 BYTE),
    v35_rank                NUMBER (2, 0),
    v35_premium_product     NUMBER (1, 0)
)
/



COMMENT ON COLUMN dfn_ntp.v35_products.v35_product_code IS 'for price side'
/