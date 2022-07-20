
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
   (	"M52_ID" NUMBER(10,0) , 
	"M52_INSTITUTE_ID_M02" NUMBER(3,0) , 
	"M52_NAME" VARCHAR2(100) , 
	"M52_NAME_LANG" VARCHAR2(100), 
	"M52_DESCRIPTION" VARCHAR2(500), 
	"M52_CREATED_BY_ID_U17" NUMBER(10,0) , 
	"M52_CREATED_DATE" DATE , 
	"M52_STATUS_ID_V01" NUMBER(5,0) , 
	"M52_MODIFIED_BY_ID_U17" NUMBER(10,0), 
	"M52_MODIFIED_DATE" DATE, 
	"M52_STATUS_CHANGED_BY_ID_U17" NUMBER(10,0), 
	"M52_STATUS_CHANGED_DATE" DATE, 
	"M52_CUSTOM_TYPE" VARCHAR2(50)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.m52_notification_group.dat'
       )
    )
/


begin
  insert into dfn_ntp.m52_notification_group select * from e_tmp;

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

