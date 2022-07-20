-- Price Migration

TRUNCATE TABLE dfn_price.esp_todays_snapshots;

TRUNCATE TABLE dfn_price.esp_transactions_complete;

COMMIT;