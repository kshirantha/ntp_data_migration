CREATE OR REPLACE PROCEDURE dfn_ntp.get_account_summary (
    p_view      OUT SYS_REFCURSOR,
    prows       OUT NUMBER,
    pu06id   IN     NUMBER)
IS
    status   NUMBER;
BEGIN
    status := 0;
    prows := 1;

    OPEN p_view FOR
        SELECT u06.u06_id,
               u06.u06_currency_code_m03,
               u06.total_cash_balance,
               u06.u06_blocked,
               u06.u06_open_buy_blocked,
               u06.u06_receivable_amount,
               u06.u06_payable_blocked,
               u06.u06_display_name,
               u06.u06_net_receivable,
               u06.buying_power,
               u06.u06_pending_deposit,
               u06.od_limit_today,
               u06.cash_for_withdraw,
               u06.u06_investment_account_no,
               u06.u06_margin_enabled,
               pv.portfolio_value AS portfolio_value,
               pv.pf_value_with_pledge AS portfolio_value_inc,
               u06.u06_maintain_margin_charged,
               u06.u06_maintain_margin_block,
               u06.u06_initial_margin,
               pv.u07_prefred_inst_type_id,
               u06.u06_maintain_margin_charged + u06.u06_initial_margin
                   AS pf_value_im_mm
          FROM vw_u06_cash_account_base u06
               LEFT JOIN
                   vw_u06_portfolio_value pv
               ON u06.u06_id = pv.u07_cash_account_id_u06
         WHERE u06.u06_id = pu06id;

    status := 1;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        status := -2;
    WHEN OTHERS
    THEN
        status := -3;
END;
/