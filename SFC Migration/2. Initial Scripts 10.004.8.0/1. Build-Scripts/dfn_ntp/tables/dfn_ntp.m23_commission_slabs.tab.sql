CREATE TABLE dfn_ntp.m23_commission_slabs
(
    m23_id                         NUMBER (5, 0) NOT NULL,
    m23_commission_group_id_m22    NUMBER (5, 0) NOT NULL,
    m23_from                       NUMBER (18, 5) DEFAULT 0 NOT NULL,
    m23_to                         NUMBER (18, 5) DEFAULT 0 NOT NULL,
    m23_percentage                 NUMBER (18, 5) DEFAULT 0 NOT NULL,
    m23_flat_commission            NUMBER (18, 5) DEFAULT 0 NOT NULL,
    m23_commission_type            NUMBER (2, 0) DEFAULT 0,
    m23_min_commission             NUMBER (18, 5) DEFAULT 0,
    m23_currency_code_m03          CHAR (3 BYTE),
    m23_currency_id_m03            NUMBER (5, 0),
    m23_instrument_type_v09        VARCHAR2 (4 BYTE),
    m23_exchange_txn_fee           NUMBER (18, 5) DEFAULT 0,
    m23_created_by_id_u17          NUMBER (20, 0),
    m23_created_date               DATE,
    m23_modified_by_id_u17         NUMBER (20, 0),
    m23_modified_date              DATE,
    m23_status_id_v01              NUMBER (20, 0),
    m23_status_changed_by_id_u17   NUMBER (20, 0),
    m23_status_changed_date        DATE,
    m23_instrument_type_id_v09     NUMBER (3, 0),
    m23_vat_percentage             NUMBER (18, 5) DEFAULT 0,
    m23_vat_charge_type_m124       NUMBER (10, 0),
    m23_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.m23_commission_slabs
ADD CONSTRAINT m23_pk PRIMARY KEY (m23_id)
USING INDEX
/


COMMENT ON TABLE dfn_ntp.m23_commission_slabs IS
    'This table holds all the commission structure definisions for each commissiongroup defined in m22_commission_group table.
Commision group may have one or more commission structures depending on how the ranges are defined for order values.'
/
COMMENT ON COLUMN dfn_ntp.m23_commission_slabs.m23_commission_group_id_m22 IS
    'Foreign key from M22'
/
COMMENT ON COLUMN dfn_ntp.m23_commission_slabs.m23_commission_type IS
    '1 - By Order Value | 2 - By Order Volumne | 3 - By Symbol Volume | 5 - By Share Price | 6 - By Execution'
/
COMMENT ON COLUMN dfn_ntp.m23_commission_slabs.m23_flat_commission IS
    'Flat commission'
/
COMMENT ON COLUMN dfn_ntp.m23_commission_slabs.m23_from IS
    'Range start order value'
/
COMMENT ON COLUMN dfn_ntp.m23_commission_slabs.m23_id IS
    'primary key of the commission structure'
/
COMMENT ON COLUMN dfn_ntp.m23_commission_slabs.m23_instrument_type_v09 IS
    'FK FROM V09'
/
COMMENT ON COLUMN dfn_ntp.m23_commission_slabs.m23_percentage IS
    '% of commission'
/
COMMENT ON COLUMN dfn_ntp.m23_commission_slabs.m23_to IS
    'Range end order value'
/