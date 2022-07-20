CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m1001_sukuk_coupon_pay_b
(
    m1001_id,
    m1001_cash_acc_id_u06,
    u06_display_name,
    u06_display_name_u01,
    m1001_principal,
    m1001_rate,
    m1001_days_per_year,
    m1001_period_days,
    m1001_is_manual,
    is_manual,
    m1001_total_coupon,
    m1001_created_date,
    m1001_modified_by_id_u17,
    m1001_modified_date,
    m1001_created_by_id_u17,
    m1001_status_id_v01,
    status_description,
    status_description_lang,
    m1001_status_changed_by_id_u17,
    m1001_status_changed_date,
    created_by_name,
    modified_by_name,
    status_changed_by_name
)
AS
SELECT m1001.m1001_id,
       m1001.m1001_cash_acc_id_u06,
       u06.u06_display_name,
       u06.u06_display_name_u01,
       m1001.m1001_principal,
       m1001.m1001_rate,
       m1001.m1001_days_per_year,
       m1001.m1001_period_days,
       m1001.m1001_is_manual,
       CASE
           WHEN m1001.m1001_is_manual = 0 THEN 'No'
           WHEN m1001.m1001_is_manual = 1 THEN 'Yes'
       END
                AS is_manual,
       m1001.m1001_total_coupon,
       m1001.m1001_created_date,
       m1001.m1001_modified_by_id_u17,
       m1001.m1001_modified_date,
       m1001.m1001_created_by_id_u17,
       m1001.m1001_status_id_v01,
       status_list.v01_description AS status_description,
       status_list.v01_description_lang AS status_description_lang,
       m1001.m1001_status_changed_by_id_u17,
       m1001.m1001_status_changed_date,
       u17_created_by.u17_full_name AS created_by_name,
       u17_modified_by.u17_full_name AS modified_by_name,
       u17_status_changed_by.u17_full_name AS status_changed_by_name
FROM m1001_sukuk_coupon_payment m1001
       LEFT JOIN u17_employee u17_created_by
           ON m1001.m1001_created_by_id_u17 = u17_created_by.u17_id
       LEFT JOIN u17_employee u17_modified_by
           ON m1001.m1001_modified_by_id_u17 = u17_modified_by.u17_id
       LEFT JOIN u17_employee u17_status_changed_by
                   ON m1001.m1001_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
       LEFT JOIN vw_status_list status_list
           ON m1001.m1001_status_id_v01 = status_list.v01_id
         LEFT JOIN u06_cash_account u06
                   ON m1001.m1001_cash_acc_id_u06 = u06.u06_id
/