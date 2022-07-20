CREATE OR REPLACE PROCEDURE dfn_ntp.sp_add_ord_cancel_req (
    pkey                   IN t53_order_canceled_requests.t53_id%TYPE,
    pt53_security_acc_no   IN t53_order_canceled_requests.t53_security_acc_no%TYPE,
    pt53_exchange          IN t53_order_canceled_requests.t53_exchange%TYPE,
    pt53_symbol            IN t53_order_canceled_requests.t53_symbol%TYPE,
    pt53_side              IN t53_order_canceled_requests.t53_side%TYPE,
    pt53_created_by        IN t53_order_canceled_requests.t53_created_by%TYPE)
IS
BEGIN
    INSERT INTO t53_order_canceled_requests (t53_id,
                                             t53_security_acc_no,
                                             t53_exchange,
                                             t53_symbol,
                                             t53_side,
                                             t53_created_by,
                                             t53_created_date,
                                             t53_status_id)
         VALUES (pkey,
                 pt53_security_acc_no,
                 pt53_exchange,
                 pt53_symbol,
                 pt53_side,
                 pt53_created_by,
                 SYSDATE,
                 1);
END;
/

DROP PROCEDURE dfn_ntp.sp_add_ord_cancel_req
/