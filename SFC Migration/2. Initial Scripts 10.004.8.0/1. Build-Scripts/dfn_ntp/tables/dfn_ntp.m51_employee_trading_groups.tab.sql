-- Table DFN_NTP.M51_EMPLOYEE_TRADING_GROUPS

CREATE TABLE dfn_ntp.m51_employee_trading_groups
(
    m51_id                     NUMBER (10, 0),
    m51_trading_group_id_m08   NUMBER (10, 0),
    m51_employee_id_u17        NUMBER (18, 0),
    m51_assigned_date          DATE,
    m51_assigned_by_u17        NUMBER (10, 0)
)
/



-- End of DDL Script for Table DFN_NTP.M51_EMPLOYEE_TRADING_GROUPS

alter table dfn_ntp.M51_EMPLOYEE_TRADING_GROUPS
	add M51_CUSTOM_TYPE varchar2(50) default 1
/

CREATE INDEX dfn_ntp.idx_m51_employee_id_u17
    ON dfn_ntp.m51_employee_trading_groups (m51_employee_id_u17)
/

CREATE INDEX dfn_ntp.idx_m51_trading_group_id_m08
    ON dfn_ntp.m51_employee_trading_groups (m51_trading_group_id_m08)
/
