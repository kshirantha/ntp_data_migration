CREATE TABLE dfn_ntp.m19_routing_data
(
    m19_id                          NUMBER (4, 0),
    m19_connection_status           NUMBER (2, 0) DEFAULT 0,
    m19_fix_tag_49                  VARCHAR2 (20 BYTE),
    m19_fix_tag_56                  VARCHAR2 (20 BYTE),
    m19_fix_tag_50                  VARCHAR2 (20 BYTE),
    m19_connection_alias            VARCHAR2 (6 BYTE),
    m19_fix_tag_142                 VARCHAR2 (20 BYTE),
    m19_created_by_id_u17           NUMBER (5, 0),
    m19_created_date                DATE,
    m19_modified_by_id_u17          NUMBER (5, 0),
    m19_modified_date               DATE,
    m19_status_id_v01               NUMBER (5, 0),
    m19_status_changed_by_id_u17    NUMBER (5, 0),
    m19_status_changed_date         DATE,
    m19_custom_type                 VARCHAR2 (50 BYTE) DEFAULT 1,
    m19_primary_institute_id_m02    NUMBER (3, 0),
    m19_default_exchange_code_m01   VARCHAR2 (10 BYTE),
    m19_default_exchange_id_m01     NUMBER (5, 0)
)
/

ALTER TABLE dfn_ntp.m19_routing_data
ADD PRIMARY KEY (m19_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m19_routing_data.m19_connection_status IS
    '0 - Disconnected, 1-Connected'
/

ALTER TABLE dfn_ntp.M19_ROUTING_DATA 
 ADD (
  M19_GMT_OFFSET_TRADE NUMBER (6, 2) DEFAULT NULL
 )
/
COMMENT ON COLUMN dfn_ntp.M19_ROUTING_DATA.M19_GMT_OFFSET_TRADE IS 'Order transaction time GMT adjustment'
/

ALTER TABLE dfn_ntp.M19_ROUTING_DATA
 ADD (
  M19_OVERWRITE_TAG_50 NUMBER (5, 0) DEFAULT 1
  )
 /
COMMENT ON COLUMN dfn_ntp.M19_ROUTING_DATA.M19_OVERWRITE_TAG_50 IS '0-Not Overwrite, 1-Overwrite(Default)'
/ 