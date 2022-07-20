-- Table DFN_NTP.M74_MARGIN_INTEREST_GROUP

CREATE TABLE dfn_ntp.m74_margin_interest_group
(
    m74_id                          NUMBER (5, 0),
    m74_description                 VARCHAR2 (255),
    m74_institution_m02             NUMBER (10, 0),
    m74_additional_details          VARCHAR2 (4000),
    m74_interest_basis              NUMBER (1, 0),
    m74_capitalization_frequency    NUMBER (1, 0),
    m74_currency_id_m03             NUMBER (5, 0),
    m74_currency_code_m03           CHAR (3),
    m74_saibor_basis_group_id_m65   NUMBER (18, 0),
    m74_add_or_sub_to_saibor_rate   NUMBER (1, 0),
    m74_add_or_sub_rate             NUMBER (10, 5),
    m74_net_rate                    NUMBER (10, 5) DEFAULT 0,
    m74_flat_fee                    NUMBER (18, 5) DEFAULT 0,
    m74_created_by_id_u17           NUMBER (20, 0),
    m74_created_date                DATE,
    m74_modified_by_id_u17          NUMBER (20, 0),
    m74_modified_date               DATE,
    m74_status_id_v01               NUMBER (20, 0),
    m74_status_changed_by_id_u17    NUMBER (20, 0),
    m74_status_changed_date         DATE
)
/

-- Constraints for  DFN_NTP.M74_MARGIN_INTEREST_GROUP


  ALTER TABLE dfn_ntp.m74_margin_interest_group ADD CONSTRAINT m74_pk PRIMARY KEY (m74_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m74_margin_interest_group MODIFY (m74_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m74_margin_interest_group MODIFY (m74_description NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m74_margin_interest_group MODIFY (m74_institution_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m74_margin_interest_group MODIFY (m74_interest_basis NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m74_margin_interest_group MODIFY (m74_capitalization_frequency NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m74_margin_interest_group MODIFY (m74_currency_id_m03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m74_margin_interest_group MODIFY (m74_currency_code_m03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m74_margin_interest_group MODIFY (m74_saibor_basis_group_id_m65 NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M74_MARGIN_INTEREST_GROUP

COMMENT ON COLUMN dfn_ntp.m74_margin_interest_group.m74_id IS 'PK'
/
COMMENT ON COLUMN dfn_ntp.m74_margin_interest_group.m74_interest_basis IS
    '1 - Utilized Limit | 2 - Max Limit'
/
COMMENT ON COLUMN dfn_ntp.m74_margin_interest_group.m74_capitalization_frequency IS
    '1 - End of Month | 2 - Daily'
/
COMMENT ON COLUMN dfn_ntp.m74_margin_interest_group.m74_add_or_sub_to_saibor_rate IS
    '0 - Add | 1 - Sub'
/
-- End of DDL Script for Table DFN_NTP.M74_MARGIN_INTEREST_GROUP

alter table dfn_ntp.M74_MARGIN_INTEREST_GROUP
	add M74_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m74_margin_interest_group
 ADD (
  m74_vat_amount_m65 NUMBER (18, 5)
 )
/

ALTER TABLE dfn_ntp.m74_margin_interest_group
 DROP COLUMN m74_vat_amount_m65
/
