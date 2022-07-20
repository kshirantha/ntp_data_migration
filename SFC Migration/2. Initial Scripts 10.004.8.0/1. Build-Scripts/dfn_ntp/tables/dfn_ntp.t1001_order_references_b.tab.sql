CREATE TABLE dfn_ntp.t1001_order_references_b
(
    t1001_id                   NUMBER (20, 0),
    t1001_current_account_no   VARCHAR2 (25 BYTE)
)
/
ALTER TABLE dfn_ntp.t1001_order_references_b
ADD CONSTRAINT pk_t1001_id PRIMARY KEY (t1001_id)
USING INDEX
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'CREATE TABLE dfn_ntp.t1001_sukuk_payment_detail_b(    t1001_id                  NUMBER (20, 0) NOT NULL,    t1001_symbol_code_m20     VARCHAR2 (100 BYTE),    t1001_coupon_id_m1001     NUMBER (18, 0),    t1001_nin                 VARCHAR2 (100 BYTE),    t1001_name                VARCHAR2 (200 BYTE),    t1001_account_no          VARCHAR2 (100 BYTE),    t1001_swift_code          VARCHAR2 (100 BYTE),    t1001_iban                VARCHAR2 (100 BYTE),    t1001_position_date       DATE,    t1001_holding_qty         NUMBER (18, 0),    t1001_coupon_amount       NUMBER (18, 5),    t1001_bank_id_m16         NUMBER (18, 0),    t1001_status_id_v01       NUMBER (5, 0),    t1001_cash_txn_id_t06     NUMBER (18, 0),    t1001_remarks             VARCHAR2 (200 BYTE),    t1001_custom_type         VARCHAR2 (50 BYTE) DEFAULT 1,    t1001_institute_id_m02    NUMBER (3, 0) DEFAULT 1,    t1001_created_date        DATE,    t1001_created_by_id_u17   NUMBER (18, 0))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t1001_sukuk_payment_detail_b');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t1001_sukuk_payment_detail_b    ADD CONSTRAINT pk_t1001 PRIMARY KEY (t1001_id)    USING INDEX';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_constraints
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t1001_sukuk_payment_detail_b')
           AND constraint_name = UPPER ('pk_t1001');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

