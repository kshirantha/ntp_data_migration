CREATE TABLE dfn_ntp.e_tmpl_7_price_user
    (user_name                      VARCHAR2(100 BYTE),
    password                       VARCHAR2(100 BYTE),
    TYPE                           VARCHAR2(100 BYTE),
    status                         VARCHAR2(100 BYTE),
    expiry_date                    VARCHAR2(100 BYTE))
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION EXTERNAL (
   DEFAULT DIRECTORY  ext_dir
    ACCESS PARAMETERS(RECORDS DELIMITED BY '\n'FIELDS TERMINATED BY ',' MISSING FIELD VALUES ARE NULL)
   LOCATION (
    ext_dir:'price_user_7.csv'
   )
  )
  NOPARALLEL
/
