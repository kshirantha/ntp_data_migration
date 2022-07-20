CREATE TABLE dfn_ntp.v08_sub_asset_type
(
    v08_id                 NUMBER (2, 0),
    v08_code               VARCHAR2 (50 BYTE),
    v08_description        VARCHAR2 (150 BYTE),
    v08_description_lang   VARCHAR2 (150 BYTE)
)
/

ALTER TABLE dfn_ntp.v08_sub_asset_type
ADD CONSTRAINT vo8_pk PRIMARY KEY (v08_id)
USING INDEX
/