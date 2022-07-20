-- Table DFN_NTP.M03_CURRENCY

CREATE TABLE dfn_ntp.m03_currency
(
    m03_code                        CHAR (3),
    m03_description                 VARCHAR2 (50),
    m03_description_lang            VARCHAR2 (50),
    m03_sub_unit_description        VARCHAR2 (50),
    m03_decimal_places              NUMBER (2, 0),
    m03_display_format              VARCHAR2 (50),
    m03_created_by_id_u17           NUMBER (10, 0),
    m03_created_date                TIMESTAMP (6),
    m03_status_id_v01               NUMBER (5, 0),
    m03_modified_by_id_u17          NUMBER (10, 0),
    m03_modified_date               TIMESTAMP (6),
    m03_status_changed_by_id_u17    NUMBER (10, 0),
    m03_id                          NUMBER (5, 0),
    m03_status_changed_date         TIMESTAMP (6),
    m03_sub_unit_description_lang   VARCHAR2 (50),
    PRIMARY KEY (m03_code) ENABLE NOVALIDATE
)
ORGANIZATION INDEX
NOCOMPRESS
/

-- Constraints for  DFN_NTP.M03_CURRENCY


  ALTER TABLE dfn_ntp.m03_currency MODIFY (m03_code NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m03_currency MODIFY (m03_description NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m03_currency MODIFY (m03_description_lang NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m03_currency MODIFY (m03_sub_unit_description NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m03_currency MODIFY (m03_decimal_places NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m03_currency MODIFY (m03_display_format NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m03_currency MODIFY (m03_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m03_currency MODIFY (m03_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m03_currency MODIFY (m03_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m03_currency MODIFY (m03_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m03_currency MODIFY (m03_status_changed_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m03_currency MODIFY (m03_status_changed_date NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M03_CURRENCY

alter table dfn_ntp.M03_CURRENCY
	add M03_CUSTOM_TYPE varchar2(50) default 1
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_ntp.m03_currency
 ADD (
  m03_enable_netreceivale NUMBER (1) DEFAULT 0
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m03_currency')
           AND column_name = UPPER ('m03_enable_netreceivale');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.m03_currency.m03_enable_netreceivale IS
    '0=Receivable, 1= Net Receivable';
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE DFN_NTP.M03_CURRENCY 
 ADD (
  M03_TRANSATION_DISABLED NUMBER (1) DEFAULT 0
 )
';
BEGIN
    SELECT COUNT (*)
    INTO l_count
    FROM all_tab_columns
    WHERE     owner = UPPER ('DFN_NTP')
          AND table_name = UPPER ('M03_CURRENCY')
          AND column_name = UPPER ('M03_TRANSATION_DISABLED');

    IF l_count = 0
    THEN
        DBMS_OUTPUT.put_line (l_ddl);

        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'COMMENT ON COLUMN DFN_NTP.M03_CURRENCY.M03_TRANSATION_DISABLED IS ''0 - No, 1 - Yes''';
BEGIN
    SELECT COUNT (*)
    INTO l_count
    FROM all_tab_columns
    WHERE     owner = UPPER ('DFN_NTP')
          AND table_name = UPPER ('M03_CURRENCY')
          AND column_name = UPPER ('M03_TRANSATION_DISABLED');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/