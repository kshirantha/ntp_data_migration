CREATE TABLE dfn_ntp.m126_rules
(
    m126_rule_type_id           NUMBER (3, 0),
    m126_rule_key               VARCHAR2 (100 BYTE),
    m126_rule                   VARCHAR2 (2000 BYTE),
    m126_passed_msg             VARCHAR2 (200 BYTE),
    m126_failed_msg             VARCHAR2 (200 BYTE),
    m126_primary_institute_id   NUMBER (3, 0) DEFAULT 1
)
/