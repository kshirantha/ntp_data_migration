CREATE TABLE dfn_ntp.u52_poa_trad_privilege_pending
(
    u52_id                         NUMBER (20, 0),
    u52_poa_id_u47                 NUMBER (10, 0) NOT NULL,
    u52_trading_account_id_u07     NUMBER (10, 0) NOT NULL,
    u52_status_id_v01              NUMBER (5, 0),
    u52_status_changed_by_id_u17   NUMBER (10, 0),
    u52_status_changed_date        DATE,
    u52_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1
)
/