CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_custody_charge_amount (
    p_custodian_id            NUMBER,
    p_charge_type             NUMBER,
    p_value                   NUMBER,
    p_symbol_currency         VARCHAR2,
    p_instrument_type_code    VARCHAR2)
    RETURN NUMBER
IS
    l_calculated_charge_amt   NUMBER;
    l_charge_per_share        NUMBER;
    l_fixed_charge            NUMBER;
    l_institute_id            NUMBER;
    l_trans_chrg_grp_id       NUMBER;
    l_hold_chrg_grp_id        NUMBER;
    l_pled_in_chrg_grp_id     NUMBER;
    l_pled_out_chrg_grp_id    NUMBER;
    l_shar_tran_chrg_grp_id   NUMBER;
    l_charge_group_id         NUMBER;
BEGIN
    IF p_value = 0
    THEN
        RETURN 0;
    END IF;

    SELECT m26.m26_trans_chrg_grp_id_m166,
           m26.m26_hold_chrg_grp_id_m166,
           m26.m26_pled_in_chrg_grp_id_m166,
           m26.m26_pled_out_chrg_grp_id_m166,
           m26.m26_shar_tran_chrg_grp_id_m166,
           m26.m26_institution_id_m02
      INTO l_trans_chrg_grp_id,
           l_hold_chrg_grp_id,
           l_pled_in_chrg_grp_id,
           l_pled_out_chrg_grp_id,
           l_shar_tran_chrg_grp_id,
           l_institute_id
      FROM m26_executing_broker m26
     WHERE m26.m26_id = p_custodian_id;

    IF p_charge_type = 1
    THEN
        l_charge_group_id := l_trans_chrg_grp_id;
    ELSIF p_charge_type = 2
    THEN
        l_charge_group_id := l_hold_chrg_grp_id;
    ELSIF p_charge_type = 3
    THEN
        l_charge_group_id := l_pled_in_chrg_grp_id;
    ELSIF p_charge_type = 4
    THEN
        l_charge_group_id := l_pled_out_chrg_grp_id;
    ELSIF p_charge_type = 5
    THEN
        l_charge_group_id := l_shar_tran_chrg_grp_id;
    END IF;

    IF p_charge_type = 1
    THEN
        SELECT m167.m167_per_share_charge, m167.m167_fixed_charge
          INTO l_charge_per_share, l_fixed_charge
          FROM m167_custody_charges_slab m167
         WHERE     m167.m167_custody_group_id_m166 = l_charge_group_id
               AND m167.m167_status_id_v01 = 2
               AND m167.m167_from <= p_value
               AND m167.m167_to > p_value
               AND m167.m167_currency_code_m03 = p_symbol_currency
               AND m167.m167_instrument_type_code_v09 =
                       p_instrument_type_code;
    ELSE
        SELECT m167.m167_per_share_charge, m167.m167_fixed_charge
          INTO l_charge_per_share, l_fixed_charge
          FROM m167_custody_charges_slab m167
         WHERE     m167.m167_custody_group_id_m166 = l_charge_group_id
               AND m167.m167_status_id_v01 = 2
               AND m167.m167_from <= p_value
               AND m167.m167_to > p_value
               AND m167.m167_currency_code_m03 = p_symbol_currency;
    END IF;

    l_calculated_charge_amt :=
        ( (ABS (p_value) * l_charge_per_share) + l_fixed_charge);

    RETURN l_calculated_charge_amt;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        RETURN 0;
END;
/
