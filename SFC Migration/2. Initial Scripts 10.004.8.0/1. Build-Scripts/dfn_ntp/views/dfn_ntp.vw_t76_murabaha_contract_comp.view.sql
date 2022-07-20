CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t76_murabaha_contract_comp
(
    t76_id,
    t76_contract_id_t75,
    t76_symbol_code_m20,
    t76_exchange_code_m01,
    t76_percentage,
    t76_exp_buy_order_value,
    t76_rem_buy_order_value,
    t76_cum_buy_order_qty,
    t76_buy_pending_qty,
    t76_average_cost,
    t76_cum_commission,
    t76_total_charges
)
AS
    (SELECT t76.t76_id,
            t76.t76_contract_id_t75,
            t76.t76_symbol_code_m20,
            t76.t76_exchange_code_m01,
            t76.t76_percentage,
            t76.t76_exp_buy_order_value,
            t76.t76_rem_buy_order_value,
            t76.t76_cum_buy_order_qty,
            t76.t76_buy_pending_qty,
            t76.t76_average_cost,
            t76.t76_cum_commission,
            t76.t76_total_charges
       FROM t76_murabaha_contract_comp t76)
/