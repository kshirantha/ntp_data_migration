CREATE TABLE dfn_ntp.m131_market_maker_grps
(
    m131_id                         NUMBER (10, 0) NOT NULL,
    m131_name                       VARCHAR2 (200 BYTE) NOT NULL,
    m131_created_by_id_u17          NUMBER (10, 0),
    m131_created_date               DATE,
    m131_modified_by_id_u17         NUMBER (10, 0),
    m131_modified_date              DATE,
    m131_status_id_v01              NUMBER (5, 0),
    m131_status_changed_by_id_u17   NUMBER (10, 0),
    m131_status_changed_date        DATE
)
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING
/



ALTER TABLE dfn_ntp.m131_market_maker_grps
    ADD CONSTRAINT pk_m131_market_maker_grps PRIMARY KEY (m131_id)
        USING INDEX
/

ALTER TABLE dfn_ntp.m131_market_maker_grps
    ADD CONSTRAINT fk_m131_status_chged_by_id_u17 FOREIGN KEY
            (m131_status_changed_by_id_u17)
             REFERENCES dfn_ntp.u17_employee (u17_id)
/

ALTER TABLE dfn_ntp.m131_market_maker_grps
    ADD CONSTRAINT fk_m131_modified_by_id_u17 FOREIGN KEY
            (m131_modified_by_id_u17)
             REFERENCES dfn_ntp.u17_employee (u17_id)
/

ALTER TABLE dfn_ntp.m131_market_maker_grps
    ADD CONSTRAINT fk_m131_created_by_id_u17 FOREIGN KEY
            (m131_created_by_id_u17)
             REFERENCES dfn_ntp.u17_employee (u17_id)
/

alter table dfn_ntp.M131_MARKET_MAKER_GRPS
	add M131_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m131_market_maker_grps
 ADD (
  m131_institute_id_m02 NUMBER (3)
 )
/

ALTER TABLE dfn_ntp.m131_market_maker_grps
    MODIFY (m131_institute_id_m02 DEFAULT 1)
/