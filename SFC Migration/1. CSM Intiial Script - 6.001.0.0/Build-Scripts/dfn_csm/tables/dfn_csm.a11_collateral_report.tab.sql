CREATE TABLE dfn_csm.a11_collateral_report
(
    a11_id            NUMBER (18, 0),
    a11_rptid         VARCHAR2 (50 BYTE),
    a11_reqid         NUMBER (18, 0),
    a11_txntm         DATE,
    a11_stat          NUMBER (1, 0),
    a11_qty           NUMBER (18, 0),
    a11_bizdt         DATE,
    a11_amt           NUMBER (18, 0),
    a11_ccy           VARCHAR2 (5 BYTE),
    a11_typ           NUMBER (1, 0),
    a11_instrmt_sym   VARCHAR2 (18 BYTE),
    a11_instrmt_id    VARCHAR2 (18 BYTE),
    a11_instrmt_src   NUMBER (1, 0)
)
SEGMENT CREATION DEFERRED
NOPARALLEL
LOGGING
MONITORING
/



COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_amt IS
    'Collateral Amount'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_bizdt IS 'Date'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_ccy IS 'Currency'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_instrmt_id IS 'ISIN'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_instrmt_src IS '4= ISIN'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_instrmt_sym IS 'Symbol'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_qty IS 'Quantity'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_reqid IS
    'Request ID - A10_ID'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_rptid IS
    'Unique ID of the report response'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_stat IS
    'Collateral Status - 0 = Unassigned, 1 = Partially Assigned, 3 = Assigned (Accepted), 4 = Challenged'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_txntm IS 'Time'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_typ IS
    'Collateral Amount Type - M06_ID'
/



DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE DFN_CSM.a11_collateral_report';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a11_collateral_report');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.a11_collateral_report
(
    a11_id         NUMBER (18, 0),
    a11_rptid      VARCHAR2 (50 BYTE),
    a11_reqid      NUMBER (18, 0),
    a11_txntm      DATE,
    a11_stat       NUMBER (1, 0),
    a11_qty        NUMBER (18, 0),
    a11_bizdt      DATE,
    a11_amt        NUMBER (18, 0),
    a11_ccy        VARCHAR2 (5 BYTE),
    a11_typ        NUMBER (1, 0),
    a11_symbol     VARCHAR2 (18 BYTE),
    a11_isincode   VARCHAR2 (18 BYTE)
)
/





COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_amt IS
    'Collateral Amount'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_bizdt IS 'Date'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_ccy IS 'Currency'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_isincode IS 'ISIN'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_qty IS 'Quantity'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_reqid IS
    'Request ID - A10_ID'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_rptid IS
    'Unique ID of the report response'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_stat IS
    'Collateral Status - 0 = Unassigned, 1 = Partially Assigned, 3 = Assigned (Accepted), 4 = Challenged'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_symbol IS 'Symbol'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_txntm IS 'Time'
/
COMMENT ON COLUMN dfn_csm.a11_collateral_report.a11_typ IS
    'Collateral Amount Type - M06_ID'
/