
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
   (	"Z07_ID" VARCHAR2(20) , 
	"Z07_NAME" VARCHAR2(50), 
	"Z07_TAG" VARCHAR2(50), 
	"Z07_SEC_ID" NUMBER(5,0), 
	"Z07_FKEY" NUMBER(10,0), 
	"Z07_HIDE" NUMBER(1,0), 
	"Z07_ICON" VARCHAR2(50), 
	"Z07_ROUTE" VARCHAR2(500), 
	"Z07_QUERY_PARAMS" VARCHAR2(500), 
	"Z07_PKEY" NUMBER(20,0), 
	"Z07_CUSTOM_TYPE" VARCHAR2(50), 
	"Z07_IS_CUSTOMIZED" NUMBER(1,0), 
	"Z07_DELETED_FROM_CORE" NUMBER(1,0), 
	"Z07_BROKER_CODE" VARCHAR2(50), 
	"Z07_FEATURE_ID_V14" NUMBER(3,0), 
	"Z07_FORM_TITLE" VARCHAR2(200)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.z07_menu.dat'
       )
    )
/


begin
  insert into dfn_ntp.z07_menu select * from e_tmp;

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

