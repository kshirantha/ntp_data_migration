CREATE OR REPLACE PROCEDURE dfn_ntp.sp_populate_int_ind_history
IS
    l_date   DATE := TRUNC (func_get_eod_date ());
BEGIN
    DELETE FROM h13_interest_indices_history
     WHERE h13_date = l_date;

    INSERT INTO h13_interest_indices_history (h13_id,
                                              h13_date,
                                              h13_description,
                                              h13_type,
                                              h13_duration_id_m64,
                                              h13_rate,
                                              h13_institution_id_m02,
                                              h13_tax)
        SELECT (SELECT NVL (MAX (h13_id) + 1, 1)
                  FROM h13_interest_indices_history),
               l_date,
               m65_description,
               m65_type,
               m65_duration_id_m64,
               m65_rate,
               m65_institution_id_m02,
               m65_tax
          FROM m65_saibor_basis_rates;
END;
/