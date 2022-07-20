-- Table DFN_NTP.M30_EX_MARKET_PERMISSIONS

CREATE TABLE dfn_ntp.m30_ex_market_permissions
(
    m30_market_code_m29          VARCHAR2 (10),
    m30_market_status_id_v19     NUMBER (2, 0),
    m30_exchange_code_m01        VARCHAR2 (10),
    m30_id                       NUMBER (10, 0),
    m30_cancel_order_allowed     NUMBER (1, 0),
    m30_amend_order_allowed      NUMBER (1, 0),
    m30_create_order_allowed     NUMBER (1, 0),
    m30_exchange_id_m01          NUMBER (10, 0),
    m30_exchange_status_id_m59   NUMBER (10, 0)
)
/

-- Constraints for  DFN_NTP.M30_EX_MARKET_PERMISSIONS


  ALTER TABLE dfn_ntp.m30_ex_market_permissions MODIFY (m30_id NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M30_EX_MARKET_PERMISSIONS

alter table dfn_ntp.M30_EX_MARKET_PERMISSIONS
	add M30_CUSTOM_TYPE varchar2(50) default 1
/
