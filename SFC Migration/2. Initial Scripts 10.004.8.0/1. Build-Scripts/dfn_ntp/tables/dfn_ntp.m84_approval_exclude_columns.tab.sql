-- Table DFN_NTP.M84_APPROVAL_EXCLUDE_COLUMNS

CREATE TABLE dfn_ntp.m84_approval_exclude_columns
(
    m84_id              NUMBER (5, 0),
    m84_table_id_m53    NUMBER (5, 0),
    m84_column_name     VARCHAR2 (50),
    m84_column_id_m85   NUMBER (5, 0)
)
/



-- End of DDL Script for Table DFN_NTP.M84_APPROVAL_EXCLUDE_COLUMNS

alter table dfn_ntp.M84_APPROVAL_EXCLUDE_COLUMNS
	add M84_Custom_Type varchar2(50) default 1
/
