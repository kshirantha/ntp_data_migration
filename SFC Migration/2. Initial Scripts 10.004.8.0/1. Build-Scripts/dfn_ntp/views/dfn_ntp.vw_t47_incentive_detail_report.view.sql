CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t47_incentive_detail_report
(
   user_or_cust_name,
   user_or_cust_institution,
   t47_incentive_group_id_m162,
   t47_staff_or_customer_id,
   t47_exchange_id_m01,
   t47_exchange_code_m01,
   t47_txn_currency_code_m03,
   t47_settle_date,
   t47_broker_commission,
   t47_total_commission,
   t47_commission_type_id_v01,
   t47_incentive,
   t47_group_type_id_v01,
   t47_frequency_id_v01,
   t47_from_date,
   t47_to_date,
   commission_type,
   commission_type_lang,
   frequency_type,
   frequency_type_lang,
   group_type,
   group_type_lang,
   t47_created_datetime
)
AS
   SELECT CASE t47_group_type_id_v01
             WHEN 1 THEN m10.m10_name
             WHEN 2 THEN u17.u17_full_name
             WHEN 3 THEN m21.m21_name
             WHEN 4 THEN u01.u01_display_name
          END                       AS user_or_cust_name,
          CASE t47_group_type_id_v01
             WHEN 1 THEN m10.m10_institute_id_m02
             WHEN 2 THEN u17.u17_institution_id_m02
             WHEN 3 THEN m21.m21_institute_id_m02
             WHEN 4 THEN u01.u01_institute_id_m02
          END                       AS user_or_cust_institution,
          t47_incentive_group_id_m162,
          t47_staff_or_customer_id,
          t47_exchange_id_m01,
          t47_exchange_code_m01,
          t47_txn_currency_code_m03,
          t47_settle_date,
          t47_broker_commission,
          t47_total_commission,
          t47_commission_type_id_v01,
          t47_incentive,
          t47_group_type_id_v01,
          t47_frequency_id_v01,
          t47_from_date,
          t47_to_date,
          v1.v01_description        AS commission_type,
          v1.v01_description_lang   AS commission_type_lang,
          v2.v01_description        AS frequency_type,
          v2.v01_description_lang   AS frequency_type_lang,
          v3.v01_description        AS group_type,
          v3.v01_description_lang   AS group_type_lang,
          t47_created_datetime
     FROM t47_incentive_for_staff_n_cust  t47
          LEFT JOIN u17_employee u17
             ON     t47_staff_or_customer_id = u17.u17_id
                AND t47_group_type_id_v01 = 2
          LEFT JOIN m10_relationship_manager m10
             ON     t47_staff_or_customer_id = m10.m10_id
                AND t47_group_type_id_v01 = 1
          LEFT JOIN m21_introducing_broker m21
             ON     t47_staff_or_customer_id = m21.m21_id
                AND t47_group_type_id_v01 = 3
          LEFT JOIN u06_cash_account u06
             ON t47_staff_or_customer_id = u06.u06_id
          LEFT JOIN u01_customer u01
             ON     u06.u06_customer_id_u01 = u01.u01_id
                AND t47_group_type_id_v01 = 4
          LEFT JOIN (SELECT v01_id, v01_description, v01_description_lang
                       FROM v01_system_master_data
                      WHERE v01_type = 76) v1
             ON t47.t47_commission_type_id_v01 = v1.v01_id
          LEFT JOIN (SELECT v01_id, v01_description, v01_description_lang
                       FROM v01_system_master_data
                      WHERE v01_type = 75) v2
             ON t47.t47_frequency_id_v01 = v2.v01_id
          LEFT JOIN (SELECT v01_id, v01_description, v01_description_lang
                       FROM v01_system_master_data
                      WHERE v01_type = 74) v3
             ON t47.t47_group_type_id_v01 = v3.v01_id
/