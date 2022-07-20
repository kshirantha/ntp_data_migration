-- Table DFN_NTP.M25_COMMISSION_DISCOUNT_SLABS

CREATE TABLE dfn_ntp.m25_commission_discount_slabs
(
    m25_id                         NUMBER (10, 0) DEFAULT NULL,
    m25_discount_group_id_m24      NUMBER (10, 0),
    m25_channel_id_v29             NUMBER (5, 0),
    m25_instrument_type_id_v09     VARCHAR2 (4),
    m25_percentage                 NUMBER (18, 5) DEFAULT 0,
    m25_flat_discount              NUMBER (18, 5) DEFAULT 0,
    m25_starting_date              DATE,
    m25_ending_date                DATE,
    m25_is_active                  NUMBER (1, 0) DEFAULT 0,
    m25_from                       NUMBER (18, 5) DEFAULT 0,
    m25_to                         NUMBER (18, 5) DEFAULT 0,
    m25_disc_type                  NUMBER (2, 0) DEFAULT 0,
    m25_frequency                  NUMBER (1, 0) DEFAULT 1,
    m25_created_by_id_u17          NUMBER (10, 0),
    m25_created_date               DATE,
    m25_modified_by_id_u17         NUMBER (10, 0),
    m25_modified_date              DATE,
    m25_status_id_v01              NUMBER (3, 0),
    m25_status_changed_by_id_u17   NUMBER (10, 0),
    m25_status_changed_date        DATE,
    m25_min_discount               NUMBER (18, 5),
    m25_currency_id_m03            NUMBER (5, 0),
    m25_currency_code_m03          VARCHAR2 (5),
    m25_instrument_type_code_v09   VARCHAR2 (5)
)
/

-- Constraints for  DFN_NTP.M25_COMMISSION_DISCOUNT_SLABS


  ALTER TABLE dfn_ntp.m25_commission_discount_slabs MODIFY (m25_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m25_commission_discount_slabs MODIFY (m25_discount_group_id_m24 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m25_commission_discount_slabs MODIFY (m25_channel_id_v29 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m25_commission_discount_slabs MODIFY (m25_instrument_type_id_v09 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m25_commission_discount_slabs MODIFY (m25_percentage NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m25_commission_discount_slabs MODIFY (m25_flat_discount NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m25_commission_discount_slabs MODIFY (m25_from NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m25_commission_discount_slabs MODIFY (m25_to NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m25_commission_discount_slabs MODIFY (m25_disc_type NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M25_COMMISSION_DISCOUNT_SLABS

alter table dfn_ntp.M25_COMMISSION_DISCOUNT_SLABS
	add M25_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m25_commission_discount_slabs
ADD m25_instrument_type_id_v09_t NUMBER(4)
/

UPDATE dfn_ntp.m25_commission_discount_slabs
   SET m25_instrument_type_id_v09_t = m25_instrument_type_id_v09;

ALTER TABLE dfn_ntp.m25_commission_discount_slabs MODIFY m25_instrument_type_id_v09 NULL
/

UPDATE dfn_ntp.m25_commission_discount_slabs
   SET m25_instrument_type_id_v09 = NULL;
   
ALTER TABLE dfn_ntp.m25_commission_discount_slabs
MODIFY m25_instrument_type_id_v09 NUMBER(4)
/ 

UPDATE dfn_ntp.m25_commission_discount_slabs
   SET m25_instrument_type_id_v09 = m25_instrument_type_id_v09_t;


ALTER TABLE dfn_ntp.m25_commission_discount_slabs
DROP COLUMN m25_instrument_type_id_v09_t
/

ALTER TABLE dfn_ntp.m25_commission_discount_slabs
MODIFY m25_instrument_type_id_v09 NOT NULL
/