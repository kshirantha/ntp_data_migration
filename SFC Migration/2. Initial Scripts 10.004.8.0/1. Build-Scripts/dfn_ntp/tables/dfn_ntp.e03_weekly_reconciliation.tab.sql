-- Table DFN_NTP.E03_WEEKLY_RECONCILIATION

  CREATE TABLE dfn_ntp.e03_weekly_reconciliation
   ( e03_broker_code VARCHAR2(100),
 e03_equator_no VARCHAR2(100),
 e03_symbol VARCHAR2(100),
 e03_isin VARCHAR2(100),
 e03_current_qty VARCHAR2(100),
 e03_available_qty VARCHAR2(100),
 e03_pledged_qty VARCHAR2(100),
 e03_position_date VARCHAR2(100),
 e03_change_date VARCHAR2(100)
   )
   ORGANIZATION EXTERNAL
    ( TYPE oracle_loader
      DEFAULT DIRECTORY ext_dir
      ACCESS PARAMETERS
      ( RECORDS DELIMITED BY
   '\n' FIELDS TERMINATED BY ',' MISSING FIELD VALUES ARE NULL (
   e03_broker_code,
   e03_equator_no,
   e03_symbol,
   e03_isin,
   e03_current_qty,
   e03_available_qty,
   e03_pledged_qty,
   e03_position_date,
   e03_change_date )                )
      LOCATION
       ( ext_dir:'weekly.txt'
       )
    )
   REJECT LIMIT UNLIMITED
/



-- End of DDL Script for Table DFN_NTP.E03_WEEKLY_RECONCILIATION

DROP TABLE dfn_ntp.e03_weekly_reconciliation
/

CREATE TABLE dfn_ntp.e03_weekly_reconciliation
    (e03_broker_code                VARCHAR2(100 BYTE),
    e03_equator_no                 VARCHAR2(100 BYTE),
    e03_symbol                     VARCHAR2(100 BYTE),
    e03_isin                       VARCHAR2(100 BYTE),
    e03_current_qty                VARCHAR2(100 BYTE),
    e03_available_qty              VARCHAR2(100 BYTE),
    e03_pledged_qty                VARCHAR2(100 BYTE),
    e03_position_date              VARCHAR2(100 BYTE),
    e03_change_date                VARCHAR2(100 BYTE))
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION EXTERNAL (
   DEFAULT DIRECTORY  ext_dir
   ACCESS PARAMETERS(RECORDS DELIMITED BY '\n'
   NOLOGFILE
   NOBADFILE
   DISABLE_DIRECTORY_LINK_CHECK
   FIELDS TERMINATED BY ',' MISSING FIELD VALUES ARE NULL (
   e03_broker_code,
   e03_equator_no,
   e03_symbol,
   e03_isin,
   e03_current_qty,
   e03_available_qty,
   e03_pledged_qty,
   e03_position_date,
   e03_change_date )        )
   LOCATION (
    ext_dir:'weekly.txt'
   )
  )
   REJECT LIMIT UNLIMITED
  NOPARALLEL
/