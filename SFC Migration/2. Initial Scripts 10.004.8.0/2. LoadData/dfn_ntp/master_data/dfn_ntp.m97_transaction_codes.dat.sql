
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
   (	"M97_ID" NUMBER(5,0) , 
	"M97_CODE" VARCHAR2(10) , 
	"M97_DESCRIPTION" VARCHAR2(100) , 
	"M97_DESCRIPTION_LANG" VARCHAR2(100), 
	"M97_CATEGORY" NUMBER(5,0) , 
	"M97_B2B_ENABLED" NUMBER(1,0), 
	"M97_VISIBLE" NUMBER(1,0), 
	"M97_STATEMENT" NUMBER(1,0), 
	"M97_CHARGE_TYPE" NUMBER(1,0), 
	"M97_CREATED_BY_ID_U17" NUMBER(5,0) , 
	"M97_CREATED_DATE" DATE , 
	"M97_MODIFIED_BY_ID_U17" NUMBER(5,0), 
	"M97_MODIFIED_DATE" DATE, 
	"M97_STATUS_ID_V01" NUMBER(5,0) , 
	"M97_STATUS_CHANGED_BY_ID_U17" NUMBER(5,0) , 
	"M97_STATUS_CHANGED_DATE" DATE , 
	"M97_TXN_IMPACT_TYPE" NUMBER(1,0), 
	"M97_CUSTOM_TYPE" VARCHAR2(50)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.m97_transaction_codes.dat'
       )
    )
/


begin
  insert into dfn_ntp.m97_transaction_codes select * from e_tmp;

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

