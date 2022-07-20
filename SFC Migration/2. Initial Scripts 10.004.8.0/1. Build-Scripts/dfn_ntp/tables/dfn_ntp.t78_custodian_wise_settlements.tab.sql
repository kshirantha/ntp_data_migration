CREATE TABLE dfn_ntp.t78_custodian_wise_settlements
(
    t78_id                           NUMBER (18, 0) NOT NULL,
    t78_custodian_id_m26             NUMBER (5, 0),
    t78_exchange_code_m01            VARCHAR2 (50 BYTE),
    t78_created_datetime             DATE,
    t78_settlement_date              DATE,
    t78_currency_code_m03            VARCHAR2 (50 BYTE),
    t78_exchange_commission          NUMBER (18, 5),
    t78_brokerage_commission         NUMBER (18, 5),
    t78_exchange_commission_vat      NUMBER (18, 5),
    t78_brokerage_commission_vat     NUMBER (18, 5),
    t78_tot_recived_from_custodian   NUMBER (18, 5),
    t78_status                       NUMBER (5, 0) DEFAULT 1,
    t78_status_changed_by_id_u17     NUMBER (10, 0),
    t78_status_changed_date          DATE,
    t78_recived_procesed_by_id_u17   NUMBER (10, 0),
    t78_recived_processed_date       DATE,
    t78_institute_id_m02             NUMBER (3, 0) DEFAULT 1,
    t78_custom_type                  VARCHAR2 (50 BYTE) DEFAULT 1
)
/



ALTER TABLE dfn_ntp.t78_custodian_wise_settlements
    ADD CONSTRAINT t78_pk PRIMARY KEY (t78_id) USING INDEX
/