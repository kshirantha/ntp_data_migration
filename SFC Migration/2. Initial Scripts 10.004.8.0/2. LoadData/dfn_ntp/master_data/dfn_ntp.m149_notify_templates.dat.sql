
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
   (	"M149_ID" NUMBER(10,0) , 
	"M149_EVENT_ID_M148" NUMBER(5,0) , 
	"M149_SMS_TEMPLATE" VARCHAR2(2000), 
	"M149_SMS_TEMPLATE_LANG" VARCHAR2(2000), 
	"M149_EMAIL_SUBJECT" VARCHAR2(500), 
	"M149_EMAIL_SUBJECT_LANG" VARCHAR2(500), 
	"M149_EMAIL_TEMPLATE" CLOB, 
	"M149_EMAIL_TEMPLATE_LANG" CLOB, 
	"M149_INSTITUTE_ID_M02" NUMBER(5,0), 
	"M149_CUSTOM_TYPE" VARCHAR2(50)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.m149_notify_templates.dat'
       )
    )
/


begin
  insert into dfn_ntp.m149_notify_templates select * from e_tmp;

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

