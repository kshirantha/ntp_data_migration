CREATE OR REPLACE PACKAGE dfn_ntp.pkg_csm
IS
    PROCEDURE get_trade_list (p_view            OUT SYS_REFCURSOR,
                              prows             OUT NUMBER,
                              psortby               VARCHAR2 DEFAULT NULL,
                              pfromrownumber        NUMBER DEFAULT NULL,
                              ptorownumber          NUMBER DEFAULT NULL,
                              psearchcriteria       VARCHAR2 DEFAULT NULL,
                              pfromdate             DATE,
                              ptodate               DATE);

    PROCEDURE get_trade_list_details (
        p_view               OUT SYS_REFCURSOR,
        prows                OUT NUMBER,
        psortby                  VARCHAR2 DEFAULT NULL,
        pfromrownumber           NUMBER DEFAULT NULL,
        ptorownumber             NUMBER DEFAULT NULL,
        psearchcriteria          VARCHAR2 DEFAULT NULL,
        pa02_a15_id       IN     dfn_csm.a02_trade_request_list_details.a02_a15_id%TYPE DEFAULT NULL);

    PROCEDURE get_trade_captured_list (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL,
        pfromdate             DATE,
        ptodate               DATE);

    PROCEDURE get_trade_captured_lst_details (
        p_view               OUT SYS_REFCURSOR,
        prows                OUT NUMBER,
        psortby                  VARCHAR2 DEFAULT NULL,
        pfromrownumber           NUMBER DEFAULT NULL,
        ptorownumber             NUMBER DEFAULT NULL,
        psearchcriteria          VARCHAR2 DEFAULT NULL,
        pa01_id           IN     dfn_csm.a01_trade_request_list.a01_id%TYPE DEFAULT -1,
        ptype             IN     dfn_csm.a02_trade_request_list_details.a02_type%TYPE DEFAULT 1);

    PROCEDURE add_trade_list (
        pkey                  OUT VARCHAR,
        pa01_csd_acc       IN     dfn_csm.a01_trade_request_list.a01_csd_acc%TYPE,
        pa01_ccp_acc       IN     dfn_csm.a01_trade_request_list.a01_ccp_acc%TYPE,
        pa01_symbol        IN     dfn_csm.a01_trade_request_list.a01_symbol%TYPE,
        pa01_exchange      IN     dfn_csm.a01_trade_request_list.a01_exchange%TYPE DEFAULT NULL,
        pa01_side          IN     dfn_csm.a01_trade_request_list.a01_side%TYPE DEFAULT NULL,
        pa01_trade_date    IN     dfn_csm.a01_trade_request_list.a01_trade_date%TYPE DEFAULT NULL,
        pa01_settle_date   IN     dfn_csm.a01_trade_request_list.a01_settle_date%TYPE DEFAULT NULL,
        pa01_quantity      IN     dfn_csm.a01_trade_request_list.a01_quantity%TYPE,
        pa01_avg_price     IN     dfn_csm.a01_trade_request_list.a01_avg_price%TYPE,
        pa01_cust_no       IN     dfn_csm.a01_trade_request_list.a01_cust_no%TYPE DEFAULT NULL,
        pa01_status        IN     dfn_csm.a01_trade_request_list.a01_status%TYPE DEFAULT NULL,
        pa01_created_by    IN     dfn_csm.a01_trade_request_list.a01_created_by%TYPE DEFAULT NULL);



    PROCEDURE validate_trade (
        pkey              OUT VARCHAR,
        pa01_csd_acc   IN     dfn_csm.a01_trade_request_list.a01_csd_acc%TYPE DEFAULT NULL,
        pa01_ccp_acc   IN     dfn_csm.a01_trade_request_list.a01_ccp_acc%TYPE DEFAULT NULL,
        pa00_sym       IN     dfn_csm.a00_trade_capture_report.a00_sym%TYPE DEFAULT NULL,
        pa00_side      IN     dfn_csm.a00_trade_capture_report.a00_side%TYPE DEFAULT NULL,
        pa00_trddt     IN     dfn_csm.a00_trade_capture_report.a00_trddt%TYPE DEFAULT NULL,
        pa00_settldt   IN     dfn_csm.a00_trade_capture_report.a00_settldt%TYPE DEFAULT NULL,
        ptype          IN     dfn_csm.a02_trade_request_list_details.a02_type%TYPE DEFAULT 1);

    PROCEDURE get_trade_rectification_list (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL,
        pfromdate             DATE DEFAULT SYSDATE,
        ptodate               DATE DEFAULT SYSDATE);

    PROCEDURE update_trade_rectification (pkey               OUT VARCHAR,
                                          pa05_id                NUMBER,
                                          pa05_csd_acc           VARCHAR,
                                          pa05_ccp_acc           VARCHAR,
                                          pa05_trd_acc_id        NUMBER,
                                          pa05_modified_by       NUMBER);

    PROCEDURE sp_get_trade_cap_req_det (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL,
        pfromdate             DATE,
        ptodate               DATE);

    PROCEDURE sp_t02_add (
        pkey           OUT VARCHAR2,
        pt02_date   IN     dfn_csm.t02_trade_capture_request.t02_date%TYPE,
        puser_id           NUMBER,
        pex01_id           VARCHAR2);

    PROCEDURE edit_trade_list (
        pkey                  OUT VARCHAR,
        pa01_id            IN     dfn_csm.a01_trade_request_list.a01_id%TYPE,
        pa01_splitted_by   IN     dfn_csm.a01_trade_request_list.a01_splitted_by%TYPE,
        pa01_status        IN     dfn_csm.a01_trade_request_list.a01_status%TYPE DEFAULT 2);

    PROCEDURE sp_t02_resend (
        pkey         OUT VARCHAR2,
        pt02_id   IN     dfn_csm.t02_trade_capture_request.t02_id%TYPE);

    PROCEDURE margin_requirement_report (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL);

    PROCEDURE get_trade_by_trade_settlements (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL);

    PROCEDURE get_margin_requirement_req (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL);

    PROCEDURE add_margin_requirement_req (
        pkey              OUT VARCHAR2,
        pa08_user_id   IN     dfn_csm.a08_margin_requirement_request.a08_user_id%TYPE,
        pex01_id              VARCHAR2);

    PROCEDURE update_margin_req_status (pkey          OUT VARCHAR,
                                        pa08_id           NUMBER,
                                        pa08_status       VARCHAR,
                                        puser_id          NUMBER);

    PROCEDURE get_collateral_inquiry (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL);

    PROCEDURE add_collateral_inquiry (
        pkey                   OUT VARCHAR2,
        pa10_request_date   IN     dfn_csm.a10_collateral_inquiry.a10_request_date%TYPE,
        pa10_user_id        IN     dfn_csm.a10_collateral_inquiry.a10_user_id%TYPE,
        pex01_id                   VARCHAR2);

    PROCEDURE update_collateral_inq_status (
        pkey          OUT VARCHAR,
        pa10_id           dfn_csm.a10_collateral_inquiry.a10_id%TYPE,
        pa10_status       dfn_csm.a10_collateral_inquiry.a10_status%TYPE,
        puser_id          NUMBER);

    PROCEDURE collateral_report (p_view            OUT SYS_REFCURSOR,
                                 prows             OUT NUMBER,
                                 psortby               VARCHAR2 DEFAULT NULL,
                                 pfromrownumber        NUMBER DEFAULT NULL,
                                 ptorownumber          NUMBER DEFAULT NULL,
                                 psearchcriteria       VARCHAR2 DEFAULT NULL);

    PROCEDURE get_collateral_assignment (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL);

    PROCEDURE add_collateral_assignment (
        pkey                           OUT VARCHAR2,
        pa12_collateral_asset_act   IN     dfn_csm.a12_collateral_assignment.a12_collateral_asset_act%TYPE,
        pa12_symbol                 IN     dfn_csm.a12_collateral_assignment.a12_symbol%TYPE,
        pa12_quantity               IN     dfn_csm.a12_collateral_assignment.a12_quantity%TYPE,
        pa12_isincode               IN     dfn_csm.a12_collateral_assignment.a12_isincode%TYPE,
        pa12_amount                 IN     dfn_csm.a12_collateral_assignment.a12_amount%TYPE,
        pex01_id                           VARCHAR2,
        puser_id                           NUMBER);

    PROCEDURE update_collateral_assgn_status (
        pkey          OUT VARCHAR,
        pa12_id           dfn_csm.a12_collateral_assignment.a12_id%TYPE,
        pa12_status       dfn_csm.a12_collateral_assignment.a12_status%TYPE,
        puser_id          NUMBER);

    PROCEDURE get_settlement_pos_req (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL,
        pfromdate             DATE DEFAULT SYSDATE,
        ptodate               DATE DEFAULT SYSDATE);

    PROCEDURE add_settle_pos_req (
        pkey                     OUT VARCHAR2,
        pa13_csd_acc          IN     dfn_csm.a13_settlement_position_req.a13_csd_acc%TYPE,
        pa13_trading_acc_id   IN     dfn_csm.a13_settlement_position_req.a13_trading_acc_id%TYPE,
        pa13_symbol           IN     dfn_csm.a13_settlement_position_req.a13_symbol%TYPE,
        pa13_user_id          IN     dfn_csm.a13_settlement_position_req.a13_user_id%TYPE,
        pa13_isincode         IN     dfn_csm.a13_settlement_position_req.a13_isincode%TYPE,
        pa13_request_date     IN     dfn_csm.a13_settlement_position_req.a13_request_date%TYPE,
        p_institution         IN     NUMBER,
        pex01_id              IN     NUMBER);

    PROCEDURE update_settle_pos_req_status (
        pkey          OUT VARCHAR,
        pa13_id           dfn_csm.a13_settlement_position_req.a13_id%TYPE,
        pa13_status       dfn_csm.a13_settlement_position_req.a13_status%TYPE,
        puser_id          NUMBER);

    PROCEDURE sp_validate_request (pkey OUT VARCHAR2, pdate IN DATE);

    PROCEDURE sp_update_t02_status (
        pkey          OUT VARCHAR,
        pt02_id           dfn_csm.t02_trade_capture_request.t02_id%TYPE,
        pt02_status       dfn_csm.t02_trade_capture_request.t02_status%TYPE,
        puser_id          NUMBER);

    PROCEDURE sp_m07_clearing_det_add (
        pkey                  OUT VARCHAR2,
        pm07_ex01_id       IN     dfn_csm.m07_clearing_member_details.m07_ex01_id%TYPE,
        pm07_member_code   IN     dfn_csm.m07_clearing_member_details.m07_member_code%TYPE,
        pm07_description   IN     dfn_csm.m07_clearing_member_details.m07_description%TYPE,
        pm07_broker_code   IN     dfn_csm.m07_clearing_member_details.m07_broker_code%TYPE DEFAULT NULL);

    PROCEDURE sp_add_a15_aggregate_list (pkey OUT VARCHAR, pdate DATE);

    PROCEDURE sp_a02_populate (pkey OUT VARCHAR2, pa01_type NUMBER);

    PROCEDURE sp_update_a02_agg_status (
        pkey          OUT VARCHAR2,
        plist             VARCHAR2,
        pcreated_by       dfn_csm.a01_trade_request_list.a01_created_by%TYPE DEFAULT 0);

    PROCEDURE sp_validate_a02 (
        pkey         OUT VARCHAR2,
        pa15_id   IN     dfn_csm.a15_aggregate_list.a15_id%TYPE);

    PROCEDURE sp_update_a01_status (
        pkey                        OUT VARCHAR2,
        pa01_id                  IN     dfn_csm.a01_trade_request_list.a01_id%TYPE,
        pa01_status              IN     dfn_csm.a01_trade_request_list.a01_status%TYPE,
        pa01_status_changed_by   IN     dfn_csm.a01_trade_request_list.a01_status_changed_by%TYPE,
        pa01_type                IN     dfn_csm.a01_trade_request_list.a01_type%TYPE DEFAULT 1);

    PROCEDURE add_trade_list_details (
        pkey               OUT VARCHAR,
        pa02_a01_id     IN     dfn_csm.a02_trade_request_list_details.a02_a01_id%TYPE DEFAULT NULL,
        pa02_csd_acc    IN     dfn_csm.a02_trade_request_list_details.a02_csd_acc%TYPE DEFAULT NULL,
        pa02_ccp_acc    IN     dfn_csm.a02_trade_request_list_details.a02_ccp_acc%TYPE DEFAULT NULL,
        pa02_price      IN     dfn_csm.a02_trade_request_list_details.a02_price%TYPE DEFAULT NULL,
        pa02_quantity   IN     dfn_csm.a02_trade_request_list_details.a02_quantity%TYPE DEFAULT NULL,
        ptype           IN     dfn_csm.a02_trade_request_list_details.a02_type%TYPE DEFAULT 1);

    PROCEDURE trade_capture_report (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL);

    PROCEDURE sp_update_a05_status (
        pkey                     OUT VARCHAR,
        pa05_id                      dfn_csm.a05_trade_rec_notif.a05_id%TYPE,
        pa05_status_id               dfn_csm.a05_trade_rec_notif.a05_status_id%TYPE,
        pa05_status_changed_by       dfn_csm.a05_trade_rec_notif.a05_status_changed_by%TYPE);

    PROCEDURE sp_validate_rectification (
        pkey             OUT VARCHAR2,
        pa05_trd_id   IN     dfn_csm.a05_trade_rec_notif.a05_trd_id%TYPE);

    PROCEDURE sp_get_share_transfer_details (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL,
        pfromdate             DATE,
        ptodate               DATE);

    PROCEDURE sp_update_t04_status (
        pkey                   OUT VARCHAR,
        pt04_id                    dfn_csm.t04_share_transfer.t04_id%TYPE,
        pt04_receiver_status       dfn_csm.t04_share_transfer.t04_receiver_status%TYPE,
        pt04_l1_approved_by        dfn_csm.t04_share_transfer.t04_l1_approved_by%TYPE);

    PROCEDURE sp_m07_clearing_det_edit (
        pkey                  OUT VARCHAR2,
        pm07_id            IN     dfn_csm.m07_clearing_member_details.m07_id%TYPE,
        pm07_member_code   IN     dfn_csm.m07_clearing_member_details.m07_member_code%TYPE,
        pm07_description   IN     dfn_csm.m07_clearing_member_details.m07_description%TYPE);

    PROCEDURE sp_get_reverse_executions (
        pview            OUT SYS_REFCURSOR,
        pa02_a01_id   IN     dfn_csm.a02_trade_request_list_details.a02_a01_id%TYPE);

    PROCEDURE sp_get_recapture_executions (
        pview            OUT SYS_REFCURSOR,
        pa02_a01_id   IN     dfn_csm.a02_trade_request_list_details.a02_a01_id%TYPE);

    PROCEDURE sp_audit_details (p_view            OUT SYS_REFCURSOR,
                                prows             OUT NUMBER,
                                psortby               VARCHAR2 DEFAULT NULL,
                                pfromrownumber        NUMBER DEFAULT NULL,
                                ptorownumber          NUMBER DEFAULT NULL,
                                psearchcriteria       VARCHAR2 DEFAULT NULL,
                                pfromdate             DATE,
                                ptodate               DATE);

    PROCEDURE sp_pledge_details (p_view            OUT SYS_REFCURSOR,
                                 prows             OUT NUMBER,
                                 psortby               VARCHAR2 DEFAULT NULL,
                                 pfromrownumber        NUMBER DEFAULT NULL,
                                 ptorownumber          NUMBER DEFAULT NULL,
                                 psearchcriteria       VARCHAR2 DEFAULT NULL,
                                 pfromdate             DATE,
                                 ptodate               DATE);
END;
/


CREATE OR REPLACE PACKAGE BODY dfn_ntp.pkg_csm
IS
    PROCEDURE get_trade_list (p_view            OUT SYS_REFCURSOR,
                              prows             OUT NUMBER,
                              psortby               VARCHAR2 DEFAULT NULL,
                              pfromrownumber        NUMBER DEFAULT NULL,
                              ptorownumber          NUMBER DEFAULT NULL,
                              psearchcriteria       VARCHAR2 DEFAULT NULL,
                              pfromdate             DATE,
                              ptodate               DATE)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
               'SELECT a15.a15_symbol AS symbol,
                       CASE WHEN a15.a15_side = 1 THEN ''BUY'' ELSE ''SELL'' END AS code,
                       a15.a15_side AS side,
                       a15.a15_csd_acc AS exchange_ac,
                       a15.a15_exchange AS exchange,
                       a15.a15_ccp_acc AS ccp_account_no,
                       a15.a15_settle_date AS settlement_date,
                       TRUNC (a15.a15_trade_date) AS trade_date,
                       a15.a15_quantity AS quantity,
                       CASE a15.a15_status
                           WHEN 2 THEN ''PARTIALLY AGGREGATED''
                           WHEN 3 THEN ''AGGREGATED''
                           WHEN 10 THEN ''PENDING''
                           WHEN 4 THEN ''INITIATE''
                           WHEN 11 THEN ''L1 APPROVED''
                           WHEN 12 THEN ''SENT TO MUQASSA''
                           WHEN 1 THEN ''REJECT''
                           ELSE ''''
                       END
                           AS status,
                       a15.a15_status AS a15_status,
                       a15.a15_avg_price AS avg_price,
                       a15.a15_customer_name AS cust_name,
                       a15_cust_no AS cust_no,
                       a15_id
                  FROM dfn_csm.a15_aggregate_list a15
                 WHERE a15_trade_date BETWEEN TO_DATE ('''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'') AND  TO_DATE ('''
            || TO_CHAR (ptodate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'') + 0.99999';

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE get_trade_list_details (
        p_view               OUT SYS_REFCURSOR,
        prows                OUT NUMBER,
        psortby                  VARCHAR2 DEFAULT NULL,
        pfromrownumber           NUMBER DEFAULT NULL,
        ptorownumber             NUMBER DEFAULT NULL,
        psearchcriteria          VARCHAR2 DEFAULT NULL,
        pa02_a15_id       IN     dfn_csm.a02_trade_request_list_details.a02_a15_id%TYPE DEFAULT NULL)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
               'SELECT t01.u07_customer_id_u01 AS customer_id,
                       a00.a00_sym AS symbol,
                       CASE WHEN a00.a00_side = 1 THEN ''BUY'' ELSE ''SELL'' END AS side,
                       t01.u07_exchange_account_no AS exchange_ac,
                       t01.m86_account_number AS ccp_account_no,
                       t01.t02_exchange_code_m01 AS exchange,
                       a00.a00_settldt AS settlement_date,
                       TRUNC (a00.a00_trddt) AS trade_date,
                       a02_quantity AS quantity,
                       a02_price AS avg_price,
                       t01.u07_display_name_u01 AS cust_name,
                       t01.u07_customer_no_u01 AS cust_no,
                       a02_is_select AS tick,
                       CASE
                           WHEN a02_status = 10 THEN ''PENDING''
                           WHEN a02_status = 0 THEN ''ACCEPTED''
                           WHEN a02_status = 1 THEN ''REJECTED''
                           WHEN a02_status = 12 THEN ''SENT TO MUQASSA''
                           WHEN a02_status = 11 THEN ''L1 APPROVED''
                           ELSE ''''
                       END
                           AS status,
                       a02_a00_trdid,
                       a02_status,
                       a02_a15_id
                  FROM dfn_csm.a00_trade_capture_report a00
                       JOIN dfn_csm.a02_trade_request_list_details a02
                           ON a00.a00_trdid = a02.a02_a00_trdid
                       JOIN vw_csm_todays_executions_dtls t01
                           ON a00.a00_trdid = t01.t02_order_exec_id
                 WHERE a02_a15_id = '
            || pa02_a15_id;

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE get_trade_captured_list (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL,
        pfromdate             DATE,
        ptodate               DATE)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
               'SELECT a01.a01_id,
                       a01.a01_cust_no AS cust_no,
                       a01.a01_symbol AS symbol,
                       CASE WHEN a01.a01_side = 1 THEN ''Buy'' ELSE ''SELL'' END AS code,
                       a01.a01_side AS side,
                       a01.a01_csd_acc AS exchange_ac,
                       a01.a01_ccp_acc AS ccp_account_no,
                       a01.a01_settle_date AS settlement_date,
                       TRUNC (a01.a01_trade_date) AS trade_date,
                       a01.a01_quantity AS quantity,
                       CASE a01.a01_status
                           WHEN 0 THEN ''Accepted''
                           WHEN 1 THEN ''Rejected''
                           WHEN 10 THEN ''Pending''
                           WHEN 11 THEN ''L1 Approved''
                           WHEN 12 THEN ''Sent to Muqassa''
                           ELSE ''''
                       END
                           AS status,
                       a01.a01_status,
                       a01.a01_customer_name AS cust_name,
                       a01.a01_avg_price AS avg_price,
                       a01.a01_a15_id,
                       a01.a01_type,
                       CASE
                           WHEN a01.a01_type = 1 THEN ''Aggregate''
                           WHEN a01.a01_type = 2 THEN ''Split''
                       END
                           AS TYPE,
                       a01.a01_customer_id AS customer_id,
                       a01.a01_trading_acc_id,
                       u07.u07_cash_account_id_u06
                  FROM dfn_csm.a01_trade_request_list a01
                        JOIN u07_trading_account u07
                           ON a01.a01_trading_acc_id = u07.u07_id
                 WHERE a01_trade_date BETWEEN TO_DATE ('''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'') AND TO_DATE ('''
            || TO_CHAR (ptodate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'') + 0.99999';

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE get_trade_captured_lst_details (
        p_view               OUT SYS_REFCURSOR,
        prows                OUT NUMBER,
        psortby                  VARCHAR2 DEFAULT NULL,
        pfromrownumber           NUMBER DEFAULT NULL,
        ptorownumber             NUMBER DEFAULT NULL,
        psearchcriteria          VARCHAR2 DEFAULT NULL,
        pa01_id           IN     dfn_csm.a01_trade_request_list.a01_id%TYPE DEFAULT -1,
        ptype             IN     dfn_csm.a02_trade_request_list_details.a02_type%TYPE DEFAULT 1)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        IF ptype = 1
        THEN
            l_qry :=
                   'SELECT a00_id,
                           a01.a01_symbol AS symbol,
                           CASE WHEN a01.a01_side = 1 THEN ''BUY'' ELSE ''SELL'' END AS side,
                           a01.a01_side,
                           a01.a01_csd_acc AS exchange_ac,
                           a01.a01_exchange AS exchange,
                           a01.a01_ccp_acc AS ccp_account_no,
                           a01.a01_settle_date AS settlement_date,
                           TRUNC (a01.a01_trade_date) AS trade_date,
                           a00.a00_lastqty AS quantity,
                           CASE a02.a02_status
                               WHEN 1 THEN ''REJECTED''
                               WHEN 10 THEN ''PENDING''
                               WHEN 11 THEN ''L1 APPROVED''
                               WHEN 12 THEN ''SENT TO MUQASSA''
                               WHEN 0 THEN ''ACCEPTED''
                               ELSE ''''
                           END
                               AS status,
                           ROUND (a00.a00_lastpx, 2) AS avg_price,
                           a01.a01_customer_name AS cust_name,
                           a01.a01_cust_no AS cust_no,
                           a01_status,
                           a02.a02_a00_trdid
                      FROM dfn_csm.a01_trade_request_list a01,
                           dfn_csm.a02_trade_request_list_details a02,
                           dfn_csm.a00_trade_capture_report a00
                     WHERE     a01.a01_id = a02.a02_a01_id
                           AND a02.a02_a00_trdid = a00.a00_trdid
                           AND a02.a02_type = 1
                           AND a01.a01_id = '
                || pa01_id;
        ELSIF ptype = 2
        THEN
            l_qry :=
                   'SELECT NULL AS a00_id,
                           a02.a02_symbol AS symbol,
                           CASE WHEN a01.a01_side = 1 THEN ''BUY'' ELSE ''SELL'' END AS side,
                           a01.a01_side,
                           a02.a02_csd_acc AS exchange_ac,
                           a01.a01_exchange AS exchange,
                           a02.a02_ccp_acc AS ccp_account_no,
                           a01.a01_settle_date AS settlement_date,
                           TRUNC (a01.a01_trade_date) AS trade_date,
                           a02.a02_quantity AS quantity,
                           CASE a02.a02_status
                               WHEN 1 THEN ''REJECTED''
                               WHEN 10 THEN ''PENDING''
                               WHEN 11 THEN ''L1 APPROVED''
                               WHEN 12 THEN ''SENT TO MUQASSA''
                               WHEN 0 THEN ''ACCEPTED''
                               ELSE ''''
                           END
                               AS status,
                           ROUND (a02.a02_price, 2) AS avg_price,
                           a02.a02_customer_name AS cust_name,
                           a02.a02_customer_no AS cust_no,
                           a01_status,
                           a02.a02_a00_trdid
                      FROM dfn_csm.a02_trade_request_list_details a02,
                           dfn_csm.a01_trade_request_list a01
                     WHERE a02.a02_a01_id = a01.a01_id AND a02.a02_type = 2 AND a01.a01_id = '
                || pa01_id;
        END IF;

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE add_trade_list (
        pkey                  OUT VARCHAR,
        pa01_csd_acc       IN     dfn_csm.a01_trade_request_list.a01_csd_acc%TYPE,
        pa01_ccp_acc       IN     dfn_csm.a01_trade_request_list.a01_ccp_acc%TYPE,
        pa01_symbol        IN     dfn_csm.a01_trade_request_list.a01_symbol%TYPE,
        pa01_exchange      IN     dfn_csm.a01_trade_request_list.a01_exchange%TYPE DEFAULT NULL,
        pa01_side          IN     dfn_csm.a01_trade_request_list.a01_side%TYPE DEFAULT NULL,
        pa01_trade_date    IN     dfn_csm.a01_trade_request_list.a01_trade_date%TYPE DEFAULT NULL,
        pa01_settle_date   IN     dfn_csm.a01_trade_request_list.a01_settle_date%TYPE DEFAULT NULL,
        pa01_quantity      IN     dfn_csm.a01_trade_request_list.a01_quantity%TYPE,
        pa01_avg_price     IN     dfn_csm.a01_trade_request_list.a01_avg_price%TYPE,
        pa01_cust_no       IN     dfn_csm.a01_trade_request_list.a01_cust_no%TYPE DEFAULT NULL,
        pa01_status        IN     dfn_csm.a01_trade_request_list.a01_status%TYPE DEFAULT NULL,
        pa01_created_by    IN     dfn_csm.a01_trade_request_list.a01_created_by%TYPE DEFAULT NULL)
    IS
    BEGIN
        pkey := dfn_csm.seq_a01_id.NEXTVAL;

        INSERT INTO dfn_csm.a01_trade_request_list (a01_id,
                                                    a01_csd_acc,
                                                    a01_ccp_acc,
                                                    a01_symbol,
                                                    a01_exchange,
                                                    a01_side,
                                                    a01_trade_date,
                                                    a01_settle_date,
                                                    a01_quantity,
                                                    a01_avg_price,
                                                    a01_cust_no,
                                                    a01_status,
                                                    a01_created_by,
                                                    a01_created_date,
                                                    a01_status_changed_by,
                                                    a01_status_changed_date,
                                                    a01_type)
             VALUES (pkey,
                     pa01_csd_acc,
                     pa01_ccp_acc,
                     pa01_symbol,
                     pa01_exchange,
                     pa01_side,
                     pa01_trade_date,
                     pa01_settle_date,
                     pa01_quantity,
                     pa01_avg_price,
                     pa01_cust_no,
                     pa01_status,
                     pa01_created_by,
                     SYSDATE,
                     pa01_created_by,
                     SYSDATE,
                     1);
    END;

    PROCEDURE edit_trade_list (
        pkey                  OUT VARCHAR,
        pa01_id            IN     dfn_csm.a01_trade_request_list.a01_id%TYPE,
        pa01_splitted_by   IN     dfn_csm.a01_trade_request_list.a01_splitted_by%TYPE,
        pa01_status        IN     dfn_csm.a01_trade_request_list.a01_status%TYPE DEFAULT 2)
    IS
    BEGIN
        UPDATE dfn_csm.a01_trade_request_list
           SET a01_status = pa01_status,
               a01_splitted_by = pa01_splitted_by,
               a01_splitted_date = SYSDATE,
               a01_type = 2
         WHERE a01_id = pa01_id;

        pkey := pa01_id;
    END;

    PROCEDURE validate_trade (
        pkey              OUT VARCHAR,
        pa01_csd_acc   IN     dfn_csm.a01_trade_request_list.a01_csd_acc%TYPE DEFAULT NULL,
        pa01_ccp_acc   IN     dfn_csm.a01_trade_request_list.a01_ccp_acc%TYPE DEFAULT NULL,
        pa00_sym       IN     dfn_csm.a00_trade_capture_report.a00_sym%TYPE DEFAULT NULL,
        pa00_side      IN     dfn_csm.a00_trade_capture_report.a00_side%TYPE DEFAULT NULL,
        pa00_trddt     IN     dfn_csm.a00_trade_capture_report.a00_trddt%TYPE DEFAULT NULL,
        pa00_settldt   IN     dfn_csm.a00_trade_capture_report.a00_settldt%TYPE DEFAULT NULL,
        ptype          IN     dfn_csm.a02_trade_request_list_details.a02_type%TYPE DEFAULT 1)
    IS
        l_count   NUMBER;
    BEGIN
        IF pa01_ccp_acc IS NULL
        THEN
            SELECT COUNT (*)
              INTO l_count
              FROM dfn_csm.a01_trade_request_list a01
             WHERE     a01.a01_csd_acc = pa01_csd_acc
                   AND a01.a01_side = pa00_side
                   AND a01.a01_symbol = pa00_sym
                   AND a01.a01_trade_date BETWEEN pa00_trddt
                                              AND pa00_trddt + 0.99999
                   AND a01.a01_settle_date BETWEEN pa00_settldt
                                               AND pa00_settldt + 0.99999
                   AND a01.a01_status = ptype;
        ELSE
            SELECT COUNT (*)
              INTO l_count
              FROM dfn_csm.a01_trade_request_list a01
             WHERE     a01.a01_csd_acc = pa01_csd_acc
                   AND a01.a01_ccp_acc = pa01_ccp_acc
                   AND a01.a01_side = pa00_side
                   AND a01.a01_symbol = pa00_sym
                   AND a01.a01_trade_date BETWEEN pa00_trddt
                                              AND pa00_trddt + 0.99999
                   AND a01.a01_settle_date BETWEEN pa00_settldt
                                               AND pa00_settldt + 0.99999
                   AND a01.a01_status = ptype;
        END IF;

        IF l_count > 0
        THEN
            pkey := -2;
        ELSE
            pkey := 1;
        END IF;
    END;

    PROCEDURE get_trade_rectification_list (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL,
        pfromdate             DATE DEFAULT SYSDATE,
        ptodate               DATE DEFAULT SYSDATE)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
               'SELECT a05.a05_id,
                   a05.a05_notif_id,
                   a05.a05_notif_date,
                   TO_CHAR (a05.a05_notif_time, ''HH:MI:SS'') AS a05_notif_time,
                   a05.a05_symbol,
                   a05.a05_trd_id,
                   a05.a05_status_id,
                   CASE
                       WHEN a05.a05_status_id = 0 THEN ''AVAILABLE''
                       WHEN a05.a05_status_id = 10 THEN ''PENDING''
                       WHEN a05.a05_status_id = 12 THEN ''SENT TO MUQASSA''
                       WHEN a05.a05_status_id = 3 THEN ''RECTIFIED''
                       WHEN a05.a05_status_id = 11 THEN ''L1 APPROVED''
                       WHEN a05.a05_status_id = 4 THEN ''FAILED''
                   END
                       AS a05_status,
                   a05_csd_acc AS csd_acc_no,
                   a05_ccp_acc AS ccp_acc_no,
                   a05_rectified_csd_acc,
                   a05_rectified_ccp_acc,
                   a05_trading_acc_id
              FROM dfn_csm.a05_trade_rec_notif a05
             WHERE a05.a05_notif_date BETWEEN TO_DATE ('''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'') AND  TO_DATE ('''
            || TO_CHAR (ptodate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'') + 0.99999';

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE update_trade_rectification (pkey               OUT VARCHAR,
                                          pa05_id                NUMBER,
                                          pa05_csd_acc           VARCHAR,
                                          pa05_ccp_acc           VARCHAR,
                                          pa05_trd_acc_id        NUMBER,
                                          pa05_modified_by       NUMBER)
    IS
    BEGIN
        pkey := 1;

        UPDATE dfn_csm.a05_trade_rec_notif
           SET a05_rectified_csd_acc = pa05_csd_acc,
               a05_rectified_ccp_acc = pa05_ccp_acc,
               a05_trading_acc_id = pa05_trd_acc_id,
               a05_status_id = 1,
               a05_modified_by = pa05_modified_by,
               a05_modified_date = SYSDATE,
               a05_status_changed_by = pa05_modified_by,
               a05_status_changed_date = SYSDATE
         WHERE a05_id = pa05_id;

        dfn_csm.pkg_dc_t03_audit.t03_add (
            pa05_modified_by,
            5,
            'Trade Rectification For ID: ' || pa05_id || ' Updated.',
            'ID:' || pa05_id);
    EXCEPTION
        WHEN OTHERS
        THEN
            pkey := -2;
    END;

    PROCEDURE sp_get_trade_cap_req_det (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL,
        pfromdate             DATE,
        ptodate               DATE)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
               'SELECT t02_id,
                       t02_date,
                       t02_status,
                       CASE
                           WHEN t02_status = 0 THEN ''ACCEPTED''
                           WHEN t02_status = 1 THEN ''COMPLETED''
                           WHEN t02_status = 2 THEN ''REJECTED''
                           WHEN t02_status = 10 THEN ''PENDING''
                           WHEN t02_status = 11 THEN ''L1 APPROVED''
                           WHEN t02_status = 12 THEN ''SENT TO MUQASSA''
                       END
                           AS status,
                       t02.t02_reason
                  FROM dfn_csm.t02_trade_capture_request t02
                 WHERE t02.t02_date BETWEEN TO_DATE ('''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'') AND TO_DATE ('''
            || TO_CHAR (ptodate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'') + 0.99999';

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE sp_t02_add (
        pkey           OUT VARCHAR2,
        pt02_date   IN     dfn_csm.t02_trade_capture_request.t02_date%TYPE,
        puser_id           NUMBER,
        pex01_id           VARCHAR2)
    IS
        lcount         NUMBER;
        l_firm_id      NUMBER;
        l_firm_count   NUMBER;
    BEGIN
        SELECT COUNT (*)
          INTO lcount
          FROM dfn_csm.t02_trade_capture_request t02
         WHERE t02.t02_date = TRUNC (pt02_date);

        SELECT COUNT (*)
          INTO l_firm_count
          FROM dfn_csm.m07_clearing_member_details m07
         WHERE m07.m07_ex01_id = pex01_id;

        IF (l_firm_count = 0)
        THEN
            pkey := '-3';
            RETURN;
        END IF;

        IF (lcount > 0)
        THEN
            pkey := '-2';
            RETURN;
        END IF;

        SELECT m07.m07_id
          INTO l_firm_id
          FROM dfn_csm.m07_clearing_member_details m07
         WHERE m07.m07_ex01_id = pex01_id;

        pkey := dfn_csm.seq_t02_id.NEXTVAL;

        INSERT INTO dfn_csm.t02_trade_capture_request (t02_id,
                                                       t02_date,
                                                       t02_status,
                                                       t02_firm_id)
             VALUES (pkey,
                     TRUNC (pt02_date),
                     10,
                     l_firm_id);

        dfn_csm.pkg_dc_t03_audit.t03_add (
            puser_id,
            6,
               'Trade Capture Request for ['
            || TRUNC (pt02_date)
            || '] Created.',
            'ID:' || pkey);
    END;

    PROCEDURE sp_t02_resend (
        pkey         OUT VARCHAR2,
        pt02_id   IN     dfn_csm.t02_trade_capture_request.t02_id%TYPE)
    IS
    BEGIN
        UPDATE dfn_csm.t02_trade_capture_request
           SET t02_status = 3
         WHERE t02_id = pt02_id;

        pkey := pt02_id;
    END;

    PROCEDURE margin_requirement_report (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
            'SELECT a09_id,
                       a09_rptid,
                       a09_reqid,
                       a09_rpttyp,
                       a09_bizdt,
                       a09_setsesid,
                       a09_setsessub,
                       a09_txntm,
                       a09_amt,
                       a09_typ,
                       a09_ccy,
                       m02_id,
                       m02_margin_type,
                       m02_description
                  FROM dfn_csm.a09_margin_requirement_report a09,
                       dfn_csm.m02_margin_types m02
                 WHERE a09.a09_typ = m02.m02_id';

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE get_trade_by_trade_settlements (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
            'SELECT NULL AS customer_id,
                   NULL AS cust_no,
                   NULL AS cust_name,
                   NULL AS trade_id,
                   NULL AS symbol,
                   NULL AS code,
                   NULL AS side,
                   NULL AS exchange_ac,
                   NULL AS ccp_account_no,
                   a04.a04_amount AS price,
                   a04.a04_quantity AS quantity,
                   a04.a04_trade_date AS trade_date,
                   a04.a04_settlement_date AS settlement_date,
                   a04.a04_settlement_status AS settlement_status,
                   a04.a04_match_status AS match_status,
                   a04.a04_reason_nmat AS reason
              FROM dfn_csm.a04_settlement_instruction a04';

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE get_margin_requirement_req (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
            'SELECT a08.a08_id,
                   a08.a08_request_date,
                   TO_CHAR (a08.a08_request_time, ''HH24:MI:SS'') AS a08_request_time,
                   a08.a08_status,
                   CASE
                       WHEN a08.a08_status = 0 THEN ''ACCEPTED''
                       WHEN a08.a08_status = 2 THEN ''COMPLETED''
                       WHEN a08.a08_status = 4 THEN ''REJECTED''
                       WHEN a08.a08_status = 10 THEN ''PENDING''
                       WHEN a08.a08_status = 11 THEN ''L1 APPROVED''
                       WHEN a08.a08_status = 12 THEN ''SENT TO MUQASSA''
                   END
                       AS status,
                   a08.a08_user_id
              FROM dfn_csm.a08_margin_requirement_request a08';

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE add_margin_requirement_req (
        pkey              OUT VARCHAR2,
        pa08_user_id   IN     dfn_csm.a08_margin_requirement_request.a08_user_id%TYPE,
        pex01_id              VARCHAR2)
    IS
        lcount         NUMBER;
        l_firm_id      NUMBER;
        l_firm_count   NUMBER;
    BEGIN
        SELECT COUNT (*)
          INTO lcount
          FROM dfn_csm.a08_margin_requirement_request a08
         WHERE TRUNC (a08.a08_request_date) = TRUNC (SYSDATE);

        SELECT COUNT (*)
          INTO l_firm_count
          FROM dfn_csm.m07_clearing_member_details m07
         WHERE m07.m07_ex01_id = pex01_id;

        IF (l_firm_count = 0)
        THEN
            pkey := '-3';
            RETURN;
        END IF;

        IF (lcount > 0)
        THEN
            pkey := '-2';
            RETURN;
        END IF;

        SELECT m07.m07_id
          INTO l_firm_id
          FROM dfn_csm.m07_clearing_member_details m07
         WHERE m07.m07_ex01_id = pex01_id;

        pkey := dfn_csm.seq_a08_id.NEXTVAL;

        INSERT INTO dfn_csm.a08_margin_requirement_request (a08_id,
                                                            a08_request_date,
                                                            a08_request_time,
                                                            a08_user_id,
                                                            a08_status,
                                                            a08_reason,
                                                            a08_firm_id)
             VALUES (pkey,
                     SYSDATE,
                     SYSDATE,
                     pa08_user_id,
                     10,
                     NULL,
                     l_firm_id);

        dfn_csm.pkg_dc_t03_audit.t03_add (
            pa08_user_id,
            1,
            'Margin Requirement Request for [' || SYSDATE || '] Created.',
            'ID:' || pkey);
    END;

    PROCEDURE update_margin_req_status (pkey          OUT VARCHAR,
                                        pa08_id           NUMBER,
                                        pa08_status       VARCHAR,
                                        puser_id          NUMBER)
    IS
        l_a08_request_date   DATE;
        l_a08_request_time   DATE;
        l_amount             NUMBER;
        l_count              NUMBER := 0;
        l_count1             NUMBER;
        l_rec_count          NUMBER;
        l_margin             NUMBER := 221;
    BEGIN
        IF (pa08_status = 11)
        THEN
            UPDATE dfn_csm.a08_margin_requirement_request
               SET a08_status = pa08_status,
                   a08_l1_approved_by = puser_id,
                   a08_l1_approved_date = SYSDATE
             WHERE a08_id = pa08_id;

            dfn_csm.pkg_dc_t03_audit.t03_add (
                puser_id,
                7,
                   'Margin Requirement Request ID:'
                || pa08_id
                || ' Status Changed to L1 Approved.',
                'ID:' || pa08_id);
        END IF;

        IF (pa08_status = 12)
        THEN
            UPDATE dfn_csm.a08_margin_requirement_request
               SET a08_status = pa08_status,
                   a08_l2_approved_by = puser_id,
                   a08_l2_approved_date = SYSDATE
             WHERE a08_id = pa08_id;

            dfn_csm.pkg_dc_t03_audit.t03_add (
                puser_id,
                7,
                   'Margin Requirement Request ID:'
                || pa08_id
                || ' Status Changed to Sent to Muqassa.',
                'ID:' || pa08_id);
        END IF;
    ----temporary need to belete after the Demo------
    /*IF (pa08_status = 12)
    THEN
        SELECT COUNT (*)
          INTO l_rec_count
          FROM dfn_csm.a09_margin_requirement_report
         WHERE TRUNC (a09_bizdt) = TRUNC (SYSDATE);

        IF (l_rec_count = 0)
        THEN
            l_count1 := dfn_csm.seq_a09_id.NEXTVAL;

            LOOP
                IF (l_count = 1)
                THEN
                    EXIT;
                END IF;


                SELECT a08_request_date, a08_request_time
                  INTO l_a08_request_date, l_a08_request_time
                  FROM dfn_csm.a08_margin_requirement_request
                 WHERE a08_id = pa08_id;


                INSERT
                  INTO dfn_csm.a09_margin_requirement_report (
                           a09_id,
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
                VALUES (
                           l_count1,
                           l_count || '' || l_count1,
                           pa08_id,
                           1,
                           l_a08_request_date,
                           '1',
                           l_a08_request_date + 2,
                           l_a08_request_time,
                             TO_NUMBER (
                                 TO_CHAR (
                                     TO_DATE (l_a08_request_date,
                                              'DD/MM/YYYY'),
                                     'DDMMYYYY'))
                           + l_count,
                           l_margin,
                           'SAR');

                l_count := l_count + 1;
                l_margin := l_margin + 1;
            END LOOP;
        END IF;

        UPDATE dfn_csm.a08_margin_requirement_request
           SET a08_status = 0
         WHERE a08_id = pa08_id;
    END IF;*/
    END;

    PROCEDURE get_collateral_inquiry (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
            'SELECT a10.a10_id,
                       a10.a10_request_date,
                       TO_CHAR(a10.a10_request_time, ''HH24:MI:SS'') AS a10_request_time,
                       a10.a10_status,
                       CASE
                           WHEN a10.a10_status = 0 THEN ''ACCEPTED''
                           WHEN a10.a10_status = 1 THEN ''FAILED''
                           WHEN a10.a10_status = 10 THEN ''PENDING''
                           WHEN a10.a10_status = 11 THEN ''L1 APPROVED''
                           WHEN a10.a10_status = 12 THEN ''SENT TO MUQASSA''
                       END
                           AS status,
                       a10.a10_user_id
                  FROM dfn_csm.a10_collateral_inquiry a10';

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE add_collateral_inquiry (
        pkey                   OUT VARCHAR2,
        pa10_request_date   IN     dfn_csm.a10_collateral_inquiry.a10_request_date%TYPE,
        pa10_user_id        IN     dfn_csm.a10_collateral_inquiry.a10_user_id%TYPE,
        pex01_id                   VARCHAR2)
    IS
        lcount         NUMBER;
        l_firm_id      NUMBER;
        l_firm_count   NUMBER;
    BEGIN
        SELECT COUNT (*)
          INTO lcount
          FROM dfn_csm.a10_collateral_inquiry a10
         WHERE a10.a10_request_date = pa10_request_date;

        SELECT COUNT (*)
          INTO l_firm_count
          FROM dfn_csm.m07_clearing_member_details m07
         WHERE m07.m07_ex01_id = pex01_id;

        IF (l_firm_count = 0)
        THEN
            pkey := '-3';
            RETURN;
        END IF;

        IF (lcount > 0)
        THEN
            pkey := '-2';
            RETURN;
        END IF;

        SELECT m07.m07_id
          INTO l_firm_id
          FROM dfn_csm.m07_clearing_member_details m07
         WHERE m07.m07_ex01_id = pex01_id;

        pkey := dfn_csm.seq_a10_id.NEXTVAL;

        INSERT INTO dfn_csm.a10_collateral_inquiry (a10_id,
                                                    a10_request_date,
                                                    a10_request_time,
                                                    a10_status,
                                                    a10_user_id,
                                                    a10_reason,
                                                    a10_firm_id)
             VALUES (pkey,
                     pa10_request_date,
                     SYSDATE,
                     10,
                     pa10_user_id,
                     NULL,
                     l_firm_id);

        dfn_csm.pkg_dc_t03_audit.t03_add (
            pa10_user_id,
            2,
               'Collateral Inquiry Request for ['
            || pa10_request_date
            || '] Created.',
            'ID:' || pkey);
    END;

    PROCEDURE update_collateral_inq_status (
        pkey          OUT VARCHAR,
        pa10_id           dfn_csm.a10_collateral_inquiry.a10_id%TYPE,
        pa10_status       dfn_csm.a10_collateral_inquiry.a10_status%TYPE,
        puser_id          NUMBER)
    IS
        l_a10_request_date   DATE;
        l_a10_request_time   DATE;
        l_amount             NUMBER;
        l_count              NUMBER := 0;
        l_count1             NUMBER;
    BEGIN
        IF (pa10_status = 11)
        THEN
            UPDATE dfn_csm.a10_collateral_inquiry
               SET a10_status = pa10_status,
                   a10_l1_approved_by = puser_id,
                   a10_l1_approved_date = SYSDATE
             WHERE a10_id = pa10_id;

            dfn_csm.pkg_dc_t03_audit.t03_add (
                puser_id,
                8,
                   'Collateral Inquiry Request ID:'
                || pa10_id
                || ' Status Changed to L1 Approved.',
                'ID:' || pa10_id);
        END IF;

        IF (pa10_status = 12)
        THEN
            UPDATE dfn_csm.a10_collateral_inquiry
               SET a10_status = pa10_status,
                   a10_l2_approved_by = puser_id,
                   a10_l2_approved_date = SYSDATE
             WHERE a10_id = pa10_id;

            dfn_csm.pkg_dc_t03_audit.t03_add (
                puser_id,
                8,
                   'Collateral Inquiry Request ID:'
                || pa10_id
                || ' Status Changed to Sent to Muqassa.',
                'ID:' || pa10_id);
        END IF;
    --temporary need to belete after the Demo

    /* IF (pa10_status = 12)
     THEN
         SELECT a10_request_date, a10_request_time
           INTO l_a10_request_date, l_a10_request_time
           FROM dfn_csm.a10_collateral_inquiry
          WHERE a10_id = pa10_id;

         SELECT COUNT (*) INTO l_count FROM dfn_csm.a11_collateral_report;

         IF (l_count = 0)
         THEN
             l_count1 := dfn_csm.seq_a11_id.NEXTVAL;

             INSERT INTO dfn_csm.a11_collateral_report (a11_id,
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
                  VALUES (1,
                          l_count1 || '' || '1',
                          l_count1,
                          l_a10_request_time,
                          3,
                          10,
                          l_a10_request_date,
                          NULL,
                          NULL,
                          NULL,
                          '1010',
                          NULL);

             l_count1 := dfn_csm.seq_a11_id.NEXTVAL;

             INSERT INTO dfn_csm.a11_collateral_report (a11_id,
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
                  VALUES (
                             1,
                             l_count1 || '' || '1',
                             l_count1,
                             l_a10_request_time,
                             3,
                             NULL,
                             l_a10_request_date,
                               TO_NUMBER (
                                   TO_CHAR (
                                       TO_DATE (l_a10_request_date,
                                                'DD/MM/YYYY'),
                                       'DDMMYYYY'))
                             + 50,
                             'SAR',
                             3,
                             NULL,
                             NULL);

             l_count1 := dfn_csm.seq_a11_id.NEXTVAL;

             INSERT INTO dfn_csm.a11_collateral_report (a11_id,
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
                  VALUES (
                             1,
                             l_count1 || '' || '1',
                             l_count1,
                             l_a10_request_time,
                             3,
                             NULL,
                             l_a10_request_date,
                               TO_NUMBER (
                                   TO_CHAR (
                                       TO_DATE (l_a10_request_date,
                                                'DD/MM/YYYY'),
                                       'DDMMYYYY'))
                             + 425,
                             'SAR',
                             3,
                             NULL,
                             NULL);
         END IF;

         UPDATE dfn_csm.a10_collateral_inquiry
            SET a10_status = 0
          WHERE a10_id = pa10_id;
     END IF;*/
    END;

    PROCEDURE collateral_report (p_view            OUT SYS_REFCURSOR,
                                 prows             OUT NUMBER,
                                 psortby               VARCHAR2 DEFAULT NULL,
                                 pfromrownumber        NUMBER DEFAULT NULL,
                                 ptorownumber          NUMBER DEFAULT NULL,
                                 psearchcriteria       VARCHAR2 DEFAULT NULL)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
            'SELECT a11.a11_id,
                   a11.a11_rptid,
                   a11.a11_bizdt,
                   a11.a11_txntm,
                   a11.a11_stat,
                   CASE
                       WHEN a11.a11_stat = 0 THEN ''UNASSIGNED''
                       WHEN a11.a11_stat = 1 THEN ''PARTIALLY ASSIGNED''
                       WHEN a11.a11_stat = 3 THEN ''ASSIGNED (ACCEPTED)''
                       WHEN a11.a11_stat = 4 THEN ''CHALLENGED''
                   END
                       AS status,
                   a11.a11_amt,
                   a11.a11_ccy,
                   m06.m06_amount_type,
                   a11.a11_qty,
                   a11.a11_symbol
              FROM dfn_csm.a11_collateral_report a11,
                   dfn_csm.m06_collateral_amount_type m06
             WHERE a11.a11_typ = m06.m06_id(+)';

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE get_collateral_assignment (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
            'SELECT a12.a12_id,
                   a12.a12_request_date,
                   TO_CHAR (a12.a12_request_date, ''HH24:MI:SS'') AS a12_request_time,
                   a12.a12_collateral_asset_act,
                   a12.a12_quantity,
                   a12.a12_amount,
                   a12.a12_symbol,
                   a12.a12_status,
                   CASE
                       WHEN a12.a12_status = 1 THEN ''ACCEPTED''
                       WHEN a12.a12_status = 3 THEN ''REJECTED''
                       WHEN a12.a12_status = 10 THEN ''PENDING''
                       WHEN a12.a12_status = 11 THEN ''L1 APPROVED''
                       WHEN a12.a12_status = 12 THEN ''SENT TO MUQASSA''
                   END
                       AS status,
                   a12.a12_received_datetime,
                   TO_CHAR (a12.a12_received_datetime, ''HH24:MI:SS'') AS a12_received_time
              FROM dfn_csm.a12_collateral_assignment a12';

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE add_collateral_assignment (
        pkey                           OUT VARCHAR2,
        pa12_collateral_asset_act   IN     dfn_csm.a12_collateral_assignment.a12_collateral_asset_act%TYPE,
        pa12_symbol                 IN     dfn_csm.a12_collateral_assignment.a12_symbol%TYPE,
        pa12_quantity               IN     dfn_csm.a12_collateral_assignment.a12_quantity%TYPE,
        pa12_isincode               IN     dfn_csm.a12_collateral_assignment.a12_isincode%TYPE,
        pa12_amount                 IN     dfn_csm.a12_collateral_assignment.a12_amount%TYPE,
        pex01_id                           VARCHAR2,
        puser_id                           NUMBER)
    IS
        lcount         NUMBER;
        l_firm_id      NUMBER;
        l_firm_count   NUMBER;
    BEGIN
        SELECT COUNT (*)
          INTO lcount
          FROM dfn_csm.a12_collateral_assignment a12
         WHERE     TRUNC (a12.a12_request_date) = TRUNC (SYSDATE)
               AND a12.a12_collateral_asset_act = pa12_collateral_asset_act
               AND a12.a12_symbol = pa12_symbol;

        SELECT COUNT (*)
          INTO l_firm_count
          FROM dfn_csm.m07_clearing_member_details m07
         WHERE m07.m07_ex01_id = pex01_id;

        IF (l_firm_count = 0)
        THEN
            pkey := '-3';
            RETURN;
        END IF;

        IF (lcount > 0)
        THEN
            pkey := '-2';
            RETURN;
        END IF;

        SELECT m07.m07_id
          INTO l_firm_id
          FROM dfn_csm.m07_clearing_member_details m07
         WHERE m07.m07_ex01_id = pex01_id;

        pkey := dfn_csm.seq_a12_id.NEXTVAL;

        INSERT
          INTO dfn_csm.a12_collateral_assignment (a12_id,
                                                  a12_request_date,
                                                  a12_collateral_asset_act,
                                                  a12_quantity,
                                                  a12_symbol,
                                                  a12_status,
                                                  a12_received_datetime,
                                                  a12_reason,
                                                  a12_isincode,
                                                  a12_firm_id,
                                                  a12_amount)
        VALUES (pkey,
                SYSDATE,
                pa12_collateral_asset_act,
                pa12_quantity,
                pa12_symbol,
                10,
                NULL,
                NULL,
                pa12_isincode,
                l_firm_id,
                pa12_amount);

        dfn_csm.pkg_dc_t03_audit.t03_add (
            puser_id,
            3,
               'Collateral Assignment Request for ['
            || TRUNC (SYSDATE)
            || '] Created.',
            'ID:' || pkey);
    END;

    PROCEDURE update_collateral_assgn_status (
        pkey          OUT VARCHAR,
        pa12_id           dfn_csm.a12_collateral_assignment.a12_id%TYPE,
        pa12_status       dfn_csm.a12_collateral_assignment.a12_status%TYPE,
        puser_id          NUMBER)
    IS
    BEGIN
        IF (pa12_status = 11)
        THEN
            UPDATE dfn_csm.a12_collateral_assignment
               SET a12_status = pa12_status,
                   a12_l1_approved_by = puser_id,
                   a12_l1_approved_date = SYSDATE
             WHERE a12_id = pa12_id;

            dfn_csm.pkg_dc_t03_audit.t03_add (
                puser_id,
                9,
                   'Collateral Assignment Request ID:'
                || pa12_id
                || ' Status Changed to L1 Approved.',
                'ID:' || pa12_id);
        END IF;

        IF (pa12_status = 12)
        THEN
            UPDATE dfn_csm.a12_collateral_assignment
               SET a12_status = pa12_status,
                   a12_l2_approved_by = puser_id,
                   a12_l2_approved_date = SYSDATE
             WHERE a12_id = pa12_id;

            dfn_csm.pkg_dc_t03_audit.t03_add (
                puser_id,
                9,
                   'Collateral Assignment Request ID:'
                || pa12_id
                || ' Status Changed to Sent to Muqassa.',
                'ID:' || pa12_id);
        END IF;
    --temporary need to belete after the Demo
    /*IF (pa12_status = 12)
    THEN
        UPDATE dfn_csm.a12_collateral_assignment
           SET a12_received_datetime = SYSDATE, a12_status = 1
         WHERE a12_id = pa12_id;
    END IF;*/
    END;

    PROCEDURE get_settlement_pos_req (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL,
        pfromdate             DATE DEFAULT SYSDATE,
        ptodate               DATE DEFAULT SYSDATE)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
               'SELECT a13.a13_id,
                   a13.a13_request_date,
                   TO_CHAR (a13.a13_request_time, ''HH24:MI:SS'') AS a13_request_time,
                   a13.a13_csd_acc,
                   a13.a13_trading_acc_id,
                   a13.a13_symbol,
                   a13.a13_status,
                   CASE
                       WHEN a13.a13_status = 0 THEN ''Completed''
                       WHEN a13.a13_status = 2 THEN ''Rejected''
                       WHEN a13.a13_status = 10 THEN ''Pending''
                       WHEN a13.a13_status = 11 THEN ''L1 Approved''
                       WHEN a13.a13_status = 12 THEN ''Sent to Muqassa''
                   END
                       AS status,
                   a13.a13_user_id
              FROM dfn_csm.a13_settlement_position_req a13
                 WHERE a13.a13_request_date BETWEEN TO_DATE ('''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'') AND  TO_DATE ('''
            || TO_CHAR (ptodate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'') + 0.99999';

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE add_settle_pos_req (
        pkey                     OUT VARCHAR2,
        pa13_csd_acc          IN     dfn_csm.a13_settlement_position_req.a13_csd_acc%TYPE,
        pa13_trading_acc_id   IN     dfn_csm.a13_settlement_position_req.a13_trading_acc_id%TYPE,
        pa13_symbol           IN     dfn_csm.a13_settlement_position_req.a13_symbol%TYPE,
        pa13_user_id          IN     dfn_csm.a13_settlement_position_req.a13_user_id%TYPE,
        pa13_isincode         IN     dfn_csm.a13_settlement_position_req.a13_isincode%TYPE,
        pa13_request_date     IN     dfn_csm.a13_settlement_position_req.a13_request_date%TYPE,
        p_institution         IN     NUMBER,
        pex01_id              IN     NUMBER)
    IS
        lcount         NUMBER;
        l_date         DATE;
        l_m312_id      NUMBER;
        l_firm_id      NUMBER;
        l_firm_count   NUMBER;
    BEGIN
        /* SELECT m312_id
          INTO l_m312_id
          FROM m312_settlement_groups
         WHERE m312_institution = p_institution AND m312_is_default = 1; */
        --ToDo - Settlement Groups in NTP

        SELECT COUNT (*)
          INTO l_firm_count
          FROM dfn_csm.m07_clearing_member_details m07
         WHERE m07.m07_ex01_id = pex01_id;

        IF (l_firm_count = 0)
        THEN
            pkey := '-3';
            RETURN;
        END IF;

        SELECT m07.m07_id
          INTO l_firm_id
          FROM dfn_csm.m07_clearing_member_details m07
         WHERE m07.m07_ex01_id = pex01_id;

        /* m43_calendar_pkg.sp_m43_get_previuos_wrkng_day (
            pkey                    => l_date,
            p_exchange_code         => 'TDWL',
            p_instrument_type       => 'CS',
            pm43_institution        => p_institution,
            p_date                  => TRUNC (SYSDATE),
            p_loss_category         => 0,
            p_settlement_date_grp   => l_m312_id); */
        --ToDo - SP for previous working day in NTP

        IF (   TRUNC (pa13_request_date) = TRUNC (l_date)
            OR TRUNC (pa13_request_date) = TRUNC (SYSDATE))
        THEN
            pkey := dfn_csm.seq_a13_id.NEXTVAL;

            INSERT
              INTO dfn_csm.a13_settlement_position_req (a13_id,
                                                        a13_request_date,
                                                        a13_request_time,
                                                        a13_csd_acc,
                                                        a13_trading_acc_id,
                                                        a13_symbol,
                                                        a13_status,
                                                        a13_user_id,
                                                        a13_reason,
                                                        a13_isincode,
                                                        a13_firm_id)
            VALUES (pkey,
                    pa13_request_date,
                    SYSDATE,
                    pa13_csd_acc,
                    pa13_trading_acc_id,
                    pa13_symbol,
                    10,
                    pa13_user_id,
                    NULL,
                    pa13_isincode,
                    l_firm_id);

            dfn_csm.pkg_dc_t03_audit.t03_add (
                pa13_user_id,
                4,
                   'Settlement Position Request for ['
                || pa13_request_date
                || '] Created.',
                'ID:' || pkey);
        ELSE
            pkey := '-2';
            RETURN;
        END IF;
    END;

    PROCEDURE update_settle_pos_req_status (
        pkey          OUT VARCHAR,
        pa13_id           dfn_csm.a13_settlement_position_req.a13_id%TYPE,
        pa13_status       dfn_csm.a13_settlement_position_req.a13_status%TYPE,
        puser_id          NUMBER)
    IS
        l_count   NUMBER;
    BEGIN
        IF (pa13_status = 11)
        THEN
            UPDATE dfn_csm.a13_settlement_position_req
               SET a13_status = pa13_status,
                   a13_l1_approved_by = puser_id,
                   a13_l1_approved_date = SYSDATE
             WHERE a13_id = pa13_id;

            dfn_csm.pkg_dc_t03_audit.t03_add (
                puser_id,
                10,
                   'Settlement Position Request ID:'
                || pa13_id
                || ' Status Changed to L1 Approved.',
                'ID:' || pa13_id);
        END IF;

        IF (pa13_status = 12)
        THEN
            UPDATE dfn_csm.a13_settlement_position_req
               SET a13_status = pa13_status,
                   a13_l2_approved_by = puser_id,
                   a13_l2_approved_date = SYSDATE
             WHERE a13_id = pa13_id;

            dfn_csm.pkg_dc_t03_audit.t03_add (
                puser_id,
                10,
                   'Settlement Position Request ID:'
                || pa13_id
                || ' Status Changed to Sent to Muqassa.',
                'ID:' || pa13_id);
        END IF;

        IF (pa13_status = 12)
        THEN
            SELECT COUNT (*)
              INTO l_count
              FROM dfn_csm.a14_settlement_position_rep
             WHERE TRUNC (a14_bizdt) = TRUNC (SYSDATE);

            IF (l_count = 0)
            THEN
                INSERT
                  INTO dfn_csm.a14_settlement_position_rep (a14_id,
                                                            a14_rptid,
                                                            a14_reqid,
                                                            a14_bizdt,
                                                            a14_msgevtsrc,
                                                            a14_symbol,
                                                            a14_isincode,
                                                            a14_settldt,
                                                            a14_txntm,
                                                            a14_qty_typ,
                                                            a14_qty_long,
                                                            a14_qty_short,
                                                            a14_qty_stat,
                                                            a14_qtydt,
                                                            a14_amt_typ,
                                                            a14_amt,
                                                            a14_amt_ccy,
                                                            a14_amt_rsn,
                                                            a14_settlement_acc)
                VALUES (dfn_csm.seq_a14_id.NEXTVAL,
                        '1',
                        pa13_id,
                        SYSDATE,
                        NULL,
                        '1010',
                        '1010',
                        SYSDATE + 2,
                        SYSDATE,
                        'NET Qty',
                        1000,
                        NULL,
                        1003,
                        NULL,
                        'Cash Amount  ',
                        1000,
                        'SAR',
                        1001,
                        'ACCCCC2');

                INSERT
                  INTO dfn_csm.a14_settlement_position_rep (a14_id,
                                                            a14_rptid,
                                                            a14_reqid,
                                                            a14_bizdt,
                                                            a14_msgevtsrc,
                                                            a14_symbol,
                                                            a14_isincode,
                                                            a14_settldt,
                                                            a14_txntm,
                                                            a14_qty_typ,
                                                            a14_qty_long,
                                                            a14_qty_short,
                                                            a14_qty_stat,
                                                            a14_qtydt,
                                                            a14_amt_typ,
                                                            a14_amt,
                                                            a14_amt_ccy,
                                                            a14_amt_rsn,
                                                            a14_settlement_acc)
                VALUES (dfn_csm.seq_a14_id.NEXTVAL,
                        '1',
                        pa13_id,
                        SYSDATE,
                        NULL,
                        '8110',
                        '8110',
                        SYSDATE + 2,
                        SYSDATE,
                        'NET Qty',
                        NULL,
                        2000,
                        1005,
                        SYSDATE,
                        'Net Cash Flow',
                        1001,
                        'SAR',
                        1001,
                        'CVDDD2');

                INSERT
                  INTO dfn_csm.a14_settlement_position_rep (a14_id,
                                                            a14_rptid,
                                                            a14_reqid,
                                                            a14_bizdt,
                                                            a14_msgevtsrc,
                                                            a14_symbol,
                                                            a14_isincode,
                                                            a14_settldt,
                                                            a14_txntm,
                                                            a14_qty_typ,
                                                            a14_qty_long,
                                                            a14_qty_short,
                                                            a14_qty_stat,
                                                            a14_qtydt,
                                                            a14_amt_typ,
                                                            a14_amt,
                                                            a14_amt_ccy,
                                                            a14_amt_rsn,
                                                            a14_settlement_acc)
                VALUES (dfn_csm.seq_a14_id.NEXTVAL,
                        '1',
                        pa13_id,
                        SYSDATE,
                        NULL,
                        '1020',
                        '1020',
                        SYSDATE + 2,
                        SYSDATE,
                        'GRS Qty',
                        NULL,
                        3000,
                        1005,
                        SYSDATE,
                        'Cash Amount',
                        2200,
                        'SAR',
                        1001,
                        'RTYYYY4');
            END IF;

            UPDATE dfn_csm.a13_settlement_position_req
               SET a13_status = 0
             WHERE a13_id = pa13_id;
        END IF;
    END;

    PROCEDURE sp_validate_request (pkey OUT VARCHAR2, pdate IN DATE)
    IS
        lcount   NUMBER;
    BEGIN
        SELECT COUNT (*)
          INTO lcount
          FROM dfn_csm.s02_db_jobs_execution_log
         WHERE     s02_job_id = 1
               AND s02_status = 1
               AND TRUNC (s02_end_time) = TRUNC (pdate);


        IF (lcount > 0)
        THEN
            pkey := '1';
        ELSE
            pkey := '-2';
        END IF;

        pkey := '1';          --ToDo | Need to remove after job implementation
    END;

    PROCEDURE sp_update_t02_status (
        pkey          OUT VARCHAR,
        pt02_id           dfn_csm.t02_trade_capture_request.t02_id%TYPE,
        pt02_status       dfn_csm.t02_trade_capture_request.t02_status%TYPE,
        puser_id          NUMBER)
    IS
        l_date    DATE;
        l_count   NUMBER;
    BEGIN
        IF (pt02_status = 11)
        THEN
            UPDATE dfn_csm.t02_trade_capture_request
               SET t02_status = pt02_status,
                   t02_l1_approved_by = puser_id,
                   t02_l1_approved_date = SYSDATE
             WHERE t02_id = pt02_id;

            dfn_csm.pkg_dc_t03_audit.t03_add (
                puser_id,
                12,
                   'Trade Capture Request ID:'
                || pt02_id
                || ' Status Changed to L1 Approved.',
                'ID:' || pt02_id);
        END IF;

        IF (pt02_status = 12)
        THEN
            UPDATE dfn_csm.t02_trade_capture_request
               SET t02_status = pt02_status,
                   t02_l2_approved_by = puser_id,
                   t02_l2_approved_date = SYSDATE
             WHERE t02_id = pt02_id;

            dfn_csm.pkg_dc_t03_audit.t03_add (
                puser_id,
                12,
                   'Trade Capture Request ID:'
                || pt02_id
                || ' Status Changed to Sent to Muqassa.',
                'ID:' || pt02_id);
        END IF;

        pkey := '1';
    --temporary need to belete after the Demo
    /*IF (pt02_status = 12)
    THEN
        SELECT t02_date
          INTO l_date
          FROM dfn_csm.t02_trade_capture_request
         WHERE t02_id = pt02_id;

        SELECT COUNT (*) INTO l_count FROM dfn_csm.t01_execution_details;

        UPDATE dfn_csm.t02_trade_capture_request
           SET t02_status =
                   CASE
                       WHEN TRUNC (l_date) = TRUNC (SYSDATE) THEN 0
                       ELSE 1
                   END
         WHERE t02_id = pt02_id;

        IF (l_count = 0)
        THEN
            INSERT INTO dfn_csm.t01_execution_details (t01_id,
                                                       t01_date,
                                                       t01_exec_id,
                                                       t01_customer_id,
                                                       t01_customer_no,
                                                       t01_customer_name,
                                                       t01_exchange,
                                                       t01_csd_no,
                                                       t01_ccp_no,
                                                       t01_symbol,
                                                       t01_side,
                                                       t01_trade_date,
                                                       t01_settle_date)
                 VALUES (dfn_csm.seq_t01_id.NEXTVAL,
                         SYSDATE,
                         '100',
                         91,
                         '11333918',
                         'Gimhan',
                         'TDWL',
                         '0500000077',
                         '1234',
                         '1010',
                         1,
                         SYSDATE,
                         SYSDATE + 2);

            INSERT INTO dfn_csm.t01_execution_details (t01_id,
                                                       t01_date,
                                                       t01_exec_id,
                                                       t01_customer_id,
                                                       t01_customer_no,
                                                       t01_customer_name,
                                                       t01_exchange,
                                                       t01_csd_no,
                                                       t01_ccp_no,
                                                       t01_symbol,
                                                       t01_side,
                                                       t01_trade_date,
                                                       t01_settle_date)
                 VALUES (dfn_csm.seq_t01_id.NEXTVAL,
                         SYSDATE,
                         '101',
                         91,
                         '11333918',
                         'Gimhan',
                         'TDWL',
                         '0500000077',
                         '1234',
                         '1010',
                         1,
                         SYSDATE,
                         SYSDATE + 2);

            INSERT INTO dfn_csm.t01_execution_details (t01_id,
                                                       t01_date,
                                                       t01_exec_id,
                                                       t01_customer_id,
                                                       t01_customer_no,
                                                       t01_customer_name,
                                                       t01_exchange,
                                                       t01_csd_no,
                                                       t01_ccp_no,
                                                       t01_symbol,
                                                       t01_side,
                                                       t01_trade_date,
                                                       t01_settle_date)
                 VALUES (dfn_csm.seq_t01_id.NEXTVAL,
                         SYSDATE,
                         '102',
                         91,
                         '11333918',
                         'Gimhan',
                         'TDWL',
                         '0500000077',
                         '1234',
                         '1010',
                         1,
                         SYSDATE,
                         SYSDATE + 2);

            INSERT INTO dfn_csm.t01_execution_details (t01_id,
                                                       t01_date,
                                                       t01_exec_id,
                                                       t01_customer_id,
                                                       t01_customer_no,
                                                       t01_customer_name,
                                                       t01_exchange,
                                                       t01_csd_no,
                                                       t01_ccp_no,
                                                       t01_symbol,
                                                       t01_side,
                                                       t01_trade_date,
                                                       t01_settle_date)
                 VALUES (dfn_csm.seq_t01_id.NEXTVAL,
                         SYSDATE,
                         '103',
                         91,
                         '11333918',
                         'Gimhan',
                         'TDWL',
                         '0500000077',
                         '1234',
                         '1010',
                         1,
                         SYSDATE,
                         SYSDATE + 2);

            INSERT INTO dfn_csm.t01_execution_details (t01_id,
                                                       t01_date,
                                                       t01_exec_id,
                                                       t01_customer_id,
                                                       t01_customer_no,
                                                       t01_customer_name,
                                                       t01_exchange,
                                                       t01_csd_no,
                                                       t01_ccp_no,
                                                       t01_symbol,
                                                       t01_side,
                                                       t01_trade_date,
                                                       t01_settle_date)
                 VALUES (dfn_csm.seq_t01_id.NEXTVAL,
                         SYSDATE,
                         '104',
                         91,
                         '11333918',
                         'Gimhan',
                         'TDWL',
                         '0500000077',
                         '1234',
                         '1010',
                         1,
                         SYSDATE,
                         SYSDATE + 2);

            INSERT INTO dfn_csm.t01_execution_details (t01_id,
                                                       t01_date,
                                                       t01_exec_id,
                                                       t01_customer_id,
                                                       t01_customer_no,
                                                       t01_customer_name,
                                                       t01_exchange,
                                                       t01_csd_no,
                                                       t01_ccp_no,
                                                       t01_symbol,
                                                       t01_side,
                                                       t01_trade_date,
                                                       t01_settle_date)
                 VALUES (dfn_csm.seq_t01_id.NEXTVAL,
                         SYSDATE,
                         '105',
                         91,
                         '11333918',
                         'Gimhan',
                         'TDWL',
                         '0500000077',
                         '1234',
                         '1010',
                         1,
                         SYSDATE,
                         SYSDATE + 2);

            INSERT INTO dfn_csm.t01_execution_details (t01_id,
                                                       t01_date,
                                                       t01_exec_id,
                                                       t01_customer_id,
                                                       t01_customer_no,
                                                       t01_customer_name,
                                                       t01_exchange,
                                                       t01_csd_no,
                                                       t01_ccp_no,
                                                       t01_symbol,
                                                       t01_side,
                                                       t01_trade_date,
                                                       t01_settle_date)
                 VALUES (dfn_csm.seq_t01_id.NEXTVAL,
                         SYSDATE,
                         '106',
                         91,
                         '11333918',
                         'Gimhan',
                         'TDWL',
                         '0500000077',
                         '1234',
                         '1010',
                         1,
                         SYSDATE,
                         SYSDATE + 2);

            INSERT INTO dfn_csm.t01_execution_details (t01_id,
                                                       t01_date,
                                                       t01_exec_id,
                                                       t01_customer_id,
                                                       t01_customer_no,
                                                       t01_customer_name,
                                                       t01_exchange,
                                                       t01_csd_no,
                                                       t01_ccp_no,
                                                       t01_symbol,
                                                       t01_side,
                                                       t01_trade_date,
                                                       t01_settle_date)
                 VALUES (dfn_csm.seq_t01_id.NEXTVAL,
                         SYSDATE,
                         '107',
                         91,
                         '11333918',
                         'Gimhan',
                         'TDWL',
                         '0500000077',
                         '1234',
                         '1010',
                         1,
                         SYSDATE,
                         SYSDATE + 2);

            INSERT INTO dfn_csm.t01_execution_details (t01_id,
                                                       t01_date,
                                                       t01_exec_id,
                                                       t01_customer_id,
                                                       t01_customer_no,
                                                       t01_customer_name,
                                                       t01_exchange,
                                                       t01_csd_no,
                                                       t01_ccp_no,
                                                       t01_symbol,
                                                       t01_side,
                                                       t01_trade_date,
                                                       t01_settle_date)
                 VALUES (dfn_csm.seq_t01_id.NEXTVAL,
                         SYSDATE,
                         '108',
                         15054,
                         '113368580',
                         'MADHU MADHU MADHU',
                         'TDWL',
                         '0002423435',
                         '3456',
                         'SF300G',
                         2,
                         SYSDATE,
                         SYSDATE + 2);

            INSERT INTO dfn_csm.t01_execution_details (t01_id,
                                                       t01_date,
                                                       t01_exec_id,
                                                       t01_customer_id,
                                                       t01_customer_no,
                                                       t01_customer_name,
                                                       t01_exchange,
                                                       t01_csd_no,
                                                       t01_ccp_no,
                                                       t01_symbol,
                                                       t01_side,
                                                       t01_trade_date,
                                                       t01_settle_date)
                 VALUES (dfn_csm.seq_t01_id.NEXTVAL,
                         SYSDATE,
                         '109',
                         15054,
                         '113368580',
                         'MADHU MADHU MADHU',
                         'TDWL',
                         '0002423435',
                         '3456',
                         'SF300G',
                         2,
                         SYSDATE,
                         SYSDATE + 2);


            INSERT
              INTO dfn_csm.a00_trade_capture_report (a00_id,
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
                                                     a00_settldt)
            VALUES (dfn_csm.seq_a00_id.NEXTVAL,
                    '12',
                    '103',
                    '101',
                    2,
                    '1',
                    1,
                    2,
                    2012420,
                    10,
                    5.2,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    '1010',
                    1,
                    '1',
                    102100,
                    1494369,
                    102101,
                    25,
                    2.5,
                    1,
                    SYSDATE + 2);

            INSERT
              INTO dfn_csm.a00_trade_capture_report (a00_id,
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
                                                     a00_settldt)
            VALUES (dfn_csm.seq_a00_id.NEXTVAL,
                    '13',
                    '104',
                    '102',
                    2,
                    '1',
                    1,
                    2,
                    2012421,
                    20,
                    5.2,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    '1010',
                    1,
                    '1',
                    102101,
                    1494368,
                    102101,
                    25,
                    2.1,
                    1,
                    SYSDATE + 2);

            INSERT
              INTO dfn_csm.a00_trade_capture_report (a00_id,
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
                                                     a00_settldt)
            VALUES (dfn_csm.seq_a00_id.NEXTVAL,
                    '14',
                    '105',
                    '102',
                    2,
                    '1',
                    1,
                    2,
                    2012422,
                    30,
                    5.2,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    '1010',
                    1,
                    '1',
                    102102,
                    1494368,
                    102101,
                    30,
                    2.4,
                    1,
                    SYSDATE + 2);

            INSERT
              INTO dfn_csm.a00_trade_capture_report (a00_id,
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
                                                     a00_settldt)
            VALUES (dfn_csm.seq_a00_id.NEXTVAL,
                    '10',
                    '106',
                    '101',
                    2,
                    '1',
                    1,
                    2,
                    2012420,
                    30,
                    5.2,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    '1010',
                    1,
                    '1',
                    102100,
                    1494369,
                    102101,
                    25,
                    2.5,
                    1,
                    SYSDATE + 2);

            INSERT
              INTO dfn_csm.a00_trade_capture_report (a00_id,
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
                                                     a00_settldt)
            VALUES (dfn_csm.seq_a00_id.NEXTVAL,
                    '60',
                    '101',
                    '102',
                    2,
                    '1',
                    1,
                    2,
                    2012421,
                    30,
                    5.2,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    '1010',
                    1,
                    '1',
                    102101,
                    1494368,
                    102101,
                    25,
                    2.1,
                    1,
                    SYSDATE + 2);

            INSERT
              INTO dfn_csm.a00_trade_capture_report (a00_id,
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
                                                     a00_settldt)
            VALUES (dfn_csm.seq_a00_id.NEXTVAL,
                    '11',
                    '102',
                    '102',
                    2,
                    '1',
                    1,
                    2,
                    2012422,
                    30,
                    5.2,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    '1010',
                    1,
                    '1',
                    102102,
                    1494368,
                    102101,
                    30,
                    2.4,
                    1,
                    SYSDATE + 2);

            INSERT
              INTO dfn_csm.a00_trade_capture_report (a00_id,
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
                                                     a00_settldt)
            VALUES (dfn_csm.seq_a00_id.NEXTVAL,
                    '45',
                    '100',
                    '101',
                    2,
                    '1',
                    1,
                    2,
                    2012420,
                    30,
                    10,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    '1010',
                    1,
                    '1',
                    102100,
                    1494369,
                    102101,
                    25,
                    2.5,
                    1,
                    SYSDATE + 2);

            INSERT
              INTO dfn_csm.a00_trade_capture_report (a00_id,
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
                                                     a00_settldt)
            VALUES (dfn_csm.seq_a00_id.NEXTVAL,
                    '11',
                    '107',
                    '102',
                    2,
                    '1',
                    1,
                    2,
                    2012422,
                    10,
                    6,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    '1010',
                    1,
                    '1',
                    102102,
                    1494368,
                    102101,
                    30,
                    2.4,
                    1,
                    SYSDATE + 2);

            INSERT
              INTO dfn_csm.a00_trade_capture_report (a00_id,
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
                                                     a00_settldt)
            VALUES (dfn_csm.seq_a00_id.NEXTVAL,
                    '45',
                    '108',
                    '101',
                    2,
                    '1',
                    1,
                    2,
                    2012420,
                    30,
                    10,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    '1010',
                    2,
                    '1',
                    102100,
                    1494369,
                    102101,
                    25,
                    2.5,
                    1,
                    SYSDATE + 2);

            INSERT
              INTO dfn_csm.a00_trade_capture_report (a00_id,
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
                                                     a00_settldt)
            VALUES (dfn_csm.seq_a00_id.NEXTVAL,
                    '11',
                    '109',
                    '102',
                    2,
                    '1',
                    1,
                    2,
                    2012422,
                    10,
                    6,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    SYSDATE,
                    '1010',
                    2,
                    '1',
                    102102,
                    1494368,
                    102101,
                    30,
                    2.4,
                    1,
                    SYSDATE + 2);
        END IF;
    END IF;*/
    END;

    PROCEDURE settlement_position_report (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
            'SELECT a14.a14_id,
                   a14.a14_reqid,
                   a14.a14_bizdt,
                   a14.a14_txntm,
                   a13.a13_csd_acc,
                   a14.a14_symbol,
                   a14.a14_settldt,
                   a14.a14_settlement_acc,
                   a14.a14_qty_typ,
                   a14.a14_qty_long,
                   a14.a14_qty_short,
                   CASE
                       WHEN a14.a14_qty_stat = 1003 THEN ''PENDING''
                       WHEN a14.a14_qty_stat = 1005 THEN ''INSTRUCTED''
                   END
                       AS position_status,
                   a14.a14_qtydt,
                   a14.a14_amt_typ,
                   a14.a14_amt,
                   a14.a14_amt_ccy,
                   CASE
                       WHEN a14.a14_amt_rsn = 1001 THEN ''AmountBuy''
                       WHEN a14.a14_amt_rsn = 1002 THEN ''AmountSell''
                       WHEN a14.a14_amt_rsn = 1003 THEN ''PendingAmountBuy''
                       WHEN a14.a14_amt_rsn = 1004 THEN ''PendingAmountSell''
                       WHEN a14.a14_amt_rsn = 1005 THEN ''InstructedAmountBuy''
                       WHEN a14.a14_amt_rsn = 1006 THEN ''InstructedAmountSell''
                   END
                       AS position_reason
              FROM dfn_csm.a14_settlement_position_rep a14,
                   dfn_csm.a13_settlement_position_req a13
             WHERE a14.a14_reqid = a13.a13_id';

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE sp_m07_clearing_det_add (
        pkey                  OUT VARCHAR2,
        pm07_ex01_id       IN     dfn_csm.m07_clearing_member_details.m07_ex01_id%TYPE,
        pm07_member_code   IN     dfn_csm.m07_clearing_member_details.m07_member_code%TYPE,
        pm07_description   IN     dfn_csm.m07_clearing_member_details.m07_description%TYPE,
        pm07_broker_code   IN     dfn_csm.m07_clearing_member_details.m07_broker_code%TYPE DEFAULT NULL)
    IS
        lcount   NUMBER;
    BEGIN
        SELECT COUNT (m07_id)
          INTO lcount
          FROM dfn_csm.m07_clearing_member_details
         WHERE m07_member_code = pm07_member_code;

        IF (lcount > 0)
        THEN
            pkey := '-2';
            RETURN;
        END IF;

        pkey := dfn_csm.seq_m07_id.NEXTVAL;

        INSERT INTO dfn_csm.m07_clearing_member_details (m07_id,
                                                         m07_ex01_id,
                                                         m07_member_code,
                                                         m07_description,
                                                         m07_broker_code)
             VALUES (pkey,
                     pm07_ex01_id,
                     pm07_member_code,
                     pm07_description,
                     pm07_broker_code);
    END;

    PROCEDURE sp_add_a15_aggregate_list (pkey OUT VARCHAR, pdate DATE)
    IS
        l_count   NUMBER;
    BEGIN
        FOR i
            IN (  SELECT t01.u07_customer_id_u01 AS customer_id,
                         a00.a00_sym AS symbol,
                         CASE WHEN a00.a00_side = 1 THEN 'BUY' ELSE 'SELL' END
                             AS code,
                         a00.a00_side AS side,
                         t01.u07_exchange_account_no AS csd_ac,
                         MAX (t01.t02_exchange_code_m01) AS exchange,
                         t01.m86_account_number AS ccp_account_no,
                         a00.a00_settldt AS settlement_date,
                         TRUNC (a00.a00_trddt) AS trade_date,
                         SUM (a00.a00_lastqty) AS quantity,
                         CASE MAX (a15.a15_status)
                             WHEN 1 THEN 'PARTIALLY AGGREGATED'
                             WHEN 2 THEN 'AGGREGATED'
                             ELSE ''
                         END
                             AS status,
                         MAX (a15.a15_status) AS a15_status,
                         ROUND (SUM (a00.trd_value) / SUM (a00.a00_lastqty), 2)
                             AS avg_price,
                         MAX (t01.u07_display_name_u01) AS cust_name,
                         MAX (t01.u07_customer_no_u01) AS cust_no,
                         MAX (a00.a00_ptyid) AS isin,
                         t01.u07_customer_id_u01 AS t01_customer_id,
                         t01.u07_id
                    FROM (SELECT a00_sym,
                                 a00_side,
                                 a00_lastqty,
                                 a00_ptyid,
                                 a00_trdid,
                                 (a00_lastpx * a00_lastqty) AS trd_value,
                                 a00_settldt,
                                 TRUNC (a00_trddt) AS a00_trddt,
                                 a00_trdsubtyp
                            FROM dfn_csm.a00_trade_capture_report) a00,
                         vw_csm_todays_executions_dtls t01,
                         dfn_csm.a15_aggregate_list a15
                   WHERE     a00.a00_trdid = t01.t02_order_exec_id
                         AND t01.u07_exchange_account_no = a15.a15_csd_acc(+)
                         AND t01.m86_account_number = a15.a15_ccp_acc(+)
                         AND t01.t02_symbol_code_m20 = a15.a15_symbol(+)
                         AND t01.t02_side = a15.a15_side(+)
                         AND t01.t02_create_date = a15.a15_trade_date(+)
                         AND t01.t02_cash_settle_date = a15.a15_settle_date(+)
                         AND a00_trddt BETWEEN TRUNC (pdate)
                                           AND TRUNC (pdate) + 0.99999
                         AND a00.a00_side IN (1, 2)
                         AND a00.a00_trdsubtyp NOT IN (1004)
                GROUP BY t01.u07_id,
                         t01.u07_customer_id_u01,
                         a00.a00_sym,
                         a00.a00_side,
                         t01.u07_exchange_account_no,
                         t01.m86_account_number,
                         a00.a00_settldt,
                         a00_trddt)
        LOOP
            SELECT COUNT (*)
              INTO l_count
              FROM dfn_csm.a15_aggregate_list
             WHERE     a15_csd_acc = i.csd_ac
                   AND a15_ccp_acc = i.ccp_account_no
                   AND a15_symbol = i.symbol
                   AND a15_side = i.side
                   AND a15_trade_date BETWEEN i.trade_date
                                          AND i.trade_date + 0.99999
                   AND a15_settle_date BETWEEN i.settlement_date
                                           AND i.settlement_date + 0.99999;


            IF (l_count = 0)
            THEN
                pkey := dfn_csm.seq_a15_id.NEXTVAL;

                INSERT INTO dfn_csm.a15_aggregate_list (a15_id,
                                                        a15_csd_acc,
                                                        a15_ccp_acc,
                                                        a15_symbol,
                                                        a15_exchange,
                                                        a15_side,
                                                        a15_trade_date,
                                                        a15_settle_date,
                                                        a15_quantity,
                                                        a15_avg_price,
                                                        a15_cust_no,
                                                        a15_status,
                                                        a15_created_by,
                                                        a15_created_date,
                                                        a15_symbol_isin,
                                                        a15_customer_name,
                                                        a15_customer_id,
                                                        a15_trading_acc_id)
                     VALUES (pkey,
                             i.csd_ac,
                             i.ccp_account_no,
                             i.symbol,
                             i.exchange,
                             i.side,
                             i.trade_date,
                             i.settlement_date,
                             i.quantity,
                             i.avg_price,
                             i.cust_no,
                             4,
                             1,
                             SYSDATE,
                             i.isin,
                             i.cust_name,
                             i.t01_customer_id,
                             i.u07_id);
            END IF;
        END LOOP;

        COMMIT;

        pkey := '1';
    END;

    PROCEDURE sp_a02_populate (pkey OUT VARCHAR2, pa01_type NUMBER)
    IS
    BEGIN
        FOR j
            IN (SELECT a15_symbol,
                       a15_side,
                       a15_csd_acc,
                       a15_ccp_acc,
                       a15_trade_date,
                       a15_settle_date,
                       a15_id,
                       a00.a00_trdid,
                       a00_lastpx,
                       a00_lastqty,
                       a15.a15_symbol_isin,
                       a15.a15_customer_name,
                       a15.a15_cust_no
                  FROM dfn_csm.a15_aggregate_list a15,
                       dfn_csm.a00_trade_capture_report a00,
                       vw_csm_todays_executions_dtls t01
                 WHERE     a00.a00_trdid = t01.t02_order_exec_id
                       AND a00.a00_sym = a15.a15_symbol
                       AND a15.a15_side = a00.a00_side
                       AND a15.a15_csd_acc = t01.u07_exchange_account_no
                       AND NVL (a15.a15_ccp_acc, -1) =
                               NVL (t01.m86_account_number, -1)
                       AND a15.a15_settle_date = a00.a00_settldt
                       AND a15.a15_trade_date = TRUNC (a00.a00_trddt)
                       AND a00_trdsubtyp NOT IN (1004)
                       AND a00.a00_trdid NOT IN
                               (SELECT a02_a00_trdid
                                  FROM dfn_csm.a02_trade_request_list_details))
        LOOP
            INSERT
              INTO dfn_csm.a02_trade_request_list_details (a02_id,
                                                           a02_a15_id,
                                                           a02_a00_trdid,
                                                           a02_csd_acc,
                                                           a02_ccp_acc,
                                                           a02_price,
                                                           a02_quantity,
                                                           a02_type,
                                                           a02_isin,
                                                           a02_customer_name,
                                                           a02_customer_no,
                                                           a02_symbol,
                                                           a02_side,
                                                           a02_trade_date,
                                                           a02_settle_date)
            VALUES (dfn_csm.seq_a02_id.NEXTVAL,
                    j.a15_id,
                    j.a00_trdid,
                    j.a15_csd_acc,
                    j.a15_ccp_acc,
                    j.a00_lastpx,
                    j.a00_lastqty,
                    pa01_type,
                    j.a15_symbol_isin,
                    j.a15_customer_name,
                    j.a15_cust_no,
                    j.a15_symbol,
                    j.a15_side,
                    j.a15_trade_date,
                    j.a15_settle_date);
        END LOOP;

        COMMIT;
        pkey := '1';
    END;


    PROCEDURE sp_update_a02_agg_status (
        pkey          OUT VARCHAR2,
        plist             VARCHAR2,
        pcreated_by       dfn_csm.a01_trade_request_list.a01_created_by%TYPE DEFAULT 0)
    IS
        TYPE t_table IS TABLE OF VARCHAR2 (10000)
            INDEX BY BINARY_INTEGER;

        l_table             t_table;
        l_count1            NUMBER := 0;
        l_str               VARCHAR2 (32000) := plist || ',';
        l_symbol            NUMBER;
        l_per               NUMBER;
        l_m90_id            NUMBER;
        l_a02_a00_trdid     VARCHAR2 (100);
        l_a02_a15_id        VARCHAR2 (100);
        l_agg_qty           NUMBER;
        l_qty               NUMBER;
        l_seperator         VARCHAR2 (4) := '|';
        l_rec_count         NUMBER;
        l_aggregate_count   NUMBER;
        l_accept_count      NUMBER;
        l_reject_count      NUMBER;
        l_pending_count     NUMBER;
        l_amount            NUMBER;
        l_trd_amount        NUMBER;
    BEGIN
        WHILE INSTR (l_str, ',') != 0
        LOOP
            l_count1 := l_count1 + 1;
            l_table (l_count1) := SUBSTR (l_str, 0, INSTR (l_str, ',') - 1);
            l_str := SUBSTR (l_str, INSTR (l_str, ',') + 1);
        END LOOP;

        FOR i IN l_table.FIRST .. l_table.LAST
        LOOP
            IF l_table (i) IS NOT NULL
            THEN
                l_a02_a00_trdid :=
                    string_splitter (l_seperator, l_table (i), 1);
                l_a02_a15_id := string_splitter (l_seperator, l_table (i), 2);


                MERGE INTO dfn_csm.a02_trade_request_list_details
                     USING DUAL
                        ON (    a02_a00_trdid = l_a02_a00_trdid
                            AND a02_a15_id = l_a02_a15_id)
                WHEN MATCHED
                THEN
                    UPDATE SET a02_status = 10, a02_is_select = 1;



                COMMIT;
            END IF;
        END LOOP;

        SELECT SUM (a02_quantity), SUM (a02_quantity * a02_price)
          INTO l_qty, l_trd_amount
          FROM dfn_csm.a02_trade_request_list_details
         WHERE     a02_a15_id = l_a02_a15_id
               AND a02_status = 10
               AND a02_is_select = 1
               AND a02_type = 1;

        pkey := dfn_csm.seq_a01_id.NEXTVAL;

        INSERT INTO dfn_csm.a01_trade_request_list (a01_id,
                                                    a01_csd_acc,
                                                    a01_ccp_acc,
                                                    a01_symbol,
                                                    a01_exchange,
                                                    a01_side,
                                                    a01_trade_date,
                                                    a01_settle_date,
                                                    a01_quantity,
                                                    a01_avg_price,
                                                    a01_cust_no,
                                                    a01_status,
                                                    a01_created_by,
                                                    a01_created_date,
                                                    a01_symbol_isin,
                                                    a01_customer_name,
                                                    a01_a15_id,
                                                    a01_type,
                                                    a01_customer_id,
                                                    a01_trading_acc_id)
            SELECT pkey,
                   a15_csd_acc,
                   a15_ccp_acc,
                   a15_symbol,
                   a15_exchange,
                   a15_side,
                   a15_trade_date,
                   a15_settle_date,
                   l_qty,
                   (l_trd_amount / l_qty),
                   a15_cust_no,
                   10,
                   pcreated_by,
                   SYSDATE,
                   a15_symbol_isin,
                   a15_customer_name,
                   a15_id,
                   1,
                   a15_customer_id,
                   a15_trading_acc_id
              FROM dfn_csm.a15_aggregate_list
             WHERE a15_id = l_a02_a15_id;


        UPDATE dfn_csm.a02_trade_request_list_details
           SET a02_a01_id = pkey
         WHERE a02_status = 10 AND a02_type = 1 AND a02_a15_id = l_a02_a15_id;


        UPDATE dfn_csm.a15_aggregate_list
           SET a15_status = 10
         WHERE a15_id = l_a02_a15_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS
        THEN
            pkey := '-1';
    END;

    PROCEDURE sp_validate_a02 (
        pkey         OUT VARCHAR2,
        pa15_id   IN     dfn_csm.a15_aggregate_list.a15_id%TYPE)
    IS
        l_count   NUMBER;
    BEGIN
        SELECT COUNT (*)
          INTO l_count
          FROM dfn_csm.a02_trade_request_list_details
         WHERE     a02_a15_id = pa15_id
               AND a02_status IN (10, 11)
               AND a02_type = 1;


        IF (l_count > 0)
        THEN
            pkey := '1';
        ELSE
            pkey := '0';
        END IF;
    END;

    PROCEDURE sp_update_a01_status (
        pkey                        OUT VARCHAR2,
        pa01_id                  IN     dfn_csm.a01_trade_request_list.a01_id%TYPE,
        pa01_status              IN     dfn_csm.a01_trade_request_list.a01_status%TYPE,
        pa01_status_changed_by   IN     dfn_csm.a01_trade_request_list.a01_status_changed_by%TYPE,
        pa01_type                IN     dfn_csm.a01_trade_request_list.a01_type%TYPE DEFAULT 1) --1 - Aggregate , 2 - Split
    IS
    BEGIN
        IF (pa01_type = 2)
        THEN
            UPDATE dfn_csm.a01_trade_request_list
               SET a01_status = pa01_status,
                   a01_status_changed_by = pa01_status_changed_by,
                   a01_status_changed_date = SYSDATE
             WHERE a01_id = pa01_id AND a01_type = 2;

            UPDATE dfn_csm.a02_trade_request_list_details
               SET a02_status = pa01_status
             WHERE a02_a01_id = pa01_id AND a02_type = 2;
        /*--Temporary . Need to be delete after the Demo
        IF (pa01_status = 12)
        THEN
            BEGIN
                dfn_csm.pkg_clearing.sp_update_agg_status (pa01_id,
                                                           0,
                                                           NULL,
                                                           NULL,
                                                           2);
            END;

            FOR i
                IN (SELECT a02.a02_symbol,
                           a02.a02_side,
                           a02.a02_csd_acc,
                           'TDWL' AS exchange,
                           a02.a02_ccp_acc,
                           a02.a02_settle_date,
                           a02.a02_trade_date,
                           a02.a02_quantity AS quantity,
                           ROUND (a02.a02_price, 2) AS avg_price,
                           a02.a02_customer_name AS cust_name,
                           a02.a02_customer_no AS cust_no,
                           a02.a02_a00_trdid
                      FROM dfn_csm.a02_trade_request_list_details a02
                     WHERE a02.a02_a01_id = pa01_id AND a02.a02_type = 2)
            LOOP
                INSERT
                  INTO dfn_csm.a00_trade_capture_report (
                           a00_id,
                           a00_lastqty,
                           a00_lastpx,
                           a00_trddt,
                           a00_bizdt,
                           a00_txntm,
                           a00_tztransacttime,
                           a00_sym,
                           a00_side,
                           a00_settldt,
                           a00_trdsubtyp)
                VALUES (dfn_csm.seq_a00_id.NEXTVAL,
                        i.quantity,
                        i.avg_price,
                        i.a02_trade_date,
                        i.a02_trade_date,
                        SYSDATE,
                        SYSDATE,
                        i.a02_symbol,
                        i.a02_side,
                        i.a02_settle_date,
                        '1003');
            END LOOP;

            UPDATE dfn_csm.a00_trade_capture_report
               SET a00_trdsubtyp = '1004'
             WHERE a00_trdid IN
                       (SELECT a02_a00_trdid
                          FROM dfn_csm.a02_trade_request_list_details
                         WHERE a02_a01_id = pa01_id AND a02_type = 1);
        END IF;*/
        ELSE
            UPDATE dfn_csm.a01_trade_request_list
               SET a01_status = pa01_status,
                   a01_status_changed_by = pa01_status_changed_by,
                   a01_status_changed_date = SYSDATE
             WHERE a01_id = pa01_id;

            UPDATE dfn_csm.a02_trade_request_list_details
               SET a02_status = pa01_status
             WHERE a02_a01_id = pa01_id;

            UPDATE dfn_csm.a15_aggregate_list
               SET a15_status = pa01_status
             WHERE a15_id IN (SELECT a01_a15_id
                                FROM dfn_csm.a01_trade_request_list
                               WHERE a01_id = pa01_id);
        /*--Temporary . Need to be delete after the Demo

        IF (pa01_status = 12)
        THEN
            BEGIN
                dfn_csm.pkg_clearing.sp_update_agg_status (pa01_id,
                                                           0,
                                                           NULL,
                                                           NULL,
                                                           1);
            END;
        END IF;*/
        END IF;

        pkey := '1';
    END;

    PROCEDURE add_trade_list_details (
        pkey               OUT VARCHAR,
        pa02_a01_id     IN     dfn_csm.a02_trade_request_list_details.a02_a01_id%TYPE DEFAULT NULL,
        pa02_csd_acc    IN     dfn_csm.a02_trade_request_list_details.a02_csd_acc%TYPE DEFAULT NULL,
        pa02_ccp_acc    IN     dfn_csm.a02_trade_request_list_details.a02_ccp_acc%TYPE DEFAULT NULL,
        pa02_price      IN     dfn_csm.a02_trade_request_list_details.a02_price%TYPE DEFAULT NULL,
        pa02_quantity   IN     dfn_csm.a02_trade_request_list_details.a02_quantity%TYPE DEFAULT NULL,
        ptype           IN     dfn_csm.a02_trade_request_list_details.a02_type%TYPE DEFAULT 1) -- 1 - Aggregate 2 - Split
    IS
        l_a02_a15             dfn_csm.a02_trade_request_list_details.a02_a15_id%TYPE
                                  DEFAULT 0;
        l_a02_isin            dfn_csm.a02_trade_request_list_details.a02_isin%TYPE
                                  DEFAULT NULL;
        l_a02_symbol          dfn_csm.a02_trade_request_list_details.a02_symbol%TYPE
                                  DEFAULT NULL;
        l_a02_side            dfn_csm.a02_trade_request_list_details.a02_side%TYPE
                                  DEFAULT NULL;
        l_a02_trade_date      dfn_csm.a02_trade_request_list_details.a02_trade_date%TYPE
            DEFAULT NULL;
        l_a02_settle_date     dfn_csm.a02_trade_request_list_details.a02_settle_date%TYPE
            DEFAULT NULL;

        l_a02_customer_name   dfn_csm.a02_trade_request_list_details.a02_customer_name%TYPE
            DEFAULT NULL;
        l_a02_customer_no     dfn_csm.a02_trade_request_list_details.a02_customer_no%TYPE
            DEFAULT NULL;
    BEGIN
        SELECT MAX (a02_a15_id),
               MAX (a02_isin),
               MAX (a02_symbol),
               MAX (a02_side),
               MAX (a02_trade_date),
               MAX (a02_settle_date)
          INTO l_a02_a15,
               l_a02_isin,
               l_a02_symbol,
               l_a02_side,
               l_a02_trade_date,
               l_a02_settle_date
          FROM dfn_csm.a02_trade_request_list_details
         WHERE a02_a01_id = pa02_a01_id;

        SELECT u07_display_name_u01, u07_customer_no_u01
          INTO l_a02_customer_name, l_a02_customer_no
          FROM u07_trading_account
         WHERE u07_exchange_account_no = pa02_csd_acc;

        pkey := dfn_csm.seq_a02_id.NEXTVAL;


        INSERT
          INTO dfn_csm.a02_trade_request_list_details (a02_id,
                                                       a02_a15_id,
                                                       a02_a01_id,
                                                       a02_csd_acc,
                                                       a02_ccp_acc,
                                                       a02_price,
                                                       a02_quantity,
                                                       a02_type,
                                                       a02_status,
                                                       a02_isin,
                                                       a02_customer_name,
                                                       a02_customer_no,
                                                       a02_symbol,
                                                       a02_side,
                                                       a02_trade_date,
                                                       a02_settle_date)
        VALUES (pkey,
                l_a02_a15,
                pa02_a01_id,
                pa02_csd_acc,
                pa02_ccp_acc,
                pa02_price,
                pa02_quantity,
                ptype,
                10,
                l_a02_isin,
                l_a02_customer_name,
                l_a02_customer_no,
                l_a02_symbol,
                l_a02_side,
                l_a02_trade_date,
                l_a02_settle_date);
    END;

    PROCEDURE trade_capture_report (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
            'SELECT t01.u07_customer_id_u01 AS customer_id,
                       t01.u07_display_name_u01 AS cust_name,
                       t01.u07_customer_no_u01 AS cust_no,
                       a00.a00_trdid AS trade_id,
                       a00.a00_sym AS symbol,
                       CASE WHEN a00.a00_side = 1 THEN ''BUY'' ELSE ''SELL'' END AS side,
                       t01.u07_exchange_account_no AS exchange_ac,
                       t01.m86_account_number AS ccp_account_no,
                       t01.t02_exchange_code_m01 AS exchange,
                       a00.a00_settldt AS settlement_date,
                       TRUNC (a00.a00_trddt) AS trade_date,
                       a00.a00_lastqty AS quantity,
                       ROUND (a00.a00_lastpx, 2) AS avg_price,
                       a00.a00_comm AS commission,
                       case when a00_trdsubtyp = 1004 then ''REVERSED''
                       when a00_trdsubtyp = 1003 then ''OVERTAKEN'' end as status
                  FROM dfn_csm.a00_trade_capture_report a00
                      LEFT JOIN vw_csm_todays_executions_dtls t01
                           ON a00.a00_trdid = t01.t02_order_exec_id';

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE sp_update_a05_status (
        pkey                     OUT VARCHAR,
        pa05_id                      dfn_csm.a05_trade_rec_notif.a05_id%TYPE,
        pa05_status_id               dfn_csm.a05_trade_rec_notif.a05_status_id%TYPE,
        pa05_status_changed_by       dfn_csm.a05_trade_rec_notif.a05_status_changed_by%TYPE)
    IS
        l_trd_id                   VARCHAR2 (50);
        l_a05_rectified_csd_acc    VARCHAR2 (50);
        l_a05_rectified_ccp_acc    VARCHAR2 (50);
        l_a05_symbol               VARCHAR2 (50);
        l_u06_m01_customer_id      NUMBER;
        l_u06_m01_c1_customer_id   VARCHAR2 (50);
        l_u06_exchange             VARCHAR2 (50);
        l_t01_symbol               VARCHAR2 (50);
        l_t01_side                 NUMBER;
        l_t01_trade_date           DATE;
        l_t01_settle_date          DATE;
        l_t01_customer_name        VARCHAR2 (500);
        l_a00_lastqty              NUMBER;
        l_a00_comm                 NUMBER;
        l_a00_lastpx               NUMBER;
        l_a15_id                   NUMBER;
        l_new_trd_id               NUMBER;
    BEGIN
        pkey := 1;

        UPDATE dfn_csm.a05_trade_rec_notif
           SET a05_status_id = pa05_status_id,
               a05_status_changed_by = pa05_status_changed_by,
               a05_status_changed_date = SYSDATE
         WHERE a05_id = pa05_id;

        IF (pa05_status_id = 11)
        THEN
            dfn_csm.pkg_dc_t03_audit.t03_add (
                pa05_status_changed_by,
                11,
                   'Trade Rectification ID:'
                || pa05_id
                || ' Status Changed to L1 Approved.',
                'ID:' || pa05_id);
        END IF;

        IF (pa05_status_id = 12)
        THEN
            dfn_csm.pkg_dc_t03_audit.t03_add (
                pa05_status_changed_by,
                11,
                   'Trade Rectification ID:'
                || pa05_id
                || ' Status Changed to Sent to Muqassa.',
                'ID:' || pa05_id);
        END IF;
    EXCEPTION
        WHEN OTHERS
        THEN
            pkey := -2;
    --Temoporary . need to remove after the demo
    /*IF (pa05_status_id = 2)
    THEN
        SELECT a05_trd_id,
               a05_rectified_csd_acc,
               a05_rectified_ccp_acc,
               a05_symbol
          INTO l_trd_id,
               l_a05_rectified_csd_acc,
               l_a05_rectified_ccp_acc,
               l_a05_symbol
          FROM dfn_csm.a05_trade_rec_notif
         WHERE a05_id = pa05_id;

        SELECT a02_a15_id
          INTO l_a15_id
          FROM dfn_csm.a02_trade_request_list_details
         WHERE a02_a00_trdid = l_trd_id;

        SELECT MAX (t01_exec_id) + 1
          INTO l_new_trd_id
          FROM dfn_csm.t01_execution_details t01;

        SELECT u06_m01_customer_id,
               u06_m01_c1_customer_id,
               u06.u06_exchange,
               u06.u06_m01_full_name
          INTO l_u06_m01_customer_id,
               l_u06_m01_c1_customer_id,
               l_u06_exchange,
               l_t01_customer_name
          FROM u06_routing_accounts u06
         WHERE u06_exchange_ac = l_a05_rectified_csd_acc;

        SELECT a00_sym,
               a00_side,
               a00_trddt,
               a00_settldt,
               a00_lastqty,
               a00_comm,
               a00_lastpx
          INTO l_t01_symbol,
               l_t01_side,
               l_t01_trade_date,
               l_t01_settle_date,
               l_a00_lastqty,
               l_a00_comm,
               l_a00_lastpx
          FROM dfn_csm.a00_trade_capture_report
         WHERE a00_trdid = l_trd_id;


        UPDATE dfn_csm.a00_trade_capture_report
           SET a00_trdsubtyp = '1004'
         WHERE a00_trdid = l_trd_id;

        INSERT INTO dfn_csm.t01_execution_details (t01_id,
                                                   t01_date,
                                                   t01_exec_id,
                                                   t01_customer_id,
                                                   t01_customer_no,
                                                   t01_customer_name,
                                                   t01_exchange,
                                                   t01_csd_no,
                                                   t01_ccp_no,
                                                   t01_symbol,
                                                   t01_side,
                                                   t01_trade_date,
                                                   t01_settle_date)
             VALUES (dfn_csm.seq_t01_id.NEXTVAL,
                     SYSDATE,
                     l_new_trd_id,
                     l_u06_m01_customer_id,
                     l_u06_m01_c1_customer_id,
                     l_t01_customer_name,
                     l_u06_exchange,
                     l_a05_rectified_csd_acc,
                     l_a05_rectified_ccp_acc,
                     l_t01_symbol,
                     l_t01_side,
                     l_t01_trade_date,
                     l_t01_settle_date);


        INSERT INTO dfn_csm.a00_trade_capture_report (a00_id,
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
                                                      a00_settldt)
             VALUES (dfn_csm.seq_a00_id.NEXTVAL,
                     '12',
                     l_new_trd_id,
                     l_new_trd_id,
                     2,
                     '1',
                     1,
                     '1003',
                     2012420,
                     l_a00_lastqty,
                     l_a00_lastpx,
                     l_t01_trade_date,
                     l_t01_trade_date,
                     l_t01_trade_date,
                     l_t01_trade_date,
                     l_t01_symbol,
                     l_t01_side,
                     '1',
                     102100,
                     1494369,
                     102101,
                     l_a00_lastqty,
                     l_a00_comm,
                     1,
                     l_t01_settle_date);

        INSERT INTO dfn_csm.a05_trade_rec_notif (a05_id,
                                                 a05_notif_id,
                                                 a05_notif_date,
                                                 a05_notif_time,
                                                 a05_symbol,
                                                 a05_trd_id,
                                                 a05_status_id,
                                                 a05_csd_acc,
                                                 a05_ccp_acc)
             VALUES (dfn_csm.seq_a05_id.NEXTVAL,
                     '10',
                     l_t01_trade_date,
                     l_t01_trade_date,
                     l_t01_symbol,
                     110,
                     0,
                     l_a05_rectified_csd_acc,
                     l_a05_rectified_ccp_acc);



        UPDATE dfn_csm.a05_trade_rec_notif
           SET a05_status_id = 3
         WHERE a05_id = pa05_id;

        UPDATE dfn_csm.a15_aggregate_list
           SET a15_quantity = a15_quantity - l_a00_lastqty
         WHERE a15_id = l_a15_id;
    END IF;*/
    END;


    PROCEDURE sp_validate_rectification (
        pkey             OUT VARCHAR2,
        pa05_trd_id   IN     dfn_csm.a05_trade_rec_notif.a05_trd_id%TYPE)
    IS
        l_count   NUMBER;
    BEGIN
        SELECT COUNT (*)
          INTO l_count
          FROM dfn_csm.a02_trade_request_list_details
         WHERE a02_a00_trdid = pa05_trd_id AND a02_is_select = 1;

        IF (l_count > 0)
        THEN
            pkey := '-2';
        ELSE
            pkey := '1';
        END IF;
    END;


    PROCEDURE sp_get_share_transfer_details (
        p_view            OUT SYS_REFCURSOR,
        prows             OUT NUMBER,
        psortby               VARCHAR2 DEFAULT NULL,
        pfromrownumber        NUMBER DEFAULT NULL,
        ptorownumber          NUMBER DEFAULT NULL,
        psearchcriteria       VARCHAR2 DEFAULT NULL,
        pfromdate             DATE,
        ptodate               DATE)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
               'SELECT t04_id,
                       t04_oms_ref,
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
                       CASE
                           WHEN t04_sender_status = 1 THEN ''SENT TO EXCHANGE''
                           WHEN t04_sender_status = 2 THEN ''PENDING CONFIRMATION''
                           WHEN t04_sender_status = 3 THEN ''L2 APPROVED''
                       END
                           AS sender_status,
                       NVL (t04_receiver_status, 0) AS t04_receiver_status,
                       CASE
                           WHEN t04_receiver_status = 1 THEN ''SENT TO EXCHANGE''
                           WHEN t04_receiver_status = 2 THEN ''PENDING CONFIRMATION''
                           WHEN t04_receiver_status = 3 THEN ''L2 APPROVED''
                           WHEN t04_receiver_status = 4 THEN ''ALLEGED''
                           WHEN t04_receiver_status = 5 THEN ''L1 APPROVED''
                           WHEN t04_receiver_status = 6 THEN ''FAILED''
                       END
                           AS receiver_status,
                       t04_type,
                       CASE
                           WHEN t04_type = 1 THEN ''RECEIVER''
                           WHEN t04_type = 2 THEN ''SENDER''
                       END
                           AS TYPE,
                       t04_match_ref,
                       t04_receiver_ref,
                       t04_receiver_new_ref
                  FROM dfn_csm.t04_share_transfer
                 WHERE t04_transaction_date BETWEEN TO_DATE ('''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'') AND TO_DATE ('''
            || TO_CHAR (ptodate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'') + 0.99999';

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE sp_update_t04_status (
        pkey                   OUT VARCHAR,
        pt04_id                    dfn_csm.t04_share_transfer.t04_id%TYPE,
        pt04_receiver_status       dfn_csm.t04_share_transfer.t04_receiver_status%TYPE,
        pt04_l1_approved_by        dfn_csm.t04_share_transfer.t04_l1_approved_by%TYPE)
    IS
        l_date    DATE;
        l_count   NUMBER;
    BEGIN
        UPDATE dfn_csm.t04_share_transfer
           SET t04_receiver_status = pt04_receiver_status,
               t04_l1_approved_by = pt04_l1_approved_by,
               t04_l1_approved_date = SYSDATE
         WHERE t04_id = pt04_id;

        pkey := '1';
    END;

    PROCEDURE sp_m07_clearing_det_edit (
        pkey                  OUT VARCHAR2,
        pm07_id            IN     dfn_csm.m07_clearing_member_details.m07_id%TYPE,
        pm07_member_code   IN     dfn_csm.m07_clearing_member_details.m07_member_code%TYPE,
        pm07_description   IN     dfn_csm.m07_clearing_member_details.m07_description%TYPE)
    IS
        lcount   NUMBER;
    BEGIN
        SELECT COUNT (m07_id)
          INTO lcount
          FROM dfn_csm.m07_clearing_member_details
         WHERE m07_member_code = pm07_member_code AND m07_id != pm07_id;

        IF (lcount > 0)
        THEN
            pkey := '-2';
            RETURN;
        END IF;

        UPDATE dfn_csm.m07_clearing_member_details
           SET m07_member_code = pm07_member_code,
               m07_description = pm07_description
         WHERE m07_id = pm07_id;
    END;

    PROCEDURE sp_get_reverse_executions (
        pview            OUT SYS_REFCURSOR,
        pa02_a01_id   IN     dfn_csm.a02_trade_request_list_details.a02_a01_id%TYPE)
    IS
    BEGIN
        OPEN pview FOR
            SELECT a02.a02_a00_trdid AS trade_id,
                   a02.a02_quantity AS quantity,
                   a02.a02_symbol AS symbol,
                   a02.a02_isin AS isin,
                   a02.a02_price
              FROM dfn_csm.a02_trade_request_list_details a02
             WHERE a02.a02_a01_id = pa02_a01_id AND a02.a02_type = 1;
    END;

    PROCEDURE sp_get_recapture_executions (
        pview            OUT SYS_REFCURSOR,
        pa02_a01_id   IN     dfn_csm.a02_trade_request_list_details.a02_a01_id%TYPE)
    IS
    BEGIN
        OPEN pview FOR
            SELECT a02.a02_a00_trdid AS trade_id,
                   a02.a02_quantity AS quantity,
                   a02.a02_symbol AS symbol,
                   a02.a02_isin AS isin,
                   a02.a02_price
              FROM dfn_csm.a02_trade_request_list_details a02
             WHERE a02.a02_a01_id = pa02_a01_id AND a02.a02_type = 2;
    END;

    PROCEDURE sp_audit_details (p_view            OUT SYS_REFCURSOR,
                                prows             OUT NUMBER,
                                psortby               VARCHAR2 DEFAULT NULL,
                                pfromrownumber        NUMBER DEFAULT NULL,
                                ptorownumber          NUMBER DEFAULT NULL,
                                psearchcriteria       VARCHAR2 DEFAULT NULL,
                                pfromdate             DATE,
                                ptodate               DATE)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
               'SELECT t03_description,
                       t03_date,
                       t03_reference_no,
                       m04_activity_name,
                       u17.u17_full_name AS name,
                       ''AT'' AS channel
                  FROM dfn_csm.t03_audit t03, dfn_csm.m04_aud_activity m04, u17_employee u17
                 WHERE     t03.t03_activity_id = m04.m04_id
                       AND t03.t03_user_id = u17.u17_id(+)
                       AND t03_date BETWEEN TO_DATE ('''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'') AND TO_DATE ('''
            || TO_CHAR (ptodate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'') + 0.99999';

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);

        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;

    PROCEDURE sp_pledge_details (p_view            OUT SYS_REFCURSOR,
                                 prows             OUT NUMBER,
                                 psortby               VARCHAR2 DEFAULT NULL,
                                 pfromrownumber        NUMBER DEFAULT NULL,
                                 ptorownumber          NUMBER DEFAULT NULL,
                                 psearchcriteria       VARCHAR2 DEFAULT NULL,
                                 pfromdate             DATE,
                                 ptodate               DATE)
    IS
        l_qry   VARCHAR2 (15000);
        s1      VARCHAR2 (15000);
        s2      VARCHAR2 (15000);
    BEGIN
        l_qry :=
               'SELECT t05_id,
                       t05_isincode,
                       t05_quantity,
                       t05_pledgor_member_code,
                       t05_pledgor_acc_no,
                       t05_pledgee_member_code,
                       t05_pledgee_acc_no,
                       t05_sender_status,
                       CASE
                           WHEN t05_sender_status = 1 THEN ''SEND TO EXCHANGE''
                           WHEN t05_sender_status = 2 THEN ''PENDING CONFIRMATION''
                           WHEN t05_sender_status = 3 THEN ''L2 APPROVED''
                           WHEN t05_sender_status = 5 THEN ''L1 APPROVED''
                           WHEN t05_sender_status = 6 THEN ''FAILED''
                           WHEN t05_sender_status = 7 THEN ''SENT TO CANCEL''
                           WHEN t05_sender_status = 8 THEN ''CANCELLED''
                       END
                           AS sender_status,
                       t05_receiver_status,
                       CASE
                           WHEN t05_receiver_status = 1 THEN ''SEND TO EXCHANGE''
                           WHEN t05_receiver_status = 2 THEN ''PENDING CONFIRMATION''
                           WHEN t05_receiver_status = 3 THEN ''L2 APPROVED''
                           WHEN t05_receiver_status = 4 THEN ''ALLEGED''
                           WHEN t05_receiver_status = 5 THEN ''L1 APPROVED''
                           WHEN t05_receiver_status = 6 THEN ''FAILED''
                           WHEN t05_receiver_status = 7 THEN ''SENT TO CANCEL''
                           WHEN t05_receiver_status = 8 THEN ''CANCELLED''
                           WHEN t05_receiver_status = 9 THEN ''PENDING CANCELLATION''
                       END
                           AS receiver_status,
                       t05_acceptance_ref,
                       t05_registration_ref,
                       t05_pledge_type,
                       CASE
                           WHEN t05_pledge_type = ''I'' THEN ''INTO PLEDGE''
                           WHEN t05_pledge_type = ''O'' THEN ''OUT OF PLEDGE''
                           WHEN t05_pledge_type = ''C'' THEN ''PLEDGE CALL''
                       END
                           AS pledge_type,
                       t05_oms_ref,
                       t05_csd_ref,
                       t05_created_date,
                       t05_type,
                       CASE
                           WHEN t05_type = 1 THEN ''RECEIVER''
                           WHEN t05_type = 2 THEN ''SENDER''
                       END
                           AS TYPE,
                       t05_process_status,
                       CASE
                           WHEN t05_process_status = ''REJT'' THEN ''REJECTED''
                           WHEN t05_process_status = ''CAND'' THEN ''CANCELLED''
                           WHEN t05_process_status = ''PACK'' THEN ''ACCEPTED''
                           WHEN t05_process_status = ''COMP'' THEN ''COMPLETED''
                           ELSE ''OTHER''
                       END
                           AS process_status,
                       t05_pledge_status,
                       CASE
                           WHEN t05_pledge_status = ''REJT'' THEN ''REJECTED''
                           WHEN t05_pledge_status = ''CANC'' THEN ''CANCELLED''
                           WHEN t05_pledge_status = ''PCNF'' THEN ''PENDING''
                           WHEN t05_pledge_status = ''REGI'' THEN ''REGISTERED''
                           WHEN t05_pledge_status = ''APPR'' THEN ''FULLY EXECUTED''
                           WHEN t05_pledge_status = ''RELE'' THEN ''FULLY RELEASED''
                           ELSE ''OTHER''
                       END
                           AS pledge_status,
                       t05_settlement_status,
                       CASE
                           WHEN t05_settlement_status = ''SETT''
                           THEN
                               ''FULLY RESTRICTED ON PLEDGOR’S ACCOUNT''
                           WHEN t05_settlement_status = ''PAIN''
                           THEN
                               ''PARTIALLY RESTRICTED''
                           WHEN t05_settlement_status = ''USET''
                           THEN
                               ''NOT RESTRICTED''
                       END
                           AS settlement_status,
                       m20.m20_symbol_code,
                       m20.m20_short_description,
                       m20.m20_short_description_lang
                  FROM     dfn_csm.t05_pledge_transfer t05
                       LEFT JOIN
                           m20_symbol m20
                       ON     t05.t05_isincode = m20.m20_isincode
                          AND m20.m20_exchange_code_m01 = ''TDWL''
                 WHERE t05_created_date BETWEEN TO_DATE ('''
            || TO_CHAR (pfromdate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'') AND TO_DATE ('''
            || TO_CHAR (ptodate, 'DD-MM-YYYY')
            || ''', ''DD-MM-YYYY'') + 0.99999';

        s1 :=
            fn_get_sp_data_query (psearchcriteria,
                                  l_qry,
                                  psortby,
                                  ptorownumber,
                                  pfromrownumber);
        s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

        OPEN p_view FOR s1;

        EXECUTE IMMEDIATE s2 INTO prows;
    END;
END;
/
