CREATE TABLE dfn_ntp.t44_pending_cust_ca_adjust
(
    t44_id                       NUMBER (10, 0) NOT NULL,
    t44_cust_ca_dist_id_t41      NUMBER (15, 0),
    t44_hold_on_rec_date_t41     NUMBER (18, 5),
    t44_no_of_approval           NUMBER (2, 0),
    t44_is_approval_completed    NUMBER (1, 0),
    t44_current_approval_level   NUMBER (2, 0),
    t44_next_status              NUMBER (3, 0),
    t44_created_date             DATE,
    t44_last_updated_date        DATE,
    t44_status_id_v01            NUMBER (5, 0),
    t44_comment                  VARCHAR2 (2000 BYTE),
    t44_created_by_id_u17        NUMBER (10, 0),
    t44_last_updated_by_id_u17   NUMBER (10, 0),
    t44_custom_type              VARCHAR2 (50 BYTE) DEFAULT 1,
    t44_institute_id_m02         NUMBER (3, 0) DEFAULT 1
)
/


ALTER TABLE dfn_ntp.t44_pending_cust_ca_adjust
ADD CONSTRAINT t44_pending_cust_ca_adjust_pk PRIMARY KEY (t44_id)
USING INDEX
/