ALTER TABLE dfn_ntp.m149_notify_templates
ADD CONSTRAINT fk_m149_event_id_m148 FOREIGN KEY (m149_event_id_m148)
REFERENCES dfn_ntp.m148_notify_events_master (m148_id)
/
