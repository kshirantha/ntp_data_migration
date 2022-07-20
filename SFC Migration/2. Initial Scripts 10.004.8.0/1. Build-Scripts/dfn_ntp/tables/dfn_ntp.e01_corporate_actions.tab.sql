-- Table DFN_NTP.E01_CORPORATE_ACTIONS

  CREATE TABLE dfn_ntp.e01_corporate_actions
   ( e01_broker_code VARCHAR2(100),
 e01_equator_no VARCHAR2(100),
 e01_symbol VARCHAR2(100),
 e01_isin VARCHAR2(100),
 e01_current_qty VARCHAR2(100),
 e01_available_qty VARCHAR2(100),
 e01_pledged_qty VARCHAR2(100),
 e01_position_date VARCHAR2(100),
 e01_change_date VARCHAR2(100)
   )
   ORGANIZATION EXTERNAL
    ( TYPE oracle_loader
      DEFAULT DIRECTORY ext_dir
      ACCESS PARAMETERS
      ( RECORDS DELIMITED BY
   '\n' FIELDS TERMINATED BY ',' MISSING FIELD VALUES ARE NULL (
   e01_broker_code,
   e01_equator_no,
   e01_symbol,
   e01_isin,
   e01_current_qty,
   e01_available_qty,
   e01_pledged_qty,
   e01_position_date,
   e01_change_date )                )
      LOCATION
       ( ext_dir:'ca.txt'
       )
    )
   REJECT LIMIT UNLIMITED
/



-- End of DDL Script for Table DFN_NTP.E01_CORPORATE_ACTIONS

DROP TABLE dfn_ntp.e01_corporate_actions
/

CREATE TABLE dfn_ntp.e01_corporate_actions
    (e01_broker_code                VARCHAR2(100 BYTE),
    e01_equator_no                 VARCHAR2(100 BYTE),
    e01_symbol                     VARCHAR2(100 BYTE),
    e01_isin                       VARCHAR2(100 BYTE),
    e01_current_qty                VARCHAR2(100 BYTE),
    e01_available_qty              VARCHAR2(100 BYTE),
    e01_pledged_qty                VARCHAR2(100 BYTE),
    e01_position_date              VARCHAR2(100 BYTE),
    e01_change_date                VARCHAR2(100 BYTE))
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION EXTERNAL (
   DEFAULT DIRECTORY  ext_dir
ACCESS PARAMETERS(RECORDS DELIMITED BY '\n'
   NOLOGFILE
   NOBADFILE
   DISABLE_DIRECTORY_LINK_CHECK
   FIELDS TERMINATED BY ','
   MISSING FIELD VALUES ARE NULL (
   e01_broker_code,
   e01_equator_no,
   e01_symbol,
   e01_isin,
   e01_current_qty,
   e01_available_qty,
   e01_pledged_qty,
   e01_position_date,
   e01_change_date )        )
   LOCATION (
    ext_dir:'ca.txt'
   )
  )
   REJECT LIMIT UNLIMITED
  NOPARALLEL
/