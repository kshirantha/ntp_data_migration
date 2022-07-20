CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_employee_trading_groups
(
    m51_id,
    m51_trading_group_id_m08,
    m08_name,
    m51_employee_id_u17,
    m51_assigned_date,
    m51_assigned_by_u17,
    m08_institute_id_m02
)
AS
    SELECT a.m51_id,
           a.m51_trading_group_id_m08,
           m08.m08_name,
           a.m51_employee_id_u17,
           a.m51_assigned_date,
           a.m51_assigned_by_u17,
           m08.m08_institute_id_m02
      FROM     m51_employee_trading_groups a
           LEFT JOIN
               m08_trading_group m08
           ON a.m51_trading_group_id_m08 = m08.m08_id
/
