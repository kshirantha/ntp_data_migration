
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
   (	"V29_ID" NUMBER(5,0) , 
	"V29_DESCRIPTION" VARCHAR2(50) , 
	"V29_ORDER_CHANNEL_CATEGORY" NUMBER(2,0) , 
	"V29_TRADER_ID_PREFIX" VARCHAR2(5), 
	"V29_CUSTOM_TYPE" VARCHAR2(50), 
	"V29_ORDER_CHANNEL_TYPE" NUMBER(5,0), 
	"V29_AUTHENTICATION_TYPE" NUMBER(5,0)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.v29_order_channel.dat'
       )
    )
/


begin
  insert into dfn_ntp.v29_order_channel select * from e_tmp;

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

