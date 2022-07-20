CREATE TABLE dfn_ntp.u05_customer_identification
(
    u05_id                         NUMBER (5, 0) NOT NULL,
    u05_identity_type_id_m15       NUMBER (5, 0) NOT NULL,
    u05_customer_id_u01            NUMBER (10, 0) NOT NULL,
    u05_id_no                      VARCHAR2 (20 BYTE) NOT NULL,
    u05_issue_date                 DATE NOT NULL,
    u05_issue_location_id_m14      NUMBER (5, 0) NOT NULL,
    u05_expiry_date                DATE NOT NULL,
    u05_is_default                 NUMBER (1, 0) NOT NULL,
    u05_created_by_id_u17          NUMBER (10, 0),
    u05_created_date               TIMESTAMP (6),
    u05_status_id_v01              NUMBER (5, 0),
    u05_modified_by_id_u17         NUMBER (10, 0),
    u05_modified_date              TIMESTAMP (6),
    u05_status_changed_by_id_u17   NUMBER (10, 0),
    u05_status_changed_date        TIMESTAMP (6),
    u05_custom_type                VARCHAR2 (20 BYTE),
    u05_issue_date1                DATE,
    CONSTRAINT pk_u05_01 PRIMARY KEY (u05_id)
)
SEGMENT CREATION IMMEDIATE
ORGANIZATION INDEX

/


CREATE INDEX dfn_ntp.ix_u05_cust_id_u01
    ON dfn_ntp.u05_customer_identification (u05_customer_id_u01 ASC)
    NOPARALLEL
    LOGGING
/

CREATE INDEX dfn_ntp.ix_u05_id_no
    ON dfn_ntp.u05_customer_identification (u05_id_no ASC)
    NOPARALLEL
    LOGGING
/


COMMENT ON COLUMN dfn_ntp.u05_customer_identification.u05_custom_type IS
    'To support customization'
/
COMMENT ON COLUMN dfn_ntp.u05_customer_identification.u05_issue_date1 IS
    'To test customization'
/

ALTER TABLE dfn_ntp.u05_customer_identification
DROP COLUMN u05_issue_date1
/

ALTER TABLE dfn_ntp.u05_customer_identification
 MODIFY (
  u05_id NUMBER (10, 0)

 )
/

DECLARE
    l_is_nullable   NUMBER := 0;
    l_script        VARCHAR2 (1000)
        := 'ALTER TABLE DFN_NTP.U05_CUSTOMER_IDENTIFICATION MODIFY (U05_ISSUE_DATE NULL)';
BEGIN
    SELECT DECODE (nullable, 'Y', 1, 0)
      INTO l_is_nullable
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('U05_CUSTOMER_IDENTIFICATION')
           AND column_name = UPPER ('U05_ISSUE_DATE');

    IF l_is_nullable = 0
    THEN
        EXECUTE IMMEDIATE l_script;
    END IF;
END;
/



DECLARE
    l_is_nullable   NUMBER := 0;
    l_script        VARCHAR2 (1000)
        := 'ALTER TABLE DFN_NTP.U05_CUSTOMER_IDENTIFICATION MODIFY (U05_ISSUE_LOCATION_ID_M14 NULL)';
BEGIN
    SELECT DECODE (nullable, 'Y', 1, 0)
      INTO l_is_nullable
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('U05_CUSTOMER_IDENTIFICATION')
           AND column_name = UPPER ('U05_ISSUE_LOCATION_ID_M14');

    IF l_is_nullable = 0
    THEN
        EXECUTE IMMEDIATE l_script;
    END IF;
END;
/