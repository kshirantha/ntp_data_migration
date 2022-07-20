ALTER TABLE dfn_ntp.m07_location
ADD CONSTRAINT fk_m07_institute_id_m02 FOREIGN KEY (m07_institute_id_m02)
REFERENCES dfn_ntp.m02_institute (m02_id)
/