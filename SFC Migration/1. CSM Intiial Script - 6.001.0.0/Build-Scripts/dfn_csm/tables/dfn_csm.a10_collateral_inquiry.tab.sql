CREATE TABLE dfn_csm.a10_collateral_inquiry
(
    a10_id             NUMBER (18, 0),
    a10_request_date   DATE,
    a10_request_time   DATE,
    a10_status         NUMBER (5, 0),
    a10_user_id        NUMBER (20, 0),
    a10_reason         VARCHAR2 (500 BYTE)
)
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING
/



COMMENT ON COLUMN dfn_csm.a10_collateral_inquiry.a10_status IS
    '1 = Failed, 10 = Pending, 11 = L1 Approved, 12 = Sent to Muqassa'
/



ALTER TABLE dfn_csm.a10_collateral_inquiry 
 ADD (
  a10_firm_id VARCHAR2 (10 BYTE)
 )
/
COMMENT ON COLUMN dfn_csm.a10_collateral_inquiry.a10_firm_id IS 'Member Code'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a10_collateral_inquiry ADD (a10_l1_approved_by NUMBER (20, 0))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a10_collateral_inquiry')
           AND column_name = UPPER ('a10_l1_approved_by');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a10_collateral_inquiry ADD (a10_l1_approved_date DATE)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a10_collateral_inquiry')
           AND column_name = UPPER ('a10_l1_approved_date');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a10_collateral_inquiry ADD (a10_l2_approved_by NUMBER (20, 0))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a10_collateral_inquiry')
           AND column_name = UPPER ('a10_l2_approved_by');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a10_collateral_inquiry ADD (a10_l2_approved_date DATE)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a10_collateral_inquiry')
           AND column_name = UPPER ('a10_l2_approved_date');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/