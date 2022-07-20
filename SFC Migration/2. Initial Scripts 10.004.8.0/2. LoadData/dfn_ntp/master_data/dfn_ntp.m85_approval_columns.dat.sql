
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
   (	"M85_ID" NUMBER(5,0), 
	"M85_TABLE_ID_M53" NUMBER(5,0), 
	"M85_COLUMN_NAME" VARCHAR2(50), 
	"M85_COLUMN_DESCRIPTION" VARCHAR2(100), 
	"M85_COLUMN_DESCRIPTION_LANG" VARCHAR2(100), 
	"M85_COLUMN_TYPE" NUMBER(1,0), 
	"M85_COLUMN_FORMAT" VARCHAR2(50), 
	"M85_IS_CHILD_COLUMN" NUMBER(1,0), 
	"M85_IS_PARENT" NUMBER(1,0), 
	"M85_CUSTOM_TYPE" VARCHAR2(50)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.m85_approval_columns.dat'
       )
    )
/


begin
  insert into dfn_ntp.m85_approval_columns select * from e_tmp;

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

