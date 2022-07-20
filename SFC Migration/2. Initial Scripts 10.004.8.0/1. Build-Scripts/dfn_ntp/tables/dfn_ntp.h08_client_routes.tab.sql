CREATE TABLE dfn_ntp.h08_client_routes
(
    h08_customer_id_u01   NUMBER (10, 0) NOT NULL,
    h08_next_node         NUMBER (2, 0) DEFAULT 0 NOT NULL,
    h08_last_update       VARCHAR2 (20 BYTE)
)
/
