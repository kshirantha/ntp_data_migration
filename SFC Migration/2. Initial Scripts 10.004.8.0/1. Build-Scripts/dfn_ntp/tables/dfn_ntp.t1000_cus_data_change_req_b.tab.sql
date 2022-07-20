CREATE TABLE dfn_ntp.t1000_cus_data_change_req_b
(
    t1000_id                    NUMBER (20, 0) NOT NULL,
    t1000_login_id_u09          NUMBER (10, 0) NOT NULL,
    t1000_login_name_u09        VARCHAR2 (20 BYTE) NOT NULL,
    t1000_current_mobile        VARCHAR2 (20 BYTE),
    t1000_new_mobile            VARCHAR2 (20 BYTE),
    t1000_otp                   VARCHAR2 (15 BYTE),
    t1000_otp_generate_time     TIMESTAMP (6),
    t1000_otp_expiration_time   TIMESTAMP (6),
    t1000_persist_otp           NUMBER (2, 0),
    t1000_status                NUMBER (2, 0),
    t1000_no_of_attempts        NUMBER (10, 0) DEFAULT 1,
    t1000_custom_type           VARCHAR2 (50 BYTE),
    t1000_current_email         VARCHAR2 (50 BYTE),
    t1000_new_email             VARCHAR2 (50 BYTE),
    t1000_type                  NUMBER (2, 0)
)
/

COMMENT ON COLUMN dfn_ntp.t1000_cus_data_change_req_b.t1000_persist_otp IS
    'YES=1 | NO=0'
/
COMMENT ON COLUMN dfn_ntp.t1000_cus_data_change_req_b.t1000_status IS
    'OTP_SENT=1 | OTP_VERIFIED=2 | OTP_RE_SENT=3'
/
COMMENT ON COLUMN dfn_ntp.t1000_cus_data_change_req_b.t1000_type IS
    'MOBILE-1 | EMAIL-2'
/
