CREATE TABLE dfn_ntp.m99_notification_items
(
    m99_id                     NUMBER (3, 0),
    m99_description            VARCHAR2 (75 BYTE),
    m99_notify_as_it_happens   NUMBER (2, 0),
    m99_item_type              NUMBER (2, 0)
)
/

COMMENT ON TABLE dfn_ntp.m99_notification_items IS
    'Use IDs greater than 100  for customizations'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE DFN_NTP.M99_NOTIFICATION_ITEMS ADD CONSTRAINT PK_M99_NOTIFICATION_ITEMS PRIMARY KEY ( M99_ID)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_constraints
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m99_notification_items')
           AND constraint_name = UPPER ('pk_m99_notification_items');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE M99_NOTIFICATION_ITEMS ADD ( M99_ALLOWED NUMBER (2) DEFAULT 0)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m99_notification_items')
           AND column_name = UPPER ('m99_allowed');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
