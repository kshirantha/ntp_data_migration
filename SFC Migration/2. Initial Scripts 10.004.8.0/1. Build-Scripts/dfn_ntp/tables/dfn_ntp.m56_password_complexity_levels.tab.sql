-- Table DFN_NTP.M56_PASSWORD_COMPLEXITY_LEVELS

CREATE TABLE dfn_ntp.m56_password_complexity_levels
(
    m56_id                          NUMBER (10, 0),
    m56_description                 VARCHAR2 (75),
    m56_regular_expression          VARCHAR2 (4000),
    m56_validation_message_1        NVARCHAR2 (2000),
    m56_validation_message_2        NVARCHAR2 (2000),
    m56_rank                        NUMBER (2, 0) DEFAULT 1,
    m56_pwd_lowercase_required      NUMBER (1, 0) DEFAULT 0,
    m56_pwd_uppercase_required      NUMBER (1, 0) DEFAULT 0,
    m56_pwd_numbers_required        NUMBER (1, 0) DEFAULT 0,
    m56_pwd_specialchars_required   NUMBER (1, 0) DEFAULT 0,
    m56_description_lang            VARCHAR2 (75)
)
/

-- Constraints for  DFN_NTP.M56_PASSWORD_COMPLEXITY_LEVELS


  ALTER TABLE dfn_ntp.m56_password_complexity_levels ADD CONSTRAINT m56_pk PRIMARY KEY (m56_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m56_password_complexity_levels MODIFY (m56_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m56_password_complexity_levels MODIFY (m56_description NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m56_password_complexity_levels MODIFY (m56_rank NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m56_password_complexity_levels MODIFY (m56_pwd_lowercase_required NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m56_password_complexity_levels MODIFY (m56_pwd_uppercase_required NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m56_password_complexity_levels MODIFY (m56_pwd_numbers_required NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m56_password_complexity_levels MODIFY (m56_pwd_specialchars_required NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M56_PASSWORD_COMPLEXITY_LEVELS

COMMENT ON COLUMN dfn_ntp.m56_password_complexity_levels.m56_id IS 'PK'
/
COMMENT ON COLUMN dfn_ntp.m56_password_complexity_levels.m56_description IS
    'Description of the complexity_level'
/
COMMENT ON COLUMN dfn_ntp.m56_password_complexity_levels.m56_regular_expression IS
    'regular expression to validate complexity'
/
COMMENT ON COLUMN dfn_ntp.m56_password_complexity_levels.m56_validation_message_1 IS
    'password validation faile message in english'
/
COMMENT ON COLUMN dfn_ntp.m56_password_complexity_levels.m56_validation_message_2 IS
    'password validation faile message in arabic'
/
COMMENT ON COLUMN dfn_ntp.m56_password_complexity_levels.m56_rank IS
    'rank of the complexity level 1  for minimum,'
/
COMMENT ON TABLE dfn_ntp.m56_password_complexity_levels IS
    'this table keeps the passowrd complexity levels defined for OMS users (m06)'
/
-- End of DDL Script for Table DFN_NTP.M56_PASSWORD_COMPLEXITY_LEVELS

ALTER TABLE dfn_ntp.M56_PASSWORD_COMPLEXITY_LEVELS 
 ADD (
  M56_PWD_START_CHAR_REQUIRED NUMBER (1, 0) DEFAULT 0 NOT NULL
 )
/


