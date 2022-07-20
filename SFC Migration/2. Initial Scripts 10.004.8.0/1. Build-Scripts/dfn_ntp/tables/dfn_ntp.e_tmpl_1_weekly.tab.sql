CREATE TABLE dfn_ntp.e_tmpl_1_weekly
    (symbol_id                      VARCHAR2(100 BYTE),
    isin                           VARCHAR2(100 BYTE),
    exg_acc_no                     VARCHAR2(100 BYTE),
    broker_code                    VARCHAR2(100 BYTE),
    current_qty                    VARCHAR2(100 BYTE),
    available_qty                  VARCHAR2(100 BYTE),
    pledge_qty                     VARCHAR2(100 BYTE),
    position_date                  VARCHAR2(100 BYTE),
    change_date                    VARCHAR2(100 BYTE))
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION EXTERNAL (
   DEFAULT DIRECTORY  ext_dir
    ACCESS PARAMETERS(RECORDS DELIMITED BY '\n'FIELDS TERMINATED BY ',' MISSING FIELD VALUES ARE NULL)
   LOCATION (
    ext_dir:'weekly_1.nt'
   )
  )
  NOPARALLEL
/