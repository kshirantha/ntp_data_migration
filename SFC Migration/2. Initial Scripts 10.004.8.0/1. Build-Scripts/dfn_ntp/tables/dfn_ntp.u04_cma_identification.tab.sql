-- Table DFN_NTP.U04_CMA_IDENTIFICATION

CREATE TABLE dfn_ntp.u04_cma_identification
(
    u04_id                         NUMBER (5, 0),
    u04_identity_type_id_m15       NUMBER (5, 0),
    u04_customer_kyc_id_u03        NUMBER (10, 0),
    u04_id_no                      VARCHAR2 (20),
    u04_issue_date                 DATE,
    u04_issue_location_id_m14      NUMBER (5, 0),
    u04_expiry_date                DATE,
    u04_is_default                 NUMBER (1, 0),
    u04_person_type                NUMBER (2, 0),
    u04_created_by_id_u17          NUMBER (10, 0),
    u04_created_date               TIMESTAMP (6),
    u04_status_id_v01              NUMBER (5, 0),
    u04_modified_by_id_u17         NUMBER (10, 0),
    u04_modified_date              TIMESTAMP (6),
    u04_status_changed_by_id_u17   NUMBER (10, 0),
    u04_status_changed_date        TIMESTAMP (6),
    u04_customer_id_u01            NUMBER (5, 0),
    u04_custom_type                VARCHAR2 (20),
    PRIMARY KEY (u04_id) ENABLE
)
ORGANIZATION INDEX
NOCOMPRESS
/

-- Constraints for  DFN_NTP.U04_CMA_IDENTIFICATION


  ALTER TABLE dfn_ntp.u04_cma_identification MODIFY (u04_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u04_cma_identification MODIFY (u04_identity_type_id_m15 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u04_cma_identification MODIFY (u04_customer_kyc_id_u03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u04_cma_identification MODIFY (u04_id_no NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u04_cma_identification MODIFY (u04_issue_location_id_m14 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u04_cma_identification MODIFY (u04_person_type NOT NULL ENABLE)
/

-- Indexes for  DFN_NTP.U04_CMA_IDENTIFICATION


CREATE INDEX dfn_ntp.u04_u04_u01_id
    ON dfn_ntp.u04_cma_identification (u04_customer_kyc_id_u03)
/

CREATE INDEX dfn_ntp.u04_u04_id_no
    ON dfn_ntp.u04_cma_identification (u04_id_no)
/

-- Comments for  DFN_NTP.U04_CMA_IDENTIFICATION

COMMENT ON COLUMN dfn_ntp.u04_cma_identification.u04_custom_type IS
    'To support customization'
/
-- End of DDL Script for Table DFN_NTP.U04_CMA_IDENTIFICATION
