CREATE TABLE dfn_ntp.m18_derivative_spread_matrix
(
    m18_id                        NUMBER (10, 0),
    m18_symbol1_id_m20            NUMBER (5, 0),
    m18_symbol2_id_m20            NUMBER (5, 0),
    m18_spread_value              NUMBER (21, 5),
    m18_status_id_v01             NUMBER (5, 0) DEFAULT 0,
    m18_created_by_id_u17         NUMBER (10, 0),
    m18_created_date              DATE,
    m18_status_change_by_id_u17   NUMBER (5, 0),
    m18_status_change_date        DATE,
    m18_modified_by_id_u17        NUMBER (10, 0),
    m18_modified_date             DATE
)
/

ALTER TABLE dfn_ntp.m18_derivative_spread_matrix
 ADD (
  m18_custom_type VARCHAR2 (50) DEFAULT 1,
  m18_institute_id_m02 NUMBER (3)
 )
 MODIFY (
  m18_created_date DEFAULT SYSDATE

 )
/

ALTER TABLE dfn_ntp.m18_derivative_spread_matrix MODIFY (m18_symbol1_id_m20 NUMBER (10))
/

ALTER TABLE dfn_ntp.m18_derivative_spread_matrix MODIFY (m18_symbol2_id_m20 NUMBER (10))
/
