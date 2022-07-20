CREATE TABLE dfn_ntp.m26_executing_broker
(
    m26_id                           NUMBER (5, 0) NOT NULL,
    m26_name                         VARCHAR2 (255 BYTE) NOT NULL,
    m26_pobox                        NVARCHAR2 (255),
    m26_street_address_1             NVARCHAR2 (255),
    m26_street_address_2             NVARCHAR2 (255),
    m26_city_id_m06                  NUMBER (5, 0),
    m26_zip                          VARCHAR2 (50 BYTE),
    m26_office_tel_1                 VARCHAR2 (20 BYTE),
    m26_office_tel_2                 VARCHAR2 (20 BYTE),
    m26_fax                          VARCHAR2 (20 BYTE),
    m26_email                        VARCHAR2 (50 BYTE),
    m26_type                         NUMBER (1, 0) DEFAULT 1 NOT NULL,
    m26_created_by_id_u17            NUMBER (10, 0),
    m26_created_date                 DATE DEFAULT NULL NOT NULL,
    m26_lastupdated_by_id_u17        NUMBER (10, 0),
    m26_lastupdated_date             DATE DEFAULT SYSDATE NOT NULL,
    m26_status_id_v01                NUMBER (20, 0) DEFAULT 0 NOT NULL,
    m26_status_changed_by_id_u17     NUMBER (10, 0),
    m26_status_changed_date          DATE DEFAULT SYSDATE NOT NULL,
    m26_sid                          VARCHAR2 (75 BYTE),
    m26_fix_tag_50                   VARCHAR2 (20 BYTE),
    m26_fix_tag_142                  VARCHAR2 (20 BYTE),
    m26_fix_tag_57                   VARCHAR2 (20 BYTE),
    m26_fix_tag_115                  VARCHAR2 (20 BYTE),
    m26_fix_tag_116                  VARCHAR2 (20 BYTE),
    m26_fix_tag_128                  VARCHAR2 (20 BYTE),
    m26_fix_tag_22                   VARCHAR2 (20 BYTE),
    m26_fix_tag_109                  VARCHAR2 (20 BYTE),
    m26_fix_tag_100                  VARCHAR2 (20 BYTE),
    m26_country_id_m05               NUMBER (5, 0),
    m26_custom_type                  VARCHAR2 (50 BYTE) DEFAULT 1,
    m26_institution_id_m02           NUMBER (3, 0) DEFAULT 1,
    m26_trans_chrg_grp_id_m166       NUMBER (18, 0),
    m26_hold_chrg_grp_id_m166        NUMBER (18, 0),
    m26_pled_in_chrg_grp_id_m166     NUMBER (18, 0),
    m26_pled_out_chrg_grp_id_m166    NUMBER (18, 0),
    m26_shar_tran_chrg_grp_id_m166   NUMBER (18, 0),
    m26_hold_chrg_last_pay_date      DATE,
    PRIMARY KEY (m26_id)
)
/

COMMENT ON COLUMN dfn_ntp.m26_executing_broker.m26_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.m26_executing_broker.m26_institution_id_m02 IS
    'Primary Institution'
/
COMMENT ON COLUMN dfn_ntp.m26_executing_broker.m26_name IS
    'name of the institution'
/
COMMENT ON COLUMN dfn_ntp.m26_executing_broker.m26_pobox IS 'PO box'
/
COMMENT ON COLUMN dfn_ntp.m26_executing_broker.m26_sid IS
    'Code in Trade Server'
/
COMMENT ON COLUMN dfn_ntp.m26_executing_broker.m26_street_address_1 IS
    'street adress part 1'
/
COMMENT ON COLUMN dfn_ntp.m26_executing_broker.m26_street_address_2 IS
    'street adress part 2'
/
COMMENT ON COLUMN dfn_ntp.m26_executing_broker.m26_type IS
    '1=Broker, 2=Custody, 3=Broker-Custody'
/

UPDATE dfn_ntp.m26_executing_broker
   SET m26_created_by_id_u17 = 0
 WHERE m26_created_by_id_u17 IS NULL;

UPDATE dfn_ntp.m26_executing_broker
   SET m26_status_changed_by_id_u17 = 0
 WHERE m26_status_changed_by_id_u17 IS NULL;

COMMIT;

ALTER TABLE dfn_ntp.m26_executing_broker
 MODIFY (
  m26_created_by_id_u17 NOT NULL,
  m26_lastupdated_date NULL,
  m26_status_changed_by_id_u17 NOT NULL
 )
/
CREATE INDEX dfn_ntp.idx_m26_type
    ON dfn_ntp.m26_executing_broker (m26_type)
/

CREATE INDEX dfn_ntp.idx_m26_fast
    ON dfn_ntp.m26_executing_broker (m26_id, m26_name, m26_type)
/

ALTER TABLE dfn_ntp.m26_executing_broker
 ADD (
  m26_clearing_type_c NUMBER (1),
  m26_is_default_clearing_type_c NUMBER (1)
 )
/
COMMENT ON COLUMN dfn_ntp.m26_executing_broker.m26_clearing_type_c IS
    '0 - None | 1 - NCM | 2  - DCM'
/
COMMENT ON COLUMN dfn_ntp.m26_executing_broker.m26_is_default_clearing_type_c IS
    '0 - No | 1 - Yes'
/