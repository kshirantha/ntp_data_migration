
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
   (	"M35_ID" NUMBER(18,0) , 
	"M35_DESCRIPTION" VARCHAR2(50) , 
	"M35_DESCRIPTION_LANG" VARCHAR2(50), 
	"M35_STATUS_ID_V01" NUMBER(15,0), 
	"M35_CREATED_BY_ID_U17" NUMBER(5,0), 
	"M35_CREATED_DATE" DATE, 
	"M35_MODIFIED_BY_ID_U17" NUMBER(10,0), 
	"M35_MODIFIED_DATE" DATE, 
	"M35_STATUS_CHANGED_BY_ID_U17" NUMBER(10,0), 
	"M35_ADDITIONAL_DETAILS" VARCHAR2(100), 
	"M35_STATUS_CHANGED_DATE" DATE, 
	"M35_CUSTOM_TYPE" VARCHAR2(50), 
	"M35_INSTITUTE_ID_M02" NUMBER(5,0), 
	"M35_IS_DEFAULT" NUMBER(1,0)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.m35_customer_settl_group.dat'
       )
    )
/


begin
  insert into dfn_ntp.m35_customer_settl_group select * from e_tmp;

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

