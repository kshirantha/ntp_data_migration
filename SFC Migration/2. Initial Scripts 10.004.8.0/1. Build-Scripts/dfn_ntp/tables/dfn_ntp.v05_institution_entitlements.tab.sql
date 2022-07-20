CREATE TABLE dfn_ntp.v05_institution_entitlements
(
    v05_id                   NUMBER (10, 0) NOT NULL,
    v05_institution_id_m02   NUMBER (10, 0) NOT NULL,
    v05_entitlement_id_v04   NUMBER (10, 0) NOT NULL
)
/


ALTER TABLE dfn_ntp.v05_institution_entitlements
ADD CONSTRAINT pk_v05_id PRIMARY KEY (v05_id)
USING INDEX
/