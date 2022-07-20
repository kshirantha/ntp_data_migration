CREATE TABLE dfn_ntp.m190_exchange_comm_types
(
    m190_id                  NUMBER NOT NULL,
    m190_exchange_id_m01     NUMBER (5, 0),
    m190_comm_type_id_m124   NUMBER (10, 0),
    m190_priority            VARCHAR2 (100 BYTE)
)
/

ALTER TABLE dfn_ntp.m190_exchange_comm_types
ADD CONSTRAINT m190_pk PRIMARY KEY (m190_id)
USING INDEX
/

