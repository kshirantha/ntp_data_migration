CREATE TABLE dfn_ntp.m158_priceuser_agreement
(
    m158_user_id_u09         NUMBER (20, 0) NOT NULL,
    m158_customer_id_u01     NUMBER (18, 0) NOT NULL,
    m158_opt_1               NUMBER (1, 0) DEFAULT 0,
    m158_opt_2               NUMBER (1, 0) DEFAULT 0,
    m158_opt_3               NUMBER (1, 0) DEFAULT 0,
    m158_opt_4               NUMBER (1, 0) DEFAULT 0,
    m158_opt_5               NUMBER (1, 0) DEFAULT 0,
    m158_agreed              NUMBER (1, 0) DEFAULT 0,
    m158_customer_type_v01   NUMBER (1, 0) DEFAULT 0,
    m158_date_signed         DATE,
    m158_priceuser           VARCHAR2 (30 BYTE)
)
/


ALTER TABLE dfn_ntp.m158_priceuser_agreement
ADD CONSTRAINT m158_pk PRIMARY KEY (m158_user_id_u09, m158_customer_id_u01)
USING INDEX
/



ALTER TABLE dfn_ntp.m158_priceuser_agreement
DROP COLUMN m158_agreed
/
