CREATE TABLE dfn_ntp.t90_murabaha_amortize
(
    t90_id                NUMBER (10, 0),
    t90_contract_id_t75   NUMBER (10, 0),
    t90_date              DATE,
    t90_amortize_amount   NUMBER (18, 5),
    t90_status            NUMBER (1, 0) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.t90_murabaha_amortize
    ADD CONSTRAINT pk_t90 PRIMARY KEY (t90_id) USING INDEX
/

COMMENT ON COLUMN dfn_ntp.t90_murabaha_amortize.t90_status IS
    '1=ACTIVE, 0=INACTIVE'
/
