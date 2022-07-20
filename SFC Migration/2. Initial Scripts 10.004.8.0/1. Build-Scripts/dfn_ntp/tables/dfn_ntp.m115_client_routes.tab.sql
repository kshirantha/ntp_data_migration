CREATE TABLE dfn_ntp.m115_client_routes
(
    m115_customer_id_u01   NUMBER (10, 0) NOT NULL,
    m115_next_node         NUMBER (3, 0) DEFAULT 0 NOT NULL,
    m115_last_update       VARCHAR2 (20 BYTE),
    m115_self_ip           VARCHAR2 (20 BYTE),
    m115_node_ip           VARCHAR2 (20 BYTE)
)
/

ALTER TABLE dfn_ntp.m115_client_routes
ADD CONSTRAINT m115_client_routes_pk PRIMARY KEY (m115_customer_id_u01)
USING INDEX
/
