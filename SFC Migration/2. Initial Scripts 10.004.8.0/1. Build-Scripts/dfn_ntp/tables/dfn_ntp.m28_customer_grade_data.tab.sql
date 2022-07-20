-- Table DFN_NTP.M28_CUSTOMER_GRADE_DATA

CREATE TABLE dfn_ntp.m28_customer_grade_data
(
    m28_id                         NUMBER (5, 0),
    m28_from_value                 NUMBER (18, 5) DEFAULT 0,
    m28_to_value                   NUMBER (18, 5) DEFAULT 0,
    m28_grade_label                VARCHAR2 (10),
    m28_institution_id_m02         NUMBER (10, 0),
    m28_version                    NUMBER (3, 0),
    m28_created_by_id_u17          NUMBER (20, 0),
    m28_created_date               TIMESTAMP (7),
    m28_modified_by_id_u17         NUMBER (20, 0),
    m28_modified_date              TIMESTAMP (7),
    m28_status_id_v01              NUMBER (20, 0),
    m28_status_changed_by_id_u17   NUMBER (20, 0),
    m28_status_changed_date        TIMESTAMP (7)
)
/

-- Constraints for  DFN_NTP.M28_CUSTOMER_GRADE_DATA


  ALTER TABLE dfn_ntp.m28_customer_grade_data ADD CONSTRAINT m28_pk PRIMARY KEY (m28_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m28_customer_grade_data MODIFY (m28_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m28_customer_grade_data MODIFY (m28_from_value NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m28_customer_grade_data MODIFY (m28_to_value NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m28_customer_grade_data MODIFY (m28_grade_label NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m28_customer_grade_data MODIFY (m28_institution_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m28_customer_grade_data MODIFY (m28_version NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m28_customer_grade_data MODIFY (m28_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m28_customer_grade_data MODIFY (m28_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m28_customer_grade_data MODIFY (m28_status_id_v01 NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M28_CUSTOMER_GRADE_DATA

COMMENT ON COLUMN dfn_ntp.m28_customer_grade_data.m28_id IS 'pk'
/
-- End of DDL Script for Table DFN_NTP.M28_CUSTOMER_GRADE_DATA

alter table dfn_ntp.M28_CUSTOMER_GRADE_DATA
	add M28_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m28_customer_grade_data
 MODIFY (
  m28_version  NULL

 )
/