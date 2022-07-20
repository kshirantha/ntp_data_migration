CREATE TABLE dfn_csm.m05_clearing_firm
(
    m05_id            NUMBER (10, 0) NOT NULL,
    m05_firm_name     NVARCHAR2 (100),
    m05_member_code   NVARCHAR2 (20)
)
SEGMENT CREATION DEFERRED
NOPARALLEL
LOGGING
MONITORING
/



ALTER TABLE dfn_csm.m05_clearing_firm
ADD CONSTRAINT pk_m05_id PRIMARY KEY (m05_id)
USING INDEX
/
