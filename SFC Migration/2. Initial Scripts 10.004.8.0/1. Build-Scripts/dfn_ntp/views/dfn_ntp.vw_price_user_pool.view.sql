CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_price_user_pool
(
    m161_id,
    m161_price_user,
    m161_price_password,
    m161_type,
    m161_status,
    m161_expiry_date,
    m161_created_date,
    m161_customer_id_u01,
    m161_assigned_date,
    m161_assigned_by_id_u17,
    m161_created_by_id_u17,
    m161_primary_institute_id_m02,
    m161_login_id_u09,
    account_type,
    status,
    created_by_full_name,
    assigned_by_full_name,
    u01_id,
    customer_no,
    customer_name,
    login_name
)
AS
    SELECT m161.m161_id,
           m161.m161_price_user,
           m161.m161_price_password,
           m161.m161_type,
           m161.m161_status,
           m161.m161_expiry_date,
           m161.m161_created_date,
           m161.m161_customer_id_u01,
           m161.m161_assigned_date,
           m161.m161_assigned_by_id_u17,
           m161.m161_created_by_id_u17,
           m161.m161_primary_institute_id_m02,
           m161.m161_login_id_u09,
           (CASE m161.m161_type
                WHEN 1 THEN 'Basic'
                WHEN 2 THEN 'Net'
                WHEN 3 THEN 'Pro'
            END)
               AS account_type,
           (CASE m161.m161_status
                WHEN 0 THEN 'Not Used'
                WHEN 1 THEN 'Reserved'
                WHEN 2 THEN 'Using'
                WHEN -1 THEN 'Invalid'
            END)
               AS status,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_assigned_by.u17_full_name AS assigned_by_full_name,
           u01.u01_id,
           u01.u01_customer_no AS customer_no,
           u01.u01_display_name AS customer_name,
           u09.u09_login_name AS login_name
      FROM m161_price_user_pool m161
           LEFT JOIN u01_customer u01
               ON u01.u01_id = m161.m161_customer_id_u01
           LEFT JOIN u17_employee u17_created_by
               ON u17_created_by.u17_id = m161.m161_created_by_id_u17
           LEFT JOIN u17_employee u17_assigned_by
               ON u17_assigned_by.u17_id = m161.m161_assigned_by_id_u17
           LEFT JOIN u09_customer_login u09
               ON m161.m161_login_id_u09 = u09.u09_id
/