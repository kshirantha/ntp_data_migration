CREATE TABLE dfn_csm.a09_margin_requirement_report
(
    a09_id          NUMBER (18, 0),
    a09_rptid       VARCHAR2 (50 BYTE),
    a09_reqid       NUMBER (18, 0),
    a09_rpttyp      NUMBER (1, 0),
    a09_bizdt       DATE,
    a09_setsesid    VARCHAR2 (5 BYTE),
    a09_setsessub   DATE,
    a09_txntm       DATE,
    a09_amt         NUMBER (18, 0),
    a09_typ         NUMBER (3, 0),
    a09_ccy         VARCHAR2 (5 BYTE)
)
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING
/



COMMENT ON COLUMN dfn_csm.a09_margin_requirement_report.a09_amt IS
    'Margin Amount'
/
COMMENT ON COLUMN dfn_csm.a09_margin_requirement_report.a09_bizdt IS
    'Valuation Date'
/
COMMENT ON COLUMN dfn_csm.a09_margin_requirement_report.a09_ccy IS 'Currency'
/
COMMENT ON COLUMN dfn_csm.a09_margin_requirement_report.a09_reqid IS
    'Request ID - A08_ID'
/
COMMENT ON COLUMN dfn_csm.a09_margin_requirement_report.a09_rptid IS
    'Unique ID of the report response'
/
COMMENT ON COLUMN dfn_csm.a09_margin_requirement_report.a09_setsessub IS
    'Settlement Date'
/
COMMENT ON COLUMN dfn_csm.a09_margin_requirement_report.a09_txntm IS 'Time'
/
COMMENT ON COLUMN dfn_csm.a09_margin_requirement_report.a09_typ IS
    'Margin Type - M02_ID'
/

