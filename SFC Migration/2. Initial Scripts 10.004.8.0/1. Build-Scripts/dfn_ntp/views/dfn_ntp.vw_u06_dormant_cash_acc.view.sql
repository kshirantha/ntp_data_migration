CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u06_dormant_cash_acc
(
   u01_id,
   u01_customer_no,
   u01_external_ref_no,
   u01_full_name,
   dormant_status,
   u06_id,
   u06_inactive_drmnt_status_v01,
   u06_investment_account_no,
   u06_inactive_dormant_date,
   u06_last_activity_date,
   u06_display_name,
   u06_institute_id_m02
)
AS
   SELECT u01.u01_id,
          u01.u01_customer_no,
          u01.u01_external_ref_no,
          u01.u01_full_name,
          status.v01_description AS dormant_status,
          u06.u06_id,
          u06.u06_inactive_drmnt_status_v01,
          u06.u06_investment_account_no,
          TRUNC (u06.u06_inactive_dormant_date) AS u06_inactive_dormant_date,
          TRUNC (u06.u06_last_activity_date) AS u06_last_activity_date,
          u06.u06_display_name,
          u06.u06_institute_id_m02
     FROM u06_cash_account u06, u01_customer u01, vw_status_list status
    WHERE     u06.u06_customer_id_u01 = u01.u01_id
          AND u06.u06_inactive_drmnt_status_v01 = status.v01_id
          AND u06.u06_inactive_drmnt_status_v01 IN (11,
                                                    12,
                                                    13,
                                                    14,
                                                    15,
                                                    16,
                                                    21)
/