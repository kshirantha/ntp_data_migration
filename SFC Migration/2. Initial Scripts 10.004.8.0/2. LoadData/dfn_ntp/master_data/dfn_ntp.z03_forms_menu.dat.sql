
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
   (	"Z03_Z01_ID" NUMBER(5,0) , 
	"Z03_SEQ_NO" NUMBER(5,0) , 
	"Z03_TEXT" VARCHAR2(100), 
	"Z03_TIME_STAMP" DATE, 
	"Z03_VISIBLE" NUMBER(1,0), 
	"Z03_PARENT_MENU" NUMBER(5,0), 
	"Z03_SEC_ID" NUMBER(5,0), 
	"Z03_FEATURE_ID_V14" NUMBER(3,0)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.z03_forms_menu.dat'
       )
    )
/


begin
  insert into dfn_ntp.z03_forms_menu select * from e_tmp;

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

