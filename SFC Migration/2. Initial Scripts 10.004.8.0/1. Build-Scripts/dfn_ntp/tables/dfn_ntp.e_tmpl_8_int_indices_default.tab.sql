CREATE TABLE dfn_ntp.e_tmpl_8_int_indices_default
    (rate                           VARCHAR2(100 BYTE),
    name                           VARCHAR2(100 BYTE),
    rate_type                      VARCHAR2(100 BYTE),
    duration                       VARCHAR2(100 BYTE))
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION EXTERNAL (
   DEFAULT DIRECTORY  ext_dir
    ACCESS PARAMETERS(RECORDS DELIMITED BY '\n'FIELDS TERMINATED BY ',' MISSING FIELD VALUES ARE NULL)
   LOCATION (
    ext_dir:'int_indices_default_8.csv'
   )
  )
  NOPARALLEL
/


