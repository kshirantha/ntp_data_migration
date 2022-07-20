CREATE TABLE dfn_ntp.m147_notify_event_cat_tag_map
(
    m147_id                  NUMBER (5, 0) NOT NULL,
    m147_event_cat_id_m145   NUMBER (5, 0) NOT NULL,
    m147_tag_id_m146         NUMBER (5, 0) NOT NULL
)
/



ALTER TABLE dfn_ntp.m147_notify_event_cat_tag_map
ADD CONSTRAINT pk_m147 PRIMARY KEY (m147_id)
USING INDEX
/



ALTER TABLE dfn_ntp.m147_notify_event_cat_tag_map
ADD CONSTRAINT fk_m147_event_cat_id_m145 FOREIGN KEY (m147_event_cat_id_m145)
REFERENCES dfn_ntp.m145_notify_event_cat (m145_id)
/
ALTER TABLE dfn_ntp.m147_notify_event_cat_tag_map
ADD CONSTRAINT fk_m147_tag_id_m146 FOREIGN KEY (m147_tag_id_m146)
REFERENCES dfn_ntp.m146_notify_tag_master (m146_id)
/

alter table dfn_ntp.M147_NOTIFY_EVENT_CAT_TAG_MAP
	add M147_CUSTOM_TYPE varchar2(50) default 1
/
