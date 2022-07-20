CREATE TABLE dfn_ntp.t63_tc_request_list
(
    t63_id                  NUMBER (18, 0) NOT NULL,
    t63_from_date           DATE,
    t63_to_date             DATE,
    t63_institute_id_m02    NUMBER (3, 0),
    t63_exchange_id_m01     NUMBER (5, 0),
    t63_exchange_code_m01   VARCHAR2 (10 BYTE),
    t63_type                NUMBER (1, 0),
    t63_created_by_id_u17   NUMBER (10, 0),
    t63_created_date        DATE
)
/

ALTER TABLE dfn_ntp.t63_tc_request_list
ADD CONSTRAINT pk_t63 PRIMARY KEY (t63_id)
USING INDEX
/