CREATE OR REPLACE PACKAGE dfn_csm.pkg_clearing
IS
    TYPE refcursor IS REF CURSOR;

    PROCEDURE update_trade_capture_report (
        p_a00_id                a00_trade_capture_report.a00_id%TYPE,
        p_a00_rptid             a00_trade_capture_report.a00_rptid%TYPE,
        p_a00_trdid             a00_trade_capture_report.a00_trdid%TYPE,
        p_a00_trdid2            a00_trade_capture_report.a00_trdid2%TYPE,
        p_a00_rpttyp            a00_trade_capture_report.a00_rpttyp%TYPE,
        p_a00_reqid             a00_trade_capture_report.a00_reqid%TYPE,
        p_a00_trdtyp            a00_trade_capture_report.a00_trdtyp%TYPE,
        p_a00_trdsubtyp         a00_trade_capture_report.a00_trdsubtyp%TYPE,
        p_a00_origntrdid2       a00_trade_capture_report.a00_origntrdid2%TYPE,
        p_a00_lastqty           a00_trade_capture_report.a00_lastqty%TYPE,
        p_a00_lastpx            a00_trade_capture_report.a00_lastpx%TYPE,
        p_a00_trddt             a00_trade_capture_report.a00_trddt%TYPE,
        p_a00_bizdt             a00_trade_capture_report.a00_bizdt%TYPE,
        p_a00_txntm             a00_trade_capture_report.a00_txntm%TYPE,
        p_a00_tztransacttime    a00_trade_capture_report.a00_tztransacttime%TYPE,
        p_a00_sym               a00_trade_capture_report.a00_sym%TYPE,
        p_a00_side              a00_trade_capture_report.a00_side%TYPE,
        p_a00_ptyid             a00_trade_capture_report.a00_ptyid%TYPE,
        p_a00_ordid             a00_trade_capture_report.a00_ordid%TYPE,
        p_a00_clordid           a00_trade_capture_report.a00_clordid%TYPE,
        p_a00_clordid2          a00_trade_capture_report.a00_clordid2%TYPE,
        p_a00_ordqty            a00_trade_capture_report.a00_ordqty%TYPE,
        p_a00_comm              a00_trade_capture_report.a00_comm%TYPE,
        p_a00_settldt           a00_trade_capture_report.a00_settldt%TYPE,
        p_a00_matchid           a00_trade_capture_report.a00_matchid%TYPE);


    PROCEDURE insert_trd_rectif_news (
        p_a05_notif_id      a05_trade_rec_notif.a05_notif_id%TYPE,
        p_a05_notif_date    a05_trade_rec_notif.a05_notif_date%TYPE,
        p_a05_notif_time    a05_trade_rec_notif.a05_notif_time%TYPE,
        p_a05_symbol        a05_trade_rec_notif.a05_symbol%TYPE,
        p_a05_trd_id        a05_trade_rec_notif.a05_trd_id%TYPE);

    PROCEDURE reset_seq (p_seq_name IN VARCHAR2);

    PROCEDURE insert_margin_req_report (
        p_a09_rptid        a09_margin_requirement_report.a09_rptid%TYPE,
        p_a09_reqid        a09_margin_requirement_report.a09_reqid%TYPE,
        p_a09_rpttyp       a09_margin_requirement_report.a09_rpttyp%TYPE,
        p_a09_bizdt        a09_margin_requirement_report.a09_bizdt%TYPE,
        p_a09_setsesid     a09_margin_requirement_report.a09_setsesid%TYPE,
        p_a09_setsessub    a09_margin_requirement_report.a09_setsessub%TYPE,
        p_a09_txntm        a09_margin_requirement_report.a09_txntm%TYPE,
        p_a09_amt          a09_margin_requirement_report.a09_amt%TYPE,
        p_a09_typ          a09_margin_requirement_report.a09_typ%TYPE,
        p_a09_ccy          a09_margin_requirement_report.a09_ccy%TYPE);

    PROCEDURE insert_collateral_inq_report (
        p_a11_rptid          a11_collateral_report.a11_rptid%TYPE,
        p_a11_reqid          a11_collateral_report.a11_reqid%TYPE,
        p_a11_txntm          a11_collateral_report.a11_txntm%TYPE,
        p_a11_stat           a11_collateral_report.a11_stat%TYPE,
        p_a11_qty            a11_collateral_report.a11_qty%TYPE,
        p_a11_bizdt          a11_collateral_report.a11_bizdt%TYPE,
        p_a11_amt            a11_collateral_report.a11_amt%TYPE,
        p_a11_ccy            a11_collateral_report.a11_ccy%TYPE,
        p_collateral_type    NVARCHAR2,
        p_a11_symbol         a11_collateral_report.a11_symbol%TYPE,
        p_a11_isincode       a11_collateral_report.a11_isincode%TYPE);


    PROCEDURE insert_settlement_pos_report (
        p_a14_rptid             a14_settlement_position_rep.a14_rptid%TYPE,
        p_a14_reqid             a14_settlement_position_rep.a14_reqid%TYPE,
        p_a14_txntm             a14_settlement_position_rep.a14_txntm%TYPE,
        p_a14_msgevtsrc         a14_settlement_position_rep.a14_msgevtsrc%TYPE,
        p_a14_settldt           a14_settlement_position_rep.a14_settldt%TYPE,
        p_a14_bizdt             a14_settlement_position_rep.a14_bizdt%TYPE,
        p_a14_symbol            a14_settlement_position_rep.a14_symbol%TYPE,
        p_a14_isincode          a14_settlement_position_rep.a14_isincode%TYPE,
        p_a14_settlement_acc    a14_settlement_position_rep.a14_settlement_acc%TYPE,
        p_a14_qty_typ           a14_settlement_position_rep.a14_qty_typ%TYPE,
        p_a14_qty_long          a14_settlement_position_rep.a14_qty_long%TYPE,
        p_a14_qty_short         a14_settlement_position_rep.a14_qty_short%TYPE,
        p_a14_qty_stat          a14_settlement_position_rep.a14_qty_stat%TYPE,
        p_a14_qtydt             a14_settlement_position_rep.a14_qtydt%TYPE,
        p_a14_amt_typ           a14_settlement_position_rep.a14_amt_typ%TYPE,
        p_a14_amt               a14_settlement_position_rep.a14_amt%TYPE,
        p_a14_amt_ccy           a14_settlement_position_rep.a14_amt_ccy%TYPE,
        p_a14_amt_rsn           a14_settlement_position_rep.a14_amt_rsn%TYPE);

    PROCEDURE sp_get_aggregate_details (
        pview        OUT refcursor,
        pa01_id   IN     a01_trade_request_list.a01_id%TYPE);

    PROCEDURE sp_update_agg_status (
        pa01_id               IN a01_trade_request_list.a01_id%TYPE,
        pa01_status           IN a01_trade_request_list.a01_status%TYPE,
        pa01_reject_reason    IN a01_trade_request_list.a01_reject_reason%TYPE DEFAULT NULL,
        pa01_response_trdid   IN a01_trade_request_list.a01_response_trdid%TYPE DEFAULT NULL,
        pa01_type             IN a01_trade_request_list.a01_type%TYPE DEFAULT 1);
END; -- Package spec
/



CREATE OR REPLACE PACKAGE BODY dfn_csm.pkg_clearing
IS
    PROCEDURE update_trade_capture_report (
        p_a00_id                a00_trade_capture_report.a00_id%TYPE,
        p_a00_rptid             a00_trade_capture_report.a00_rptid%TYPE,
        p_a00_trdid             a00_trade_capture_report.a00_trdid%TYPE,
        p_a00_trdid2            a00_trade_capture_report.a00_trdid2%TYPE,
        p_a00_rpttyp            a00_trade_capture_report.a00_rpttyp%TYPE,
        p_a00_reqid             a00_trade_capture_report.a00_reqid%TYPE,
        p_a00_trdtyp            a00_trade_capture_report.a00_trdtyp%TYPE,
        p_a00_trdsubtyp         a00_trade_capture_report.a00_trdsubtyp%TYPE,
        p_a00_origntrdid2       a00_trade_capture_report.a00_origntrdid2%TYPE,
        p_a00_lastqty           a00_trade_capture_report.a00_lastqty%TYPE,
        p_a00_lastpx            a00_trade_capture_report.a00_lastpx%TYPE,
        p_a00_trddt             a00_trade_capture_report.a00_trddt%TYPE,
        p_a00_bizdt             a00_trade_capture_report.a00_bizdt%TYPE,
        p_a00_txntm             a00_trade_capture_report.a00_txntm%TYPE,
        p_a00_tztransacttime    a00_trade_capture_report.a00_tztransacttime%TYPE,
        p_a00_sym               a00_trade_capture_report.a00_sym%TYPE,
        p_a00_side              a00_trade_capture_report.a00_side%TYPE,
        p_a00_ptyid             a00_trade_capture_report.a00_ptyid%TYPE,
        p_a00_ordid             a00_trade_capture_report.a00_ordid%TYPE,
        p_a00_clordid           a00_trade_capture_report.a00_clordid%TYPE,
        p_a00_clordid2          a00_trade_capture_report.a00_clordid2%TYPE,
        p_a00_ordqty            a00_trade_capture_report.a00_ordqty%TYPE,
        p_a00_comm              a00_trade_capture_report.a00_comm%TYPE,
        p_a00_settldt           a00_trade_capture_report.a00_settldt%TYPE,
        p_a00_matchid           a00_trade_capture_report.a00_matchid%TYPE)
    IS
        p_a00_is_valid   a00_trade_capture_report.a00_is_valid%TYPE;
    BEGIN
        p_a00_is_valid := 1;

        IF p_a00_trdsubtyp IS NOT NULL AND p_a00_trdsubtyp = '1004'
        THEN
            UPDATE a00_trade_capture_report
               SET a00_trdsubtyp = p_a00_trdsubtyp, a00_is_valid = 0
             WHERE a00_trdid = p_a00_trdid;
        ELSE
            MERGE INTO a00_trade_capture_report a00
                 USING DUAL
                    ON (a00.a00_trdid = p_a00_trdid)
            WHEN NOT MATCHED
            THEN
                INSERT     (a00_id,
                            a00_rptid,
                            a00_trdid,
                            a00_trdid2,
                            a00_rpttyp,
                            a00_reqid,
                            a00_trdtyp,
                            a00_trdsubtyp,
                            a00_origntrdid2,
                            a00_lastqty,
                            a00_lastpx,
                            a00_trddt,
                            a00_bizdt,
                            a00_txntm,
                            a00_tztransacttime,
                            a00_sym,
                            a00_side,
                            a00_ptyid,
                            a00_ordid,
                            a00_clordid,
                            a00_clordid2,
                            a00_ordqty,
                            a00_comm,
                            a00_is_valid,
                            a00_settldt,
                            a00_matchid)
                    VALUES (fn_get_fixml_seq_id (),
                            p_a00_rptid,
                            p_a00_trdid,
                            p_a00_trdid2,
                            p_a00_rpttyp,
                            p_a00_reqid,
                            p_a00_trdtyp,
                            p_a00_trdsubtyp,
                            p_a00_origntrdid2,
                            p_a00_lastqty,
                            p_a00_lastpx,
                            p_a00_trddt,
                            p_a00_bizdt,
                            p_a00_txntm,
                            p_a00_tztransacttime,
                            p_a00_sym,
                            p_a00_side,
                            p_a00_ptyid,
                            p_a00_ordid,
                            p_a00_clordid,
                            p_a00_clordid2,
                            p_a00_ordqty,
                            p_a00_comm,
                            p_a00_is_valid,
                            p_a00_settldt,
                            p_a00_matchid);
        END IF;
    END;

    PROCEDURE insert_trd_rectif_news (
        p_a05_notif_id      a05_trade_rec_notif.a05_notif_id%TYPE,
        p_a05_notif_date    a05_trade_rec_notif.a05_notif_date%TYPE,
        p_a05_notif_time    a05_trade_rec_notif.a05_notif_time%TYPE,
        p_a05_symbol        a05_trade_rec_notif.a05_symbol%TYPE,
        p_a05_trd_id        a05_trade_rec_notif.a05_trd_id%TYPE)
    IS
    BEGIN
        INSERT INTO a05_trade_rec_notif (a05_id,
                                         a05_notif_id,
                                         a05_notif_date,
                                         a05_notif_time,
                                         a05_symbol,
                                         a05_trd_id,
                                         a05_status_id)
             VALUES (seq_a05_id.NEXTVAL,
                     p_a05_notif_id,
                     p_a05_notif_date,
                     p_a05_notif_time,
                     p_a05_symbol,
                     p_a05_trd_id,
                     0);
    END;


    PROCEDURE reset_seq (p_seq_name IN VARCHAR2)
    IS
        l_val   NUMBER;
    BEGIN
        EXECUTE IMMEDIATE 'select ' || p_seq_name || '.nextval from dual'
            INTO l_val;

        EXECUTE IMMEDIATE
               'alter sequence '
            || p_seq_name
            || ' increment by -'
            || l_val
            || ' minvalue 0';

        EXECUTE IMMEDIATE 'select ' || p_seq_name || '.nextval from dual'
            INTO l_val;

        EXECUTE IMMEDIATE
            'alter sequence ' || p_seq_name || ' increment by 1 minvalue 0';
    END;

    PROCEDURE insert_margin_req_report (
        p_a09_rptid        a09_margin_requirement_report.a09_rptid%TYPE,
        p_a09_reqid        a09_margin_requirement_report.a09_reqid%TYPE,
        p_a09_rpttyp       a09_margin_requirement_report.a09_rpttyp%TYPE,
        p_a09_bizdt        a09_margin_requirement_report.a09_bizdt%TYPE,
        p_a09_setsesid     a09_margin_requirement_report.a09_setsesid%TYPE,
        p_a09_setsessub    a09_margin_requirement_report.a09_setsessub%TYPE,
        p_a09_txntm        a09_margin_requirement_report.a09_txntm%TYPE,
        p_a09_amt          a09_margin_requirement_report.a09_amt%TYPE,
        p_a09_typ          a09_margin_requirement_report.a09_typ%TYPE,
        p_a09_ccy          a09_margin_requirement_report.a09_ccy%TYPE)
    IS
    BEGIN
        INSERT INTO a09_margin_requirement_report (a09_id,
                                                   a09_rptid,
                                                   a09_reqid,
                                                   a09_rpttyp,
                                                   a09_bizdt,
                                                   a09_setsesid,
                                                   a09_setsessub,
                                                   a09_txntm,
                                                   a09_amt,
                                                   a09_typ,
                                                   a09_ccy)
             VALUES (seq_a09_id.NEXTVAL,
                     p_a09_rptid,
                     p_a09_reqid,
                     p_a09_rpttyp,
                     p_a09_bizdt,
                     p_a09_setsesid,
                     p_a09_setsessub,
                     p_a09_txntm,
                     p_a09_amt,
                     p_a09_typ,
                     p_a09_ccy);
    END;

    PROCEDURE insert_collateral_inq_report (
        p_a11_rptid          a11_collateral_report.a11_rptid%TYPE,
        p_a11_reqid          a11_collateral_report.a11_reqid%TYPE,
        p_a11_txntm          a11_collateral_report.a11_txntm%TYPE,
        p_a11_stat           a11_collateral_report.a11_stat%TYPE,
        p_a11_qty            a11_collateral_report.a11_qty%TYPE,
        p_a11_bizdt          a11_collateral_report.a11_bizdt%TYPE,
        p_a11_amt            a11_collateral_report.a11_amt%TYPE,
        p_a11_ccy            a11_collateral_report.a11_ccy%TYPE,
        p_collateral_type    NVARCHAR2,
        p_a11_symbol         a11_collateral_report.a11_symbol%TYPE,
        p_a11_isincode       a11_collateral_report.a11_isincode%TYPE)
    IS
        p_a11_typ   a11_collateral_report.a11_typ%TYPE;
    BEGIN
        SELECT m06_id
          INTO p_a11_typ
          FROM m06_collateral_amount_type
         WHERE m06_amount_type = p_collateral_type;

        INSERT INTO a11_collateral_report (a11_id,
                                           a11_rptid,
                                           a11_reqid,
                                           a11_txntm,
                                           a11_stat,
                                           a11_qty,
                                           a11_bizdt,
                                           a11_amt,
                                           a11_ccy,
                                           a11_typ,
                                           a11_symbol,
                                           a11_isincode)
             VALUES (seq_a11_id.NEXTVAL,
                     p_a11_rptid,
                     p_a11_reqid,
                     p_a11_txntm,
                     p_a11_stat,
                     p_a11_qty,
                     p_a11_bizdt,
                     p_a11_amt,
                     p_a11_ccy,
                     p_a11_typ,
                     p_a11_symbol,
                     p_a11_isincode);
    END;

    PROCEDURE insert_settlement_pos_report (
        p_a14_rptid             a14_settlement_position_rep.a14_rptid%TYPE,
        p_a14_reqid             a14_settlement_position_rep.a14_reqid%TYPE,
        p_a14_txntm             a14_settlement_position_rep.a14_txntm%TYPE,
        p_a14_msgevtsrc         a14_settlement_position_rep.a14_msgevtsrc%TYPE,
        p_a14_settldt           a14_settlement_position_rep.a14_settldt%TYPE,
        p_a14_bizdt             a14_settlement_position_rep.a14_bizdt%TYPE,
        p_a14_symbol            a14_settlement_position_rep.a14_symbol%TYPE,
        p_a14_isincode          a14_settlement_position_rep.a14_isincode%TYPE,
        p_a14_settlement_acc    a14_settlement_position_rep.a14_settlement_acc%TYPE,
        p_a14_qty_typ           a14_settlement_position_rep.a14_qty_typ%TYPE,
        p_a14_qty_long          a14_settlement_position_rep.a14_qty_long%TYPE,
        p_a14_qty_short         a14_settlement_position_rep.a14_qty_short%TYPE,
        p_a14_qty_stat          a14_settlement_position_rep.a14_qty_stat%TYPE,
        p_a14_qtydt             a14_settlement_position_rep.a14_qtydt%TYPE,
        p_a14_amt_typ           a14_settlement_position_rep.a14_amt_typ%TYPE,
        p_a14_amt               a14_settlement_position_rep.a14_amt%TYPE,
        p_a14_amt_ccy           a14_settlement_position_rep.a14_amt_ccy%TYPE,
        p_a14_amt_rsn           a14_settlement_position_rep.a14_amt_rsn%TYPE)
    IS
    BEGIN
        INSERT INTO a14_settlement_position_rep (a14_id,
                                                 a14_rptid,
                                                 a14_reqid,
                                                 a14_txntm,
                                                 a14_msgevtsrc,
                                                 a14_settldt,
                                                 a14_bizdt,
                                                 a14_symbol,
                                                 a14_isincode,
                                                 a14_settlement_acc,
                                                 a14_qty_typ,
                                                 a14_qty_long,
                                                 a14_qty_short,
                                                 a14_qty_stat,
                                                 a14_qtydt,
                                                 a14_amt_typ,
                                                 a14_amt,
                                                 a14_amt_ccy,
                                                 a14_amt_rsn)
             VALUES (seq_a14_id.NEXTVAL,
                     p_a14_rptid,
                     p_a14_reqid,
                     p_a14_txntm,
                     p_a14_msgevtsrc,
                     p_a14_settldt,
                     p_a14_bizdt,
                     p_a14_symbol,
                     p_a14_isincode,
                     p_a14_settlement_acc,
                     p_a14_qty_typ,
                     p_a14_qty_long,
                     p_a14_qty_short,
                     p_a14_qty_stat,
                     p_a14_qtydt,
                     p_a14_amt_typ,
                     p_a14_amt,
                     p_a14_amt_ccy,
                     p_a14_amt_rsn);
    END;


    PROCEDURE sp_get_aggregate_details (
        pview        OUT refcursor,
        pa01_id   IN     a01_trade_request_list.a01_id%TYPE)
    IS
    BEGIN
        OPEN pview FOR
            SELECT a01.a01_side AS side,
                   a02.a02_a00_trdid AS trade_id,
                   a02.a02_quantity AS quantity,
                   a01.a01_symbol AS symbol,
                   a02.a02_isin AS isin
              FROM a02_trade_request_list_details a02,
                   a01_trade_request_list a01
             WHERE     a01.a01_id = pa01_id
                   AND a01.a01_id = a02.a02_a01_id
                   AND a02_status = 10
                   AND a02_type = 1;
    END;

    PROCEDURE sp_update_agg_status (
        pa01_id               IN a01_trade_request_list.a01_id%TYPE,
        pa01_status           IN a01_trade_request_list.a01_status%TYPE,
        pa01_reject_reason    IN a01_trade_request_list.a01_reject_reason%TYPE DEFAULT NULL,
        pa01_response_trdid   IN a01_trade_request_list.a01_response_trdid%TYPE DEFAULT NULL,
        pa01_type             IN a01_trade_request_list.a01_type%TYPE DEFAULT 1) -- 1 - Aggregate ,2 - Split
    IS
        l_initiate_count   NUMBER;
        l_pending_count    NUMBER;
        l_accept_count     NUMBER;
        l_reject_count     NUMBER;
        l_record_count     NUMBER;
        l_other_count      NUMBER;
    BEGIN
        IF (pa01_type = 1)
        THEN
            UPDATE a01_trade_request_list
               SET a01_status = pa01_status,
                   a01_reject_reason = pa01_reject_reason,
                   a01_response_trdid = pa01_response_trdid
             WHERE a01_id = pa01_id;

            UPDATE a02_trade_request_list_details
               SET a02_status = pa01_status,
                   a02_is_select =
                       CASE
                           WHEN pa01_status = 1 THEN 0
                           ELSE a02_is_select
                       END
             WHERE a02_a01_id = pa01_id;


            SELECT SUM (accept_count), SUM (accept_count + other_count)
              INTO l_accept_count, l_record_count
              FROM (  SELECT CASE WHEN a02_status = 0 THEN COUNT (*) ELSE 0 END
                                 AS accept_count,
                             CASE
                                 WHEN a02_status <> 0 OR a02_status IS NULL
                                 THEN
                                     COUNT (*)
                                 ELSE
                                     0
                             END
                                 AS other_count
                        FROM (SELECT a15_id
                                FROM a15_aggregate_list
                               WHERE a15_id IN (SELECT a01_a15_id
                                                  FROM a01_trade_request_list
                                                 WHERE a01_id = pa01_id)) a15,
                             a02_trade_request_list_details a02
                       WHERE a15.a15_id = a02.a02_a15_id
                    GROUP BY a02_status);

            UPDATE a15_aggregate_list
               SET a15_status =
                       CASE
                           WHEN pa01_status IN (1, 12) THEN pa01_status
                           WHEN l_record_count = l_accept_count THEN 3
                           ELSE 2
                       END
             WHERE a15_id IN (SELECT a01_a15_id
                                FROM a01_trade_request_list
                               WHERE a01_id = pa01_id);
        ELSE
            UPDATE a01_trade_request_list
               SET a01_status = pa01_status,
                   a01_reject_reason = pa01_reject_reason,
                   a01_response_trdid = pa01_response_trdid
             WHERE a01_id = pa01_id;

            UPDATE a02_trade_request_list_details
               SET a02_status = pa01_status
             WHERE a02_a01_id = pa01_id AND a02_type = 2;
        END IF;
    END;
END;
/