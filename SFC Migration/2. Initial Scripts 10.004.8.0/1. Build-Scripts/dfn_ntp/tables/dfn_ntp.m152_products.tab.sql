CREATE TABLE dfn_ntp.m152_products
(
    m152_id                   NUMBER (5, 0),
    m152_product_code         VARCHAR2 (100 BYTE),
    m152_product_name         VARCHAR2 (200 BYTE),
    m152_product_name_lang    VARCHAR2 (400 BYTE),
    m152_institution_id_m02   NUMBER (3, 0),
    m152_is_active            NUMBER (1, 0),
    m152_rank                 NUMBER (2, 0),
    m152_premium_product      NUMBER (1, 0) DEFAULT 1,
    m152_currency_code_m03    VARCHAR2 (3 BYTE),
    m152_currency_id_m03      VARCHAR2 (3 BYTE),
    m152_duration             NUMBER (2, 0),
    m152_service_fee          NUMBER (18, 5) DEFAULT 0,
    m152_broker_fee           NUMBER (18, 5) DEFAULT 0,
    m152_vat_pct              NUMBER (8, 5) DEFAULT 0,
    m152_created_date         DATE DEFAULT SYSDATE,
    m152_created_by_id_u17    NUMBER (10, 0) NOT NULL,
    m152_modified_date        DATE DEFAULT SYSDATE,
    m152_modified_by_id_u17   NUMBER (10, 0),
    m152_custom_type          VARCHAR2 (20 BYTE) DEFAULT 1
)
/



ALTER TABLE dfn_ntp.m152_products
    ADD CONSTRAINT m152_pk PRIMARY KEY (m152_id) USING INDEX
/

ALTER TABLE dfn_ntp.m152_products
    ADD CONSTRAINT m152_uk UNIQUE (m152_institution_id_m02, m152_rank)
        USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m152_products.m152_is_active IS
    '1=active,0=suspend'
/
COMMENT ON COLUMN dfn_ntp.m152_products.m152_product_code IS 'for price side'
/
COMMENT ON COLUMN dfn_ntp.m152_products.m152_rank IS
    'hierarchy of the product'
/

ALTER TABLE dfn_ntp.m152_products
 ADD (
  m152_product_id_v35 NUMBER (3, 0)
 )
/

ALTER TABLE dfn_ntp.m152_products 
 ADD (
  M152_STATUS_ID_V01 NUMBER (5, 0),
  M152_STATUS_CHANGED_BY_ID_U17 NUMBER (10, 0),
  M152_STATUS_CHANGED_DATE TIMESTAMP (7)
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.M152_PRODUCTS 
 ADD (
 M152_SUB_AGREEMENT_TYPE NUMBER (1)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('M152_PRODUCTS')
           AND column_name = UPPER ('M152_SUB_AGREEMENT_TYPE');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.M152_PRODUCTS.M152_SUB_AGREEMENT_TYPE IS '0=Private,1=Business'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.M152_PRODUCTS 
 ADD (
 M152_EXCHANGE_FEE NUMBER (18, 5)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('M152_PRODUCTS')
           AND column_name = UPPER ('M152_EXCHANGE_FEE');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.M152_PRODUCTS 
 ADD (
 M152_OTHER_FEE NUMBER (18, 5)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('M152_PRODUCTS')
           AND column_name = UPPER ('M152_OTHER_FEE');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

ALTER TABLE dfn_ntp.m152_products
 ADD (
  m152_product_id_m144 NUMBER (5)
 )
/


ALTER TABLE dfn_ntp.m152_products
    DROP CONSTRAINT m152_uk DROP INDEX
/

ALTER TABLE dfn_ntp.m152_products
    ADD CONSTRAINT uk_product_name UNIQUE
            (m152_institution_id_m02, m152_product_name)
            USING INDEX
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE dfn_ntp.m152_products
 ADD (
  m152_description VARCHAR2 (200 BYTE)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('M152_PRODUCTS')
           AND column_name = UPPER ('m152_description');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN DFN_NTP.M152_PRODUCTS.M152_PRODUCT_CODE IS 'm144_product_id_v35'
/
