CREATE TABLE dfn_ntp.m59_exchange_board_status
(
    m59_id                    NUMBER (3, 0) NOT NULL,
    m59_exchange_id_m01       NUMBER (5, 0),
    m59_exchange_code_m01     VARCHAR2 (10 BYTE),
    m59_board_status_id_v19   NUMBER (2, 0),
    m59_custom_type           VARCHAR2 (50 BYTE) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.m59_exchange_board_status
ADD CONSTRAINT m59_brd_pk PRIMARY KEY (m59_id)
USING INDEX
/

