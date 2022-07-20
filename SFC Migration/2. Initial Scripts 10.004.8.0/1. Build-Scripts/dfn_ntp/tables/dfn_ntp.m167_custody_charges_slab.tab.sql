CREATE TABLE dfn_ntp.m167_custody_charges_slab
(
    m167_id                         NUMBER (18, 0) NOT NULL,
    m167_custody_group_id_m166      NUMBER (18, 0),
    m167_instrument_type_code_v09   VARCHAR2 (4 BYTE),
    m167_from                       NUMBER (20, 0),
    m167_to                         NUMBER (20, 0),
    m167_per_share_charge           NUMBER (18, 5),
    m167_fixed_charge               NUMBER (18, 5),
    m167_currency_id_m03            NUMBER (18, 0),
    m167_currency_code_m03          CHAR (3 BYTE),
    m167_created_by_id_u17          NUMBER (20, 0),
    m167_created_date               DATE,
    m167_modified_by_id_u17         NUMBER (20, 0),
    m167_modified_date              DATE,
    m167_status_id_v01              NUMBER (20, 0),
    m167_status_changed_by_id_u17   NUMBER (20, 0),
    m167_status_changed_date        DATE,
    m167_custom_type                VARCHAR2 (50 BYTE)
)
/

COMMENT ON COLUMN dfn_ntp.m167_custody_charges_slab.m167_custody_group_id_m166 IS
    'FK from M166'
/
COMMENT ON COLUMN dfn_ntp.m167_custody_charges_slab.m167_id IS 'PK'
/

ALTER TABLE dfn_ntp.M167_CUSTODY_CHARGES_SLAB 
 MODIFY (
  M167_INSTRUMENT_TYPE_CODE_V09 VARCHAR2 (50 BYTE)

 )
/
