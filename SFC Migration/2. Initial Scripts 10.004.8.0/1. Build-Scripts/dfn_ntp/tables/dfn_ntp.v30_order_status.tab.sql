-- Table DFN_NTP.V30_ORDER_STATUS

CREATE TABLE dfn_ntp.v30_order_status
(
    v30_status_id                NVARCHAR2 (4),
    v30_description              NVARCHAR2 (50),
    v30_description_lang         NVARCHAR2 (50),
    v30_short_description        VARCHAR2 (12),
    v30_short_description_lang   VARCHAR2 (50)
)
/

-- Constraints for  DFN_NTP.V30_ORDER_STATUS


  ALTER TABLE dfn_ntp.v30_order_status MODIFY (v30_status_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v30_order_status MODIFY (v30_description NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v30_order_status MODIFY (v30_description_lang NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v30_order_status ADD CONSTRAINT v30_status_id_pk PRIMARY KEY (v30_status_id)
  USING INDEX  ENABLE
/



-- End of DDL Script for Table DFN_NTP.V30_ORDER_STATUS

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE dfn_ntp.v30_order_status
 ADD (
  v30_amend_allow NUMBER (1) DEFAULT 0
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('v30_order_status')
           AND column_name = UPPER ('v30_amend_allow');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE dfn_ntp.v30_order_status
 ADD (
  v30_cancel_allow NUMBER (1) DEFAULT 0
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('v30_order_status')
           AND column_name = UPPER ('v30_cancel_allow');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE dfn_ntp.v30_order_status
 ADD (
  v30_mapping_fix_status NVARCHAR2 (4)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('v30_order_status')
           AND column_name = UPPER ('v30_mapping_fix_status');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.V30_ORDER_STATUS  ADD (  V30_MANUAL_ORDER_EXEC_ALLOW NUMBER (1, 0) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('V30_ORDER_STATUS')
           AND column_name = UPPER ('V30_MANUAL_ORDER_EXEC_ALLOW');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.V30_ORDER_STATUS.V30_MANUAL_ORDER_EXEC_ALLOW IS '0=NOT, 1=ALLOW'
/