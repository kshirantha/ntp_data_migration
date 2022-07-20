CREATE TABLE dfn_ntp.u28_employee_exchanges
(
    u28_id                         NUMBER (4, 0) NOT NULL,
    u28_exchange_code_m01          VARCHAR2 (10 BYTE) NOT NULL,
    u28_employee_id_u17            NUMBER (10, 0) NOT NULL,
    u28_created_by_id_u17          NUMBER (10, 0) NOT NULL,
    u28_created_date               DATE NOT NULL,
    u28_modified_by_id_u17         NUMBER (10, 0),
    u28_modified_date              DATE,
    u28_status_id_v01              NUMBER (20, 0) NOT NULL,
    u28_status_changed_by_id_u17   NUMBER (10, 0) NOT NULL,
    u28_status_changed_date        DATE NOT NULL,
    u28_dealer_exchange_code       VARCHAR2 (100 BYTE),
    u28_price_subscribed           NUMBER (1, 0) DEFAULT 1,
    u28_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    u28_exchange_id_m01            NUMBER (5, 0) NOT NULL
)
/

CREATE INDEX dfn_ntp.ix_u28_exg_code_m01
    ON dfn_ntp.u28_employee_exchanges (u28_exchange_code_m01 ASC)
    NOPARALLEL
    LOGGING
/

ALTER TABLE dfn_ntp.u28_employee_exchanges
ADD CONSTRAINT uk_u28_exg_cod_emp_id UNIQUE (u28_exchange_code_m01,
  u28_employee_id_u17)
USING INDEX
/

ALTER TABLE dfn_ntp.u28_employee_exchanges
ADD CONSTRAINT pk_u28_id PRIMARY KEY (u28_id)
USING INDEX
/

COMMENT ON TABLE dfn_ntp.u28_employee_exchanges IS
    'this table keeps all the exchanges allocated to executiong broker users'
/
COMMENT ON COLUMN dfn_ntp.u28_employee_exchanges.u28_employee_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.u28_employee_exchanges.u28_exchange_code_m01 IS
    'fk from m11'
/
COMMENT ON COLUMN dfn_ntp.u28_employee_exchanges.u28_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.u28_employee_exchanges.u28_price_subscribed IS
    '1 Subscribed'
/

ALTER TABLE dfn_ntp.u28_employee_exchanges
 ADD (u28_market_id_m29 NUMBER (3))
/

ALTER TABLE dfn_ntp.u28_employee_exchanges
    DROP CONSTRAINT uk_u28_exg_cod_emp_id DROP INDEX
/