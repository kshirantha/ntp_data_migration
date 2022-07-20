-- Table DFN_NTP.A11_LOG_DATA

CREATE TABLE dfn_ntp.a11_log_data
(
    a11_id             NUMBER,
    a11_log_type       NUMBER,
    a11_user_id_u17    NUMBER,
    a11_message        VARCHAR2 (4000),
    a11_created_date   DATE
)
/

-- Constraints for  DFN_NTP.A11_LOG_DATA


  ALTER TABLE dfn_ntp.a11_log_data ADD CONSTRAINT a11_log_data_pk PRIMARY KEY (a11_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.a11_log_data MODIFY (a11_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a11_log_data MODIFY (a11_log_type NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.A11_LOG_DATA
ALTER TABLE dfn_ntp.a11_log_data
 MODIFY (
  a11_id NUMBER (18),
  a11_log_type NUMBER (5),
  a11_user_id_u17 NUMBER (5)

 )
/

alter table dfn_ntp.A11_LOG_DATA
	add A11_CUSTOM_TYPE varchar2(50) default 1
/