-- Table DFN_NTP.A12_REST_DATA

CREATE TABLE dfn_ntp.a12_rest_data
(
    a12_req_id        VARCHAR2 (100),
    a12_req_started   VARCHAR2 (200) DEFAULT NULL,
    a12_req_end       VARCHAR2 (200) DEFAULT NULL,
    a12_req_diff      VARCHAR2 (100) DEFAULT NULL
)
/

-- Constraints for  DFN_NTP.A12_REST_DATA


  ALTER TABLE dfn_ntp.a12_rest_data MODIFY (a12_req_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a12_rest_data ADD CONSTRAINT pk_a12_rest_data PRIMARY KEY (a12_req_id)
  USING INDEX  ENABLE
/



-- End of DDL Script for Table DFN_NTP.A12_REST_DATA
