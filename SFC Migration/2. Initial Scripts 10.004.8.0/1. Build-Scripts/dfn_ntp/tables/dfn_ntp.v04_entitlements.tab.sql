CREATE TABLE dfn_ntp.v04_entitlements
(
    v04_id                        NUMBER (10, 0) NOT NULL,
    v04_task_name                 VARCHAR2 (200 BYTE) NOT NULL,
    v04_enabled                   NUMBER (1, 0) DEFAULT 1,
    v04_entitlement_type_id_v03   NUMBER (10, 0),
    v04_sensitive_level_id_v02    NUMBER (3, 0)
)
/

ALTER TABLE dfn_ntp.v04_entitlements
ADD CONSTRAINT v04_pk PRIMARY KEY (v04_id)
USING INDEX
/

ALTER TABLE dfn_ntp.v04_entitlements
ADD CONSTRAINT v04_task_name_uk UNIQUE (v04_task_name)
USING INDEX
/

COMMENT ON TABLE dfn_ntp.v04_entitlements IS
    'this table keeps all the entitlements of AURA.'
/