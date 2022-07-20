DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE dfn_csm.t01_execution_details';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('t01_execution_details');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.t01_execution_details
(
    t01_id              NUMBER (15, 0),
    t01_date            DATE,
    t01_exec_id         VARCHAR2 (50 BYTE),
    t01_customer_id     NUMBER (10, 0),
    t01_customer_no     VARCHAR2 (15 BYTE),
    t01_customer_name   VARCHAR2 (250 BYTE),
    t01_exchange        VARCHAR2 (10 BYTE),
    t01_csd_no          VARCHAR2 (20 BYTE),
    t01_ccp_no          VARCHAR2 (20 BYTE),
    t01_symbol          VARCHAR2 (30 BYTE),
    t01_side            NUMBER (1, 0),
    t01_trade_date      DATE,
    t01_settle_date     DATE
)
/


