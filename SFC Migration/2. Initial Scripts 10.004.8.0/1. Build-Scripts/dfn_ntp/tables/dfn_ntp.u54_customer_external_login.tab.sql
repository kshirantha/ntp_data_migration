-- Table DFN_NTP.U54_CUSTOMER_EXTERNAL_LOGIN

CREATE TABLE dfn_ntp.u54_customer_external_login
(
    u54_id                      NUMBER (10, 0),
    u54_customer_id_u01         NUMBER (10, 0),
    u54_external_id_v29         NUMBER (2, 0),
    u54_identification_number   VARCHAR2 (30),
    u54_pin                     VARCHAR2 (100),
    u54_failed_attempts         NUMBER (3, 0),
    u54_status_id_v01           NUMBER (1, 0),
    u54_is_first_time           NUMBER (1, 0),
    u54_last_login_date         TIMESTAMP (6),
    u54_pin_last_updated_date   TIMESTAMP (6),
    u54_modified_by_id_u17      NUMBER (10, 0),
    u54_modified_date           TIMESTAMP (6),
    u54_history_pins            VARCHAR2 (4000)
)
/

-- Constraints for  DFN_NTP.U54_CUSTOMER_EXTERNAL_LOGIN


  ALTER TABLE dfn_ntp.u54_customer_external_login MODIFY (u54_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u54_customer_external_login MODIFY (u54_customer_id_u01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u54_customer_external_login MODIFY (u54_external_id_v29 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u54_customer_external_login MODIFY (u54_identification_number NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u54_customer_external_login MODIFY (u54_pin NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u54_customer_external_login MODIFY (u54_failed_attempts NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u54_customer_external_login MODIFY (u54_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u54_customer_external_login MODIFY (u54_is_first_time NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u54_customer_external_login ADD CONSTRAINT pk_u54_cust_external_login PRIMARY KEY (u54_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.u54_customer_external_login ADD CONSTRAINT uk_u54_identification_number UNIQUE (u54_identification_number)
  USING INDEX  ENABLE
/

-- Indexes for  DFN_NTP.U54_CUSTOMER_EXTERNAL_LOGIN


CREATE INDEX dfn_ntp.u54_u54_u01_id
    ON dfn_ntp.u54_customer_external_login (u54_customer_id_u01)
/


-- End of DDL Script for Table DFN_NTP.U54_CUSTOMER_EXTERNAL_LOGIN
