-- Table DFN_NTP.R07_FIX_LOG

CREATE TABLE dfn_ntp.r07_fix_log
(
    unique_key         VARCHAR2 (255 CHAR),
    avg_cost           FLOAT (126),
    avg_price          FLOAT (126),
    cash_acntid        NUMBER (10, 0),
    channelid          NUMBER (10, 0),
    cl_ordid           VARCHAR2 (255 CHAR),
    customerid         NUMBER (19, 0),
    exchange           VARCHAR2 (255 CHAR),
    execid             VARCHAR2 (255 CHAR),
    exec_instid        NUMBER (10, 0),
    exec_trans_type    NUMBER (10, 0),
    exec_type          CHAR (1 CHAR),
    last_price         FLOAT (126),
    last_shares        NUMBER (19, 0),
    leaves_qty         NUMBER (19, 0),
    ordid              VARCHAR2 (255 CHAR),
    ordno              VARCHAR2 (255 CHAR),
    ord_rej_code       NUMBER (10, 0),
    ord_rej_reason     VARCHAR2 (255 CHAR),
    orig_cl_ordid      VARCHAR2 (255 CHAR),
    original_channel   NUMBER (10, 0),
    price              FLOAT (126),
    price_block        FLOAT (126),
    price_inst_type    NUMBER (10, 0),
    quantity           NUMBER (19, 0),
    remark             VARCHAR2 (255 CHAR),
    securityid         VARCHAR2 (255 CHAR),
    side               NUMBER (10, 0),
    status             CHAR (1 CHAR),
    symbol             VARCHAR2 (255 CHAR),
    transact_time      VARCHAR2 (255 CHAR),
    TYPE               CHAR (1 CHAR)
)
/

-- Constraints for  DFN_NTP.R07_FIX_LOG


  ALTER TABLE dfn_ntp.r07_fix_log ADD CONSTRAINT pk_r07_fix_log PRIMARY KEY (unique_key)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (unique_key NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (avg_cost NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (avg_price NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (cash_acntid NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (channelid NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (customerid NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (exec_instid NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (exec_trans_type NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (exec_type NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (last_price NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (last_shares NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (leaves_qty NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (ord_rej_code NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (original_channel NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (price NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (price_block NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (price_inst_type NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (quantity NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (side NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (status NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r07_fix_log MODIFY (TYPE NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.R07_FIX_LOG
