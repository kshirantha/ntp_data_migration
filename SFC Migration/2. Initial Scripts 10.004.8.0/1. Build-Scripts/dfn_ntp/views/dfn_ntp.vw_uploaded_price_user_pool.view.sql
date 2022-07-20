CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_uploaded_price_user_pool
(
    m161_price_user,
    m161_price_password,
    m161_type,
    m161_status,
    account_type,
    status,
    m161_expiry_date,
    m161_primary_institute_id_m02,
    execution_status,
    execution_reason
)
AS
    SELECT m161.m161_price_user,
           m161.m161_price_password,
           m161.m161_type,
           m161.m161_status,
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
           m161.m161_expiry_date,
           m161.m161_primary_institute_id_m02,
           (CASE
                WHEN    m161.m161_execution_status = 2
                     OR m161.m161_execution_status = -1
                THEN
                    'Rejected'
                WHEN    m161.m161_execution_status = 1
                     OR m161.m161_execution_status = 0
                THEN
                    'Valid'
                ELSE
                    ''
            END)
               AS execution_status,
           (CASE m161_execution_status
                WHEN 0 THEN 'Unavailable'
                WHEN 1 THEN 'Reserved'
                WHEN 2 THEN 'Available'
                WHEN -1 THEN 'Expired'
                ELSE ''
            END)
               AS execution_reason
      FROM m161_uploaded_price_user_pool m161
/