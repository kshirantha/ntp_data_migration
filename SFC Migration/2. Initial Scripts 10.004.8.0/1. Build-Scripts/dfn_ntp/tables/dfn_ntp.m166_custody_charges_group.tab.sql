CREATE TABLE dfn_ntp.m166_custody_charges_group
(
    m166_id                          NUMBER (18, 0) NOT NULL,
    m166_name                        VARCHAR2 (50 BYTE) NOT NULL,
    m166_description                 VARCHAR2 (200 BYTE),
    m166_trans_charg_freq_v01        NUMBER (2, 0),
    m166_holding_charg_freq_v01      NUMBER (2, 0),
    m166_bill_trans_charg_freq_v01   NUMBER (2, 0),
    m166_type_v01                    NUMBER (2, 0),
    m166_created_by_id_u17           NUMBER (20, 0),
    m166_created_date                DATE,
    m166_modified_by_id_u17          NUMBER (20, 0),
    m166_modified_date               DATE,
    m166_status_id_v01               NUMBER (20, 0),
    m166_status_changed_by_id_u17    NUMBER (20, 0),
    m166_status_changed_date         DATE,
    m166_custom_type                 VARCHAR2 (50 BYTE),
    m166_institute_id_m02            NUMBER
)
/



COMMENT ON COLUMN dfn_ntp.m166_custody_charges_group.m166_bill_trans_charg_freq_v01 IS
    '1 - Daily , 2 Weekly , 3 - Monthly'
/
COMMENT ON COLUMN dfn_ntp.m166_custody_charges_group.m166_custom_type IS
    'Default =1'
/
COMMENT ON COLUMN dfn_ntp.m166_custody_charges_group.m166_holding_charg_freq_v01 IS
    '1 - Daily , 2 Weekly , 3 - Monthly'
/
COMMENT ON COLUMN dfn_ntp.m166_custody_charges_group.m166_id IS 'PK'
/
COMMENT ON COLUMN dfn_ntp.m166_custody_charges_group.m166_trans_charg_freq_v01 IS
    '1 - Daily , 2 Weekly , 3 - Monthly'
/
COMMENT ON COLUMN dfn_ntp.m166_custody_charges_group.m166_type_v01 IS
    '1- Custody transactional , 2 -Custody Holding , 3 - Pledge In , 4 - Pledge Out , 5 - Share Transfer'
/

CREATE TABLE dfn_ntp.m166_custody_charges_group_b
AS
    SELECT * FROM dfn_ntp.m166_custody_charges_group;

DELETE FROM dfn_ntp.m166_custody_charges_group;

COMMIT;

ALTER TABLE dfn_ntp.m166_custody_charges_group
 MODIFY (
  m166_institute_id_m02 NUMBER (3)

 )
/

INSERT INTO dfn_ntp.m166_custody_charges_group
    SELECT * FROM dfn_ntp.m166_custody_charges_group_b;

DROP TABLE dfn_ntp.m166_custody_charges_group_b;

COMMIT;