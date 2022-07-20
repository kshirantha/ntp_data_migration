CREATE TABLE dfn_csm.a00_trade_capture_report
(
    a00_id               NUMBER (10, 0) NOT NULL,
    a00_rptid            VARCHAR2 (50 BYTE),
    a00_trdid            VARCHAR2 (50 BYTE),
    a00_trdid2           VARCHAR2 (50 BYTE),
    a00_rpttyp           NUMBER (2, 0),
    a00_reqid            VARCHAR2 (50 BYTE),
    a00_trdtyp           NUMBER (2, 0),
    a00_trdsubtyp        NUMBER (2, 0),
    a00_origntrdid2      NUMBER (18, 0),
    a00_lastqty          NUMBER (18, 0),
    a00_lastpx           NUMBER (18, 5),
    a00_trddt            DATE,
    a00_bizdt            DATE,
    a00_txntm            DATE,
    a00_tztransacttime   DATE,
    a00_sym              VARCHAR2 (50 BYTE),
    a00_side             NUMBER (1, 0),
    a00_ptyid            VARCHAR2 (50 BYTE),
    a00_ordid            NUMBER (18, 0),
    a00_clordid          NUMBER (18, 0),
    a00_clordid2         NUMBER (18, 0),
    a00_ordqty           NUMBER (18, 0),
    a00_comm             NUMBER (18, 5)
)
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING
/



COMMENT ON COLUMN dfn_csm.a00_trade_capture_report.a00_id IS 'pk'
/



DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE DFN_CSM.a00_trade_capture_report';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a00_trade_capture_report');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.a00_trade_capture_report
(
    a00_id               NUMBER (10, 0) NOT NULL,
    a00_rptid            VARCHAR2 (50 BYTE),
    a00_trdid            VARCHAR2 (50 BYTE),
    a00_trdid2           VARCHAR2 (50 BYTE),
    a00_rpttyp           NUMBER (2, 0),
    a00_reqid            VARCHAR2 (50 BYTE),
    a00_trdtyp           NUMBER (2, 0),
    a00_trdsubtyp        NUMBER (10, 0),
    a00_origntrdid2      NUMBER (18, 0),
    a00_lastqty          NUMBER (18, 0),
    a00_lastpx           NUMBER (18, 5),
    a00_trddt            DATE,
    a00_bizdt            DATE,
    a00_txntm            DATE,
    a00_tztransacttime   DATE,
    a00_sym              VARCHAR2 (50 BYTE),
    a00_side             NUMBER (1, 0),
    a00_ptyid            VARCHAR2 (50 BYTE),
    a00_ordid            NUMBER (18, 0),
    a00_clordid          NUMBER (18, 0),
    a00_clordid2         NUMBER (18, 0),
    a00_ordqty           NUMBER (18, 0),
    a00_comm             NUMBER (18, 5),
    a00_is_valid         NUMBER (1, 0) DEFAULT 1,
    a00_settldt          DATE
)
/





COMMENT ON COLUMN dfn_csm.a00_trade_capture_report.a00_id IS 'pk'
/
COMMENT ON COLUMN dfn_csm.a00_trade_capture_report.a00_is_valid IS
    '1=valid record, 2-invalid record'
/
COMMENT ON COLUMN dfn_csm.a00_trade_capture_report.a00_reqid IS 'T02_ID'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.a00_trade_capture_report ADD (a00_matchid VARCHAR2 (50))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a00_trade_capture_report')
           AND column_name = UPPER ('a00_matchid');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
