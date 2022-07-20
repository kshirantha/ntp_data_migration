CREATE TABLE dfn_ntp.m39_price_qty_factors
(
    m39_id                         NUMBER (5, 0) NOT NULL,
    m39_name                       VARCHAR2 (20 BYTE) NOT NULL,
    m39_name_lang                  VARCHAR2 (50 BYTE),
    m39_institute_id_m02           NUMBER (3, 0),
    m39_price_ratio                NUMBER (10, 5),
    m39_lot_size                   NUMBER (10, 0),
    m39_status_id_v01              NUMBER (4, 0),
    m39_created_by_id_u17          NUMBER (5, 0),
    m39_created_date               DATE,
    m39_modified_by_id_u17         NUMBER (5, 0),
    m39_modified_date              DATE,
    m39_status_changed_by_id_u17   NUMBER (5, 0),
    m39_status_changed_date        DATE,
    m39_custom_type                VARCHAR2 (50 BYTE)
)
/
ALTER TABLE dfn_ntp.m39_price_qty_factors
ADD CONSTRAINT pk_m39 PRIMARY KEY (m39_id)
USING INDEX
/

ALTER TABLE dfn_ntp.m39_price_qty_factors
 MODIFY (
  m39_name VARCHAR2 (50 BYTE)

 )
/
COMMENT ON COLUMN dfn_ntp.m39_price_qty_factors.m39_institute_id_m02 IS
    'This is Primary Institution'
/
