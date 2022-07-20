CREATE TABLE dfn_ntp.v19_board_status
(
    v19_id                 NUMBER (2, 0) NOT NULL,
    v19_status             VARCHAR2 (100 BYTE),
    v19_price_mapping_id   NUMBER (2, 0)
)
/

ALTER TABLE dfn_ntp.v19_board_status
ADD CONSTRAINT v19_brd_pk PRIMARY KEY (v19_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.v19_board_status.v19_id IS 'fk'
/
COMMENT ON COLUMN dfn_ntp.v19_board_status.v19_price_mapping_id IS
    'Price Feed''s Mapping Required for DT'
/
