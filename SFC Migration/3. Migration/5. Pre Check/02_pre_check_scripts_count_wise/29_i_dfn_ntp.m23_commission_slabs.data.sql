DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link a
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'M52_COMMISSION_STRUCTURES';

    ----------- VAT Charge Type INVALID -----------

    SELECT COUNT (*)
      INTO l_error_count
      FROM mubasher_oms.m52_commission_structures@mubasher_db_link m52,
           dfn_ntp.m124_commission_types m124 -- Master Data Table
     WHERE     m52.m52_vat_charge_type = m124.m124_value(+)
           AND m124.m124_value IS NULL;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M23_COMMISSION_SLABS',
                 'M52_COMMISSION_STRUCTURES',
                 l_source_count,
                 l_error_count,
                 '(M52_VAT_CHARGE_TYPE) INVALID');
END;
/
