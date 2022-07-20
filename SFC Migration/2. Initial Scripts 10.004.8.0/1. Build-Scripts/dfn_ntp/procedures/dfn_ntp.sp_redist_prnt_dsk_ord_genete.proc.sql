CREATE OR REPLACE PROCEDURE dfn_ntp.sp_redist_prnt_dsk_ord_genete (
    s t09_txn_single_entry_v3%ROWTYPE)
IS
    pcount            NUMBER (5);
    desk_ord_status   VARCHAR (1);
    orig_ord_id       VARCHAR2 (18);
BEGIN
    UPDATE t52_desk_orders t
       SET t.t52_cum_netsettle = s.t09_cumord_netsettle,
           t.t52_avgpx = s.t09_parent_avg_price,
           t.t52_internall_order_status = s.t09_internal_order_status_v30,
           t.t52_status_id_v30 = s.t09_parent_status_v30,
           t.t52_cum_child_qty = s.t09_cum_child_qty,
           t.t52_cum_quantity = s.t09_parent_cum_quantity,
           t.t52_last_updated_date = SYSDATE
     WHERE t.t52_order_id = s.t09_desk_order_ref_t52;


    -----------------------------UPDATING T52 CANCELLED AND INVALIDATED BY CANCEL STATUS--------------------
    SELECT t52_internall_order_status, t52_orig_order_id
      INTO desk_ord_status, orig_ord_id
      FROM t52_desk_orders
     WHERE t52_order_id = s.t09_desk_order_ref_t52;

    DBMS_OUTPUT.put_line ('desk_ord_status: ' || desk_ord_status);

    IF desk_ord_status = 'g'
    THEN
        SELECT COUNT (1)
          INTO pcount
          FROM t01_order t01, t52_desk_orders t52
         WHERE     t01.t01_desk_order_ref_t52 = t52.t52_orig_order_id
               AND t01.t01_status_id_v30 IN ('0', 'O', '1', '4')
               AND t52.t52_order_id = s.t09_desk_order_ref_t52;

        DBMS_OUTPUT.put_line ('pcount: ' || pcount);

        IF pcount = 0
        THEN
            DBMS_OUTPUT.put_line (
                   'updating t52 order id:'
                || s.t09_desk_order_ref_t52
                || 'to status 4');

            UPDATE t52_desk_orders a
               SET a.t52_status_id_v30 = '4',
                   a.t52_internall_order_status = '4'
             WHERE a.t52_order_id = s.t09_desk_order_ref_t52;

            DBMS_OUTPUT.put_line (
                'updating t52 order id:' || orig_ord_id || 'to status m');

            UPDATE t52_desk_orders a
               SET a.t52_status_id_v30 = 'm',
                   a.t52_internall_order_status = 'm'
             WHERE a.t52_order_id = orig_ord_id;
        END IF;
    END IF;
-----------------------------------------------------------------------------------------------------------
END;
/
