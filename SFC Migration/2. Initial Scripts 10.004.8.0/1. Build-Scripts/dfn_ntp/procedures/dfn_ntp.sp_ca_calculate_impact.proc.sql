CREATE OR REPLACE PROCEDURE dfn_ntp.sp_ca_calculate_impact (p_ca_id NUMBER)
IS
    bal        NUMBER;
    quantity   NUMBER;
BEGIN
    UPDATE m143_corp_act_cash_adjustments
       SET m143_impact_balance = 0
     WHERE m143_cust_corp_act_id_m141 = p_ca_id;

    UPDATE m142_corp_act_hold_adjustments
       SET m142_impact_quantity = 0
     WHERE m142_cust_corp_act_id_m141 = p_ca_id;

    FOR i IN (SELECT *
                FROM m143_corp_act_cash_adjustments a
               WHERE a.m143_cust_corp_act_id_m141 = p_ca_id)
    LOOP
        SELECT SUM (t43.t43_amnt_in_txn_currency) AS bal
          INTO bal
          FROM t43_cust_corp_act_cash_adjust t43
         WHERE     t43_corp_act_adj_id_m143 = i.m143_id
               AND t43_status_id_v01 NOT IN (3, 5);

        bal := NVL (bal, 0);

        UPDATE m143_corp_act_cash_adjustments a
           SET a.m143_impact_balance = bal
         WHERE m143_id = i.m143_id;
    END LOOP;


    FOR i IN (SELECT *
                FROM m142_corp_act_hold_adjustments a
               WHERE a.m142_cust_corp_act_id_m141 = p_ca_id)
    LOOP
        SELECT SUM (t42.t42_approved_quantity) AS bal
          INTO quantity
          FROM t42_cust_corp_act_hold_adjust t42
         WHERE     t42.t42_corp_act_adj_id_m142 = i.m142_id
               AND t42_status_id_v01 NOT IN (3, 5);


        quantity := NVL (quantity, 0);

        UPDATE m142_corp_act_hold_adjustments a
           SET a.m142_impact_quantity = quantity
         WHERE m142_id = i.m142_id;
    END LOOP;
END;
/
