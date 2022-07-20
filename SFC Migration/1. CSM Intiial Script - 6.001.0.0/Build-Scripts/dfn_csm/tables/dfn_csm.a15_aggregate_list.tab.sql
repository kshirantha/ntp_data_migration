CREATE TABLE dfn_csm.a15_aggregate_list
(
    a15_id              NUMBER (18, 0) NOT NULL,
    a15_csd_acc         VARCHAR2 (30 BYTE),
    a15_ccp_acc         VARCHAR2 (30 BYTE),
    a15_symbol          VARCHAR2 (30 BYTE),
    a15_exchange        VARCHAR2 (30 BYTE),
    a15_side            NUMBER (1, 0),
    a15_trade_date      DATE,
    a15_settle_date     DATE,
    a15_quantity        NUMBER (18, 0),
    a15_avg_price       NUMBER (18, 5),
    a15_cust_no         VARCHAR2 (30 BYTE),
    a15_status          NUMBER (2, 0),
    a15_created_by      NUMBER (18, 0),
    a15_created_date    DATE,
    a15_symbol_isin     VARCHAR2 (100 BYTE),
    a15_customer_name   VARCHAR2 (500 BYTE)
)
/





COMMENT ON COLUMN dfn_csm.a15_aggregate_list.a15_id IS 'PK'
/
COMMENT ON COLUMN dfn_csm.a15_aggregate_list.a15_status IS
    '0 - Accept ,  1 - Reject ,2 - Partially Aggregated , 3 - Aggregated ,   4 - Initiate , 10  -  Pending ,11 -  L1 Approved , 12 - Sent to Muqassa'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a15_aggregate_list ADD (a15_customer_id NUMBER (10))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a15_aggregate_list')
           AND column_name = UPPER ('a15_customer_id');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/