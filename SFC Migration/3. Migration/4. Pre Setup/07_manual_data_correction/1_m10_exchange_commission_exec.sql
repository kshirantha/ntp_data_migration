UPDATE m10_exchange_commission_exec m10
   SET m10.m10_currency = 'GBP'
 WHERE m10.m10_exchange = 'LSE';

UPDATE m10_exchange_commission_exec m10
   SET m10.m10_currency = 'AED'
 WHERE m10.m10_exchange = 'NMS';

UPDATE m10_exchange_commission_exec m10
   SET m10.m10_currency = 'EUR'
 WHERE m10.m10_exchange = 'PAR';


UPDATE m10_exchange_commission_exec m10
   SET m10.m10_exchange = 'KSE'
 WHERE m10.m10_exchange = 'KUW';

UPDATE m10_exchange_commission_exec m10
   SET m10.m10_exchange = 'ADSM'
 WHERE m10.m10_exchange = 'ADX';

COMMIT;