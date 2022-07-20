CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_acc_locked_users
(
   u17_full_name,
   u17_id,
   u17_login_name,
   u17_type_id_m11,
   u17_institution_id_m02
)
AS
   SELECT u17.u17_full_name,
          u17.u17_id,
          u17.u17_login_name,
          u17.U17_TYPE_ID_M11,
          u17.u17_institution_id_m02
     FROM u17_employee u17
    WHERE U17_LOGIN_STATUS = 2;
/