CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_tax_eom_data (
    p_cashaccountid   IN     u06_cash_account.u06_id%TYPE,
    p_customerid      IN     u01_customer.u01_id%TYPE,
    p_startdate       IN     t48_tax_invoices.t48_from_date%TYPE DEFAULT SYSDATE,
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER)
IS
    l_invoice_no   VARCHAR2 (20) := NULL;
    l_inst_id      NUMBER := 1;
BEGIN
    prows := 1;

    SELECT NVL (MAX (t48.t48_invoice_no), '-1'),
           NVL (MAX (u06.u06_institute_id_m02), -1)
      INTO l_invoice_no, l_inst_id
      FROM     t48_tax_invoices t48
           JOIN
               u06_cash_account u06
           ON u06.u06_id = t48_cash_account_id_u06
     WHERE     TRUNC (t48.t48_from_date) = TRUNC (p_startdate)
           AND t48.t48_eom_report = 1
           AND u06.u06_customer_id_u01 = p_customerid
           AND t48.t48_cash_account_id_u06 = p_cashaccountid;

    sp_get_tax_invoice_details (p_view           => p_view,
                                prows            => prows,
                                p_invoiceno      => l_invoice_no,
                                p_institute_id   => l_inst_id);
END;
/
