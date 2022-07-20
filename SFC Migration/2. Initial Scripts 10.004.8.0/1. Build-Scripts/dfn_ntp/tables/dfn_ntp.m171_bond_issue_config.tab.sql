CREATE TABLE dfn_ntp.m171_bond_issue_config
(
    m171_id                         NUMBER (10, 0),
    m171_name                       VARCHAR2 (50 BYTE),
    m171_otc_trad_instrument_m168   NUMBER (10, 0),
    m171_issue_date                 DATE,
    m171_maturity_date              DATE,
    m171_bond_type_v01              NUMBER (10, 0),
    m171_nominal_value              NUMBER (10, 0),
    m171_discount_or_premium_pct    NUMBER (8, 5),
    m171_discount_or_premium_amnt   NUMBER (18, 5),
    m171_principal_amount           NUMBER (18, 5),
    m171_issue_quantity             NUMBER (10, 0),
    m171_no_of_payments_v01         NUMBER (10, 0),
    m171_interest_rate_type_v01     NUMBER (10, 0),
    m171_interest_rate              NUMBER (10, 5),
    m171_interest_day_basis_v01     NUMBER (10, 0),
    m171_institute_id_m02           NUMBER (10, 0),
    m171_status_id_v01              NUMBER (15, 0),
    m171_created_by_id_u17          NUMBER (20, 0),
    m171_created_date               DATE,
    m171_modified_by_id_u17         NUMBER (20, 0),
    m171_modified_date              DATE,
    m171_status_changed_by_id_u17   NUMBER (20, 0),
    m171_status_changed_date        DATE,
    m171_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1
)
/



ALTER TABLE dfn_ntp.m171_bond_issue_config
    ADD CONSTRAINT pk_m171 PRIMARY KEY (m171_id) USING INDEX
/