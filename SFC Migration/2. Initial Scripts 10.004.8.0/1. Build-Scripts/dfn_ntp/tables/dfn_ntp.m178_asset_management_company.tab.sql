CREATE TABLE dfn_ntp.m178_asset_management_company
(
    m178_id                         NUMBER (5, 0) NOT NULL,
    m178_company_name               VARCHAR2 (75 BYTE) NOT NULL,
    m178_address                    VARCHAR2 (255 BYTE),
    m178_phone                      VARCHAR2 (30 BYTE),
    m178_fax                        VARCHAR2 (30 BYTE),
    m178_country_id_m05             NUMBER (5, 0) NOT NULL,
    m178_code                       VARCHAR2 (20 BYTE),
    m178_created_by_id_u17          NUMBER (10, 0),
    m178_created_date               DATE,
    m178_status_changed_by_id_u17   NUMBER (10, 0),
    m178_status_id_v01              NUMBER (5, 0),
    m178_status_changed_date        DATE,
    m178_modified_by_id_u17         NUMBER (10, 0),
    m178_modified_date              DATE,
    m178_custom_type                VARCHAR2 (50 BYTE),
    m178_institute_id_m02           NUMBER (3, 0)
)
/

ALTER TABLE dfn_ntp.m178_asset_management_company
    ADD CONSTRAINT m178_pk PRIMARY KEY (m178_id) USING INDEX
/

COMMENT ON TABLE dfn_ntp.m178_asset_management_company IS
    'this table keeps all the asset management companies(AMC) by country in OMS. m20 table refers this only for FUND symbols'
/
COMMENT ON COLUMN dfn_ntp.m178_asset_management_company.m178_address IS
    'address of the AMC'
/
COMMENT ON COLUMN dfn_ntp.m178_asset_management_company.m178_code IS
    'optional AMC code for external reference'
/
COMMENT ON COLUMN dfn_ntp.m178_asset_management_company.m178_company_name IS
    'company name'
/
COMMENT ON COLUMN dfn_ntp.m178_asset_management_company.m178_fax IS
    'office fax number'
/
COMMENT ON COLUMN dfn_ntp.m178_asset_management_company.m178_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.m178_asset_management_company.m178_phone IS
    'office phone number'
/