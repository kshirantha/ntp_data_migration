CREATE TABLE dfn_ntp.t71_otp
(
    t71_id                    NUMBER (20, 0) NOT NULL,
    t71_customer_no_u01       VARCHAR2 (50 BYTE),
    t71_mobile                VARCHAR2 (20 BYTE),
    t71_otp                   VARCHAR2 (15 BYTE),
    t71_otp_generate_time     TIMESTAMP (6),
    t71_otp_expiration_time   TIMESTAMP (6),
    t71_status                NUMBER (2, 0),
    t71_no_of_attempts        NUMBER (2, 0),
    t71_service_id            NUMBER (2, 0),
    t71_des_value             VARCHAR2 (50 BYTE)
)
/