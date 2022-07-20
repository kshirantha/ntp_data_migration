CREATE TABLE dfn_ntp.t62_order_status_requests
(
    t62_exec_id                  VARCHAR2 (50 BYTE),
    t62_exchange_code_m01        VARCHAR2 (15 BYTE),
    t62_symbol_id_m20            NUMBER (5, 0),
    t62_symbol_code_m20          VARCHAR2 (25 BYTE),
    t62_cl_ord_id                VARCHAR2 (22 BYTE) NOT NULL,
    t62_cum_quantity             NUMBER (15, 0) DEFAULT 0,
    t62_status_id_v30            CHAR (1 BYTE) NOT NULL,
    t62_leaves_qty               NUMBER (15, 0) DEFAULT 0,
    t62_date_time                TIMESTAMP (6),
    t62_ord_no                   VARCHAR2 (22 BYTE),
    t62_last_updated_date_time   TIMESTAMP (6),
    t62_quantity                 NUMBER (15, 0) NOT NULL,
    t62_requested_by_id_u17      NUMBER (5, 0),
    t62_customer_id_u01          NUMBER (10, 0),
    t62_institution_id_m02       NUMBER (5, 0),
    t62_request_type             CHAR (1 BYTE),
    t62_narration                VARCHAR2 (500 BYTE)
)
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING
/



COMMENT ON COLUMN dfn_ntp.t62_order_status_requests.t62_narration IS
    'Reject reason'
/
COMMENT ON COLUMN dfn_ntp.t62_order_status_requests.t62_request_type IS
    '1-Request | 2-Response'
/

ALTER TABLE dfn_ntp.t62_order_status_requests
 ADD (
  t62_prev_status_id_v30 CHAR (1 BYTE)
 )
 MODIFY (
  t62_status_id_v30 NULL

 )
/

ALTER TABLE dfn_ntp.t62_order_status_requests MODIFY (t62_symbol_id_m20 NUMBER (10))
/
