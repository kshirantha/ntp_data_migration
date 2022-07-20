CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_id_expired_customer_list
(
    u01_id,
    u01_customer_no,
    u01_institute_id_m02,
    u01_external_ref_no,
    u01_display_name,
    u01_display_name_lang,
    cust_id_type,
    cust_id_type_lang,
    cust_id_no,
    cust_id_issue_date,
    cust_id_exp_date
)
AS
    SELECT u01.u01_id,
           u01.u01_customer_no,
           u01.u01_institute_id_m02,
           u01.u01_external_ref_no,
           u01.u01_display_name,
           u01.u01_display_name_lang,
           m15.m15_name AS cust_id_type,
           m15.m15_name_lang AS cust_id_type_lang,
           u05.u05_id_no AS cust_id_no,
           u05.u05_issue_date AS cust_id_issue_date,
           u05.u05_expiry_date AS cust_id_exp_date
      FROM u01_customer u01,
           u05_customer_identification u05,
           m15_identity_type m15
     WHERE     u01.u01_id = u05.u05_customer_id_u01
           AND u05.u05_identity_type_id_m15 = m15.m15_id
/