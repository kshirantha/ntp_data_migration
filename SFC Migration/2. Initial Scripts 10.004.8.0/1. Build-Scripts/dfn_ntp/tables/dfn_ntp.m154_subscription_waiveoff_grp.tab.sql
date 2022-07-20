CREATE TABLE dfn_ntp.m154_subscription_waiveoff_grp
(
    m154_id                         NUMBER (5, 0),
    m154_name                       VARCHAR2 (200 BYTE),
    m154_name_lang                  VARCHAR2 (400 BYTE),
    m154_institution_id_m02         NUMBER (3, 0),
    m154_created_by_id_u17          NUMBER (10, 0) NOT NULL,
    m154_created_date               DATE NOT NULL,
    m154_status_id_v01              NUMBER (5, 0) NOT NULL,
    m154_modified_by_id_u17         NUMBER (10, 0),
    m154_modified_date              DATE,
    m154_status_changed_by_id_u17   NUMBER (10, 0),
    m154_status_changed_date        DATE,
    m154_custom_type                VARCHAR2 (20 BYTE) DEFAULT 1
)
/



ALTER TABLE dfn_ntp.m154_subscription_waiveoff_grp
    ADD CONSTRAINT m154_pk PRIMARY KEY (m154_id) USING INDEX
/

ALTER TABLE dfn_ntp.m154_subscription_waiveoff_grp
    ADD CONSTRAINT m154_uk UNIQUE (m154_institution_id_m02, m154_name)
        USING INDEX
/

ALTER TABLE dfn_ntp.m154_subscription_waiveoff_grp
 ADD (
  m154_product_ids_v35_c VARCHAR2 (20)
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m154_subscription_waiveoff_grp DROP COLUMN m154_product_ids_v35_c';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m154_subscription_waiveoff_grp')
           AND column_name = UPPER ('m154_product_ids_v35_c');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/