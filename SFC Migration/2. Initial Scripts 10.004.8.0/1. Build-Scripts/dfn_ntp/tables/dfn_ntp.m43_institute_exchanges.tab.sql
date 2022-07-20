CREATE TABLE dfn_ntp.m43_institute_exchanges
(
    m43_institute_id_m02           NUMBER (4, 0) NOT NULL,
    m43_exchange_code_m01          VARCHAR2 (10 BYTE) NOT NULL,
    m43_custodian_id_m26           NUMBER (5, 0),
    m43_executing_broker_id_m26    NUMBER (5, 0),
    m43_status_id_v01              NUMBER (5, 0),
    m43_created_by_id_u17          NUMBER (10, 0),
    m43_created_date               DATE,
    m43_modified_by_id_u17         NUMBER (10, 0),
    m43_modified_date              DATE,
    m43_status_changed_by_id_u17   NUMBER (10, 0),
    m43_status_changed_date        DATE,
    m43_id                         NUMBER (5, 0),
    m43_exchange_id_m01            NUMBER (5, 0),
    m43_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.m43_institute_exchanges
ADD CONSTRAINT uk_instituteid_exchangecode UNIQUE (m43_institute_id_m02,
  m43_exchange_code_m01)
USING INDEX
/

ALTER TABLE dfn_ntp.m43_institute_exchanges
ADD CONSTRAINT pk_m43 PRIMARY KEY (m43_id)
USING INDEX
/