
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
   (	"M88_ID" NUMBER(5,0) , 
	"M88_FUNCTION" VARCHAR2(50), 
	"M88_FUNCTION_DESCRIPTION" VARCHAR2(50), 
	"M88_APPROVAL_LEVELS" NUMBER(1,0), 
	"M88_MAKER_CHECKER_TYPE" NUMBER(1,0), 
	"M88_CHANNEL_ID_V29" NUMBER(5,0), 
	"M88_CUSTOM_TYPE" VARCHAR2(50), 
	"M88_TXN_CODE" VARCHAR2(10)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.m88_function_approval.dat'
       )
    )
/


begin
  insert into dfn_ntp.m88_function_approval select * from e_tmp;

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

