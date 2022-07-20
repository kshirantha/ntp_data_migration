ALTER TABLE dfn_ntp.m59_exchange_board_status
ADD CONSTRAINT m59_brd_m01 FOREIGN KEY (m59_exchange_id_m01)
REFERENCES dfn_ntp.m01_exchanges (m01_id)
/

ALTER TABLE dfn_ntp.m59_exchange_board_status
ADD CONSTRAINT m59_brd_v19 FOREIGN KEY (m59_board_status_id_v19)
REFERENCES dfn_ntp.v19_market_status (v19_id)
/