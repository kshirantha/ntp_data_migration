CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_vat_invoice
(
    t05_code,
    description,
    description_ar,
    supply_date,
    customer_name,
    address,
    address_ar,
    vat_number,
    vat_no_of_supplying_company,
    from_name,
    from_address,
    total,
    vat,
    total_excl_vat,
    invoice_no,
    vat_rate,
    t48_issue_date,
    t48_from_date,
    t48_to_date,
    u01_customer_no
)
AS
    (  SELECT t02.t02_txn_code AS t05_code,
              MAX (m97_description) AS description,
              MAX (m97_description_lang) AS description_ar,
              TRUNC (t02.t02_create_date) AS supply_date,
              -- COUNT (t02.t02_last_db_seq_id) AS cnt,
              MAX (u01.u01_display_name) AS customer_name,
              -- MAX (u01.u01_display_name_lang) AS custname_ar,
              MAX (
                     u02_po_box
                  || ', '
                  || u02_building_no
                  || ', '
                  || u02_address_line1
                  || ', '
                  || u02_address_line2
                  || ', '
                  || m06.m06_name
                  || ', '
                  || m05_name)
                  AS address,
              MAX (
                     u02_po_box
                  || ', '
                  || u02_building_no
                  || ', '
                  || u02_address_line1_lang
                  || ', '
                  || u02_address_line2_lang
                  || ', '
                  || m06.m06_name_lang
                  || ', '
                  || m05_name_lang)
                  AS address_ar,
              MAX (u01.u01_tax_ref) AS vat_number,
              MAX (m02.m02_vat_no) AS vat_no_of_supplying_company,
              MAX (m02_name) AS from_name,
              MAX (m02_address) AS from_address,
              SUM (ABS (t02.t02_amnt_in_txn_currency)) AS total,
              SUM (t02.t02_broker_tax + t02.t02_exchange_tax) AS vat,
                SUM (ABS (t02.t02_amnt_in_txn_currency))
              - SUM (t02.t02_broker_tax + t02.t02_exchange_tax)
                  AS total_excl_vat,
              MAX (t49_invoice_no_t48) AS invoice_no,
              CASE
                  WHEN TRUNC (t02_create_date) <
                           TO_DATE ('2020-07-01', 'YYYY-MM-DD')
                  THEN
                      5
                  ELSE
                      15
              END
                  AS vat_rate,
              MAX (t48.t48_issue_date) AS t48_issue_date,
              MAX (t48_from_date) AS t48_from_date,
              MAX (t48_to_date) AS t48_to_date,
              MAX (u01_customer_no) AS u01_customer_no
         FROM dfn_ntp.t49_tax_invoice_details t49
              INNER JOIN t02_transaction_log t02
                  ON t02.t02_last_db_seq_id = t49_last_db_seq_id_t02
              INNER JOIN m97_transaction_codes m97
                  ON m97_code = t49_txn_code
              INNER JOIN u01_customer u01
                  ON u01.u01_id = t02.t02_customer_id_u01
              INNER JOIN u02_customer_contact_info u02
                  ON u02.u02_customer_id_u01 = u01.u01_id
              INNER JOIN m06_city m06
                  ON m06.m06_id = u02_city_id_m06
              INNER JOIN m05_country m05
                  ON m06.m06_country_id_m05 = m05.m05_id
              INNER JOIN m02_institute m02
                  ON u01.u01_institute_id_m02 = m02.m02_id
              INNER JOIN t48_tax_invoices t48
                  ON t48.t48_invoice_no = t49_invoice_no_t48
     --  WHERE t49_invoice_no_t48 = '0000001357'
     GROUP BY t02.t02_txn_code, t02.t02_order_no, TRUNC (t02.t02_create_date))
/
