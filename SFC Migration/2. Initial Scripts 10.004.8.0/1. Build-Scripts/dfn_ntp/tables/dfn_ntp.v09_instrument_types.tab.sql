CREATE TABLE dfn_ntp.v09_instrument_types
(
    v09_code                       VARCHAR2 (4 BYTE) NOT NULL,
    v09_description                VARCHAR2 (75 BYTE) NOT NULL,
    v09_created_by_id_m17          NUMBER (20, 0),
    v09_created_date               DATE,
    v09_modified_by_id_m17         NUMBER (20, 0),
    v09_modified_date              DATE,
    v09_status_id_v01              NUMBER (20, 0),
    v09_status_changed_by_id_u17   NUMBER (20, 0),
    v09_status_changed_date        DATE,
    v09_margin_enable              NUMBER (1, 0) DEFAULT 0,
    v09_default_price_qty_type     NUMBER (1, 0) DEFAULT 1,
    v09_lot_size                   NUMBER (5, 0) DEFAULT 1,
    v09_price_factor               NUMBER (10, 5) DEFAULT 1,
    v09_id                         NUMBER (3, 0)
)
/

ALTER TABLE dfn_ntp.v09_instrument_types
ADD CONSTRAINT v09_pk PRIMARY KEY (v09_code)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.v09_instrument_types.v09_code IS 'PK'
/
COMMENT ON COLUMN dfn_ntp.v09_instrument_types.v09_default_price_qty_type IS
    '0 - Price | 1 - Quantity'
/
COMMENT ON COLUMN dfn_ntp.v09_instrument_types.v09_description IS
    'description of instrument_types'
/
COMMENT ON COLUMN dfn_ntp.v09_instrument_types.v09_lot_size IS
    'Default Lot Size of the Symbol'
/
COMMENT ON COLUMN dfn_ntp.v09_instrument_types.v09_margin_enable IS
    '1 - Enable | 0 - Disable'
/
COMMENT ON COLUMN dfn_ntp.v09_instrument_types.v09_price_factor IS
    'Default Price Factor of the Symbol'
/