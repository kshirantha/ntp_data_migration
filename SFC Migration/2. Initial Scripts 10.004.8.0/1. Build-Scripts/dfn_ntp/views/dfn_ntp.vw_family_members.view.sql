CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_family_members
(
    m109_id,
    m109_customer_id_u01,
    m109_family_member_id_u01,
    m109_customer_no,
    m109_family_member_name,
    m109_customer_id_number
)
AS
    SELECT m109.m109_id,
           m109.m109_customer_id_u01,
           m109.m109_family_member_id_u01,
           family.u01_customer_no AS m109_customer_no,
           family.u01_display_name AS m109_family_member_name,
           family.u01_default_id_no AS m109_customer_id_number
      FROM     m109_customer_family_members m109
           JOIN
               u01_customer family
           ON m109.m109_family_member_id_u01 = family.u01_id
/