-- Table DFN_NTP.M65_SAIBOR_BASIS_RATES

CREATE TABLE dfn_ntp.m65_saibor_basis_rates
(
    m65_id                         NUMBER (18, 0),
    m65_description                VARCHAR2 (255),
    m65_type                       NUMBER (1, 0),
    m65_duration_id_m64            NUMBER (18, 0),
    m65_rate                       NUMBER (18, 5),
    m65_institution_id_m02         NUMBER (18, 0),
    m65_status_id_v01              NUMBER (18, 0),
    m65_status_changed_by_id_u17   NUMBER (18, 0),
    m65_status_changed_date        DATE,
    m65_created_by_id_u17          NUMBER (18, 0),
    m65_created_date               DATE,
    m65_modified_by_id_u17         NUMBER (18, 0),
    m65_modified_date              DATE
)
/

-- Constraints for  DFN_NTP.M65_SAIBOR_BASIS_RATES


  ALTER TABLE dfn_ntp.m65_saibor_basis_rates ADD CONSTRAINT m65_pk PRIMARY KEY (m65_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m65_saibor_basis_rates MODIFY (m65_id NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M65_SAIBOR_BASIS_RATES

COMMENT ON COLUMN dfn_ntp.m65_saibor_basis_rates.m65_description IS
    'Name of the Group'
/
COMMENT ON COLUMN dfn_ntp.m65_saibor_basis_rates.m65_type IS
    '0-SAIBOR, 1-BASIS'
/
COMMENT ON COLUMN dfn_ntp.m65_saibor_basis_rates.m65_duration_id_m64 IS
    'FK from M64'
/
COMMENT ON COLUMN dfn_ntp.m65_saibor_basis_rates.m65_institution_id_m02 IS
    'fkm02'
/
COMMENT ON COLUMN dfn_ntp.m65_saibor_basis_rates.m65_status_id_v01 IS 'fkm64'
/
COMMENT ON COLUMN dfn_ntp.m65_saibor_basis_rates.m65_status_changed_by_id_u17 IS
    'fkm06'
/
COMMENT ON COLUMN dfn_ntp.m65_saibor_basis_rates.m65_created_by_id_u17 IS
    'fku17'
/
COMMENT ON COLUMN dfn_ntp.m65_saibor_basis_rates.m65_modified_date IS 'fkm06'
/
-- End of DDL Script for Table DFN_NTP.M65_SAIBOR_BASIS_RATES

alter table dfn_ntp.M65_SAIBOR_BASIS_RATES
	add M65_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m65_saibor_basis_rates
 ADD (
  m65_tax NUMBER (18, 5)
 )
/

ALTER TABLE dfn_ntp.M65_SAIBOR_BASIS_RATES 
 MODIFY (
  M65_TYPE NUMBER (10, 0)

 )
/
COMMENT ON COLUMN dfn_ntp.M65_SAIBOR_BASIS_RATES.M65_TYPE IS '1-SAIBOR, 2-BASIS, 3-SIBOR, 4-LIBOR'
/



