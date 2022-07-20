
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
   (	"M03_CODE" CHAR(3) , 
	"M03_DESCRIPTION" VARCHAR2(50) , 
	"M03_DESCRIPTION_LANG" VARCHAR2(50) , 
	"M03_SUB_UNIT_DESCRIPTION" VARCHAR2(50) , 
	"M03_DECIMAL_PLACES" NUMBER(2,0) , 
	"M03_DISPLAY_FORMAT" VARCHAR2(50) , 
	"M03_CREATED_BY_ID_U17" NUMBER(10,0) , 
	"M03_CREATED_DATE" TIMESTAMP (6) , 
	"M03_STATUS_ID_V01" NUMBER(5,0) , 
	"M03_MODIFIED_BY_ID_U17" NUMBER(10,0), 
	"M03_MODIFIED_DATE" TIMESTAMP (6), 
	"M03_STATUS_CHANGED_BY_ID_U17" NUMBER(10,0) , 
	"M03_ID" NUMBER(5,0) , 
	"M03_STATUS_CHANGED_DATE" TIMESTAMP (6) , 
	"M03_SUB_UNIT_DESCRIPTION_LANG" VARCHAR2(50), 
	"M03_CUSTOM_TYPE" VARCHAR2(50), 
	"M03_ENABLE_NETRECEIVALE" NUMBER(1,0), 
	"M03_TRANSATION_DISABLED" NUMBER(1,0)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.m03_currency.dat'
       )
    )
/


begin
  insert into dfn_ntp.m03_currency select * from e_tmp;

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

