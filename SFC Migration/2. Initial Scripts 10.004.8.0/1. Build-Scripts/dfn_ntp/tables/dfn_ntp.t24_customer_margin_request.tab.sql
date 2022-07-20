CREATE TABLE dfn_ntp.t24_customer_margin_request
(
    t24_id                           NUMBER (18, 0) NOT NULL,
    t24_cust_margin_product_id_u23   NUMBER (10, 0) NOT NULL,
    t24_customer_id_u01              NUMBER (18, 0) NOT NULL,
    t24_default_cash_acc_id_u06      NUMBER (18, 0),
    t24_margin_products_id_m73       NUMBER (3, 0) NOT NULL,
    t24_interest_group_id_m74        NUMBER (5, 0),
    t24_max_margin_limit             NUMBER (18, 5) DEFAULT 0,
    t24_max_limit_curr_id_m03        NUMBER (5, 0),
    t24_max_limit_curr_code_m03      CHAR (3 BYTE),
    t24_margin_expiry_date           DATE,
    t24_margin_call_level_1          NUMBER (10, 5) DEFAULT 0,
    t24_margin_call_level_2          NUMBER (10, 5) DEFAULT 0,
    t24_liquidation_level            NUMBER (10, 5) DEFAULT 0,
    t24_symbol_margnblty_grps_m77    NUMBER (5, 0),
    t24_stock_conctrn_group_id_m75   NUMBER (10, 0),
    t24_borrowers_name               VARCHAR2 (255 BYTE),
    t24_margin_percentage            NUMBER (10, 5),
    t24_no_of_approval               NUMBER (2, 0),
    t24_is_approval_completed        NUMBER (1, 0),
    t24_current_approval_level       NUMBER (2, 0),
    t24_next_status                  NUMBER (3, 0),
    t24_created_date                 DATE DEFAULT SYSDATE,
    t24_last_updated_date            DATE,
    t24_status_id_v01                NUMBER (5, 0),
    t24_comment                      VARCHAR2 (2000 BYTE),
    t24_created_by_id_u17            NUMBER (10, 0),
    t24_last_updated_by_id_u17       NUMBER (10, 0),
    t24_other_cash_acc_ids_u06       VARCHAR2 (500 BYTE),
    t24_restore_level                NUMBER (10, 5),
    t24_exempt_liquidation           NUMBER (1, 0),
    t24_custom_type                  VARCHAR2 (50 BYTE) DEFAULT 1,
    t24_request_action               NUMBER (2, 0),
    t24_institute_id_m02             NUMBER (3, 0) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.t24_customer_margin_request
ADD CONSTRAINT pk_t24 PRIMARY KEY (t24_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.t24_customer_margin_request.t24_other_cash_acc_ids_u06 IS
    'Comma Separated U06 IDs'
/

ALTER TABLE dfn_ntp.t24_customer_margin_request
 ADD (
  t24_request_type NUMBER (1, 0) DEFAULT 1
 )
/

