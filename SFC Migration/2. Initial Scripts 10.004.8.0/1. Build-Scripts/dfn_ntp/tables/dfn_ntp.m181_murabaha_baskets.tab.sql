CREATE TABLE dfn_ntp.m181_murabaha_baskets
(
    m181_id                         NUMBER (18, 0) NOT NULL,
    m181_basket_code                VARCHAR2 (10 BYTE) NOT NULL,
    m181_basket_name                VARCHAR2 (200 BYTE),
    m181_basket_size                NUMBER (3, 0),
    m181_upper_limit                NUMBER (20, 5),
    m181_lower_limit                NUMBER (20, 5),
    m181_in_use                     NUMBER (1, 0) DEFAULT 0,
    m181_type                       NUMBER (1, 0) DEFAULT 0,
    m181_created_by_id_u17          NUMBER (10, 0) NOT NULL,
    m181_created_date               DATE DEFAULT SYSDATE NOT NULL,
    m181_modified_by_id_u17         NUMBER (10, 0),
    m181_modified_date              DATE,
    m181_status_id_v01              NUMBER (5, 0) NOT NULL,
    m181_status_changed_by_id_u17   NUMBER (10, 0),
    m181_status_changed_date        DATE,
    m181_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1
)
/

COMMENT ON COLUMN dfn_ntp.m181_murabaha_baskets.m181_in_use IS
    '0 = NOT IN USE, 1 = IN USE'
/
COMMENT ON COLUMN dfn_ntp.m181_murabaha_baskets.m181_type IS
    '0 = FIXED, 1 = CUSTOMIZABLE'
/

ALTER TABLE dfn_ntp.m181_murabaha_baskets
 ADD (
  m181_institute_id_m02 NUMBER (3)
 )
/