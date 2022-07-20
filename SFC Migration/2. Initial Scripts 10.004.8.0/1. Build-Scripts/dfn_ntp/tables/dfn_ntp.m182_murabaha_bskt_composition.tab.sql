CREATE TABLE dfn_ntp.m182_murabaha_bskt_composition
    (m182_id                        NUMBER(10,0) NOT NULL,
    m182_basket_id_m181            NUMBER(10,0) NOT NULL,
    m182_exchange_id_m01           CHAR(10 BYTE),
    m182_symbol_code_m20           VARCHAR2(40 BYTE) NOT NULL,
    m182_percentage                NUMBER(5,2),
    m182_allowed_change            NUMBER(1,0) DEFAULT 0,
    m182_created_by_id_u17         NUMBER(10,0),
    m182_created_date              DATE DEFAULT SYSDATE,
    m182_modified_by_id_u17        NUMBER(10,0),
    m182_modified_date             DATE,
    m182_status_id_v01             NUMBER(2,0),
    m182_custom_type               VARCHAR2(50 BYTE) DEFAULT 1,
    m182_symbol_id_m20             NUMBER(10,0) NOT NULL)
/
