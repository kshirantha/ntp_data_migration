
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
   (	"V30_STATUS_ID" NVARCHAR2(4) , 
	"V30_DESCRIPTION" NVARCHAR2(50) , 
	"V30_DESCRIPTION_LANG" NVARCHAR2(50) , 
	"V30_SHORT_DESCRIPTION" VARCHAR2(12), 
	"V30_SHORT_DESCRIPTION_LANG" VARCHAR2(50), 
	"V30_AMEND_ALLOW" NUMBER(1,0), 
	"V30_CANCEL_ALLOW" NUMBER(1,0), 
	"V30_MAPPING_FIX_STATUS" NVARCHAR2(4), 
	"V30_MANUAL_ORDER_EXEC_ALLOW" NUMBER(1,0)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.v30_order_status.dat'
       )
    )
/


begin
  insert into dfn_ntp.v30_order_status select * from e_tmp;

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

