CREATE OR REPLACE PROCEDURE dfn_ntp.sp_t02_get_eod_settlement (
    p_view          OUT SYS_REFCURSOR,
    prows           OUT NUMBER,
    p_date       IN     t02_transaction_log.t02_create_date%TYPE,
    p_exchange   IN     t02_transaction_log.t02_exchange_code_m01%TYPE,
    p_inst_id    IN     t02_transaction_log.t02_inst_id_m02%TYPE)
IS
    l_broker_id   NUMBER;
BEGIN
    SELECT a.m150_id
      INTO l_broker_id
      FROM m150_broker a
     WHERE a.m150_primary_institute_id_m02 = p_inst_id;

    OPEN p_view FOR
        SELECT SUM (
                     t02.t02_last_price
                   * t02.t02_last_shares
                   * CASE
                         WHEN t02.t02_txn_code IN ('STLBUY', 'REVSEL')
                         THEN
                             -1
                         ELSE
                             1
                     END)
                   AS net_settle,
               SUM (
                   CASE
                       WHEN t02.t02_txn_code IN ('STLBUY', 'REVBUY')
                       THEN
                             t02.t02_last_price
                           * t02.t02_last_shares
                           * DECODE (t02.t02_txn_code, 'STLBUY', -1, 1)
                       ELSE
                           0
                   END)
                   AS buy_settle,
               SUM (
                   CASE
                       WHEN t02.t02_txn_code IN ('STLSEL', 'REVSEL')
                       THEN
                             t02.t02_last_price
                           * t02.t02_last_shares
                           * DECODE (t02.t02_txn_code, 'REVSEL', -1, 1)
                       ELSE
                           0
                   END)
                   AS sel_settle
          FROM     t02_transaction_log t02
               INNER JOIN
                   m02_institute m02
               ON t02.t02_inst_id_m02 = m02.m02_id
         WHERE     t02.t02_exchange_code_m01 = p_exchange
               AND m02.m02_broker_id_m150 = l_broker_id
               AND t02.t02_create_date BETWEEN TRUNC (p_date)
                                           AND TRUNC (p_date) + 0.99999;
END;
/
