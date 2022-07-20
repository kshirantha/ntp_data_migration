CREATE TABLE dfn_ntp.u18_trading_channel_restrict
(
    u18_id                   NUMBER (15, 0) NOT NULL,
    u18_trd_acnt_id_u07      NUMBER (10, 0) NOT NULL,
    u18_restriction_id_v31   NUMBER (5, 0) NOT NULL,
    u18_channel_id_v29       NUMBER (5, 0) NOT NULL,
    u18_custom_type          VARCHAR2 (50 BYTE) DEFAULT 1
)
/



ALTER TABLE dfn_ntp.u18_trading_channel_restrict
ADD CONSTRAINT u18_trading_channel_restri_pk PRIMARY KEY (u18_id)
USING INDEX
/