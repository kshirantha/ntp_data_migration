
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
   (	"V34_ID" NUMBER(10,0) , 
	"V34_INST_ID_V09" NUMBER(10,0) , 
	"V34_INST_CODE_V09" VARCHAR2(100) , 
	"V34_PRICE_INST_TYPE_ID" NUMBER(10,0) , 
	"V34_PRICE_INST_TYPE_DESC" VARCHAR2(100) , 
	"V34_PRICE_INST_TYPE_DESC_LANG" VARCHAR2(100)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.v34_price_instrument_type.dat'
       )
    )
/


begin
  insert into dfn_ntp.v34_price_instrument_type select * from e_tmp;

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

