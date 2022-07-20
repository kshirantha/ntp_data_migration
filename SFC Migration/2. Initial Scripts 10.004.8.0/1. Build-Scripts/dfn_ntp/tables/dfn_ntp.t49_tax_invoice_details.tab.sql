CREATE TABLE dfn_ntp.t49_tax_invoice_details
(
    t49_invoice_no_t48       VARCHAR2 (20 BYTE) NOT NULL,
    t49_last_db_seq_id_t02   NUMBER (18, 0) NOT NULL,
    t49_txn_code             VARCHAR2 (20 BYTE) NOT NULL
)
/


CREATE INDEX dfn_ntp.idx_t49_invoice_no_t48
    ON dfn_ntp.t49_tax_invoice_details ("T49_INVOICE_NO_T48" DESC)
    NOPARALLEL
    LOGGING
/


COMMENT ON COLUMN dfn_ntp.t49_tax_invoice_details.t49_invoice_no_t48 IS
    'FK from t48'
/

CREATE INDEX dfn_ntp.idx_t49_last_db_seq_id_t02
    ON dfn_ntp.t49_tax_invoice_details (t49_last_db_seq_id_t02 DESC)
/
