
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
   (	"V06_TYPE_ID" VARCHAR2(2), 
	"V06_DESCRIPTION_1" NVARCHAR2(50) , 
	"V06_DESCRIPTION_2" NVARCHAR2(50) , 
	"V06_DEFAULT" NUMBER(1,0) , 
	"V06_IS_REGULAR_ORDER_TYPE" NUMBER(1,0) , 
	"V06_IS_AVAILABLE_IN_FIX" NUMBER(1,0) , 
	"V06_ID" NUMBER(2,0) 
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.v06_order_type.dat'
       )
    )
/


begin
  insert into dfn_ntp.v06_order_type select * from e_tmp;

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

