CREATE TABLE dfn_ntp.u01_customer
(
    u01_id                           NUMBER (10, 0) NOT NULL,
    u01_customer_no                  VARCHAR2 (10 BYTE) NOT NULL,
    u01_institute_id_m02             NUMBER (3, 0) NOT NULL,
    u01_account_category_id_v01      NUMBER (1, 0),
    u01_first_name                   VARCHAR2 (100 BYTE) DEFAULT NULL NOT NULL,
    u01_first_name_lang              VARCHAR2 (100 BYTE) DEFAULT NULL NOT NULL,
    u01_second_name                  VARCHAR2 (100 BYTE) DEFAULT NULL,
    u01_second_name_lang             VARCHAR2 (100 BYTE) DEFAULT NULL,
    u01_third_name                   VARCHAR2 (100 BYTE),
    u01_third_name_lang              VARCHAR2 (100 BYTE),
    u01_last_name                    VARCHAR2 (100 BYTE) DEFAULT NULL,
    u01_last_name_lang               VARCHAR2 (100 BYTE) DEFAULT NULL,
    u01_display_name                 VARCHAR2 (1000 BYTE),
    u01_display_name_lang            VARCHAR2 (1000 BYTE),
    u01_gender                       CHAR (1 BYTE),
    u01_title_id_v01                 NUMBER (5, 0),
    u01_marital_status_id_v01        NUMBER (5, 0),
    u01_date_of_birth                DATE,
    u01_birth_country_id_m05         NUMBER (5, 0),
    u01_birth_city_id_m06            NUMBER (5, 0),
    u01_default_id_no                VARCHAR2 (20 BYTE),
    u01_default_id_type_m15          NUMBER (5, 0),
    u01_preferred_lang_id_v01        NUMBER (5, 0) DEFAULT 1 NOT NULL,
    u01_is_ipo_customer              NUMBER (1, 0) NOT NULL,
    u01_is_black_listed              NUMBER (1, 0) NOT NULL,
    u01_created_by_id_u17            NUMBER (10, 0) NOT NULL,
    u01_created_date                 DATE NOT NULL,
    u01_status_id_v01                NUMBER (5, 0) NOT NULL,
    u01_signup_location_id_m07       NUMBER (5, 0),
    u01_service_location_id_m07      NUMBER (5, 0),
    u01_relationship_mngr_id_m10     NUMBER (5, 0),
    u01_grade                        CHAR (1 BYTE),
    u01_black_listed_reason          VARCHAR2 (200 BYTE),
    u01_identification_code          VARCHAR2 (10 BYTE),
    u01_modified_by_id_u17           NUMBER (10, 0),
    u01_modified_date                DATE,
    u01_status_changed_by_id_u17     NUMBER (10, 0),
    u01_status_changed_date          DATE,
    u01_nationality_id_m05           NUMBER (5, 0),
    u01_trading_enabled              NUMBER (1, 0),
    u01_online_trading_enabled       NUMBER (1, 0),
    u01_preferred_name               VARCHAR2 (255 BYTE),
    u01_preferred_name_lang          VARCHAR2 (255 BYTE),
    u01_full_name                    VARCHAR2 (1000 BYTE),
    u01_full_name_lang               VARCHAR2 (1000 BYTE),
    u01_external_ref_no              VARCHAR2 (15 BYTE) DEFAULT NULL,
    u01_account_type_id_v01          NUMBER (1, 0),
    u01_master_account_id_u01        NUMBER (10, 0),
    u01_corp_client_type_id_v01      NUMBER (1, 0),
    u01_corp_license_renewal_date    DATE,
    u01_corp_license                 VARCHAR2 (50 BYTE),
    u01_corp_name_address_of_group   VARCHAR2 (50 BYTE),
    u01_corp_type_of_business        VARCHAR2 (100 BYTE),
    u01_corp_date_incorporation      DATE,
    u01_corp_country_id_m05          NUMBER (5, 0),
    u01_corp_annual_turnover         NUMBER (18, 5),
    u01_corp_region_id_m90           NUMBER (5, 0),
    u01_corp_no_of_employees         NUMBER (5, 0),
    u01_corp_regulatory_body         VARCHAR2 (50 BYTE),
    u01_corp_paid_up_capital         NUMBER (18, 5),
    u01_corp_legal_form              VARCHAR2 (50 BYTE),
    u01_corp_general_partner         VARCHAR2 (50 BYTE),
    u01_corp_investors               VARCHAR2 (50 BYTE),
    u01_minor_account                NUMBER (1, 0) DEFAULT 0,
    u01_poa_available                NUMBER (1, 0) DEFAULT 0,
    u01_guardian_relationship_v01    NUMBER (3, 0),
    u01_guardian_id_u01              NUMBER (10, 0),
    u01_signup_date                  DATE,
    u01_is_qualified_investor        NUMBER (1, 0) DEFAULT 0,
    u01_vat_waive_off                NUMBER (1, 0) DEFAULT 0,
    u01_tax_ref                      VARCHAR2 (50 BYTE),
    u01_custom_type                  VARCHAR2 (50 BYTE),
    u01_status_changed_reason        VARCHAR2 (255 BYTE),
    u01_swap_master                  NUMBER (1, 0) DEFAULT 0,
    u01_ib_id_m21                    NUMBER (10, 0),
    u01_subfee_waiveoff_grp_id       NUMBER (5, 0),
    PRIMARY KEY (u01_id)
)
ORGANIZATION INDEX
NOCOMPRESS
OVERFLOW
/



CREATE INDEX dfn_ntp.u01_u01_default_id_no
    ON dfn_ntp.u01_customer (u01_default_id_no ASC)
    NOPARALLEL
    LOGGING
/


ALTER TABLE dfn_ntp.u01_customer
ADD UNIQUE (u01_customer_no)
USING INDEX
/



COMMENT ON COLUMN dfn_ntp.u01_customer.u01_account_category_id_v01 IS
    '1- Individual | 2-Corporate (V01 TYPE = 16)'
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_account_type_id_v01 IS
    '1 - Master Account | 2 - Sub Account (V01_TYPE = 58)'
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_corp_client_type_id_v01 IS
    '1 - Company
2 - Government
3 - Institution'
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_custom_type IS
    'to support customization'
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_guardian_relationship_v01 IS
    'fkv01-54'
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_minor_account IS
    '1= minor account, 0= adult account'
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_poa_available IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_preferred_lang_id_v01 IS
    'V01_TYPE = 14'
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_status_changed_reason IS
    'suspend restore reason'
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_swap_master IS '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_vat_waive_off IS
    '0 - No | 1 - Yes'
/

ALTER TABLE dfn_ntp.u01_customer
 MODIFY (
  u01_first_name VARCHAR2 (255 BYTE),
  u01_first_name_lang VARCHAR2 (255 BYTE),
  u01_second_name VARCHAR2 (255 BYTE),
  u01_second_name_lang VARCHAR2 (255 BYTE),
  u01_third_name VARCHAR2 (255 BYTE),
  u01_third_name_lang VARCHAR2 (255 BYTE),
  u01_last_name VARCHAR2 (255 BYTE),
  u01_last_name_lang VARCHAR2 (255 BYTE),
  u01_preferred_name VARCHAR2 (1000 BYTE),
  u01_preferred_name_lang VARCHAR2 (1000 BYTE)

 )
/

ALTER TABLE dfn_ntp.u01_customer
 ADD (
  u01_direct_dealing_enabled NUMBER (1),
  u01_dd_from_date DATE,
  u01_dd_to_date DATE
 )
/

ALTER TABLE dfn_ntp.u01_customer
 MODIFY (
  u01_direct_dealing_enabled DEFAULT 0
 )
/

COMMENT ON COLUMN dfn_ntp.u01_customer.u01_direct_dealing_enabled IS
    '0 - No | 1 - Yes'
/


ALTER TABLE dfn_ntp.u01_customer
 ADD (
  u01_referral_cash_acc_id_u06 NUMBER (20),
  u01_incentive_group_id_m162 NUMBER (20)
 )
/


ALTER TABLE dfn_ntp.u01_customer
 ADD (
  u01_tila_enable NUMBER (5) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_tila_enable IS '0 - No | 1 - Yes'
/

ALTER TABLE dfn_ntp.u01_customer
 ADD (
  u01_is_institutional_client NUMBER (1) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_is_institutional_client IS
    '0 - No | 1 - Yes'
/

ALTER TABLE dfn_ntp.u01_customer
 ADD (
  u01_def_mobile VARCHAR2 (35 BYTE),
  u01_def_email VARCHAR2 (100 BYTE)
 )
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_def_mobile IS
    'U02_MOBILE in default contact'
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_def_email IS
    'U02_EMAIL in default contact'
/

ALTER TABLE dfn_ntp.U01_CUSTOMER
 ADD (
  U01_AGENT_TYPE NUMBER (1, 0) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.U01_CUSTOMER.U01_AGENT_TYPE IS '0 - Default (Empty) | 1 - Brokerage | 2 - Other'
/

ALTER TABLE dfn_ntp.U01_CUSTOMER
 ADD (
  U01_AGENT_CODE VARCHAR2 (100 BYTE)
 )
/

ALTER TABLE dfn_ntp.U01_CUSTOMER 
 ADD (
  U01_DD_REFERENCE_NO VARCHAR2 (10 BYTE)
 )
/
COMMENT ON COLUMN dfn_ntp.U01_CUSTOMER.U01_DD_REFERENCE_NO IS 'direct dealing reference no'
/

ALTER TABLE dfn_ntp.u01_customer
 MODIFY (
  u01_customer_no VARCHAR2 (25 BYTE),
  u01_external_ref_no VARCHAR2 (25 BYTE)

 )
/

ALTER TABLE dfn_ntp.u01_customer
 ADD (
  U01_IS_STAFF_B NUMBER (1) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_is_staff_b IS '0 - No | 1 - Yes'
/

ALTER TABLE dfn_ntp.u01_customer
 MODIFY (
  u01_external_ref_no VARCHAR2 (50 BYTE),
  u01_customer_no VARCHAR2 (50 BYTE)

 )
/

ALTER TABLE dfn_ntp.u01_customer
 ADD (
  u01_investor_id VARCHAR2 (75)
 )
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_investor_id IS
    'Customer exchange reference'
/

ALTER TABLE dfn_ntp.u01_customer
 MODIFY (
  u01_first_name NULL,
  u01_first_name_lang NULL
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE dfn_ntp.u01_customer
 ADD (
  u01_kyc_next_review DATE
 )
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('u01_customer')
           AND column_name = UPPER ('u01_kyc_next_review');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


ALTER TABLE DFN_NTP.U01_CUSTOMER 
 ADD (
  U01_BLOCK_STATUS_B NUMBER (1) DEFAULT 1
 )
/
COMMENT ON COLUMN DFN_NTP.U01_CUSTOMER.U01_BLOCK_STATUS_B IS '1 - Open, 2 - Debit Block, 3 - Close, 4 - Full Block, Null Consider As Debit Block'
/

ALTER TABLE dfn_ntp.u01_customer
 ADD (
  u01_category_m89 NUMBER (5)
 )
/

COMMENT ON COLUMN dfn_ntp.u01_customer.u01_category_m89 IS 'fk m89_id'
/



ALTER TABLE dfn_ntp.u01_customer
 ADD (
  u01_customer_type_b VARCHAR2 (10),
  u01_customer_sub_type_b VARCHAR2 (10)
 )
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_customer_type_b IS 'v01-1001'
/
COMMENT ON COLUMN dfn_ntp.u01_customer.u01_customer_sub_type_b IS 'v01-1002'
/

ALTER TABLE dfn_ntp.U01_CUSTOMER 
 ADD (
  U01_IS_STAFF_MEMBER NUMBER (1) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.U01_CUSTOMER.U01_IS_STAFF_MEMBER IS '0- No | 1- YES'
/

ALTER TABLE dfn_ntp.u01_customer
 MODIFY (
  u01_category_m89 DEFAULT 0
 )
/

COMMENT ON COLUMN dfn_ntp.u01_customer.u01_category_m89 IS
    'fk m89_id | 0 - Default | 1 - Staff'
/

ALTER TABLE dfn_ntp.u01_customer
RENAME COLUMN u01_category_m89 TO u01_category_v01
/

COMMENT ON COLUMN dfn_ntp.u01_customer.u01_category_v01 IS
    'v01_type = 86 | 0 - Default | 1 - Staff'
/

ALTER TABLE dfn_ntp.U01_CUSTOMER 
 ADD (
  U01_BATCH_ID_T80 NUMBER (20)
 )
/
COMMENT ON COLUMN dfn_ntp.U01_CUSTOMER.U01_BATCH_ID_T80 IS 'This Coloumn anly for Automated File processing reference'
/
