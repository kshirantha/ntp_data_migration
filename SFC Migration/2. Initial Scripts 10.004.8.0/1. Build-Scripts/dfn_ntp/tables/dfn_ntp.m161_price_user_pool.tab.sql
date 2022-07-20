CREATE TABLE dfn_ntp.m161_price_user_pool
(
    m161_id                         NUMBER (10, 0),
    m161_price_user                 VARCHAR2 (50 BYTE) NOT NULL,
    m161_price_password             VARCHAR2 (100 BYTE) NOT NULL,
    m161_type                       NUMBER (1, 0) DEFAULT 1 NOT NULL,
    m161_status                     NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m161_expiry_date                DATE NOT NULL,
    m161_created_date               DATE DEFAULT SYSDATE NOT NULL,
    m161_customer_id_u01            NUMBER (18, 0),
    m161_assigned_date              DATE,
    m161_assigned_by_id_u17         NUMBER (10, 0),
    m161_created_by_id_u17          NUMBER (10, 0) NOT NULL,
    m161_primary_institute_id_m02   NUMBER (3, 0) DEFAULT 1,
    m161_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1
)
/

COMMENT ON COLUMN dfn_ntp.m161_price_user_pool.m161_status IS
    '-1- invalid,0-notused,1-reserved,2-using,'
/
COMMENT ON COLUMN dfn_ntp.m161_price_user_pool.m161_type IS
    '1-basic, 2-net ,3-pro'
/

ALTER TABLE dfn_ntp.M161_PRICE_USER_POOL
 ADD (
  M161_LOGIN_ID_U09 NUMBER (10)
 )
/
