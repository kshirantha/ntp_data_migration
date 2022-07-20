CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_umessage_share_details
(
    t19_id,
    t19_t18_id,
    t19_exchange,
    t19_symbol,
    t19_isin_9719,
    t19_shares_53,
    t19_shares_available_9957,
    t19_shares_pledge_9958,
    t19_position_date_9720,
    t19_change_date_9721,
    t19_net_holding,
    t18_trading_account_id_u07
)
AS
    SELECT t19.t19_id,
           t19.t19_t18_id,
           t19.t19_exchange,
           t19.t19_symbol,
           t19.t19_isin_9719,
           t19.t19_shares_53,
           t19.t19_shares_available_9957,
           t19.t19_shares_pledge_9958,
           t19.t19_position_date_9720,
           t19.t19_change_date_9721,
           t19.t19_net_holding,
           t18.t18_trading_account_id_u07
      FROM     t19_c_umessage_share_details t19
           JOIN
               t18_c_umessage t18
           ON t19.t19_t18_id = t18.t18_id;
/
