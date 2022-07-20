CREATE TABLE dfn_ntp.t48_tax_invoices
(
    t48_id                    NUMBER (18, 0) NOT NULL,
    t48_invoice_no            VARCHAR2 (20 BYTE) NOT NULL,
    t48_customer_id_u01       NUMBER (10, 0) NOT NULL,
    t48_from_date             DATE NOT NULL,
    t48_to_date               DATE NOT NULL,
    t48_issue_date            DATE NOT NULL,
    t48_txn_code              VARCHAR2 (20 BYTE) NOT NULL,
    t48_created_by_id_u17     NUMBER (10, 0),
    t48_custom_type           VARCHAR2 (50 BYTE) DEFAULT 1,
    t48_institute_id_m02      NUMBER (3, 0) DEFAULT 1,
    t48_eom_report            NUMBER (2, 0) DEFAULT 0 NOT NULL,
    t48_cash_account_id_u06   NUMBER (10, 0)
)
/



ALTER TABLE dfn_ntp.t48_tax_invoices
ADD CONSTRAINT uk_t48_invoice_no UNIQUE (t48_invoice_no)
USING INDEX
/

ALTER TABLE dfn_ntp.t48_tax_invoices
ADD CONSTRAINT t48_pk PRIMARY KEY (t48_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.t48_tax_invoices.t48_created_by_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.t48_tax_invoices.t48_customer_id_u01 IS
    'fk from u01'
/
COMMENT ON COLUMN dfn_ntp.t48_tax_invoices.t48_eom_report IS
    '0 = Manual Generated , 1 = EOM report'
/
COMMENT ON COLUMN dfn_ntp.t48_tax_invoices.t48_txn_code IS
    'm97_code/ ''ALL'' for all txn types'
/

CREATE INDEX dfn_ntp.idx_t48_from_date
    ON dfn_ntp.t48_tax_invoices (t48_from_date DESC)
/

CREATE INDEX dfn_ntp.idx_t48_to_date
    ON dfn_ntp.t48_tax_invoices (t48_to_date DESC)
/
