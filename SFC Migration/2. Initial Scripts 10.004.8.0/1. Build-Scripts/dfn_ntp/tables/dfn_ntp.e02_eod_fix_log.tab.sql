-- Table DFN_NTP.E02_EOD_FIX_LOG

CREATE TABLE dfn_ntp.e02_eod_fix_log
(
    e02_sequence       VARCHAR2 (20),
    e02_reverse_exec   VARCHAR2 (20),
    e02_fix_record     VARCHAR2 (4000),
    e02_exec_id        VARCHAR2 (20)
)
ORGANIZATION EXTERNAL
    (TYPE oracle_loader DEFAULT DIRECTORY ext_dir ACCESS PARAMETERS
      ( RECORDS DELIMITED BY '\n'
    FIELDS TERMINATED BY '#'
    LRTRIM
    MISSING FIELD VALUES ARE NULL
    (e02_sequence CHAR (20)  LRTRIM,
    e02_reverse_exec CHAR (20)  LRTRIM,
    e02_fix_record CHAR (4000)  LRTRIM,
    e02_exec_id CHAR (20)  )
               )         LOCATION (ext_dir:'fix_log.txt'))
/



-- End of DDL Script for Table DFN_NTP.E02_EOD_FIX_LOG

DROP TABLE dfn_ntp.e02_eod_fix_log
/
CREATE TABLE dfn_ntp.e02_eod_fix_log
    (e02_sequence                   VARCHAR2(100 BYTE),
    e02_reverse_exec               VARCHAR2(100 BYTE),
    e02_fix_record                 VARCHAR2(4000 BYTE),
    e02_exec_id                    VARCHAR2(100 BYTE))
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION EXTERNAL (
   DEFAULT DIRECTORY  ext_dir
    ACCESS PARAMETERS(RECORDS DELIMITED BY '\n'
    FIELDS TERMINATED BY '#'
    LRTRIM
    MISSING FIELD VALUES ARE NULL
    (e02_sequence CHAR (100) ,
    e02_reverse_exec CHAR (100),
    e02_fix_record CHAR (4000),
    e02_exec_id CHAR (100)  )
   )
   LOCATION (
    ext_dir:'fix_log.txt'
   )
  )
  REJECT LIMIT UNLIMITED
  NOPARALLEL
/

DROP TABLE dfn_ntp.e02_eod_fix_log
/

CREATE TABLE dfn_ntp.e02_eod_fix_log
    (e02_sequence                   VARCHAR2(100 BYTE),
    e02_reverse_exec               VARCHAR2(100 BYTE),
    e02_fix_record                 VARCHAR2(4000 BYTE),
    e02_exec_id                    VARCHAR2(100 BYTE))
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION EXTERNAL (
   DEFAULT DIRECTORY  ext_dir
    ACCESS PARAMETERS(RECORDS DELIMITED BY '\n'
    NOLOGFILE
    NOBADFILE
    DISABLE_DIRECTORY_LINK_CHECK
    FIELDS TERMINATED BY '#'
    LRTRIM
    MISSING FIELD VALUES ARE NULL (
    e02_sequence CHAR (100) ,
    e02_reverse_exec CHAR (100),
    e02_fix_record CHAR (4000),
    e02_exec_id CHAR (100)  )
   )
   LOCATION (
    ext_dir:'fix_log.txt'
   )
  )
   REJECT LIMIT UNLIMITED
  NOPARALLEL
/


DROP TABLE dfn_ntp.e02_eod_fix_log
/

CREATE TABLE dfn_ntp.e02_eod_fix_log
    (e02_sequence                   VARCHAR2(100 BYTE),
    e02_reverse_exec               VARCHAR2(100 BYTE),
    e02_fix_record                 VARCHAR2(4000 BYTE),
    e02_exec_id                    VARCHAR2(100 BYTE),
    e02_primary_institute_id       VARCHAR2(100 BYTE))
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION EXTERNAL (
   DEFAULT DIRECTORY  ext_dir
    ACCESS PARAMETERS(RECORDS DELIMITED BY '\n'
    NOLOGFILE
    NOBADFILE
    DISABLE_DIRECTORY_LINK_CHECK
    FIELDS TERMINATED BY '#'
    LRTRIM
    MISSING FIELD VALUES ARE NULL (
    e02_sequence CHAR (100) ,
    e02_reverse_exec CHAR (100),
    e02_fix_record CHAR (4000),
    e02_exec_id CHAR (100) ,
    e02_primary_institute_id CHAR(100 )
   ))
   LOCATION (
    ext_dir:'fix_log.txt'
   )
  )
   REJECT LIMIT UNLIMITED
  NOPARALLEL
/
