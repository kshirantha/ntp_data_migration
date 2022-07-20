CREATE TABLE dfn_ntp.m145_notify_event_cat
(
    m145_id                 NUMBER (5, 0) NOT NULL,
    m145_description        VARCHAR2 (100 BYTE) NOT NULL,
    m145_description_lang   VARCHAR2 (100 BYTE)
)
/



ALTER TABLE dfn_ntp.m145_notify_event_cat
ADD CONSTRAINT pk_m145 PRIMARY KEY (m145_id)
USING INDEX
/
