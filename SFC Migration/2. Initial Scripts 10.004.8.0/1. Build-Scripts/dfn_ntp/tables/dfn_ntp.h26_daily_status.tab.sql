CREATE TABLE dfn_ntp.h26_daily_status
(
    h26_id                   NUMBER (20, 0),
    h26_date                 DATE,
    h26_buy                  NUMBER (18, 5),
    h26_sell                 NUMBER (18, 5),
    h26_broker_comm          NUMBER (18, 5),
    h26_total_comm           NUMBER (18, 5),
    h26_no_of_trades         NUMBER (10, 0),
    h26_no_of_orders         NUMBER (10, 0),
    h26_no_of_cust_traded    NUMBER (10, 0),
    h26_exg_turnover         NUMBER (20, 5),
    h26_exg_no_of_trades     NUMBER (18, 0),
    h26_exchange             VARCHAR2 (10 BYTE) NOT NULL,
    h26_institution_id_m02   NUMBER (3, 0) DEFAULT 1,
    h26_exchange_id_m01      NUMBER (10, 0)
)
/



ALTER TABLE dfn_ntp.h26_daily_status
    ADD CONSTRAINT pk_h26 PRIMARY KEY (h26_id) USING INDEX
/

COMMENT ON COLUMN dfn_ntp.h26_daily_status.h26_id IS 'PK'
/