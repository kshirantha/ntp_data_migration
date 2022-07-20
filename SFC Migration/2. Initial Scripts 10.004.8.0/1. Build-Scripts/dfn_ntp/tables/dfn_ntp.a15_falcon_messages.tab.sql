CREATE TABLE dfn_ntp.a15_falcon_messages
(
    a15_id                    NUMBER (10, 0) NOT NULL,
    a15_unique_request_id     VARCHAR2 (255 BYTE),
    a15_message_type          NUMBER (10, 0),
    a15_channel_v29               NUMBER (10, 0),
    a15_comm_ver              VARCHAR2 (255),
    a15_login_id              NUMBER (10),
    a15_session_id            VARCHAR2 (255),
    a15_client_ip             VARCHAR2 (255),
    a15_tenantcode            VARCHAR2 (255),
    a15_customer_id_u01           NUMBER (10),
    a15_nodeid                NUMBER (10),
    a15_msg_date              TIMESTAMP (6),
    a15_responsetime          NUMBER (19),
    a15_persistingtimestamp   TIMESTAMP (6),
    a15_falcontime            TIMESTAMP (6),
    a15_slabreached           NUMBER (5),
    a15_message               CLOB,
    a15_req_res               NUMBER (5)
)
/

COMMENT ON COLUMN dfn_ntp.a15_falcon_messages.a15_req_res IS 'REQ-1,RES-2'
/
COMMENT ON COLUMN dfn_ntp.A15_FALCON_MESSAGES.A15_LOGIN_ID IS 'Customer or User'
/

CREATE INDEX dfn_ntp.idx_a15_uniq_req_id_req_res
    ON dfn_ntp.a15_falcon_messages (a15_unique_request_id ASC,
                                    a15_req_res ASC)
/