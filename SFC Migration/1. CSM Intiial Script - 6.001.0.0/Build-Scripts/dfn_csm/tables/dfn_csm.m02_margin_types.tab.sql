DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE dfn_csm.m02_margin_types';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('m02_margin_types');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.m02_margin_types
(
    m02_id            NUMBER (10, 0) NOT NULL,
    m02_margin_type   VARCHAR2 (200 BYTE),
    m02_description   VARCHAR2 (500 BYTE)
)
/



ALTER TABLE dfn_csm.m02_margin_types
ADD CONSTRAINT pk_m02_id PRIMARY KEY (m02_id)
USING INDEX
/

COMMENT ON COLUMN dfn_csm.m02_margin_types.m02_id IS 'PK'
/
