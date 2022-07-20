CREATE TABLE dfn_ntp.u13_ext_custody_portfolios
(
    u13_id                         NUMBER (10, 0) NOT NULL,
    u13_customer_id_u01            NUMBER (18, 0) NOT NULL,
    u13_name                       VARCHAR2 (20 BYTE) NOT NULL,
    u13_exg_broker_id_m105         NUMBER (5, 0) NOT NULL,
    u13_id_no                      VARCHAR2 (20 BYTE) NOT NULL,
    u13_exchange_acc               VARCHAR2 (20 BYTE) NOT NULL,
    u13_created_by_id_u17          NUMBER (20, 0) NOT NULL,
    u13_created_date               DATE NOT NULL,
    u13_modified_by_id_u17         NUMBER (20, 0),
    u13_modified_date              DATE,
    u13_status_id_v01              NUMBER (20, 0),
    u13_status_changed_by_id_u17   NUMBER (20, 0),
    u13_status_changed_date        DATE
)
/



ALTER TABLE dfn_ntp.u13_ext_custody_portfolios
ADD CONSTRAINT u13_ext_custody_portfolios_pk PRIMARY KEY (u13_id)
USING INDEX
/

alter table dfn_ntp.U13_EXT_CUSTODY_PORTFOLIOS
	add U13_CUSTOM_TYPE varchar2(50) default 1
/