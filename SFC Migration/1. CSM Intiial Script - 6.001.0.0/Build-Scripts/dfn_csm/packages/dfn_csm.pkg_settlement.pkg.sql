CREATE OR REPLACE PACKAGE dfn_csm.pkg_settlement
IS
    TYPE refcursor IS REF CURSOR;

    PROCEDURE update_settlement_instructions (
        p_a04_parent_reqid          VARCHAR2,
        p_a04_process_status        VARCHAR2,
        p_a04_match_status          VARCHAR2,
        p_a04_settlement_status     VARCHAR2,
        p_a04_reason_nmat           VARCHAR2,
        p_a04_trade_date            VARCHAR2,
        p_a04_settlement_date       VARCHAR2,
        p_a04_effect_settle_date    VARCHAR2);

    PROCEDURE insert_share_transfer (
        p_t04_oms_ref               t04_share_transfer.t04_oms_ref%TYPE,
        p_t04_receiver_ref          t04_share_transfer.t04_receiver_ref%TYPE,
        p_t04_type                  t04_share_transfer.t04_type%TYPE,
        p_t04_movement_type         t04_share_transfer.t04_movement_type%TYPE,
        p_t04_settlement_date       t04_share_transfer.t04_settlement_date%TYPE,
        p_t04_transaction_date      t04_share_transfer.t04_transaction_date%TYPE,
        p_t04_isincode              t04_share_transfer.t04_isincode%TYPE,
        p_t04_quantity              t04_share_transfer.t04_quantity%TYPE,
        p_t04_buyer_acc_no          t04_share_transfer.t04_buyer_acc_no%TYPE,
        p_t04_buyer_member_code     t04_share_transfer.t04_buyer_member_code%TYPE,
        p_t04_seller_acc_no         t04_share_transfer.t04_seller_acc_no%TYPE,
        p_t04_seller_member_code    t04_share_transfer.t04_seller_member_code%TYPE,
        p_t04_sender_status         t04_share_transfer.t04_sender_status%TYPE,
        p_t04_receiver_status       t04_share_transfer.t04_receiver_status%TYPE);

    PROCEDURE get_details_for_stock_deposit (pview         OUT refcursor,
                                             p_t04_id   IN     NUMBER);

    PROCEDURE insert_pledge_transfer (
        p_t05_oms_ref                t05_pledge_transfer.t05_oms_ref%TYPE,
        p_t05_type                   t05_pledge_transfer.t05_type%TYPE,
        p_t05_isincode               t05_pledge_transfer.t05_isincode%TYPE,
        p_t05_quantity               t05_pledge_transfer.t05_quantity%TYPE,
        p_t05_pledgor_acc_no         t05_pledge_transfer.t05_pledgor_acc_no%TYPE,
        p_t05_pledgor_member_code    t05_pledge_transfer.t05_pledgor_member_code%TYPE,
        p_t05_pledgee_acc_no         t05_pledge_transfer.t05_pledgee_acc_no%TYPE,
        p_t05_pledgee_member_code    t05_pledge_transfer.t05_pledgee_member_code%TYPE,
        p_t05_pledge_type            t05_pledge_transfer.t05_pledge_type%TYPE,
        p_t05_sender_status          t05_pledge_transfer.t05_sender_status%TYPE,
        p_t05_receiver_status        t05_pledge_transfer.t05_receiver_status%TYPE);
END;
/



CREATE OR REPLACE PACKAGE BODY dfn_csm.pkg_settlement
IS
    PROCEDURE update_settlement_instructions (
        p_a04_parent_reqid          VARCHAR2,
        p_a04_process_status        VARCHAR2,
        p_a04_match_status          VARCHAR2,
        p_a04_settlement_status     VARCHAR2,
        p_a04_reason_nmat           VARCHAR2,
        p_a04_trade_date            VARCHAR2,
        p_a04_settlement_date       VARCHAR2,
        p_a04_effect_settle_date    VARCHAR2)
    IS
    BEGIN
        /*need to check for null values */
        UPDATE a04_settlement_instruction
           SET a04_process_status = p_a04_process_status,
               a04_match_status = p_a04_match_status,
               a04_settlement_status = p_a04_settlement_status,
               a04_reason_nmat = p_a04_reason_nmat,
               a04_trade_date = p_a04_trade_date,
               a04_settlement_date = p_a04_settlement_date,
               a04_effect_settle_date = p_a04_effect_settle_date
         WHERE a04_parent_reqid = p_a04_parent_reqid;
    END;

    PROCEDURE insert_share_transfer (
        p_t04_oms_ref               t04_share_transfer.t04_oms_ref%TYPE,
        p_t04_receiver_ref          t04_share_transfer.t04_receiver_ref%TYPE,
        p_t04_type                  t04_share_transfer.t04_type%TYPE,
        p_t04_movement_type         t04_share_transfer.t04_movement_type%TYPE,
        p_t04_settlement_date       t04_share_transfer.t04_settlement_date%TYPE,
        p_t04_transaction_date      t04_share_transfer.t04_transaction_date%TYPE,
        p_t04_isincode              t04_share_transfer.t04_isincode%TYPE,
        p_t04_quantity              t04_share_transfer.t04_quantity%TYPE,
        p_t04_buyer_acc_no          t04_share_transfer.t04_buyer_acc_no%TYPE,
        p_t04_buyer_member_code     t04_share_transfer.t04_buyer_member_code%TYPE,
        p_t04_seller_acc_no         t04_share_transfer.t04_seller_acc_no%TYPE,
        p_t04_seller_member_code    t04_share_transfer.t04_seller_member_code%TYPE,
        p_t04_sender_status         t04_share_transfer.t04_sender_status%TYPE,
        p_t04_receiver_status       t04_share_transfer.t04_receiver_status%TYPE)
    IS
    BEGIN
        INSERT INTO t04_share_transfer (t04_id,
                                        t04_oms_ref,
                                        t04_receiver_ref,
                                        t04_movement_type,
                                        t04_settlement_date,
                                        t04_transaction_date,
                                        t04_isincode,
                                        t04_quantity,
                                        t04_buyer_acc_no,
                                        t04_buyer_member_code,
                                        t04_seller_acc_no,
                                        t04_seller_member_code,
                                        t04_sender_status,
                                        t04_receiver_status,
                                        t04_type)
             VALUES (seq_t04_id.NEXTVAL,
                     p_t04_oms_ref,
                     p_t04_receiver_ref,
                     p_t04_movement_type,
                     p_t04_settlement_date,
                     p_t04_transaction_date,
                     p_t04_isincode,
                     p_t04_quantity,
                     p_t04_buyer_acc_no,
                     p_t04_buyer_member_code,
                     p_t04_seller_acc_no,
                     p_t04_seller_member_code,
                     p_t04_sender_status,
                     p_t04_receiver_status,
                     p_t04_type);
    END;

    PROCEDURE get_details_for_stock_deposit (pview         OUT refcursor,
                                             p_t04_id   IN     NUMBER) /* receiver record id */
    IS
        l_broker_code             VARCHAR2 (100);
        l_t04_buyer_member_code   t04_share_transfer.t04_buyer_member_code%TYPE;
    BEGIN
        SELECT t04.t04_buyer_member_code
          INTO l_t04_buyer_member_code
          FROM t04_share_transfer t04
         WHERE t04.t04_id = p_t04_id;


        SELECT MAX (m04.m07_broker_code)
          INTO l_broker_code
          FROM m07_clearing_member_details m04;

        IF (l_broker_code <> l_t04_buyer_member_code)
        THEN
            OPEN pview FOR
                SELECT t04.t04_isincode,
                       t04.t04_quantity,
                       t04.t04_buyer_acc_no,
                       t04.t04_buyer_member_code,
                       t04.t04_seller_acc_no,
                       t04.t04_seller_member_code
                  FROM t04_share_transfer t04
                 WHERE t04.t04_id = p_t04_id;
        END IF;
    END;

    PROCEDURE insert_pledge_transfer (
        p_t05_oms_ref                t05_pledge_transfer.t05_oms_ref%TYPE,
        p_t05_type                   t05_pledge_transfer.t05_type%TYPE,
        p_t05_isincode               t05_pledge_transfer.t05_isincode%TYPE,
        p_t05_quantity               t05_pledge_transfer.t05_quantity%TYPE,
        p_t05_pledgor_acc_no         t05_pledge_transfer.t05_pledgor_acc_no%TYPE,
        p_t05_pledgor_member_code    t05_pledge_transfer.t05_pledgor_member_code%TYPE,
        p_t05_pledgee_acc_no         t05_pledge_transfer.t05_pledgee_acc_no%TYPE,
        p_t05_pledgee_member_code    t05_pledge_transfer.t05_pledgee_member_code%TYPE,
        p_t05_pledge_type            t05_pledge_transfer.t05_pledge_type%TYPE,
        p_t05_sender_status          t05_pledge_transfer.t05_sender_status%TYPE,
        p_t05_receiver_status        t05_pledge_transfer.t05_receiver_status%TYPE)
    IS
    BEGIN
        INSERT INTO t05_pledge_transfer (t05_id,
                                         t05_oms_ref,
                                         t05_type,
                                         t05_isincode,
                                         t05_quantity,
                                         t05_pledgor_acc_no,
                                         t05_pledgor_member_code,
                                         t05_pledgee_acc_no,
                                         t05_pledgee_member_code,
                                         t05_pledge_type,
                                         t05_sender_status,
                                         t05_receiver_status,
                                         t05_created_date)
             VALUES (seq_t05_id.NEXTVAL,
                     p_t05_oms_ref,
                     p_t05_type,
                     p_t05_isincode,
                     p_t05_quantity,
                     p_t05_pledgor_acc_no,
                     p_t05_pledgor_member_code,
                     p_t05_pledgee_acc_no,
                     p_t05_pledgee_member_code,
                     p_t05_pledge_type,
                     p_t05_sender_status,
                     p_t05_receiver_status,
                     SYSDATE);
    END;
END;
/