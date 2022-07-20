CREATE TABLE dfn_csm.a01_trade_request_list
(
    a01_id                    NUMBER (18, 0) NOT NULL,
    a01_type                  NUMBER (1, 0) NOT NULL,
    a01_csd_acc               VARCHAR2 (30 BYTE),
    a01_ccp_acc               VARCHAR2 (30 BYTE),
    a01_symbol                VARCHAR2 (30 BYTE),
    a01_exchange              VARCHAR2 (30 BYTE),
    a01_side                  NUMBER (1, 0),
    a01_trade_date            DATE,
    a01_settle_date           DATE,
    a01_quantity              NUMBER (18, 0),
    a01_avg_price             NUMBER (18, 5),
    a01_cust_no               VARCHAR2 (30 BYTE),
    a01_status                NUMBER (1, 0),
    a01_created_by            NUMBER (18, 0),
    a01_created_date          DATE,
    a01_status_changed_by     NUMBER (18, 0),
    a01_status_changed_date   DATE
)
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING
/



COMMENT ON COLUMN dfn_csm.a01_trade_request_list.a01_id IS 'PK'
/
COMMENT ON COLUMN dfn_csm.a01_trade_request_list.a01_status IS
    '1 - Aggregated 2 - Splited'
/
COMMENT ON COLUMN dfn_csm.a01_trade_request_list.a01_type IS
    '1 - Aggregated 2 - Splited'
/



DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE dfn_csm.a01_trade_request_list';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a01_trade_request_list');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.a01_trade_request_list
(
    a01_id                    NUMBER (18, 0) NOT NULL,
    a01_csd_acc               VARCHAR2 (30 BYTE),
    a01_ccp_acc               VARCHAR2 (30 BYTE),
    a01_symbol                VARCHAR2 (30 BYTE),
    a01_exchange              VARCHAR2 (30 BYTE),
    a01_side                  NUMBER (1, 0),
    a01_trade_date            DATE,
    a01_settle_date           DATE,
    a01_quantity              NUMBER (18, 0),
    a01_avg_price             NUMBER (18, 5),
    a01_cust_no               VARCHAR2 (30 BYTE),
    a01_status                NUMBER (1, 0),
    a01_created_by            NUMBER (18, 0),
    a01_created_date          DATE,
    a01_status_changed_by     NUMBER (18, 0),
    a01_status_changed_date   DATE
)
/





COMMENT ON COLUMN dfn_csm.a01_trade_request_list.a01_id IS 'PK'
/
COMMENT ON COLUMN dfn_csm.a01_trade_request_list.a01_status IS
    '1 - Aggregated 2 - Splited'
/

ALTER TABLE dfn_csm.a01_trade_request_list 
 ADD (
  A01_MODIFIED_BY NUMBER (18, 0)
 )
/

ALTER TABLE dfn_csm.a01_trade_request_list 
 ADD (
  A01_MODIFIED_DATE DATE
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE dfn_csm.a01_trade_request_list';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a01_trade_request_list');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.a01_trade_request_list
(
    a01_id                    NUMBER (18, 0) NOT NULL,
    a01_csd_acc               VARCHAR2 (30 BYTE),
    a01_ccp_acc               VARCHAR2 (30 BYTE),
    a01_symbol                VARCHAR2 (30 BYTE),
    a01_exchange              VARCHAR2 (30 BYTE),
    a01_side                  NUMBER (1, 0),
    a01_trade_date            DATE,
    a01_settle_date           DATE,
    a01_quantity              NUMBER (18, 0),
    a01_avg_price             NUMBER (18, 5),
    a01_cust_no               VARCHAR2 (30 BYTE),
    a01_status                NUMBER (2, 0),
    a01_created_by            NUMBER (18, 0),
    a01_created_date          DATE,
    a01_status_changed_by     NUMBER (18, 0),
    a01_status_changed_date   DATE,
    a01_splitted_by           NUMBER (18, 0),
    a01_splitted_date         DATE,
    a01_customer_name         VARCHAR2 (1000 BYTE),
    a01_symbol_isin           VARCHAR2 (100 BYTE),
    a01_a15_id                NUMBER (18, 0),
    a01_reject_reason         VARCHAR2 (500 BYTE),
    a01_response_trdid        NUMBER (18, 0),
    a01_type                  NUMBER (1, 0)
)
/




COMMENT ON COLUMN dfn_csm.a01_trade_request_list.a01_created_date IS
    'Aggregate by'
/
COMMENT ON COLUMN dfn_csm.a01_trade_request_list.a01_id IS 'PK'
/
COMMENT ON COLUMN dfn_csm.a01_trade_request_list.a01_status IS
    '0 - Accept ,  1 - Reject ,  10  -  Pending ,11 -  L1 Approved , 12 - Sent to Muqassa ,'
/
COMMENT ON COLUMN dfn_csm.a01_trade_request_list.a01_type IS
    '1 - Aggregate , 2 - Split'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a01_trade_request_list ADD (a01_customer_id NUMBER (10))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a01_trade_request_list')
           AND column_name = UPPER ('a01_customer_id');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/