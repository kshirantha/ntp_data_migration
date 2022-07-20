CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_ams_order_list
(
    ordno,
    mkt_id,
    shortdesc_1,
    shortdesc_2,
    prdid,
    orddate,
    ordqty,
    ord_side_cd,
    pendingqty,
    filledqty,
    minqty,
    maxqty,
    tiftype,
    tifdate,
    portfoliono,
    changeable,
    ordpric,
    ordtyp,
    ordstatus,
    ordvalue,
    t01_ordnetvalue,
    averageprice,
    ordcommission,
    cumcommission,
    t01_exchange_vat,
    t01_broker_vat,
    total_vat,
    t01_portfoliono,
    t01_expiry_date
)
AS
    (SELECT ord.t01_orderno "ORDNO",
            ord.t01_exchange "MKT_ID",
            NVL (shortdesc_1, ord.t01_symbol) shortdesc_1,
            NVL (shortdesc_2, ord.t01_symbol) shortdesc_2,
            prdid,
            ord.t01_createddate "ORDDATE",
            ord.t01_orderqty AS "ORDQTY",
            ord_side_cd,
            (ord.t01_orderqty - ord.t01_cumqty) "PENDINGQTY",
            ord.t01_cumqty "FILLEDQTY",
            ord.t01_minqty "MINQTY",
            ord.t01_maxfloor "MAXQTY",
            ord.t01_timeinforce AS "TIFTYPE",
            TO_CHAR (ord.t01_expiretime, 'dd/MM/yyyy') AS "TIFDATE",
            ord.t01_routingac AS "PORTFOLIONO",
            CASE WHEN v30_amend_allow = 1 THEN 'Y' ELSE 'N' END AS changeable,
            ord.t01_price "ORDPRIC",
            ordtyp,
            ord.t01_status_id_v30 "ORDSTATUS",
            ord.t01_ordvalue AS ordvalue,
            ord.t01_ordnetvalue AS t01_ordnetvalue,
            ord.t01_avgpx AS "AVERAGEPRICE",
            ord.t01_commission AS "ORDCOMMISSION",
            ord.t01_cum_commission AS "CUMCOMMISSION",
            ord.t01_exchange_vat,
            ord.t01_broker_vat,
            (ord.t01_exchange_vat + ord.t01_broker_vat) AS total_vat,
            t01_portfoliono,
            t01_expiry_date
       FROM (  SELECT a.t01_trading_acntno_u07 AS t01_portfoliono,
                      a.t01_symbol_code_m20 AS t01_symbol,
                      a.t01_exchange_code_m01 AS t01_exchange,
                      0 AS t01_ordertype,
                      a.t01_symbol_currency_code_m03 AS t01_currency,
                      CASE
                          WHEN a.t01_symbol_currency_code_m03 = 'SAR' THEN 'LB'
                          ELSE 'IB'
                      END
                          AS prdid,
                      CASE WHEN a.t01_side = 1 THEN 2 ELSE 1 END AS ordtyp,
                      v01.v01_description AS ord_side_cd,
                      a.t01_quantity AS t01_orderqty,
                      a.t01_price,
                      a.t01_tif_id_v10 AS t01_timeinforce,
                      a.t01_expiry_date AS t01_expiretime,
                      a.t01_min_quantity AS t01_minqty,
                      0 AS t01_maxfloor,            --         a.t01_maxfloor,
                      a.t01_date_time AS t01_createddate,
                      --v30.v30_description AS ordtyp,
                      a.t01_status_id_v30,
                      a.t01_cum_quantity AS t01_cumqty,
                      a.t01_leaves_qty AS t01_leavesqty,
                      a.t01_ord_no AS t01_orderno,
                      a.t01_ord_value AS t01_ordvalue,
                      a.t01_ord_net_settle AS t01_netsettle,
                      a.t01_reject_reason AS t01_text,
                      a.t01_ord_net_value AS t01_ordnetvalue,
                      a.t01_trading_acntno_u07 AS t01_routingac,
                      a.t01_instrument_type_code AS t01_instrument_type,
                      0 totalaskqty,
                      0 totalbidqty,
                      DECODE (sym.exchange,
                              'TDWL', sym.symbolshortdescription_2,
                              sym.symboldescription_2)
                          AS shortdesc_2,
                      DECODE (sym.exchange,
                              'TDWL', sym.symbolshortdescription_1,
                              sym.symboldescription_1)
                          AS shortdesc_1,
                      a.t01_avg_price AS t01_avgpx,
                      a.t01_commission,
                      a.t01_cum_commission,
                      a.t01_exchange_tax AS t01_exchange_vat,
                      a.t01_broker_tax AS t01_broker_vat,
                      a.t01_expiry_date,
                      v30.v30_amend_allow
                 FROM dfn_ntp.t01_order a,
                      dfn_price.esp_symbolmap sym,
                      dfn_price.esp_todays_snapshots esp,
                      dfn_ntp.v30_order_status v30,
                      dfn_ntp.v01_system_master_data v01
                WHERE     (   a.t01_instrument_type_code = 'CS'
                           OR (    t01_instrument_type_code = 'RHT'
                               AND a.t01_exchange_code_m01 = 'TDWL'))
                      AND a.t01_status_id_v30 NOT IN ('f', 'm', 'I', 'J')
                      AND a.t01_is_active_order = 1
                      AND a.t01_exchange_code_m01 = sym.exchange(+)
                      AND a.t01_symbol_code_m20 = sym.symbol(+)
                      AND sym.exchange = esp.exchangecode(+)
                      AND sym.symbol = esp.symbol(+)
                      AND v30.v30_status_id = a.t01_status_id_v30
                      AND v01_type = 15
                      AND v01.v01_id = a.t01_side
             ORDER BY a.t01_ord_no DESC) ord)
/
