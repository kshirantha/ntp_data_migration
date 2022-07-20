CREATE TABLE dfn_csm.a02_trade_request_list_details
(
    a02_id         NUMBER (18, 0) NOT NULL,
    a02_id_a01     NUMBER (18, 0) NOT NULL,
    a02_id_a00     NUMBER (18, 0),
    a02_csd_acc    VARCHAR2 (30 BYTE),
    a02_ccp_acc    VARCHAR2 (30 BYTE),
    a02_price      NUMBER (18, 5),
    a02_quantity   NUMBER (18, 0)
)
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING
/



COMMENT ON COLUMN dfn_csm.a02_trade_request_list_details.a02_id IS 'PK'
/



DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE dfn_csm.a02_trade_request_list_details';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a02_trade_request_list_details');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.a02_trade_request_list_details
(
    a02_id         NUMBER (18, 0) NOT NULL,
    a02_id_a01     NUMBER (18, 0) NOT NULL,
    a02_id_a00     NUMBER (18, 0),
    a02_csd_acc    VARCHAR2 (30 BYTE),
    a02_ccp_acc    VARCHAR2 (30 BYTE),
    a02_price      NUMBER (18, 5),
    a02_quantity   NUMBER (18, 0),
    a02_type       NUMBER (1, 0)
)
/



COMMENT ON COLUMN dfn_csm.a02_trade_request_list_details.a02_id IS 'PK'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE dfn_csm.a02_trade_request_list_details';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a02_trade_request_list_details');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.a02_trade_request_list_details
(
    a02_id              NUMBER (18, 0) NOT NULL,
    a02_a15_id          NUMBER (18, 0) NOT NULL,
    a02_a00_trdid       VARCHAR2 (50 BYTE),
    a02_csd_acc         VARCHAR2 (30 BYTE),
    a02_ccp_acc         VARCHAR2 (30 BYTE),
    a02_price           NUMBER (18, 5),
    a02_quantity        NUMBER (18, 0),
    a02_type            NUMBER (1, 0),
    a02_is_select       NUMBER (1, 0) DEFAULT 0,
    a02_status          NUMBER (2, 0),
    a02_isin            VARCHAR2 (100 BYTE),
    a02_symbol          VARCHAR2 (100 BYTE),
    a02_a01_id          NUMBER (18, 0),
    a02_customer_name   VARCHAR2 (1000 BYTE),
    a02_customer_no     VARCHAR2 (30 BYTE),
    a02_side            NUMBER (1, 0),
    a02_trade_date      DATE,
    a02_settle_date     DATE
)
/




COMMENT ON COLUMN dfn_csm.a02_trade_request_list_details.a02_a00_trdid IS
    'execution id'
/
COMMENT ON COLUMN dfn_csm.a02_trade_request_list_details.a02_id IS 'PK'
/
COMMENT ON COLUMN dfn_csm.a02_trade_request_list_details.a02_status IS
    '0 - Accept ,  1 - Reject , 10 - Pending ,11 -  L1 Approved , 12 - Sent to Muqassa'
/
COMMENT ON COLUMN dfn_csm.a02_trade_request_list_details.a02_type IS
    '1 - Aggregate , 2 - Split'
/