CREATE TABLE dfn_ntp.m148_notify_events_master
(
    m148_id                  NUMBER (5, 0) NOT NULL,
    m148_event_cat_id_m145   NUMBER (5, 0) NOT NULL,
    m148_description         VARCHAR2 (100 BYTE) NOT NULL,
    m148_description_lang    VARCHAR2 (100 BYTE)
)
/



ALTER TABLE dfn_ntp.m148_notify_events_master
ADD CONSTRAINT pk_m148 PRIMARY KEY (m148_id)
USING INDEX
/


ALTER TABLE dfn_ntp.m148_notify_events_master
ADD CONSTRAINT fk_m148_event_cat_id_m145 FOREIGN KEY (m148_event_cat_id_m145)
REFERENCES dfn_ntp.m145_notify_event_cat (m145_id)
/
