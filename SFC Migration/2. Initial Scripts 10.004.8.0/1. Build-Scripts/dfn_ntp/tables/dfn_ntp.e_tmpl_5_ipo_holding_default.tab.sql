CREATE TABLE dfn_ntp.e_tmpl_5_ipo_holding_default
    (MEMBER                         VARCHAR2(100 BYTE),
    account                        VARCHAR2(100 BYTE),
    symbol                         VARCHAR2(100 BYTE),
    isin_number                    VARCHAR2(100 BYTE),
    shares_current_balance         VARCHAR2(100 BYTE),
    shares_available               VARCHAR2(100 BYTE),
    shares_pledged                 VARCHAR2(100 BYTE),
    position_date                  VARCHAR2(100 BYTE),
    change_date                    VARCHAR2(100 BYTE))
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION EXTERNAL (
   DEFAULT DIRECTORY  ext_dir
    ACCESS PARAMETERS(RECORDS DELIMITED BY '\n'
    FIELDS TERMINATED BY '|'
    MISSING FIELD VALUES ARE NULL
   )
   LOCATION (
    ext_dir:'ipo_holding_default_5.txt'
   )
  )
/

