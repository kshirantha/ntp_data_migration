CREATE TABLE dfn_ntp.a21_minimum_commission_audit
(
    a21_id                       NUMBER (10, 0),
    a21_comm_id_m22              NUMBER (5, 0),
    a21_old_min_comm             NUMBER (18, 0),
    a21_new_min_comm             NUMBER (18, 0),
    a21_from_currency_code_m03   CHAR (3 BYTE),
    a21_to_currency_code_m03     CHAR (3 BYTE),
    a21_modified_date            DATE,
    a21_modified_by_u17          NUMBER (10, 0),
    a21_institute_id_m02         NUMBER (5, 0),
    a21_custom_type              VARCHAR2 (50 BYTE)
)
/
