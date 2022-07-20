CREATE TABLE dfn_ntp.m85_approval_columns
(
    m85_id                        NUMBER (5, 0),
    m85_table_id_m53              NUMBER (5, 0),
    m85_column_name               VARCHAR2 (50 BYTE),
    m85_column_description        VARCHAR2 (100 BYTE),
    m85_column_description_lang   VARCHAR2 (100 BYTE),
    m85_column_type               NUMBER (1, 0),
    m85_column_format             VARCHAR2 (50 BYTE),
    m85_is_child_column           NUMBER (1, 0) DEFAULT 0,
    m85_is_parent                 NUMBER (1, 0) DEFAULT 0,
    m85_custom_type               VARCHAR2 (50 BYTE) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.m85_approval_columns
ADD CONSTRAINT pk_m85 PRIMARY KEY (m85_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m85_approval_columns.m85_is_child_column IS
    '0 - No | 1- Yes'
/
COMMENT ON COLUMN dfn_ntp.m85_approval_columns.m85_is_parent IS
    '0 - No | 1- Yes'
/