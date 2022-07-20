CREATE OR REPLACE PROCEDURE dfn_ntp.sp_redist_base_hld_generate (
    t09c    t09_txn_single_entry_v3%ROWTYPE)
IS
BEGIN
    BEGIN
        MERGE INTO dfn_ntp.u24_holdings t
         USING (SELECT *
                  FROM (SELECT t09c.t09_base_trading_acc_id_u07,
                               t09c.t09_symbol_id_m20,
                               t09c.t09_base_sym_exchange_m01
                                   AS t09_exchange_m01,
                               t09c.t09_custodian_id_m26
                                   AS t09_custodian_id_m26,
                               t09c.t09_base_symbol_code_m20
                                   AS t09_symbol_code_m20 --  ,CASE WHEN T.lastUpdatedTime = 0 THEN SYSDATE ELSE TO_DATE(T.lastUpdatedTime,'YYYYMMDD') END AS lastUpdatedTime
                                                         --  ,T.lastUpdatedTime
                               ,
                               --  TO_DATE ('19700101', 'yyyymmdd')
                               -- + (  (t09c.t09_last_updated_time / 1000)
                               --    / 24
                               --    / 60
                               --    / 60)
                               NVL (
                                   TO_TIMESTAMP (t09c.t09_last_updated_time,
                                                 'YYYYMMDDHH24MISS'),
                                   SYSDATE)
                                   AS t09_last_updated_time,
                               NVL (t09c.t09_base_holding_block, 0)
                                   AS t09_holding_blk,
                               t09c.t09_db_seq_id AS t09_db_seq_id,
                               t09c.t09_parent_lockseq AS t09_parent_lockseq
                          FROM DUAL) ca) s
            ON (    t.u24_symbol_code_m20 = s.t09_symbol_code_m20
                AND t.u24_exchange_code_m01 = s.t09_exchange_m01
                AND t.u24_trading_acnt_id_u07 = s.t09_base_trading_acc_id_u07
                AND t.u24_custodian_id_m26 = s.t09_custodian_id_m26)
        WHEN MATCHED
        THEN
            UPDATE SET
                t.u24_last_update_datetime = s.t09_last_updated_time,
                t.u24_holding_block = s.t09_holding_blk,
                t.u24_ordexecseq = s.t09_parent_lockseq
                 WHERE NVL (t.u24_ordexecseq, 0) < s.t09_parent_lockseq;
    END;
END;
/