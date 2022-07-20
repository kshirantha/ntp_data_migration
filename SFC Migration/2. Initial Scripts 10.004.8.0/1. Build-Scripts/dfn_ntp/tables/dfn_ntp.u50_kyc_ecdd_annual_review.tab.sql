-- Table DFN_NTP.U50_KYC_ECDD_ANNUAL_REVIEW

CREATE TABLE dfn_ntp.u50_kyc_ecdd_annual_review
(
    u50_id                         NUMBER (10, 0),
    u50_customer_id_u01            NUMBER (18, 0),
    u50_client_visit_date          DATE,
    u50_cdd_medium                 NUMBER (1, 0),
    u50_cdd_date                   DATE,
    u50_next_update_due            DATE,
    u50_last_update_mub            DATE,
    u50_is_ecdd_required           NUMBER (1, 0),
    u50_is_ecdd_completed          NUMBER (1, 0),
    u50_cac_approval_date          DATE,
    u50_ecdd_staff_updating_kyc    NUMBER (10, 0) DEFAULT 0,
    u50_ecdd_staff_ext_no          VARCHAR2 (20),
    u50_call_time                  VARCHAR2 (20),
    u50_created_by_id_u17          NUMBER (10, 0),
    u50_created_date               TIMESTAMP (6),
    u50_status_id_v01              NUMBER (5, 0),
    u50_modified_by_id_u17         NUMBER (10, 0),
    u50_modified_date              TIMESTAMP (6),
    u50_status_changed_by_id_u17   NUMBER (10, 0),
    u50_status_changed_date        TIMESTAMP (6)
)
/

-- Constraints for  DFN_NTP.U50_KYC_ECDD_ANNUAL_REVIEW


  ALTER TABLE dfn_ntp.u50_kyc_ecdd_annual_review ADD CONSTRAINT pk_u50 PRIMARY KEY (u50_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.u50_kyc_ecdd_annual_review MODIFY (u50_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u50_kyc_ecdd_annual_review MODIFY (u50_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u50_kyc_ecdd_annual_review MODIFY (u50_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u50_kyc_ecdd_annual_review MODIFY (u50_status_id_v01 NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.U50_KYC_ECDD_ANNUAL_REVIEW

COMMENT ON COLUMN dfn_ntp.u50_kyc_ecdd_annual_review.u50_id IS 'u50_pk'
/
COMMENT ON COLUMN dfn_ntp.u50_kyc_ecdd_annual_review.u50_customer_id_u01 IS
    'fk from m01'
/
COMMENT ON COLUMN dfn_ntp.u50_kyc_ecdd_annual_review.u50_cdd_medium IS
    '-1=none,1=Face-to-face,2=Online'
/
COMMENT ON COLUMN dfn_ntp.u50_kyc_ecdd_annual_review.u50_is_ecdd_required IS
    '-1=none,1=No,2=Yes'
/
COMMENT ON COLUMN dfn_ntp.u50_kyc_ecdd_annual_review.u50_is_ecdd_completed IS
    '-1=none,1=No,2=Yes'
/
COMMENT ON COLUMN dfn_ntp.u50_kyc_ecdd_annual_review.u50_ecdd_staff_updating_kyc IS
    'FK From m06_ID'
/
COMMENT ON COLUMN dfn_ntp.u50_kyc_ecdd_annual_review.u50_ecdd_staff_ext_no IS
    'M06_TELEPHONE_EXT'
/
-- End of DDL Script for Table DFN_NTP.U50_KYC_ECDD_ANNUAL_REVIEW

alter table dfn_ntp.u50_kyc_ecdd_annual_review
	add U50_CUSTOM_TYPE varchar2(50) default 1
/
