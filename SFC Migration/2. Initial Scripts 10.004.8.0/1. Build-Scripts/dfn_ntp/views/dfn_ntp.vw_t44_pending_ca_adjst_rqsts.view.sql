CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t44_pending_ca_adjst_rqsts
(
   t44_id,
   t44_cust_ca_dist_id_t41,
   t44_hold_on_rec_date_t41,
   t44_no_of_approval,
   t44_is_approval_completed,
   t44_current_approval_level,
   t44_next_status,
   t44_created_date,
   t44_last_updated_date,
   t44_status_id_v01,
   t44_comment,
   t44_created_by_id_u17,
   t44_last_updated_by_id_u17,
   t44_institute_id_m02,
   status_description,
   status_description_lang,
   created_by_full_name,
   modified_by_full_name,
   t41_id,
   t41_hold_on_rec_date,
   u01_customer_no,
   u01_display_name,
   u01_display_name_lang,
   u07_display_name,
   u06_display_name,
   symbol_code
)
AS
   SELECT t44.T44_ID,
          t44.T44_CUST_CA_DIST_ID_T41,
          t44.T44_HOLD_ON_REC_DATE_T41,
          t44.T44_NO_OF_APPROVAL,
          t44.T44_IS_APPROVAL_COMPLETED,
          t44.T44_CURRENT_APPROVAL_LEVEL,
          t44.T44_NEXT_STATUS,
          t44.T44_CREATED_DATE,
          t44.T44_LAST_UPDATED_DATE,
          t44.T44_STATUS_ID_V01,
          t44.T44_COMMENT,
          t44.T44_CREATED_BY_ID_U17,
          t44.T44_LAST_UPDATED_BY_ID_U17,
          t44.t44_institute_id_m02,
          status_list.v01_description AS status_description,
          status_list.v01_description_lang AS status_description_lang,
          u17_created_by.u17_full_name AS created_by_full_name,
          u17_modified_by.u17_full_name AS modified_by_full_name,
          t41.T41_ID,
          t41.T41_HOLD_ON_REC_DATE,
          u01.u01_customer_no,
          u01.u01_display_name,
          u01.u01_display_name_lang,
          u07.u07_display_name,
          u06.u06_display_name,
          m141.M141_SYMBOL_CODE_M20 AS symbol_code
     FROM T44_PENDING_CUST_CA_ADJUST t44
          JOIN T41_CUST_CORP_ACT_DISTRIBUTION t41
             ON t44.T44_CUST_CA_DIST_ID_T41 = t41.T41_ID
          INNER JOIN u01_customer u01 ON t41.t41_customer_id_u01 = u01.u01_id
          INNER JOIN u06_cash_account u06
             ON t41.t41_cash_acc_id_u06 = u06.u06_id
          INNER JOIN u07_trading_account u07
             ON t41.t41_trading_acc_id_u07 = u07.u07_id
          LEFT JOIN u17_employee u17_created_by
             ON t44.t44_created_by_id_u17 = u17_created_by.u17_id
          LEFT JOIN u17_employee u17_modified_by
             ON t44.t44_last_updated_by_id_u17 = u17_modified_by.u17_id
          LEFT JOIN vw_status_list status_list
             ON t44.t44_status_id_v01 = status_list.v01_id
          LEFT JOIN M141_CUST_CORPORATE_ACTION m141
             ON t41.T41_CUST_CORP_ACT_ID_M141 = m141.M141_ID
/