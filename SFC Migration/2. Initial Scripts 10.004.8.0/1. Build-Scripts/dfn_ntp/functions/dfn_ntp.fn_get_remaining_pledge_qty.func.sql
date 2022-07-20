CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_remaining_pledge_qty (trading_acc_id    NUMBER,
                                      symbol            VARCHAR2,
                                      send_to_ex        NUMBER,
                                      exchnge           VARCHAR2,
                                      trans_no          VARCHAR2,
                                      symbol_id_m20     NUMBER)
    RETURN NUMBER
IS
    l_rem_qty   NUMBER;
BEGIN
    IF (send_to_ex = 1)
    THEN
        SELECT SUM (
                   CASE
                       WHEN a.t20_pledge_type = '8' THEN a.t20_qty
                       WHEN a.t20_pledge_type = '9' THEN a.t20_qty * -1
                   END)
          INTO l_rem_qty
          FROM t20_pending_pledge a
         WHERE     a.t20_trading_acc_id_u07 = trading_acc_id
               AND a.t20_symbol_id_m20 = symbol_id_m20
               AND a.t20_status_id_v01 = 2
               AND a.t20_transaction_number = trans_no;

        RETURN l_rem_qty;
    ELSE
        SELECT SUM (
                   CASE
                       WHEN a.t20_pledge_type = '8' THEN a.t20_qty
                       WHEN a.t20_pledge_type = '9' THEN a.t20_qty * -1
                   END)
          INTO l_rem_qty
          FROM t20_pending_pledge a
         WHERE     a.t20_trading_acc_id_u07 = trading_acc_id
               AND a.t20_symbol_id_m20 = symbol_id_m20
               AND a.t20_status_id_v01 = 2;


        RETURN l_rem_qty;
    END IF;
END;
/