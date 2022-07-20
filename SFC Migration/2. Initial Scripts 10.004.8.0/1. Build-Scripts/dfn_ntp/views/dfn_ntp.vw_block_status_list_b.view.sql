CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_block_status_list_b
(
    v01_id,
    v01_description,
    v01_description_lang
)
AS
    SELECT a.v01_id, a.v01_description, a.v01_description_lang
      FROM v01_system_master_data a
     WHERE v01_type = 1003
    UNION ALL
    SELECT NULL AS v01_id,
           'Debit Block' AS v01_description,
           'Debit Block' AS v01_description_lang
      FROM DUAL

--1 - Open, 2 - Debit Block, 3 - Close, 4 - Full Block, Null Consider As Debit Block
/

