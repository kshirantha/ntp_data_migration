-- Table DFN_NTP.M27_IB_COMMISSION_STRUCTURES

CREATE TABLE dfn_ntp.m27_ib_commission_structures
(
    m27_id                         NUMBER (20, 0),
    m27_ib_grp_id_m21              NUMBER (20, 0),
    m27_exchange_code_m01          VARCHAR2 (20),
    m27_exchange_id_m01            NUMBER (20, 0),
    m27_comm_group_id_m22          NUMBER (5, 0),
    m27_created_by_id_u17          NUMBER (5, 0),
    m27_created_date               DATE,
    m27_modified_by_id_u17         NUMBER (5, 0),
    m27_modified_date              DATE,
    m27_status_id_v01              NUMBER (20, 0),
    m27_status_changed_date        DATE,
    m27_status_changed_by_id_u17   NUMBER (20, 0)
)
/

-- Constraints for  DFN_NTP.M27_IB_COMMISSION_STRUCTURES


  ALTER TABLE dfn_ntp.m27_ib_commission_structures MODIFY (m27_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m27_ib_commission_structures MODIFY (m27_ib_grp_id_m21 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m27_ib_commission_structures MODIFY (m27_exchange_id_m01 NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M27_IB_COMMISSION_STRUCTURES

alter table dfn_ntp.M27_IB_COMMISSION_STRUCTURES
	add M27_CUSTOM_TYPE varchar2(50) default 1
/