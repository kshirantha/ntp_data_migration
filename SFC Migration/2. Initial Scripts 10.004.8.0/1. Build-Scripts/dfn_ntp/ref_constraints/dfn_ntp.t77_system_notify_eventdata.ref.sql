  ALTER TABLE dfn_ntp.t77_system_notify_eventdata ADD CONSTRAINT fk_t77_m148_id FOREIGN KEY (t77_event_id_m148)
   REFERENCES dfn_ntp.m148_notify_events_master (m148_id) ENABLE
/
