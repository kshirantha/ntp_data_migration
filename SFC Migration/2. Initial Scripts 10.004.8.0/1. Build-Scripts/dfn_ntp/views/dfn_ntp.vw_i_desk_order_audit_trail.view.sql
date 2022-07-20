CREATE OR REPLACE VIEW dfn_ntp.vw_i_desk_order_audit_trail (
   "ordNo",
   "date",
   "ordCat",
   "status",
   "perfrmedBy",
   "deskOrdQty",
   "deskOrdPrc",
   "deskOrdFilledQty",
   "deskOrdFilledPrc",
   "childOrdQty",
   "price",
   "lstPrice",
   "childOrdFilledQty",
   "childOrdTyp",
   "clientOrd",
   "deskOrd",
   "deskRef" )
AS
(
( 
 SELECT
        t52.t52_orderno AS "ordNo",
        TO_CHAR (t52.t52_created_date, 'YYYYMMDD') AS "date",
        'Desk' AS "ordCat",
        t52.t52_status_id_v30 AS "status",
        u17_login_name AS "perfrmedBy",
        t52.t52_quantity AS "deskOrdQty",
        t52.t52_price AS "deskOrdPrc",
        t52.t52_cum_quantity AS "deskOrdFilledQty",
        t52.t52_avgpx AS "deskOrdFilledPrc",
        0 AS "childOrdQty",
        0 AS "price",
        0 AS "lstPrice",
        0 AS "childOrdFilledQty",
        '' AS "childOrdTyp",
        '' AS "clientOrd",
        t52.t52_order_id AS "deskOrd",
        '' AS "deskRef"
   FROM t52_desk_orders t52
   LEFT JOIN u17_employee u17 ON t52.t52_dealer_id_u17 = u17.u17_id
 UNION ALL
 SELECT
        t01.t01_cl_ord_id AS "ordNo",
        TO_CHAR (t01.t01_date_time, 'YYYYMMDD')  AS "date",
        'Child' AS "ordCat",
        t01.t01_status_id_v30 AS "status",
        u17_login_name AS "perfrmedBy",
        0 AS "deskOrdQty",
        0 AS "deskOrdPrc",
        0 AS "deskOrdFilledQty",
        0 AS "deskOrdFilledPrc",
        t01.t01_quantity AS "childOrdQty",
        t01.t01_price AS "price",
        t01.t01_last_price AS "lstPrice",
        t01.t01_cum_quantity AS "childOrdFilledQty",
        t01.t01_ord_type_id_v06 AS "childOrdTyp",
        t01.t01_cl_ord_id AS "clientOrd",
        t01.t01_desk_order_no_t52 AS "deskOrd",
        t01.t01_desk_order_ref_t52 AS "deskRef"
   FROM t01_order t01
   LEFT JOIN u17_employee u17 ON t01.t01_dealer_id_u17 = u17.u17_id

   )
   

)
/
