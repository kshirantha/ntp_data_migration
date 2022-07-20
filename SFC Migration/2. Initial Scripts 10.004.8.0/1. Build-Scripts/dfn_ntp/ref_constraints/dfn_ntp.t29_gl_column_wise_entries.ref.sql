ALTER TABLE dfn_ntp.t29_gl_column_wise_entries ADD CONSTRAINT fk_t29_batch_id_t27 FOREIGN KEY (t29_batch_id_t27)
   REFERENCES dfn_ntp.t27_gl_batches (t27_id) ENABLE
/
