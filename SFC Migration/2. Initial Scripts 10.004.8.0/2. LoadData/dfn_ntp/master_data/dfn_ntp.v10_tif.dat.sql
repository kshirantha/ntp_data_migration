
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
   (	"V10_ID" NUMBER(2,0) , 
	"V10_DESCRIPTION" VARCHAR2(75) , 
	"V10_DEFAULT" NUMBER(1,0) , 
	"V10_EXPIRY_DATE_REQUIRED" NUMBER(1,0) , 
	"V10_EXPIRY_DATE_OFFSET" NUMBER(2,0) , 
	"V10_EXPIRY_TIME_REQUIRED" VARCHAR2(1) , 
	"V10_IS_AVAILABLE_IN_FIX" NUMBER(1,0) , 
	"V10_DURATION" NUMBER(3,0) , 
	"V10_DESCRIPTION_LANG" VARCHAR2(200)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.v10_tif.dat'
       )
    )
/


begin
  insert into dfn_ntp.v10_tif select * from e_tmp;

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

