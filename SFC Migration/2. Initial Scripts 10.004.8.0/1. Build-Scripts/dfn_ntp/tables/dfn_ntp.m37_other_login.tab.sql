CREATE TABLE dfn_ntp.m37_other_login
(
    m37_user_id    NUMBER (10, 0) NOT NULL,
    m37_username   VARCHAR2 (50 BYTE),
    m37_password   VARCHAR2 (100 BYTE)
)
/

ALTER TABLE dfn_ntp.m37_other_login
ADD CONSTRAINT m37_pk PRIMARY KEY (m37_user_id)
USING INDEX
/