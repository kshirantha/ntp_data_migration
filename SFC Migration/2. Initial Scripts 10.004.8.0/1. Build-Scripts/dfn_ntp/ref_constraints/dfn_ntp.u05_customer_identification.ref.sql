ALTER TABLE dfn_ntp.u05_customer_identification
ADD CONSTRAINT fk_u05_u01 FOREIGN KEY (u05_customer_id_u01)
REFERENCES dfn_ntp.u01_customer (u01_id)
ENABLE NOVALIDATE
/