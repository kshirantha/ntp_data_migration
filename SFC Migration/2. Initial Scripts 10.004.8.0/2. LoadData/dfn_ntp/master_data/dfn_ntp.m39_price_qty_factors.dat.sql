
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
   (	"M39_ID" NUMBER(5,0) , 
	"M39_NAME" VARCHAR2(50) , 
	"M39_NAME_LANG" VARCHAR2(50), 
	"M39_INSTITUTE_ID_M02" NUMBER(3,0), 
	"M39_PRICE_RATIO" NUMBER(10,5), 
	"M39_LOT_SIZE" NUMBER(10,0), 
	"M39_STATUS_ID_V01" NUMBER(4,0), 
	"M39_CREATED_BY_ID_U17" NUMBER(5,0), 
	"M39_CREATED_DATE" DATE, 
	"M39_MODIFIED_BY_ID_U17" NUMBER(5,0), 
	"M39_MODIFIED_DATE" DATE, 
	"M39_STATUS_CHANGED_BY_ID_U17" NUMBER(5,0), 
	"M39_STATUS_CHANGED_DATE" DATE, 
	"M39_CUSTOM_TYPE" VARCHAR2(50)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.m39_price_qty_factors.dat'
       )
    )
/


begin
  insert into dfn_ntp.m39_price_qty_factors select * from e_tmp;

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

