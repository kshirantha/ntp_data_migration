DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE dfn_csm.t02_trade_capture_request';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('t02_trade_capture_request');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.t02_trade_capture_request
(
    t02_id       NUMBER (10, 0),
    t02_date     DATE,
    t02_status   NUMBER (5, 0),
    t02_reason   VARCHAR2 (500 BYTE)
)
/




COMMENT ON COLUMN dfn_csm.t02_trade_capture_request.t02_status IS
    '0 = Accepted,1 = Completed ,2 = Rejected ,3 = Sent to Muqassa , 4= Resend, 5= Created'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.t02_trade_capture_request ADD (t02_firm_id VARCHAR2 (10 BYTE))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('t02_trade_capture_request')
           AND column_name = UPPER ('t02_firm_id');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_csm.t02_trade_capture_request.t02_firm_id IS 'Member Code'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.t02_trade_capture_request ADD (t02_l1_approved_by NUMBER (20, 0))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('t02_trade_capture_request')
           AND column_name = UPPER ('t02_l1_approved_by');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.t02_trade_capture_request ADD (t02_l1_approved_date DATE)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('t02_trade_capture_request')
           AND column_name = UPPER ('t02_l1_approved_date');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.t02_trade_capture_request ADD (t02_l2_approved_by NUMBER (20, 0))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('t02_trade_capture_request')
           AND column_name = UPPER ('t02_l2_approved_by');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.t02_trade_capture_request ADD (t02_l2_approved_date DATE)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('t02_trade_capture_request')
           AND column_name = UPPER ('t02_l2_approved_date');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/