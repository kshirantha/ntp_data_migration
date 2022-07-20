-- Table DFN_NTP.M50_EMPLOYEE_TRD_LIMITS

CREATE TABLE dfn_ntp.m50_employee_trd_limits
(
    m50_employee_id_u17             NUMBER (10, 0),
    m50_approvable_order_limit      NUMBER (18, 8),
    m50_approvable_overdraw_limit   NUMBER (18, 8),
    m50_bp_exceed_limit             NUMBER (18, 8),
    m50_breach_coverage_ratio       NUMBER (18, 8),
    m50_default_currency_code_m03   VARCHAR2 (255),
    m50_last_updated_by_id_u17      NUMBER (10, 0),
    m50_last_updated_date           DATE,
    m50_max_order_value             NUMBER (18, 8),
    m50_price_tolerence             NUMBER (18, 8),
    m50_default_currency_id_m03     NUMBER (5, 0),
    m50_status_id_v01               NUMBER (5, 0),
    m50_status_changed_by_id_u17    NUMBER (10, 0),
    m50_status_changed_date         DATE,
    m50_id                          NUMBER (18, 0)
)
/

-- Constraints for  DFN_NTP.M50_EMPLOYEE_TRD_LIMITS


  ALTER TABLE dfn_ntp.m50_employee_trd_limits ADD CONSTRAINT m50_id_pk PRIMARY KEY (m50_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m50_employee_trd_limits MODIFY (m50_employee_id_u17 NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M50_EMPLOYEE_TRD_LIMITS

COMMENT ON COLUMN dfn_ntp.m50_employee_trd_limits.m50_default_currency_id_m03 IS
    ''
/
-- End of DDL Script for Table DFN_NTP.M50_EMPLOYEE_TRD_LIMITS

ALTER TABLE dfn_ntp.m50_employee_trd_limits 
 MODIFY (
  m50_approvable_order_limit DEFAULT 0,
  m50_approvable_overdraw_limit DEFAULT 0,
  m50_bp_exceed_limit DEFAULT 0,
  m50_max_order_value DEFAULT 0

 )
/

alter table dfn_ntp.M50_EMPLOYEE_TRD_LIMITS
	add M50_CUSTOM_TYPE varchar2(50) default 1
/


ALTER TABLE dfn_ntp.m50_employee_trd_limits
 ADD (
  m50_order_value_per_day NUMBER (21, 8),
  m50_order_volume_per_day  NUMBER (21, 8)
 )
/

ALTER TABLE dfn_ntp.m50_employee_trd_limits
 MODIFY (
  m50_approvable_order_limit NUMBER (20, 8) DEFAULT 0,
  m50_approvable_overdraw_limit NUMBER (20, 8) DEFAULT 0

 )
/