CREATE OR REPLACE PACKAGE dfn_csm.pkg_dc_execution_summary
IS
    PROCEDURE sp_populate_exection_dtls;
END;                                                           -- Package spec
/



CREATE OR REPLACE PACKAGE BODY dfn_csm.pkg_dc_execution_summary
IS
    PROCEDURE sp_populate_exection_dtls
    IS
    BEGIN
        INSERT INTO t01_execution_details (t01_id,
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
            SELECT seq_t01_id.NEXTVAL,
                   TRUNC (SYSDATE),
                   t11.t11_exec_id,
                   u06_m01_customer_id,
                   u06.u06_m01_c1_customer_id,
                   u06.u06_m01_full_name,
                   t11.t11_exchange,
                   t11.t11_routingac,
                   u06.u06_ccp_account_no,
                   t11.t11_symbol,
                   t11.t11_side,
                   t11.t11_datetime,
                   t11.t11_settlement_date
              FROM mubasher_oms.t11_executed_orders t11,
                   mubasher_oms.u06_routing_accounts u06
             WHERE     t11.t11_routingac = u06.u06_exchange_ac(+)
                   AND t11.t11_datetime BETWEEN TRUNC (SYSDATE)
                                            AND TRUNC (SYSDATE) + 0.99999;
    END;
END;
/
