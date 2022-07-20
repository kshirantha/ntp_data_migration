CREATE TABLE dfn_ntp.m172_bond_issue_term_structure
(
    m172_id                          NUMBER (10, 0),
    m172_bond_issue_config_id_m171   NUMBER (10, 0),
    m172_coupon_no                   VARCHAR2 (100 BYTE),
    m172_coupon_start_date           DATE,
    m172_no_of_days                  NUMBER (10, 0),
    m172_end_date                    DATE,
    m172_principal_amount            NUMBER (18, 5),
    m172_interest_pct                NUMBER (8, 5),
    m172_daily_interest_amnt         NUMBER (18, 5),
    m172_interest_amount             NUMBER (18, 5),
    m172_principal_redemption        NUMBER (18, 5),
    m172_remaining_principal         NUMBER (18, 5),
    m172_institute_id_m02            NUMBER (10, 0),
    m172_status_id_v01               NUMBER (15, 0),
    m172_created_by_id_u17           NUMBER (20, 0),
    m172_created_date                DATE,
    m172_modified_by_id_u17          NUMBER (20, 0),
    m172_modified_date               DATE,
    m172_status_changed_by_id_u17    NUMBER (20, 0),
    m172_status_changed_date         DATE,
    m172_custom_type                 VARCHAR2 (50 BYTE) DEFAULT 1
)
/



ALTER TABLE dfn_ntp.m172_bond_issue_term_structure
    ADD CONSTRAINT pk_m172 PRIMARY KEY (m172_id) USING INDEX
/