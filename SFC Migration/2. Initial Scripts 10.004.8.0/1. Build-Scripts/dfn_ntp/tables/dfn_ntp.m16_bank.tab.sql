CREATE TABLE dfn_ntp.m16_bank
(
    m16_id                         NUMBER (5, 0) NOT NULL,
    m16_name                       VARCHAR2 (100 BYTE) NOT NULL,
    m16_name_lang                  VARCHAR2 (100 BYTE) NOT NULL,
    m16_swift_code                 VARCHAR2 (50 BYTE) NOT NULL,
    m16_bank_identifier            VARCHAR2 (20 BYTE),
    m16_created_by_id_u17          NUMBER (10, 0) NOT NULL,
    m16_created_date               TIMESTAMP (6) NOT NULL,
    m16_status_id_v01              NUMBER (5, 0) NOT NULL,
    m16_modified_by_id_u17         NUMBER (10, 0),
    m16_modified_date              TIMESTAMP (6),
    m16_status_changed_by_id_u17   NUMBER (10, 0),
    m16_status_changed_date        TIMESTAMP (6),
    m16_external_ref               VARCHAR2 (20 BYTE),
    m16_address                    NVARCHAR2 (255),
    m16_aba_routing_no             VARCHAR2 (20 BYTE),
    m16_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    m16_institute_id_m02           NUMBER (3, 0) DEFAULT 1,
    PRIMARY KEY (m16_id)
)
/

ALTER TABLE dfn_ntp.m16_bank
 ADD (
  m16_external_reference VARCHAR2 (50)
 )
/

DECLARE
    l_is_nullable   NUMBER := 0;
    l_script        VARCHAR2 (1000)
        := 'ALTER TABLE DFN_NTP.M16_BANK MODIFY (M16_SWIFT_CODE NULL)';
BEGIN
    SELECT DECODE (nullable, 'Y', 1, 0)
      INTO l_is_nullable
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('M16_BANK')
           AND column_name = UPPER ('M16_SWIFT_CODE');

    IF l_is_nullable = 0
    THEN
        EXECUTE IMMEDIATE l_script;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE DFN_NTP.M16_BANK
 ADD (
  M16_COUNTRY_ID_M05 NUMBER (5)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('M16_BANK')
           AND column_name = UPPER ('M16_COUNTRY_ID_M05');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE dfn_ntp.m16_bank DROP COLUMN m16_external_reference';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('M16_BANK')
           AND column_name = UPPER ('M16_EXTERNAL_REFERENCE');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
