
whenever sqlerror exit
set echo off
set define off
set sqlblanklines on
set sqlt off

declare
        e_exception_name exception;
        pragma exception_init(e_exception_name,-20120);
        l_user all_users.username%type;
        l_user_dba_status  NUMBER;

begin
        select user into l_user from dual;
end;
/

declare
  l_count number;
begin
  select count(*) into l_count from user_objects where object_name = 'E_TMP' ;

  if l_count = 1
  then
     execute immediate 'drop table e_tmp';
  end if;
end;
/

  CREATE TABLE "E_TMP" 
   (	"Z02_Z01_ID" NUMBER(5,0) , 
	"Z02_MAPPING_NAME" VARCHAR2(100) , 
	"Z02_COLUMN_NAME" NVARCHAR2(100) , 
	"Z02_WIDTH" NUMBER(5,0) , 
	"Z02_ALIGNMENT" NUMBER(1,0) , 
	"Z02_FORMAT" VARCHAR2(100), 
	"Z02_SEQ_NO" NUMBER(5,0) , 
	"Z02_VISIBLE" NUMBER(1,0) , 
	"Z02_TRANSLATABLE" NUMBER(1,0) , 
	"Z02_SHOW_BY_DEFAULT" NUMBER(1,0) , 
	"Z02_FORCE_DEFAULT_FORMATTING" NUMBER(1,0) , 
	"Z02_ADJUST_GMT" NUMBER(1,0) , 
	"Z02_FORMAT_BASED_ON_CURRENCY" NUMBER(1,0) , 
	"Z02_CURRENCY_FIELD_NAME" VARCHAR2(100), 
	"Z02_SHOW_TOTAL" NUMBER(1,0) , 
	"Z02_FIXED_FILTER_VALUE" NUMBER(1,0), 
	"Z02_MIN_FILTER_LENGTH" NUMBER(2,0), 
	"Z02_SHOW_IN_FILTER" NUMBER(1,0), 
	"Z02_COLUMN_TYPE" NUMBER(2,0), 
	"Z02_CHANGE_STATUS" NUMBER(1,0), 
	"Z02_BROKER_CODE" VARCHAR2(20), 
	"Z02_FEATURE_ID_V14" NUMBER(3,0)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.z02_forms_cols_c.dat'
       )
    )
/


begin
  insert into dfn_ntp.z02_forms_cols_c select * from e_tmp;

  commit;
end;
/

declare
  l_count number;
begin
  select count(*) into l_count from user_objects where object_name = 'E_TMP' ;

  if l_count = 1
  then
     execute immediate 'drop table e_tmp';
  end if;
end;
/

set sqlt on

