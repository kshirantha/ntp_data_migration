GRANT SELECT,
      INSERT,
      DELETE,
      UPDATE
    ON esp_transactions_complete
    TO dfn_mig;
GRANT SELECT,
      INSERT,
      DELETE,
      UPDATE
    ON esp_todays_snapshots
    TO dfn_mig;

COMMIT;