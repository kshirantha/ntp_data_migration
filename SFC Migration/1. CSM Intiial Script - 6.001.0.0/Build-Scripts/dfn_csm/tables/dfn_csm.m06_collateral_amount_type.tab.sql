CREATE TABLE dfn_csm.m06_collateral_amount_type
(
    m06_id            NUMBER (10, 0) NOT NULL,
    m06_amount_type   VARCHAR2 (200 BYTE),
    m06_description   VARCHAR2 (500 BYTE)
)
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING
/



ALTER TABLE dfn_csm.m06_collateral_amount_type
ADD CONSTRAINT pk_m06_id PRIMARY KEY (m06_id)
USING INDEX
/

COMMENT ON COLUMN dfn_csm.m06_collateral_amount_type.m06_id IS 'PK'
/


