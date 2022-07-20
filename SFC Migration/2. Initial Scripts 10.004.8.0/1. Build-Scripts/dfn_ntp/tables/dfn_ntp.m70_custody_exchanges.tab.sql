CREATE TABLE dfn_ntp.m70_custody_exchanges
(
    m70_id                   NUMBER (5, 0),
    m70_exec_broker_id_m26   NUMBER (5, 0),
    m70_exchange_code_m01    VARCHAR2 (10 BYTE),
    m70_exchange_id_m01      NUMBER (5, 0),
    m70_custom_type          VARCHAR2 (50 BYTE) DEFAULT 1
)
/