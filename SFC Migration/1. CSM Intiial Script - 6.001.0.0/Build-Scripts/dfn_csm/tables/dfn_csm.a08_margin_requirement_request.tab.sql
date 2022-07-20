CREATE TABLE dfn_csm.a08_margin_requirement_request
(
    a08_id             NUMBER (18, 0),
    a08_request_date   DATE,
    a08_request_time   DATE,
    a08_user_id        NUMBER (20, 0),
    a08_status         NUMBER (5, 0),
    a08_reason         VARCHAR2 (500 BYTE)
)
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING
/



COMMENT ON COLUMN dfn_csm.a08_margin_requirement_request.a08_status IS
    '0 = Accepted , 2 = Completed, 4 = Rejected, 10 = Pending, 11 = L1 Approved, 12 = Sent to Muqassa'
/



ALTER TABLE dfn_csm.a08_margin_requirement_request 
 ADD (
  a08_firm_id VARCHAR2 (10 BYTE)
 )
/
COMMENT ON COLUMN dfn_csm.a08_margin_requirement_request.a08_firm_id IS 'Member Code'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a08_margin_requirement_request ADD (a08_l1_approved_by NUMBER (20, 0))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a08_margin_requirement_request')
           AND column_name = UPPER ('a08_l1_approved_by');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a08_margin_requirement_request ADD (a08_l1_approved_date DATE)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a08_margin_requirement_request')
           AND column_name = UPPER ('a08_l1_approved_date');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a08_margin_requirement_request ADD (a08_l2_approved_by NUMBER (20, 0))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a08_margin_requirement_request')
           AND column_name = UPPER ('a08_l2_approved_by');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a08_margin_requirement_request ADD (a08_l2_approved_date DATE)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a08_margin_requirement_request')
           AND column_name = UPPER ('a08_l2_approved_date');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/