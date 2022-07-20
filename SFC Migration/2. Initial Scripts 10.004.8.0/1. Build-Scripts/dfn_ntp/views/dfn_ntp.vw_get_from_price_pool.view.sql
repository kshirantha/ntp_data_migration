/* Formatted on 03-Sep-2019 12:04:47 (QP5 v5.276) */
CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_get_from_price_pool
(
    m161_id,
    m161_price_user,
    m161_price_password,
    m161_type
)
AS
    SELECT m161_id,
           m161_price_user,
           m161_price_password,
           m161_type
      FROM m161_price_user_pool
     WHERE m161_id = (SELECT MIN (m161_id)
                        FROM m161_price_user_pool
                       WHERE m161_status = 0 AND m161_expiry_date >= SYSDATE)
/