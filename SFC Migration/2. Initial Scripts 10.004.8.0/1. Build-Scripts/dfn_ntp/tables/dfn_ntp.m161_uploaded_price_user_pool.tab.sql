CREATE TABLE dfn_ntp.m161_uploaded_price_user_pool
(
    m161_price_user                 VARCHAR2 (500 BYTE) NOT NULL,
    m161_price_password             VARCHAR2 (500 BYTE) NOT NULL,
    m161_type                       NUMBER (1, 0) DEFAULT 1 NOT NULL,
    m161_status                     NUMBER (1, 0) DEFAULT 0 NOT NULL,
    m161_expiry_date                VARCHAR2 (500 BYTE) NOT NULL,
    m161_primary_institute_id_m02   NUMBER (3, 0) DEFAULT 1 NOT NULL,
    m161_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    m161_execution_status           NUMBER (1, 0)
)
/
