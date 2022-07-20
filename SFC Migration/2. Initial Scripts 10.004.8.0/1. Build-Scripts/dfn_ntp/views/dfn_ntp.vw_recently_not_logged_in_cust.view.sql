CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_recently_not_logged_in_cust
(
    u01_id,
    u09_id,
    u09_login_name,
    u01_full_name,
    u09_last_login_date,
    u01_institute_id_m02,
    m02_account_suspension_period,
    diff
)
AS
    SELECT u01.u01_id,
           u09.u09_id,
           u09.u09_login_name,
           u01.u01_full_name,
           u09.u09_last_login_date,
           u01.u01_institute_id_m02,
           m02.m02_account_suspension_period,
           TRUNC (
                 TO_DATE (SYSDATE, 'DD/MM/RRRR HH24:MI:SS')
               - TO_DATE (u09.u09_last_login_date, 'DD/MM/RRRR HH24:MI:SS'))
               AS diff
      FROM u01_customer u01, u09_customer_login u09, m02_institute m02
     WHERE     u01.u01_id = u09.u09_customer_id_u01
           AND u01.u01_institute_id_m02 = m02.m02_id
           AND u09.u09_login_status_id_v01 = 1
           AND TRUNC (
                     TO_DATE (SYSDATE, 'DD/MM/RRRR HH24:MI:SS')
                   - TO_DATE (u09.u09_last_login_date,
                              'DD/MM/RRRR HH24:MI:SS')) >
                   m02.m02_account_suspension_period
/
