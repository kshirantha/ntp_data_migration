CREATE TABLE dfn_ntp.h13_interest_indices_history
(
    h13_date                 DATE,
    h13_id                   NUMBER (18, 0) NOT NULL,
    h13_description          VARCHAR2 (255 BYTE),
    h13_type                 NUMBER (10, 0),
    h13_duration_id_m64      NUMBER (18, 0),
    h13_rate                 NUMBER (18, 5),
    h13_institution_id_m02   NUMBER (18, 0),
    h13_custom_type          VARCHAR2 (50 BYTE) DEFAULT 1,
    h13_tax                  NUMBER (18, 5)
)
/



COMMENT ON COLUMN dfn_ntp.h13_interest_indices_history.h13_type IS
    '1-SAIBOR, 2-BASIS, 3-SIBOR, 4-LIBOR'
/