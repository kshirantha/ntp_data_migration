CREATE TABLE dfn_ntp.m31_exec_broker_routing
(
    m31_exchange_code_m01          VARCHAR2 (10 BYTE),
    m31_routing_data_id_m19        NUMBER (4, 0),
    m31_id                         NUMBER (5, 0),
    m31_fix_tag_50                 VARCHAR2 (20 BYTE),
    m31_fix_tag_142                VARCHAR2 (20 BYTE),
    m31_fix_tag_57                 VARCHAR2 (20 BYTE),
    m31_fix_tag_115                VARCHAR2 (20 BYTE),
    m31_fix_tag_116                VARCHAR2 (20 BYTE),
    m31_fix_tag_128                VARCHAR2 (20 BYTE),
    m31_fix_tag_22                 VARCHAR2 (20 BYTE),
    m31_fix_tag_109                VARCHAR2 (20 BYTE),
    m31_fix_tag_100                VARCHAR2 (20 BYTE),
    m31_fix_tag_49                 VARCHAR2 (20 BYTE),
    m31_fix_tag_56                 VARCHAR2 (20 BYTE),
    m31_exchange_id_m01            NUMBER (5, 0),
    m31_exec_broker_id_m26         NUMBER (5, 0),
    m31_market_code                VARCHAR2 (10 BYTE),
    m31_is_active                  NUMBER (1, 0),
    m31_created_by_id_u17          NUMBER (10, 0),
    m31_created_date               DATE,
    m31_modified_by_id_u17         NUMBER (10, 0),
    m31_modified_date              DATE,
    m31_status_id_v01              NUMBER (5, 0),
    m31_status_changed_by_id_u17   NUMBER (10, 0),
    m31_status_changed_date        DATE,
    m31_connect_status             NUMBER (1, 0),
    m31_institute_id               NUMBER (3, 0),
    m31_type                       NUMBER (6, 0) DEFAULT 1 NOT NULL,
    m31_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    m31_market_id_m29              NUMBER (10, 0)
)
/

ALTER TABLE dfn_ntp.m31_exec_broker_routing
ADD CONSTRAINT m31_pk PRIMARY KEY (m31_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m31_exec_broker_routing.m31_type IS
    '1= Trading,2= uMsg,3=AlgoOrders'
/

ALTER TABLE dfn_ntp.m31_exec_broker_routing
 ADD (
  m31_board_code_m54 VARCHAR2 (6)
 )
/

ALTER TABLE dfn_ntp.m31_exec_broker_routing
 ADD (
  m31_custom_message NUMBER (1) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.m31_exec_broker_routing.m31_custom_message IS
    '0 - No | 1 - Yes'
/

ALTER TABLE dfn_ntp.m31_exec_broker_routing
 MODIFY (
  m31_board_code_m54 VARCHAR2 (10 BYTE)

 )
/

