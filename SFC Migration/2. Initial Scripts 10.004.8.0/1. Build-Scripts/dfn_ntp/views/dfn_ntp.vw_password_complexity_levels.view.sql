CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_password_complexity_levels
(
    m56_id,
    m56_regular_expression,
    m56_validation_message_1,
    m56_validation_message_2,
    m56_rank,
    m56_pwd_lowercase_required,
    m56_pwd_uppercase_required,
    m56_pwd_numbers_required,
    m56_pwd_specialchars_required,
    m56_pwd_start_char_required
)
AS
    SELECT m56.m56_id,
           m56.m56_regular_expression,
           m56.m56_validation_message_1,
           m56.m56_validation_message_2,
           m56.m56_rank,
           m56.m56_pwd_lowercase_required,
           m56.m56_pwd_uppercase_required,
           m56.m56_pwd_numbers_required,
           m56.m56_pwd_specialchars_required,
           m56.m56_pwd_start_char_required
      FROM m56_password_complexity_levels m56;
/
