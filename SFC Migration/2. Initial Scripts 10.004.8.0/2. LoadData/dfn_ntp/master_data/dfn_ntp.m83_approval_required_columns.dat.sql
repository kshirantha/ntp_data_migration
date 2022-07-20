
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
   (	"M83_ID" NUMBER(5,0), 
	"M83_TABLE_ID_M53" NUMBER(5,0), 
	"M83_COLUMN_ID_M85" NUMBER(5,0), 
	"M83_CUSTOM_TYPE" VARCHAR2(50), 
	"M83_DEPENDANT_NO" NUMBER(2,0), 
	"M83_IS_SENSITIVE_DATA" NUMBER(1,0), 
	"M83_ENTITLEMENT_ID_V04" NUMBER(10,0)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.m83_approval_required_columns.dat'
       )
    )
/


begin
  insert into dfn_ntp.m83_approval_required_columns select * from e_tmp;

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

