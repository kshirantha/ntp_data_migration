-- Table DFN_NTP.U09_CUSTOMER_LOGIN

CREATE TABLE dfn_ntp.u09_customer_login
(
    u09_id                          NUMBER (10, 0),
    u09_customer_id_u01             NUMBER (10, 0),
    u09_login_name                  VARCHAR2 (20),
    u09_login_password              VARCHAR2 (100),
    u09_mobile_no                   VARCHAR2 (20),
    u09_email                       VARCHAR2 (50),
    u09_failed_attempts             NUMBER (3, 0) DEFAULT 0,
    u09_login_status_id_v01         NUMBER (1, 0) DEFAULT 1,
    u09_login_auth_type_id_v01      NUMBER (1, 0) DEFAULT 1,
    u09_trans_auth_type_id_v01      NUMBER (1, 0) DEFAULT 1,
    u09_transaction_password        VARCHAR2 (100),
    u09_password_expiry_date        DATE DEFAULT SYSDATE + 90,
    u09_change_pwd_at_next_login    NUMBER (1, 0) DEFAULT 1,
    u09_auto_trading_acc            NUMBER (1, 0) DEFAULT 0,
    u09_price_user_name             VARCHAR2 (20),
    u09_price_password              VARCHAR2 (100),
    u09_last_login_date             TIMESTAMP (6),
    u09_last_login_channel_id_v29   NUMBER (2, 0),
    u09_last_otp                    VARCHAR2 (20),
    u09_last_otp_gen_time           TIMESTAMP (6),
    u09_pw_last_updated_date        TIMESTAMP (6),
    u09_kyc_ignored_attempts        NUMBER (3, 0),
    u09_modified_by_id_u17          NUMBER (10, 0),
    u09_modified_date               TIMESTAMP (6),
    u09_history_passwords           VARCHAR2 (4000),
    u09_created_by_id_u17           NUMBER (10, 0),
    u09_created_date                TIMESTAMP (6),
    u09_status_id_v01               NUMBER (5, 0),
    u09_status_changed_by_id_u17    NUMBER (10, 0),
    u09_status_changed_date         TIMESTAMP (6),
    u09_is_first_time               NUMBER (5, 0),
    PRIMARY KEY (u09_id) ENABLE
)
ORGANIZATION INDEX
NOCOMPRESS
OVERFLOW
/

-- Constraints for  DFN_NTP.U09_CUSTOMER_LOGIN


  ALTER TABLE dfn_ntp.u09_customer_login MODIFY (u09_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u09_customer_login MODIFY (u09_customer_id_u01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u09_customer_login MODIFY (u09_login_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u09_customer_login MODIFY (u09_failed_attempts NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u09_customer_login MODIFY (u09_login_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u09_customer_login MODIFY (u09_login_auth_type_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u09_customer_login MODIFY (u09_trans_auth_type_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u09_customer_login MODIFY (u09_password_expiry_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u09_customer_login MODIFY (u09_auto_trading_acc NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u09_customer_login MODIFY (u09_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u09_customer_login MODIFY (u09_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u09_customer_login MODIFY (u09_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u09_customer_login ADD CONSTRAINT uk_u09_login_name UNIQUE (u09_login_name)
  USING INDEX  ENABLE
/

-- Indexes for  DFN_NTP.U09_CUSTOMER_LOGIN


CREATE INDEX dfn_ntp.u09_u09_primary_u01_id
    ON dfn_ntp.u09_customer_login (u09_customer_id_u01)
/

-- Comments for  DFN_NTP.U09_CUSTOMER_LOGIN

COMMENT ON COLUMN dfn_ntp.u09_customer_login.u09_login_status_id_v01 IS
    '0- Pending, 1- Active,  2- Locked, 3- Suspended, 4- Deleted'
/
COMMENT ON COLUMN dfn_ntp.u09_customer_login.u09_login_auth_type_id_v01 IS
    '1- Password, 2- Password & OTP'
/
COMMENT ON COLUMN dfn_ntp.u09_customer_login.u09_trans_auth_type_id_v01 IS
    '1- No Password, 2-Password Once, 3-Password Each Time, 4-USB, 5-OTP'
/
COMMENT ON COLUMN dfn_ntp.u09_customer_login.u09_change_pwd_at_next_login IS
    'First time login : 1, Otherwise : 0'
/
-- End of DDL Script for Table DFN_NTP.U09_CUSTOMER_LOGIN

ALTER TABLE dfn_ntp.U09_CUSTOMER_LOGIN 
 MODIFY (
  U09_LAST_LOGIN_DATE DATE

 )
/

alter table dfn_ntp.U09_CUSTOMER_LOGIN
	add U09_CUSTOM_TYPE varchar2(50) default 1
/


ALTER TABLE dfn_ntp.u09_customer_login
 ADD (
  u09_institute_id_m02 NUMBER (3, 0)
 )
/

ALTER TABLE dfn_ntp.u09_customer_login
    MODIFY (u09_institute_id_m02 DEFAULT 1)
/

ALTER TABLE dfn_ntp.U09_CUSTOMER_LOGIN
 ADD (
  U09_PREFERRED_LANG_ID_V01 NUMBER (1) DEFAULT 1 NOT NULL
 )
/

ALTER TABLE dfn_ntp.U09_CUSTOMER_LOGIN
 ADD (
  U09_ALGO_WAIVED NUMBER (1) DEFAULT 0 NOT NULL
 )
/

ALTER TABLE dfn_ntp.U09_CUSTOMER_LOGIN
 ADD (
  U09_ACCOUNT_EXPIRY_DATE DATE
 )
/

COMMENT ON COLUMN dfn_ntp.u09_customer_login.U09_ALGO_WAIVED IS
    '1 - Waived, 0 - Not Waived'
/

ALTER TABLE dfn_ntp.u09_customer_login
DROP COLUMN u09_account_expiry_date
/

ALTER TABLE dfn_ntp.u09_customer_login
DROP COLUMN u09_algo_waived
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_ntp.U09_CUSTOMER_LOGIN 
 ADD (
  u09_idle_session_time_out NUMBER (3) DEFAULT 15
 )
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('U09_CUSTOMER_LOGIN')
           AND column_name = UPPER ('u09_idle_session_time_out');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
COMMENT ON COLUMN dfn_ntp.U09_CUSTOMER_LOGIN.u09_idle_session_time_out IS 'time out in minutes'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.U09_CUSTOMER_LOGIN 
 ADD (
 U09_SUB_AGREEMENT_TYPE NUMBER (1)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('U09_CUSTOMER_LOGIN')
           AND column_name = UPPER ('U09_SUB_AGREEMENT_TYPE');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN DFN_NTP.u09_customer_login.u09_sub_agreement_type IS
    '0=Private,1=Business'
/

