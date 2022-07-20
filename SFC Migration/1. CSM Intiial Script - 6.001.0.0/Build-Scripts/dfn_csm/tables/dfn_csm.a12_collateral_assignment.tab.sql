CREATE TABLE dfn_csm.a12_collateral_assignment
(
    a12_id                     NUMBER (18, 0),
    a12_request_date           DATE,
    a12_collateral_asset_act   VARCHAR2 (20 BYTE),
    a12_quantity               NUMBER (18, 0),
    a12_symbol                 VARCHAR2 (30 BYTE),
    a12_status                 NUMBER (5, 0),
    a12_received_datetime      DATE,
    a12_reason                 VARCHAR2 (500 BYTE)
)
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING
/



COMMENT ON COLUMN dfn_csm.a12_collateral_assignment.a12_status IS
    '1 = Accepted, 3 =  Rejected, 10 = Pending, 11 = L1 Approved, 12 = Sent to Muqassa'
/

ALTER TABLE dfn_csm.a12_collateral_assignment 
 ADD (
  A12_ISINCODE VARCHAR2 (30 BYTE)
 )
/



ALTER TABLE dfn_csm.a12_collateral_assignment
 ADD (
  A12_AMOUNT NUMBER (18, 5)
 )
/

ALTER TABLE dfn_csm.a12_collateral_assignment 
 ADD (
  a12_firm_id VARCHAR2 (10 BYTE)
 )
/
COMMENT ON COLUMN dfn_csm.a12_collateral_assignment.a12_firm_id IS 'Member Code'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a12_collateral_assignment ADD (a12_l1_approved_by NUMBER (20, 0))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a12_collateral_assignment')
           AND column_name = UPPER ('a12_l1_approved_by');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a12_collateral_assignment ADD (a12_l1_approved_date DATE)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a12_collateral_assignment')
           AND column_name = UPPER ('a12_l1_approved_date');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a12_collateral_assignment ADD (a12_l2_approved_by NUMBER (20, 0))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a12_collateral_assignment')
           AND column_name = UPPER ('a12_l2_approved_by');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a12_collateral_assignment ADD (a12_l2_approved_date DATE)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a12_collateral_assignment')
           AND column_name = UPPER ('a12_l2_approved_date');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/