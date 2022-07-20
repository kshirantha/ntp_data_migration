CREATE TABLE dfn_ntp.t30_gl_txn_candidates
(
    t30_date                  DATE,
    t30_batch_id_t27          NUMBER (10, 0),
    t30_txn_id                VARCHAR2 (20 BYTE),
    t30_data_source_id_m137   NUMBER (10, 0)
)
/

CREATE INDEX dfn_ntp.idx_t30_date
    ON dfn_ntp.t30_gl_txn_candidates (t30_date)
/

ALTER TABLE dfn_ntp.t30_gl_txn_candidates
ADD CONSTRAINT uk_t30 UNIQUE (t30_batch_id_t27, t30_txn_id,
  t30_data_source_id_m137)
USING INDEX
/

CREATE INDEX dfn_ntp.idx_t30_batch_id_t27
    ON dfn_ntp.t30_gl_txn_candidates (t30_batch_id_t27)
/
