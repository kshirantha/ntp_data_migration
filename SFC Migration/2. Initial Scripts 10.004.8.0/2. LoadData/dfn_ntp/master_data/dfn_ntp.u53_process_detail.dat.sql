
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
   (	"U53_ID" NUMBER(18,0) , 
	"U53_CODE" VARCHAR2(10) , 
	"U53_DESCRIPTION" VARCHAR2(1000), 
	"U53_DATA" BLOB, 
	"U53_POSITION_DATE" DATE, 
	"U53_COMPRESSED" NUMBER(1,0), 
	"U53_STATUS_ID_V01" NUMBER(5,0) , 
	"U53_UPDATED_BY_ID_U17" NUMBER(10,0) , 
	"U53_UPDATED_DATE_TIME" DATE , 
	"U53_FAILED_REASON" VARCHAR2(4000), 
	"U53_PRIMARY_INSTITUTE_ID_M02" NUMBER(3,0)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.u53_process_detail.dat'
       )
    )
/


begin
  insert into dfn_ntp.u53_process_detail select * from e_tmp;

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

