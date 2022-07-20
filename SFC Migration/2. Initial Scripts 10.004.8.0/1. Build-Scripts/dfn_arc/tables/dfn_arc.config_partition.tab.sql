CREATE TABLE dfn_arc.config_partition
(
    enable_partition     NUMBER (1),
    min_partition_date   DATE
)
/

INSERT
  INTO dfn_arc.config_partition (enable_partition, min_partition_date)
VALUES (1, TO_DATE ('01/01/2020', 'DD/MM/YYYY'));

COMMIT;
