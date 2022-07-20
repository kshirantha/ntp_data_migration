
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
   (	"M07_ID" NUMBER(5,0) , 
	"M07_INSTITUTE_ID_M02" NUMBER(3,0) , 
	"M07_NAME" VARCHAR2(100) , 
	"M07_NAME_LANG" VARCHAR2(100), 
	"M07_CREATED_BY_ID_U17" NUMBER(10,0) , 
	"M07_CREATED_DATE" TIMESTAMP (6) , 
	"M07_STATUS_ID_V01" NUMBER(5,0) , 
	"M07_MODIFIED_BY_ID_U17" NUMBER(10,0), 
	"M07_MODIFIED_DATE" TIMESTAMP (6), 
	"M07_STATUS_CHANGED_BY_ID_U17" NUMBER(10,0), 
	"M07_STATUS_CHANGED_DATE" TIMESTAMP (6), 
	"M07_EXTERNAL_REF" VARCHAR2(20), 
	"M07_REGION_ID_M90" NUMBER(10,0), 
	"M07_LOCATION_CODE" VARCHAR2(250), 
	"M07_CUSTOM_TYPE" VARCHAR2(50), 
	"M07_ORDER_VALUE_PER_DAY" NUMBER(21,8), 
	"M07_ORDER_VOLUME_PER_DAY" NUMBER(21,8), 
	"M07_DEFAULT_CURRENCY_CODE_M03" VARCHAR2(255), 
	"M07_DEFAULT_CURRENCY_ID_M03" NUMBER(5,0)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.m07_location.dat'
       )
    )
/


begin
  insert into dfn_ntp.m07_location select * from e_tmp;

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

