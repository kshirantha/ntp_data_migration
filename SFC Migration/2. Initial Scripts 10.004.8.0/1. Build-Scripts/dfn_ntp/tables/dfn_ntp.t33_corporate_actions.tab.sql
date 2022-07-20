CREATE TABLE dfn_ntp.t33_corporate_actions
(
    t33_broker_code                VARCHAR2 (100 BYTE),
    t33_equator_no                 VARCHAR2 (100 BYTE),
    t33_symbol                     VARCHAR2 (100 BYTE),
    t33_isin                       VARCHAR2 (100 BYTE),
    t33_current_qty                VARCHAR2 (100 BYTE),
    t33_available_qty              VARCHAR2 (100 BYTE),
    t33_pledged_qty                VARCHAR2 (100 BYTE),
    t33_position_date              VARCHAR2 (100 BYTE),
    t33_change_date                VARCHAR2 (100 BYTE),
    t33_primary_institute_id_m02   NUMBER (3, 0)
)
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_ntp.t33_corporate_actions 
 ADD (
  t33_batch_id_t80 NUMBER(20,0)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('T33_CORPORATE_ACTIONS')
           AND column_name = UPPER ('T33_BATCH_ID_T80');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
