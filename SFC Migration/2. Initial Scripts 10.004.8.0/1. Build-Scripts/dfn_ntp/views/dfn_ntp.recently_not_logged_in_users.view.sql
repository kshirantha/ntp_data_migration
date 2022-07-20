CREATE OR REPLACE FORCE VIEW dfn_ntp.recently_not_logged_in_users
(
    u17_id,
    u17_login_name,
    u17_full_name,
    u17_last_login_date,
    u17_institution_id_m02,
    m02_account_suspension_period,
    diff
)
AS
    SELECT u17.u17_id,
           u17.u17_login_name,
           u17.u17_full_name,
           u17.u17_last_login_date,
           u17.u17_institution_id_m02,
           m02.m02_account_suspension_period,
           TRUNC (
                 TO_DATE (SYSDATE, 'DD/MM/RRRR HH24:MI:SS')
               - TO_DATE (u17.u17_last_login_date, 'DD/MM/RRRR HH24:MI:SS'))
               AS diff
      FROM u17_employee u17, m02_institute m02
     WHERE     u17.u17_institution_id_m02 = m02.m02_id
           AND u17.u17_login_status = 1
           AND TRUNC (
                     TO_DATE (SYSDATE, 'DD/MM/RRRR HH24:MI:SS')
                   - TO_DATE (u17.u17_last_login_date,
                              'DD/MM/RRRR HH24:MI:SS')) >
                   m02.m02_account_suspension_period;
/
