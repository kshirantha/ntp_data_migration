--Run this script if PTTP need to be enabled

UPDATE dfn_ntp.u07_trading_account
   SET u07_exchange_account_no = LPAD (u07_exchange_account_no, 11, '0')
 WHERE u07_exchange_code_m01 = 'TDWL';

COMMIT;

UPDATE dfn_ntp.u01_customer
   SET u01_investor_id = u01_default_id_no;

COMMIT;

