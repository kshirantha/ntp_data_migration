
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
   (	"V20_ID" NUMBER(5,0), 
	"V20_DESCRIPTION" VARCHAR2(200), 
	"V20_VALUE" NVARCHAR2(200), 
	"V20_INSTITUTE_ID_M02" NUMBER(5,0), 
	"V20_PRIMARY_INSTITUTE_ID_M02" NUMBER(5,0), 
	"V20_TAG" VARCHAR2(200), 
	"V20_TYPE" NUMBER(1,0), 
	"V20_IS_CONFIGURABLE" NUMBER(1,0), 
	"V20_CUSTOM_TYPE" NUMBER(1,0), 
	"V20_MODIFIED_BY_ID_U17" NUMBER(10,0)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.v20_default_master_data.dat'
       )
    )
/


begin
  insert into dfn_ntp.v20_default_master_data select * from e_tmp;

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

