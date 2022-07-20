
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
   (	"EXCHANGE" VARCHAR2(8) , 
	"EXCHANGECODE" CHAR(5) , 
	"DESCRIPTION_1" VARCHAR2(40), 
	"DESCRIPTION_2" NVARCHAR2(80), 
	"PRIMARY_CURRENCY" VARCHAR2(4) , 
	"MARKETSTATUS" NUMBER(10,0) , 
	"LAST_EOD_DATE" DATE , 
	"LAST_ACTIVE_DATE" DATE , 
	"LAST_INIT_DATE" DATE , 
	"ISDEFAULTS" NUMBER(1,0) , 
	"IS_ACTIVE" NUMBER(5,0), 
	"TIMEZONECODE" NUMBER(10,0), 
	"PATH" NUMBER(10,0), 
	"COUNTRY_CODE" CHAR(10), 
	"PARAMETERS" VARCHAR2(100), 
	"NOOFUPS" NUMBER(10,0), 
	"NOOFDOWNS" NUMBER(10,0), 
	"NOOFNOCHANGE" NUMBER(10,0), 
	"VOLUME" NUMBER(10,0), 
	"TURNOVER" NUMBER(20,3), 
	"SYMBOLS_TRADED" NUMBER(10,0), 
	"NOOFTRADES" NUMBER(10,0), 
	"INTRADAY_OHLC_DAYS" NUMBER(10,0), 
	"SATELLITE_DATA_PORT" NUMBER(10,0), 
	"SATELLITE_ENABLED" NUMBER(10,0), 
	"SATELLITE_FILE_PORT" NUMBER(10,0), 
	"IS_EXPAND_SUBMKTS" NUMBER(1,0), 
	"DEFAULT_DECIMAL_PTS" NUMBER(10,0), 
	"PRICE_MODIFICATION_FACTOR" NUMBER(10,0), 
	"SHORT_DESCRIPTION_1" VARCHAR2(50), 
	"SHORT_DESCRIPTION_2" NVARCHAR2(100), 
	"ARCHIVE_GEN_STATUS" NUMBER(1,0), 
	"ARCHIVE_GEN_TIME" DATE, 
	"DEC_CORRECTION_FACTOR" NUMBER(10,0), 
	"DESCRIPTION_3" NVARCHAR2(80), 
	"SHORT_DESCRIPTION_3" NVARCHAR2(100), 
	"IS_EOD_COMPLETED" NUMBER(1,0), 
	"CONTENT_SERVER_IP" VARCHAR2(20), 
	"IS_ALLOW_DISPLAY" NUMBER , 
	"DISPLAY_EXCHANGE" VARCHAR2(25)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_price.esp_exchangemaster.dat'
       )
    )
/


begin
  insert into dfn_price.esp_exchangemaster select * from e_tmp;

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

