CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t1001_sukuk_pay_det_b
(
    name,
    nin,
    iban,
    account_no,
    no_of_sukuk,
    coupon_amount,
    t1001_status_id_v01,
    status,
    t1001_coupon_id_m1001,
    t1001_id
)
AS
    (SELECT t1001.t1001_name AS name,
            t1001.t1001_nin AS nin,
            t1001.t1001_iban AS iban,
            t1001.t1001_account_no AS account_no,
            t1001.t1001_holding_qty AS no_of_sukuk,
            t1001.t1001_coupon_amount AS coupon_amount,
            t1001.t1001_status_id_v01,
            status_list.v01_description AS status,
            t1001.t1001_coupon_id_m1001,
            t1001.t1001_id
       FROM     t1001_sukuk_payment_detail_b t1001
            INNER JOIN
                vw_status_list status_list
            ON t1001.t1001_status_id_v01 = status_list.v01_id)
/