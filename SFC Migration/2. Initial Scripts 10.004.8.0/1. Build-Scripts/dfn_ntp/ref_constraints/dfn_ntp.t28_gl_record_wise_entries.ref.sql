ALTER TABLE dfn_ntp.t28_gl_record_wise_entries ADD CONSTRAINT fk_t28_batch_id_t27 FOREIGN KEY (t28_batch_id_t27)
   REFERENCES dfn_ntp.t27_gl_batches (t27_id) ENABLE
/
