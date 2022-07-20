CREATE TABLE dfn_ntp.u23_customer_margin_product
(
    u23_id                          NUMBER (5, 0) NOT NULL,
    u23_customer_id_u01             NUMBER (18, 0),
    u23_margin_product_m73          NUMBER (3, 0),
    u23_interest_group_id_m74       NUMBER (5, 0),
    u23_max_margin_limit            NUMBER (18, 5) DEFAULT 0,
    u23_max_limit_currency_m03      CHAR (3 BYTE),
    u23_margin_expiry_date          DATE,
    u23_margin_call_level_1         NUMBER (10, 5) DEFAULT 0,
    u23_margin_call_level_2         NUMBER (10, 5) DEFAULT 0,
    u23_liquidation_level           NUMBER (10, 5) DEFAULT 0,
    u23_sym_margin_group_m77        NUMBER (5, 0),
    u23_stock_concentration_m75     NUMBER (10, 0),
    u23_status_id_v01               NUMBER (10, 0),
    u23_created_date                DATE DEFAULT SYSDATE,
    u23_created_by_id_u17           NUMBER (10, 0),
    u23_modified_date               DATE,
    u23_modified_by_id_u17          NUMBER (10, 0),
    u23_max_limit_currency_id_m03   NUMBER (5, 0),
    u23_borrowers_name              VARCHAR2 (50 BYTE),
    u23_default_cash_acc_id_u06     NUMBER (5, 0),
    u23_margin_percentage           NUMBER (8, 3),
    u23_status_changed_by_id_u17    NUMBER (5, 0),
    u23_status_changed_date         DATE,
    u23_other_cash_acc_ids_u06      VARCHAR2 (500 BYTE),
    u23_restore_level               NUMBER (10, 5) DEFAULT 0,
    u23_current_margin_call_level   NUMBER (5, 0) DEFAULT 0,
    u23_exempt_liquidation          NUMBER (1, 0),
    PRIMARY KEY (u23_id)
)
/



COMMENT ON COLUMN dfn_ntp.u23_customer_margin_product.u23_current_margin_call_level IS
    '1 - Notification Level | 2 - Remionder Level | 3 - Liquidation Level'
/
COMMENT ON COLUMN dfn_ntp.u23_customer_margin_product.u23_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.u23_customer_margin_product.u23_margin_percentage IS
    'Coverage or IM'
/
COMMENT ON COLUMN dfn_ntp.u23_customer_margin_product.u23_other_cash_acc_ids_u06 IS
    'Comma Sperated U06 IDs'
/

alter table dfn_ntp.u23_customer_margin_product
	add M23_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.u23_customer_margin_product
 ADD (
  u23_institute_id_m02 NUMBER (3, 0)
 )
/

ALTER TABLE dfn_ntp.u23_customer_margin_product
    MODIFY (u23_institute_id_m02 DEFAULT 1)
/

ALTER TABLE dfn_ntp.U23_CUSTOMER_MARGIN_PRODUCT 
RENAME COLUMN M23_CUSTOM_TYPE TO U23_CUSTOM_TYPE
/

ALTER TABLE dfn_ntp.u23_customer_margin_product
 MODIFY (
  u23_default_cash_acc_id_u06 NUMBER (10, 0)
 )
/

ALTER TABLE dfn_ntp.u23_customer_margin_product
 ADD (
  u23_margin_expired NUMBER (1, 0) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.u23_customer_margin_product.u23_margin_expired IS
    '1- Margin Expired'
/

CREATE INDEX dfn_ntp.idx_u23_sym_margin_group_m77
    ON dfn_ntp.u23_customer_margin_product (u23_sym_margin_group_m77)
/

CREATE INDEX dfn_ntp.idx_u23_margin_product_m73
    ON dfn_ntp.u23_customer_margin_product (u23_margin_product_m73)
/

ALTER TABLE dfn_ntp.u23_customer_margin_product
 ADD (
   u23_murabaha_loan_limit NUMBER (18, 5)
 )
/



ALTER TABLE dfn_ntp.u23_customer_margin_product
ADD ( u23_add_or_sub_to_saibor_rate NUMBER(1) DEFAULT 0,
u23_add_or_sub_rate NUMBER(10,5) DEFAULT 0,
u23_flat_fee NUMBER(18,5) DEFAULT 0
)
/

COMMENT ON COLUMN dfn_ntp.u23_customer_margin_product.u23_add_or_sub_to_saibor_rate IS
    '0 - Add | 1 - Sub'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.u23_customer_margin_product ADD (u23_allow_los_cat_symbols_b NUMBER (1))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('u23_customer_margin_product')
           AND column_name = UPPER ('u23_allow_los_cat_symbols_b');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.U23_CUSTOMER_MARGIN_PRODUCT.u23_allow_los_cat_symbols_b IS 'Allow Loss Category Symbols (1=Allowed,0=Not Allowed)'
/