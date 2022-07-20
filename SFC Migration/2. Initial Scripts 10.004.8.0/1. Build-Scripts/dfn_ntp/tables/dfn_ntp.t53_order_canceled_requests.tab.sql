-- Table DFN_NTP.T53_ORDER_CANCELED_REQUESTS

CREATE TABLE dfn_ntp.t53_order_canceled_requests
(
    t53_id                NUMBER (20, 0),
    t53_security_acc_no   VARCHAR2 (10),
    t53_exchange          VARCHAR2 (10),
    t53_symbol            VARCHAR2 (40),
    t53_side              NUMBER (1, 0),
    t53_created_by        NUMBER (10, 0),
    t53_created_date      DATE,
    t53_status_id         NUMBER (20, 0),
    t53_approved_by       NUMBER (10, 0),
    t53_approved_date     DATE,
    t53_rejected_by       NUMBER (10, 0),
    t53_rejected_date     DATE
)
/

-- Constraints for  DFN_NTP.T53_ORDER_CANCELED_REQUESTS


  ALTER TABLE dfn_ntp.t53_order_canceled_requests MODIFY (t53_created_by NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t53_order_canceled_requests MODIFY (t53_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t53_order_canceled_requests MODIFY (t53_status_id NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.T53_ORDER_CANCELED_REQUESTS


ALTER TABLE dfn_ntp.t53_order_canceled_requests
 ADD (
  t53_symbol_id_m20 NUMBER (10)
 )
/