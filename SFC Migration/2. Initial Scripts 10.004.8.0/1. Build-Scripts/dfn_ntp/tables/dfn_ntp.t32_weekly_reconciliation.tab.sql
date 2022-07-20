CREATE TABLE dfn_ntp.t32_weekly_reconciliation
(
    t32_broker_code                VARCHAR2 (100 BYTE),
    t32_equator_no                 VARCHAR2 (100 BYTE),
    t32_symbol                     VARCHAR2 (100 BYTE),
    t32_isin                       VARCHAR2 (100 BYTE),
    t32_current_qty                VARCHAR2 (100 BYTE),
    t32_available_qty              VARCHAR2 (100 BYTE),
    t32_pledged_qty                VARCHAR2 (100 BYTE),
    t32_position_date              VARCHAR2 (100 BYTE),
    t32_change_date                VARCHAR2 (100 BYTE),
    t32_primary_institute_id_m02   NUMBER (3, 0)
)
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE dfn_ntp.T32_WEEKLY_RECONCILIATION 
 ADD (
  T32_BATCH_ID_T80 NUMBER(20,0)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('T32_WEEKLY_RECONCILIATION')
           AND column_name = UPPER ('T32_BATCH_ID_T80');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/