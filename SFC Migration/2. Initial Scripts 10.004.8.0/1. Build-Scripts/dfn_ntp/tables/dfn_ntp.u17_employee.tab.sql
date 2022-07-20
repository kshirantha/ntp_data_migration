CREATE TABLE dfn_ntp.u17_employee
(
    u17_id                        NUMBER (10, 0) NOT NULL,
    u17_institution_id_m02        NUMBER (3, 0) NOT NULL,
    u17_full_name                 VARCHAR2 (200 BYTE) NOT NULL,
    u17_login_name                VARCHAR2 (20 BYTE) NOT NULL,
    u17_password                  VARCHAR2 (100 BYTE) NOT NULL,
    u17_failed_attempts           NUMBER (2, 0) NOT NULL,
    u17_is_first_time             NUMBER (1, 0) NOT NULL,
    u17_created_by_id_u17         NUMBER (10, 0) NOT NULL,
    u17_created_date              TIMESTAMP (6) NOT NULL,
    u17_status_id_v01             NUMBER (5, 0) NOT NULL,
    u17_login_status              NUMBER (1, 0) NOT NULL,
    u17_type_id_m11               NUMBER (5, 0) NOT NULL,
    u17_price_login_name          VARCHAR2 (20 BYTE),
    u17_price_password            VARCHAR2 (100 BYTE),
    u17_pw_expire_date            DATE,
    u17_last_login_date           DATE,
    u17_telephone                 VARCHAR2 (20 BYTE),
    u17_telephone_ext             VARCHAR2 (20 BYTE),
    u17_mobile                    VARCHAR2 (20 BYTE),
    u17_email                     VARCHAR2 (100 BYTE),
    u17_department_id_m12         NUMBER (5, 0),
    u17_employee_no               VARCHAR2 (20 BYTE),
    u17_modified_by_id_u17        NUMBER (10, 0),
    u17_modified_date             TIMESTAMP (6),
    u17_status_changed_by_u17     NUMBER (10, 0),
    u17_status_changed_date       TIMESTAMP (6),
    u17_history_passwords         VARCHAR2 (4000 BYTE),
    u17_user_category             NUMBER (1, 0) DEFAULT 0,
    u17_client_version            VARCHAR2 (30 BYTE),
    u17_trading_enabled           NUMBER (1, 0),
    u17_full_name_saudi           VARCHAR2 (50 BYTE),
    u17_location_id_m07           NUMBER (5, 0),
    u17_custom_type               VARCHAR2 (50 BYTE) DEFAULT 1,
    u17_display_name              VARCHAR2 (50 BYTE),
    u17_dealer_cmsn_grp_id_m162   NUMBER (18, 0),
    PRIMARY KEY (u17_id)
)
ORGANIZATION INDEX
NOCOMPRESS
OVERFLOW
/



ALTER TABLE dfn_ntp.u17_employee
ADD UNIQUE (u17_login_name)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.u17_employee.u17_client_version IS
    'Client Application Version Assigned for the Login'
/
COMMENT ON COLUMN dfn_ntp.u17_employee.u17_login_status IS
    '0 - Pending, 1 - Active,  2 - Locked, 3=Suspended'
/
COMMENT ON COLUMN dfn_ntp.u17_employee.u17_trading_enabled IS '1=YES, 0 = NO'
/
COMMENT ON COLUMN dfn_ntp.u17_employee.u17_user_category IS
    'Local = 0, International = 1, both = 3'
/

ALTER TABLE dfn_ntp.u17_employee DROP COLUMN u17_display_name
/ 

ALTER TABLE dfn_ntp.u17_employee
 ADD (
  u17_authentication_type NUMBER (5,0) DEFAULT 0
 )
/

COMMENT ON COLUMN dfn_ntp.u17_employee.u17_authentication_type IS
    '0=Default,1=NONE,2=DB,3=LDAP'
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'COMMENT ON COLUMN DFN_NTP.U17_EMPLOYEE.U17_CLIENT_VERSION IS ''Client Application Version Assigned for the Login / DT''';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('U17_EMPLOYEE')
           AND column_name = UPPER ('U17_CLIENT_VERSION');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

ALTER TABLE dfn_ntp.u17_employee
    DROP COLUMN u17_user_category
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.u17_employee
ADD (
  u17_external_ref varchar2 (25 BYTE) 
)';

BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('u17_employee')
           AND column_name = UPPER ('u17_external_ref');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE DFN_NTP.U17_EMPLOYEE  ADD (  U17_USER_CATEGORY NUMBER (1) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('U17_EMPLOYEE')
           AND column_name = UPPER ('U17_USER_CATEGORY');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN DFN_NTP.U17_EMPLOYEE.U17_USER_CATEGORY IS '0- Local, 1 - International, 2 – Both'
/

