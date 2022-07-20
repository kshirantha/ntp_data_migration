CREATE TABLE dfn_ntp.m146_notify_tag_master
(
    m146_id                 NUMBER (5, 0) NOT NULL,
    m146_tag                VARCHAR2 (20 BYTE) NOT NULL,
    m146_description        VARCHAR2 (100 BYTE) NOT NULL,
    m146_description_lang   VARCHAR2 (100 BYTE)
)
/



ALTER TABLE dfn_ntp.m146_notify_tag_master
ADD CONSTRAINT pk_m146 PRIMARY KEY (m146_id)
USING INDEX
/
