
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
   (	"V09_CODE" VARCHAR2(4) , 
	"V09_DESCRIPTION" VARCHAR2(75) , 
	"V09_CREATED_BY_ID_M17" NUMBER(20,0), 
	"V09_CREATED_DATE" DATE, 
	"V09_MODIFIED_BY_ID_M17" NUMBER(20,0), 
	"V09_MODIFIED_DATE" DATE, 
	"V09_STATUS_ID_V01" NUMBER(20,0), 
	"V09_STATUS_CHANGED_BY_ID_U17" NUMBER(20,0), 
	"V09_STATUS_CHANGED_DATE" DATE, 
	"V09_MARGIN_ENABLE" NUMBER(1,0), 
	"V09_DEFAULT_PRICE_QTY_TYPE" NUMBER(1,0), 
	"V09_LOT_SIZE" NUMBER(5,0), 
	"V09_PRICE_FACTOR" NUMBER(10,5), 
	"V09_ID" NUMBER(3,0)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.v09_instrument_types.dat'
       )
    )
/


begin
  insert into dfn_ntp.v09_instrument_types select * from e_tmp;

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

