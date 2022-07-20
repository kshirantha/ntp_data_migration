CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u05_customer_acc_frozen
(
   u05_id,
   u01_customer_no,
   u01_id,
   u01_external_ref_no,
   u01_full_name,
   u01_full_name_lang,
   u01_institute_id_m02,
   u05_id_no,
   m15_name,
   m15_name_lang,
   expiry_date,
   signing_date,
   nationality,
   nationality_lang,
   expiry_type
)
AS
   SELECT u05.u05_id,
          u01.u01_customer_no,
          u01.u01_id,
          u01.u01_external_ref_no,
          u01.u01_full_name,
          u01.u01_full_name_lang,
          u01.u01_institute_id_m02,
          u05.u05_id_no,
          m15.m15_name,
          m15.m15_name_lang,
          u05.u05_expiry_date AS expiry_date,
          u05.u05_issue_date AS signing_date,
          m05.m05_name AS nationality,
          m05.m05_name_lang AS nationality_lang,
          'ID Expiry' AS expiry_type
     FROM u05_customer_identification u05,
          m15_identity_type m15,
          u01_customer u01,
          m05_country m05
    WHERE     u05.u05_identity_type_id_m15 = m15.m15_id
          AND u05.u05_customer_id_u01 = u01.u01_id
          AND u01.u01_nationality_id_m05 = m05.m05_id
          AND u05.u05_expiry_date < TRUNC (SYSDATE)
   UNION ALL
   SELECT u05.u05_id,
          u01.u01_customer_no,
          u01.u01_id,
          u01.u01_external_ref_no,
          u01.u01_full_name,
          u01.u01_full_name_lang,
          u01.u01_institute_id_m02,
          u05.u05_id_no,
          m15.m15_name,
          m15.m15_name_lang,
          u03.u03_other_next_review AS expiry_date,
          u03.u03_other_repaper_date AS signing_date,
          m05.m05_name AS nationality,
          m05.m05_name_lang AS nationality_lang,
          'KYC Expiry' AS expiry_type
     FROM u05_customer_identification u05,
          u01_customer u01,
          m15_identity_type m15,
          u03_customer_kyc u03,
          m05_country m05
    WHERE     u05.u05_identity_type_id_m15 = m15.m15_id
          AND u05.u05_customer_id_u01 = u01.u01_id
          AND u01.u01_id = u03.u03_customer_id_u01
          AND u01.u01_nationality_id_m05 = m05.m05_id
          AND u03.u03_other_next_review < TRUNC (SYSDATE)
/