CREATE TABLE dfn_ntp.t83_exec_broker_wise_settlmnt
(
    t83_id                           NUMBER (18, 0) NOT NULL,
    t83_exec_broker_id_m26           NUMBER (5, 0),
    t83_created_datetime             DATE,
    t83_settlement_date              DATE,
    t83_currency_code_m03            VARCHAR2 (50 BYTE),
    t83_order_value                  NUMBER (18, 5),
    t83_exchange_commission          NUMBER (18, 5),
    t83_brokerage_commission         NUMBER (18, 5),
    t83_exchange_commission_vat      NUMBER (18, 5),
    t83_brokerage_commission_vat     NUMBER (18, 5),
    t83_tot_recived_from_exec_brok   NUMBER (18, 5),
    t83_status_id_v01                NUMBER (5, 0) DEFAULT 1,
    t83_status_changed_by_id_u17     NUMBER (10, 0),
    t83_status_changed_date          DATE,
    t83_recived_procesed_by_id_u17   NUMBER (10, 0),
    t83_recived_processed_date       DATE,
    t83_institute_id_m02             NUMBER (3, 0) DEFAULT 1,
    t83_custom_type                  VARCHAR2 (50 BYTE) DEFAULT 1,
    t83_exchange_code_m01            VARCHAR2 (50 BYTE)
)
/



ALTER TABLE dfn_ntp.t83_exec_broker_wise_settlmnt
ADD CONSTRAINT t83_pk PRIMARY KEY (t83_id)
USING INDEX
/
