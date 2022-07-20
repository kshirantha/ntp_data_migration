CREATE TABLE dfn_ntp.m132_market_maker_grp_details
(
    m132_id                         NUMBER (10, 0) NOT NULL,
    m132_market_maker_grp_id_m131   NUMBER (10, 0) NOT NULL,
    m132_exchange_id_m01            NUMBER (10, 0),
    m132_exchange_code_m01          VARCHAR2 (50 BYTE),
    m132_symbol_id_m20              NUMBER (10, 0),
    m132_symbol_code_m20            VARCHAR2 (50 BYTE),
    m132_trader_id                  VARCHAR2 (20 BYTE),
    m132_created_by_id_u17          NUMBER (10, 0),
    m132_created_date               DATE
)
/


ALTER TABLE dfn_ntp.m132_market_maker_grp_details
    ADD CONSTRAINT pk_m132_mrkt_maker_grp_details PRIMARY KEY (m132_id)
        USING INDEX
/

ALTER TABLE dfn_ntp.m132_market_maker_grp_details
    ADD CONSTRAINT fk_m132_created_by_id_u17 FOREIGN KEY
            (m132_created_by_id_u17)
             REFERENCES dfn_ntp.u17_employee (u17_id)
/

ALTER TABLE dfn_ntp.m132_market_maker_grp_details
    ADD CONSTRAINT fk_m132_symbol_id_m20 FOREIGN KEY (m132_symbol_id_m20)
             REFERENCES dfn_ntp.m20_symbol (m20_id)
/

ALTER TABLE dfn_ntp.m132_market_maker_grp_details
    ADD CONSTRAINT fk_m132_exchange_id_m01 FOREIGN KEY (m132_exchange_id_m01)
             REFERENCES dfn_ntp.m01_exchanges (m01_id)
/

ALTER TABLE dfn_ntp.m132_market_maker_grp_details
    ADD CONSTRAINT fk_m132_mrkt_maker_grp_id_m131 FOREIGN KEY
            (m132_market_maker_grp_id_m131)
             REFERENCES dfn_ntp.m131_market_maker_grps (m131_id)
/

ALTER TABLE M132_MARKET_MAKER_GRP_DETAILS 
 ADD (
  M132_MODIFIED_BY_ID_U17 NUMBER (10, 0),
  M132_MODIFIED_DATE DATE
 )
/

ALTER TABLE DFN_NTP.M132_MARKET_MAKER_GRP_DETAILS ADD CONSTRAINT FK_M132_MODIFIED_BY_ID_U17
  FOREIGN KEY (
M132_MODIFIED_BY_ID_U17
)
 REFERENCES DFN_NTP.U17_EMPLOYEE
 (
U17_ID
) 
 ENABLE 
 VALIDATE 
/

alter table dfn_ntp.M132_MARKET_MAKER_GRP_DETAILS
	add M132_CUSTOM_TYPE varchar2(50) default 1
/
