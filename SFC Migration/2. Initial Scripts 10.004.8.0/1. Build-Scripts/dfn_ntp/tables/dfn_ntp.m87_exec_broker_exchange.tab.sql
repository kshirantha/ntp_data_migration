-- Table DFN_NTP.M87_EXEC_BROKER_EXCHANGE

CREATE TABLE dfn_ntp.m87_exec_broker_exchange
(
    m87_id                   NUMBER,
    m87_exec_broker_id_m26   NUMBER (6, 0),
    m87_exchange_code_m01    VARCHAR2 (10),
    m87_exchange_id_m01      NUMBER (5, 0),
    m87_fix_tag_50           VARCHAR2 (20),
    m87_fix_tag_142          VARCHAR2 (20),
    m87_fix_tag_57           VARCHAR2 (20),
    m87_fix_tag_115          VARCHAR2 (20),
    m87_fix_tag_116          VARCHAR2 (20),
    m87_fix_tag_128          VARCHAR2 (20),
    m87_fix_tag_22           VARCHAR2 (20),
    m87_fix_tag_109          VARCHAR2 (20),
    m87_fix_tag_100          VARCHAR2 (20)
)
/



-- End of DDL Script for Table DFN_NTP.M87_EXEC_BROKER_EXCHANGE

alter table dfn_ntp.M87_EXEC_BROKER_EXCHANGE
	add M87_CUSTOM_TYPE varchar2(50) default 1
/


ALTER TABLE dfn_ntp.m87_exec_broker_exchange ADD CONSTRAINT pk_m87_exec_broker_exchange
  PRIMARY KEY (
  m87_id
)
 ENABLE
 VALIDATE
/
