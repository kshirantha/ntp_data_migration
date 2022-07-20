CREATE TABLE dfn_csm.a13_settlement_position_req
(
    a13_id             NUMBER (18, 0),
    a13_request_date   DATE,
    a13_request_time   DATE,
    a13_csd_acc        VARCHAR2 (30 BYTE),
    a13_symbol         VARCHAR2 (30 BYTE),
    a13_status         NUMBER (5, 0),
    a13_user_id        NUMBER (20, 0),
    a13_reason         VARCHAR2 (500 BYTE),
    a13_isincode       VARCHAR2 (30 BYTE)
)
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING
/



COMMENT ON COLUMN dfn_csm.a13_settlement_position_req.a13_status IS
    '0 = Completed, 2 =  Rejected, 10 = Pending, 11 = L1 Approved, 12 = Sent to Muqassa'
/



ALTER TABLE dfn_csm.a13_settlement_position_req 
 ADD (
  a13_firm_id VARCHAR2 (10 BYTE)
 )
/
COMMENT ON COLUMN dfn_csm.a13_settlement_position_req.a13_firm_id IS 'Member Code'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a13_settlement_position_req ADD (a13_l1_approved_by NUMBER (20, 0))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a13_settlement_position_req')
           AND column_name = UPPER ('a13_l1_approved_by');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a13_settlement_position_req ADD (a13_l1_approved_date DATE)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a13_settlement_position_req')
           AND column_name = UPPER ('a13_l1_approved_date');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a13_settlement_position_req ADD (a13_l2_approved_by NUMBER (20, 0))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a13_settlement_position_req')
           AND column_name = UPPER ('a13_l2_approved_by');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a13_settlement_position_req ADD (a13_l2_approved_date DATE)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a13_settlement_position_req')
           AND column_name = UPPER ('a13_l2_approved_date');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/