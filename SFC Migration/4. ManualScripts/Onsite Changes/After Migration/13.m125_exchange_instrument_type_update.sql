MERGE INTO dfn_ntp.m125_exchange_instrument_type m125
     USING dfn_ntp.m54_boards m54
        ON (    m125_exchange_code_m01 = m54.m54_exchange_code_m01
            AND m54_exchange_code_m01 <> 'TDWL')
WHEN MATCHED
THEN
    UPDATE SET m125_board_code_m54 = m54_code, m125_board_id_m54 = m54_id;


COMMIT;

MERGE INTO dfn_ntp.m125_exchange_instrument_type m125
     USING dfn_ntp.m54_boards m54
        ON (    m125_exchange_code_m01 = m54.m54_exchange_code_m01
            AND m54_exchange_code_m01 = 'TDWL'
            AND m54_code = 'SAEQ'
            AND m125_instrument_type_code_v09 NOT IN ('OPT', 'FUT', 'BN'))
WHEN MATCHED
THEN
    UPDATE SET m125_board_code_m54 = m54_code, m125_board_id_m54 = m54_id;


MERGE INTO dfn_ntp.m125_exchange_instrument_type m125
     USING dfn_ntp.m54_boards m54
        ON (    m125_exchange_code_m01 = m54.m54_exchange_code_m01
            AND m54_exchange_code_m01 = 'TDWL'
            AND m54_code = 'SADF'
            AND m125_instrument_type_code_v09 IN ('OPT', 'FUT'))
WHEN MATCHED
THEN
    UPDATE SET m125_board_code_m54 = m54_code, m125_board_id_m54 = m54_id;

MERGE INTO dfn_ntp.m125_exchange_instrument_type m125
     USING dfn_ntp.m54_boards m54
        ON (    m125_exchange_code_m01 = m54.m54_exchange_code_m01
            AND m54_exchange_code_m01 = 'TDWL'
            AND m54_code = 'SAFI'
            AND m125_instrument_type_code_v09 IN ('BN'))
WHEN MATCHED
THEN
    UPDATE SET m125_board_code_m54 = m54_code, m125_board_id_m54 = m54_id;

COMMIT;