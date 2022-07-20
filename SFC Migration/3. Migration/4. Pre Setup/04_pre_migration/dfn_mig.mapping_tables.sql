DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm02_institute_mappings';
    l_old_column   VARCHAR2 (50) := 'old_institute_id';
    l_new_column   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm12_emp_dep_mappings';
    l_old_column   VARCHAR2 (50) := 'old_emp_dep_id';
    l_new_column   VARCHAR2 (50) := 'new_emp_dep_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'u17_employee_mappings';
    l_old_column   VARCHAR2 (50) := 'old_employee_id';
    l_new_column   VARCHAR2 (50) := 'new_employee_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm07_location_mappings';
    l_old_column   VARCHAR2 (50) := 'old_location_id';
    l_new_column   VARCHAR2 (50) := 'new_location_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm08_trd_group_mappings';
    l_old_column   VARCHAR2 (50) := 'old_trd_group_id';
    l_new_column   VARCHAR2 (50) := 'new_trd_group_id';
    l_is_local_exchange   VARCHAR2 (50) := 'is_local_exchange'; -- 1 : TDWL | 0 : None TDWL
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_is_local_exchange
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm09_companies_mappings';
    l_old_column       VARCHAR2 (50) := 'old_companies_id';
    l_new_column       VARCHAR2 (50) := 'new_companies_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm10_rm_mappings';
    l_old_column   VARCHAR2 (50) := 'old_rm_id';
    l_new_column   VARCHAR2 (50) := 'new_rm_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm14_issue_location_mappings';
    l_old_column       VARCHAR2 (50) := 'old_issue_location_id';
    l_new_column       VARCHAR2 (50) := 'new_issue_location_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm16_bank_mappings';
    l_old_column   VARCHAR2 (50) := 'old_bank_id';
    l_new_column   VARCHAR2 (50) := 'new_bank_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm17_bank_branches_mappings';
    l_old_column   VARCHAR2 (50) := 'old_bank_branches_id';
    l_new_column   VARCHAR2 (50) := 'new_bank_branches_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm20_symbol_mappings';
    l_old_column   VARCHAR2 (50) := 'old_symbol_id';
    l_new_column   VARCHAR2 (50) := 'new_symbol_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm21_introducing_brk_mappings';
    l_old_column       VARCHAR2 (50) := 'old_introducing_brk_id';
    l_new_column       VARCHAR2 (50) := 'new_introducing_brk_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm22_comm_grp_mappings';
    l_old_column   VARCHAR2 (50) := 'old_comm_grp_id';
    l_new_column   VARCHAR2 (50) := 'new_comm_grp_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm22_default_comm_groups';
    l_exchange     VARCHAR2 (50) := 'exchange';
    l_comm_group   VARCHAR2 (50) := 'comm_group';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_exchange
            || ' VARCHAR2 (10) NOT NULL,'
            || l_comm_group
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm23_comm_slabs_mappings';
    l_old_column   VARCHAR2 (50) := 'old_comm_slab_id';
    l_new_column   VARCHAR2 (50) := 'new_comm_slab_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm24_comm_disc_grp_mappings';
    l_old_column   VARCHAR2 (50) := 'old_comm_disc_grp_id';
    l_new_column   VARCHAR2 (50) := 'new_comm_disc_grp_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm25_comm_disc_slabs_mappings';
    l_old_column   VARCHAR2 (50) := 'old_comm_disc_slabs_id';
    l_new_column   VARCHAR2 (50) := 'new_comm_disc_slabs_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm26_executing_broker_mappings';
    l_old_column   VARCHAR2 (50) := 'old_executing_broker_id';
    l_new_column   VARCHAR2 (50) := 'new_executing_broker_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm34_exec_broker_comm_mappings';
    l_old_column   VARCHAR2 (50) := 'old_exec_broker_comm_id';
    l_new_column   VARCHAR2 (50) := 'new_exec_broker_comm_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm28_cust_grade_data_mappings';
    l_old_column       VARCHAR2 (50) := 'old_cust_grade_data_id';
    l_new_column       VARCHAR2 (50) := 'new_cust_grade_data_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm57_exg_order_types_mappings';
    l_old_column   VARCHAR2 (50) := 'old_exg_order_types_id';
    l_new_column   VARCHAR2 (50) := 'new_exg_order_types_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm58_exchange_tif_mappings';
    l_old_column   VARCHAR2 (50) := 'old_exchange_tif_id';
    l_new_column   VARCHAR2 (50) := 'new_exchange_tif_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm59_exg_mkt_status_mappings';
    l_old_column   VARCHAR2 (50) := 'old_exg_mkt_status_id';
    l_new_column   VARCHAR2 (50) := 'new_exg_mkt_status_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm30_ex_mkt_permission_mappings';
    l_old_column   VARCHAR2 (50) := 'old_ex_mkt_permission_id';
    l_new_column   VARCHAR2 (50) := 'new_ex_mkt_permission_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm32_ex_mkt_status_tif_mappings';
    l_old_column   VARCHAR2 (50) := 'old_ex_mkt_status_tif_id';
    l_new_column   VARCHAR2 (50) := 'new_ex_mkt_status_tif_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm45_permission_groups_mappings';
    l_old_column   VARCHAR2 (50) := 'old_permission_groups_id';
    l_new_column   VARCHAR2 (50) := 'new_permission_groups_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count              NUMBER := 0;
    l_table              VARCHAR2 (50) := 'm46_permisn_grp_entl_mappings';
    l_old_column         VARCHAR2 (50) := 'old_permisn_grp_entl_id';
    l_new_column         VARCHAR2 (50) := 'new_permisn_grp_entl_id';
    new_entitlement_id   VARCHAR2 (50) := 'new_entitlement_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' VARCHAR2 (100) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_entitlement_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm47_permisn_grp_users_mappings';
    l_old_column   VARCHAR2 (50) := 'old_permisn_grp_users_id';
    l_new_column   VARCHAR2 (50) := 'new_permisn_grp_users_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm51_emp_trading_grp_mappings';
    l_old_column   VARCHAR2 (50) := 'old_emp_trading_grp_id';
    l_new_column   VARCHAR2 (50) := 'new_emp_trading_grp_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm60_institute_banks_mappings';
    l_old_column   VARCHAR2 (50) := 'old_institute_banks_id';
    l_new_column   VARCHAR2 (50) := 'new_institute_banks_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm62_inst_documents_mappings';
    l_old_column   VARCHAR2 (50) := 'old_inst_documents_id';
    l_new_column   VARCHAR2 (50) := 'new_inst_documents_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm52_notification_grp_mappings';
    l_old_column   VARCHAR2 (50) := 'old_notification_grp_id';
    l_new_column   VARCHAR2 (50) := 'new_notification_grp_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm65_saibor_basis_rate_mappings';
    l_old_column   VARCHAR2 (50) := 'old_saibor_basis_rate_id';
    l_new_column   VARCHAR2 (50) := 'new_saibor_basis_rate_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count              NUMBER := 0;
    l_table              VARCHAR2 (50) := 'm65_default_sibor_basis_rates';
    l_institution        VARCHAR2 (50) := 'institution';
    l_sibor_basis_rate   VARCHAR2 (50) := 'sibor_basis_rate';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_institution
            || ' NUMBER (22, 0) NOT NULL,'
            || l_sibor_basis_rate
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm67_fix_logins_mappings';
    l_old_column   VARCHAR2 (50) := 'old_fix_logins_id';
    l_new_column   VARCHAR2 (50) := 'new_fix_logins_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm70_custody_exchanges_mappings';
    l_old_column   VARCHAR2 (50) := 'old_custody_exchanges_id';
    l_new_column   VARCHAR2 (50) := 'new_custody_exchanges_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm72_exec_brk_cash_acc_mappings';
    l_old_column   VARCHAR2 (50) := 'old_exec_brk_cash_acc_id';
    l_new_column   VARCHAR2 (50) := 'new_exec_brk_cash_acc_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm73_margin_products_mappings';
    l_old_column1      VARCHAR2 (50) := 'old_margin_products_id';
    l_old_column2      VARCHAR2 (50) := 'currency_code';
    l_new_column       VARCHAR2 (50) := 'new_margin_products_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column1
            || ' NUMBER (22, 0) NOT NULL,'
            || l_old_column2
            || ' VARCHAR2 (10 BYTE) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm74_margin_int_group_mappings';
    l_old_column1      VARCHAR2 (50) := 'old_currency';
    l_old_column2      VARCHAR2 (50) := 'old_interest_index';
    l_new_column       VARCHAR2 (50) := 'new_margin_int_group_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column1
            || ' VARCHAR2 (1000 BYTE) NOT NULL,'
            || l_old_column2
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm74_default_mrgn_int_groups';
    l_currency         VARCHAR2 (50) := 'currency_code';
    l_mrgn_int_group   VARCHAR2 (50) := 'mrgn_int_group';
    l_mrgn_prd         VARCHAR2 (50) := 'margin_product';
    l_institution      VARCHAR2 (50) := 'institution';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_currency
            || ' VARCHAR2 (10) NOT NULL,'
            || l_mrgn_prd
            || ' NUMBER (22, 0) NOT NULL,'
            || l_mrgn_int_group
            || ' NUMBER (22, 0) NOT NULL,'
            || l_institution
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm77_symbol_margin_grp_mappings';
    l_old_column   VARCHAR2 (50) := 'old_symbol_margin_grp_id';
    l_new_column   VARCHAR2 (50) := 'new_symbol_margin_grp_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm78_sym_marginability_mappings';
    l_old_column   VARCHAR2 (50) := 'old_sym_marginability_id';
    l_new_column   VARCHAR2 (50) := 'new_sym_marginability_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm79_pending_sy_mg_req_mappings';
    l_old_column   VARCHAR2 (50) := 'old_pending_sy_mg_req_id';
    l_new_column   VARCHAR2 (50) := 'new_pending_sy_mg_req_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm87_exec_broker_exg_mappings';
    l_old_column   VARCHAR2 (50) := 'old_exec_broker_exg_id';
    l_new_column   VARCHAR2 (50) := 'new_exec_broker_exg_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm105_other_brokerages_mappings';
    l_old_column       VARCHAR2 (50) := 'old_other_brokerages_id';
    l_new_column       VARCHAR2 (50) := 'new_other_brokerages_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm114_cmpny_positions_mappings';
    l_old_column       VARCHAR2 (50) := 'old_cmpny_positions_id';
    l_new_column       VARCHAR2 (50) := 'new_cmpny_positions_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm110_reasons_mappings';
    l_old_column       VARCHAR2 (50) := 'old_reasons_id';
    l_new_column       VARCHAR2 (50) := 'new_reasons_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm116_hijri_adjustment_mappings';
    l_old_column       VARCHAR2 (50) := 'old_hijri_adjustment_id';
    l_new_column       VARCHAR2 (50) := 'new_hijri_adjustment_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm117_charge_groups_mappings';
    l_old_column       VARCHAR2 (50) := 'old_charge_groups_id';
    l_new_column       VARCHAR2 (50) := 'new_charge_groups_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm118_chrg_fee_struct_mappings';
    l_old_column       VARCHAR2 (50) := 'old_chrg_fee_structure_id';
    l_new_column       VARCHAR2 (50) := 'new_chrg_fee_structure_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm122_exg_tick_sizes_mappings';
    l_old_column   VARCHAR2 (50) := 'old_exg_tick_sizes_id';
    l_new_column   VARCHAR2 (50) := 'new_exg_tick_sizes_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm125_exg_inst_type_mappings';
    l_old_column   VARCHAR2 (50) := 'old_exg_inst_type_id';
    l_new_column   VARCHAR2 (50) := 'new_exg_inst_type_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm133_gl_account_types_mappings';
    l_old_column   VARCHAR2 (50) := 'old_gl_account_types_id';
    l_new_column   VARCHAR2 (50) := 'new_gl_account_types_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm134_gl_acc_category_mappings';
    l_old_column   VARCHAR2 (50) := 'old_gl_acc_category_name';
    l_new_column   VARCHAR2 (50) := 'new_gl_acc_categories_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' VARCHAR2 (1000 BYTE) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm135_gl_accounts_mappings';
    l_old_column       VARCHAR2 (50) := 'old_gl_accounts_id';
    l_new_column       VARCHAR2 (50) := 'new_gl_accounts_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm93_bank_accounts_mappings';
    l_old_column   VARCHAR2 (50) := 'old_bank_accounts_id';
    l_new_column   VARCHAR2 (50) := 'new_bank_accounts_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'u01_customer_mappings';
    l_old_column   VARCHAR2 (50) := 'old_customer_id';
    l_new_column   VARCHAR2 (50) := 'new_customer_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';

        EXECUTE IMMEDIATE
               'CREATE UNIQUE INDEX idx_old_customer_id ON '
            || l_table
            || '(old_customer_id ASC)';

        EXECUTE IMMEDIATE
               'CREATE UNIQUE INDEX idx_new_customer_id ON '
            || l_table
            || '(new_customer_id ASC)';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm109_cust_family_mem_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cust_family_mem_id';
    l_new_column   VARCHAR2 (50) := 'new_cust_family_mem_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'u48_corp_cust_contact_mappings';
    l_old_column   VARCHAR2 (50) := 'old_corp_cust_contact_id';
    l_new_column   VARCHAR2 (50) := 'new_corp_cust_contact_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'u05_cust_id_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cust_id_id';
    l_new_column   VARCHAR2 (50) := 'new_cust_id_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'u03_customer_kyc_mappings';
    l_old_column   VARCHAR2 (50) := 'old_customer_kyc_id';
    l_new_column   VARCHAR2 (50) := 'new_customer_kyc_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'u06_cash_account_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cash_account_id';
    l_new_column   VARCHAR2 (50) := 'new_cash_account_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';

        EXECUTE IMMEDIATE
               'CREATE UNIQUE INDEX idx_old_cash_account_id ON '
            || l_table
            || '(old_cash_account_id ASC)';

        EXECUTE IMMEDIATE
               'CREATE UNIQUE INDEX idx_new_cash_account_id ON '
            || l_table
            || '(new_cash_account_id ASC)';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm131_market_maker_grp_mappings';
    l_old_column       VARCHAR2 (50) := 'old_market_maker_grp_id';
    l_new_column       VARCHAR2 (50) := 'new_market_maker_grp_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count         NUMBER := 0;
    l_table         VARCHAR2 (50) := 'u07_trading_account_mappings';
    l_old_column1   VARCHAR2 (50) := 'old_trading_account_id'; -- No Usage But Added on Request for Tracking
    l_old_column2   VARCHAR2 (50) := 'old_routing_account_id';
    l_new_column    VARCHAR2 (50) := 'new_trading_account_id';
    exchange_code   VARCHAR2 (50) := 'exchange_code';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column1
            || ' NUMBER (22, 0) NOT NULL,'
            || l_old_column2
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || exchange_code
            || ' VARCHAR2 (10) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'u08_cust_benefcry_acc_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cust_benefcry_acc_id';
    l_new_column   VARCHAR2 (50) := 'new_cust_benefcry_acc_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'u09_customer_login_mappings';
    l_old_column   VARCHAR2 (50) := 'old_customer_login_id';
    l_new_column   VARCHAR2 (50) := 'new_customer_login_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm104_cust_notify_sche_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cust_notify_sche_id';
    l_new_column   VARCHAR2 (50) := 'new_cust_notify_sche_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'u23_cust_margin_prod_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cust_margin_prod_id';
    l_new_column   VARCHAR2 (50) := 'new_cust_margin_prod_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'u22_cust_mrg_call_log_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cust_mrg_call_log_id';
    l_new_column   VARCHAR2 (50) := 'new_cust_mrg_call_log_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'u29_emp_notifi_groups_mappings';
    l_old_column   VARCHAR2 (50) := 'old_emp_notifi_groups_id';
    l_new_column   VARCHAR2 (50) := 'new_emp_notifi_groups_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'u41_notification_conf_mappings';
    l_old_column   VARCHAR2 (50) := 'old_notification_conf_id';
    l_new_column   VARCHAR2 (50) := 'new_notification_conf_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'u44_uploaded_doc_mappings';
    l_old_column   VARCHAR2 (50) := 'old_uploaded_doc_id';
    l_new_column   VARCHAR2 (50) := 'new_uploaded_doc_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'u45_uploaded_doc_page_mappings';
    l_old_column   VARCHAR2 (50) := 'old_uploaded_doc_page_id';
    l_new_column   VARCHAR2 (50) := 'new_uploaded_doc_page_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count         NUMBER := 0;
    l_table         VARCHAR2 (50) := 'u47_power_of_attorney_mappings';
    l_old_column1   VARCHAR2 (50) := 'old_poa_id';
    l_old_column2   VARCHAR2 (50) := 'old_customer_id';
    l_new_column    VARCHAR2 (50) := 'new_power_of_attorney_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column1
            || ' NUMBER (22, 0) NOT NULL,'
            || l_old_column2
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'u55_poa_sym_restrict_mappings';
    l_old_column   VARCHAR2 (50) := 'old_poa_sym_restrict_id';
    l_new_column   VARCHAR2 (50) := 'new_poa_sym_restrict_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'u13_ext_custody_pf_mappings';
    l_old_column   VARCHAR2 (50) := 'old_ext_custody_pf_id';
    l_new_column   VARCHAR2 (50) := 'new_ext_custody_pf_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't01_order_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cl_order_id';
    l_new_column   VARCHAR2 (50) := 'new_cl_order_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';

        EXECUTE IMMEDIATE
               'CREATE UNIQUE INDEX idx_old_order_id ON '
            || l_table
            || '(old_cl_order_id ASC)';

        EXECUTE IMMEDIATE
               'CREATE UNIQUE INDEX idx_new_order_id ON '
            || l_table
            || '(new_cl_order_id ASC)';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't01_subs_order_mappings';
    l_old_column   VARCHAR2 (50) := 'old_stock_txn_id';
    l_new_column   VARCHAR2 (50) := 'new_subs_cl_order_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';

        EXECUTE IMMEDIATE
               'CREATE UNIQUE INDEX idx_old_old_stock_txn_id ON '
            || l_table
            || '(old_stock_txn_id ASC)';

        EXECUTE IMMEDIATE
               'CREATE UNIQUE INDEX idx_new_subs_cl_order_id ON '
            || l_table
            || '(new_subs_cl_order_id ASC)';
    END IF;
END;
/

DECLARE
    l_count         NUMBER := 0;
    l_table         VARCHAR2 (50) := 't02_transaction_log_mappings';
    l_old_column1   VARCHAR2 (50) := 'old_cash_txn_log_id';
    l_old_column2   VARCHAR2 (50) := 'old_holding_txn_log_id';
    l_new_column1   VARCHAR2 (50) := 'new_cash_txn_log_id';
    l_new_column2   VARCHAR2 (50) := 'new_holding_txn_log_id';
    l_new_column3   VARCHAR2 (20) := 'new_txn_code ';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column1
            || ' NUMBER (22, 0),'
            || l_old_column2
            || ' NUMBER (22, 0),'
            || l_new_column1
            || ' NUMBER (22, 0),'
            || l_new_column2
            || ' NUMBER (22, 0),'
            || l_new_column3
            || ' VARCHAR2 (20) NOT NULL
    )';

        EXECUTE IMMEDIATE
               'ALTER TABLE '
            || l_table
            || ' ADD CONSTRAINT uk_ids
            UNIQUE (old_cash_txn_log_id, old_holding_txn_log_id, new_cash_txn_log_id, new_holding_txn_log_id, new_txn_code)
            USING INDEX';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't04_dis_exg_acc_req_mappings';
    l_old_column   VARCHAR2 (50) := 'old_dis_exg_acc_req_id';
    l_new_column   VARCHAR2 (50) := 'new_dis_exg_acc_req_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't05_inst_cash_acc_log_mappings';
    l_old_column   VARCHAR2 (50) := 'old_inst_cash_acc_log_id';
    l_new_column   VARCHAR2 (50) := 'new_inst_cash_acc_log_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't06_cash_transaction_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cash_transaction_id';
    l_new_column   VARCHAR2 (50) := 'new_cash_transaction_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't08_od_withdraw_limit_mappings';
    l_old_column   VARCHAR2 (50) := 'old_od_withdraw_limit_id';
    l_new_column   VARCHAR2 (50) := 'new_od_withdraw_limit_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't10_cash_block_req_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cash_block_req_id';
    l_new_column   VARCHAR2 (50) := 'new_cash_block_req_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't11_block_amt_details_mappings';
    l_old_column   VARCHAR2 (50) := 'old_block_amt_details_id';
    l_new_column   VARCHAR2 (50) := 'new_block_amt_details_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't12_share_transaction_mappings';
    l_old_column   VARCHAR2 (50) := 'old_share_transaction_id';
    l_new_column   VARCHAR2 (50) := 'new_share_transaction_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't20_pending_pledg_mappings';
    l_old_column   VARCHAR2 (50) := 'old_pending_pledg_id';
    l_new_column   VARCHAR2 (50) := 'new_pending_pledg_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count          NUMBER := 0;
    l_table          VARCHAR2 (50) := 't21_daily_int_charges_mappings';
    l_old_column     VARCHAR2 (50) := 'old_daily_int_charges_id';
    l_new_column     VARCHAR2 (50) := 'new_daily_int_charges_id';
    l_source_table   VARCHAR2 (50) := 'old_source_table';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_source_table
            || ' VARCHAR2 (100) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't22_order_audit_mappings';
    l_old_column   VARCHAR2 (50) := 'old_order_audit_id';
    l_new_column   VARCHAR2 (50) := 'new_order_audit_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't24_cust_margin_req_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cust_margin_req_id';
    l_new_column   VARCHAR2 (50) := 'new_cust_margin_req_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't52_desk_orders_mappings';
    l_old_column   VARCHAR2 (50) := 'old_desk_orders_id';
    l_new_column   VARCHAR2 (50) := 'new_desk_orders_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't53_order_cancel_req_mappings';
    l_old_column   VARCHAR2 (50) := 'old_order_cancel_req_id';
    l_new_column   VARCHAR2 (50) := 'new_order_cancel_req_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm165_disc_charge_grp_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cash_account_id';
    l_new_column   VARCHAR2 (50) := 'new_disc_charge_group_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        SELECT COUNT (*)
          INTO l_count
          FROM user_tables
         WHERE table_name = UPPER (l_table);

        IF (l_count = 0)
        THEN
            EXECUTE IMMEDIATE
                   'CREATE TABLE '
                || l_table
                || ' ('
                || l_old_column
                || ' NUMBER (22, 0) NOT NULL,'
                || l_new_column
                || ' NUMBER (22, 0) NOT NULL
    )';
        END IF;

        EXECUTE IMMEDIATE
               'ALTER TABLE '
            || l_table
            || ' ADD CONSTRAINT uk_disc_chrg_grp
            UNIQUE (old_cash_account_id, new_disc_charge_group_id)
            USING INDEX';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm162_incentive_group_mappings';
    l_old_column   VARCHAR2 (50) := 'old_incentive_group_id';
    l_new_column   VARCHAR2 (50) := 'new_incentive_group_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm163_incentive_slabs_mappings';
    l_old_column   VARCHAR2 (50) := 'old_incentive_slabs_id';
    l_new_column   VARCHAR2 (50) := 'new_incentive_slabs_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count          NUMBER := 0;
    l_table          VARCHAR2 (50) := 't13_notifications_mappings';
    l_old_column     VARCHAR2 (50) := 'old_notification_id';
    l_new_column     VARCHAR2 (50) := 'new_notification_id';
    l_source_table   VARCHAR2 (50) := 'old_notification_table';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_source_table
            || ' VARCHAR2 (100) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't14_notification_data_mappings';
    l_old_column   VARCHAR2 (50) := 'old_notification_data_id';
    l_new_column   VARCHAR2 (50) := 'new_notification_data_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't18_c_umessage_mappings';
    l_old_column   VARCHAR2 (50) := 'old_umessage_id';
    l_new_column   VARCHAR2 (50) := 'new_umessage_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't19_umsg_share_detail_mappings';
    l_old_column   VARCHAR2 (50) := 'old_umsg_share_detail_id';
    l_new_column   VARCHAR2 (50) := 'new_umsg_share_detail_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm161_price_user_pool_mappings';
    l_old_column   VARCHAR2 (50) := 'old_price_user_pool_id';
    l_new_column   VARCHAR2 (50) := 'new_price_user_pool_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm178_asset_mngmnt_cmp_mappings';
    l_old_column       VARCHAR2 (50) := 'old_asset_mngmnt_comp_id';
    l_new_column       VARCHAR2 (50) := 'new_asset_mngmnt_comp_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm132_mkt_maker_detail_mappings';
    l_old_column       VARCHAR2 (50) := 'old_mkt_maker_detail_id';
    l_new_column       VARCHAR2 (50) := 'new_mkt_maker_detail_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't54_slice_orders_mappings';
    l_old_column   VARCHAR2 (50) := 'old_slice_order_id';
    l_new_column   VARCHAR2 (50) := 'new_slice_order_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm152_products_mappings';
    l_old_column   VARCHAR2 (50) := 'old_product_id';
    l_new_column   VARCHAR2 (50) := 'new_product_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm152_prd_subs_many_to_one_map';
    l_old_column   VARCHAR2 (50) := 'from_subs_prd_id';
    l_new_column   VARCHAR2 (50) := 'to_subs_prd_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm153_exg_subs_prd_mappings';
    l_old_column   VARCHAR2 (50) := 'old_exg_subs_prd_id';
    l_new_column   VARCHAR2 (50) := 'new_exg_subs_prd_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm154_sub_waiveoff_grp_mappings';
    l_old_column   VARCHAR2 (50) := 'old_customer_id';
    l_new_column   VARCHAR2 (50) := 'old_product_id';
    l_group_id     VARCHAR2 (50) := 'new_waiveoff_grp_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_group_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm155_prd_waiveoff_dtl_mappings';
    l_old_column   VARCHAR2 (50) := 'old_prd_waiveoff_dtl_id';
    l_new_column   VARCHAR2 (50) := 'new_prd_waiveoff_dtl_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm156_exg_waiveoff_dtl_mappings';
    l_old_column   VARCHAR2 (50) := 'old_exg_waiveoff_dtl_id';
    l_new_column   VARCHAR2 (50) := 'new_exg_waiveoff_dtl_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't56_product_subs_data_mappings';
    l_old_column   VARCHAR2 (50) := 'old_product_subs_data_id';
    l_new_column   VARCHAR2 (50) := 'new_product_subs_data_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't57_exchange_sub_data_mappings';
    l_old_column   VARCHAR2 (50) := 'old_exchange_sub_data_id';
    l_new_column   VARCHAR2 (50) := 'new_exchange_sub_data_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't59_product_subs_log_mappings';
    l_old_column   VARCHAR2 (50) := 'old_product_subs_log_id';
    l_new_column   VARCHAR2 (50) := 'new_product_subs_log_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't60_exg_subs_log_mappings';
    l_old_column   VARCHAR2 (50) := 'old_exg_subs_log_id';
    l_new_column   VARCHAR2 (50) := 'new_exg_subs_log_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm39_price_qty_factors_mappings';
    l_old_column   VARCHAR2 (50) := 'old_price_qty_factors_id';
    l_new_column   VARCHAR2 (50) := 'new_price_qty_factors_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm176_order_limit_grp_mappings';
    l_old_column       VARCHAR2 (50) := 'old_order_limit_grp_id';
    l_new_column       VARCHAR2 (50) := 'new_order_limit_grp_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm177_csh_trns_lmt_grp_mappings';
    l_old_column       VARCHAR2 (50) := 'old_csh_trns_lmt_grp_id';
    l_new_column       VARCHAR2 (50) := 'new_csh_trns_lmt_grp_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm141_cust_corp_action_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cust_corp_action_id';
    l_new_column   VARCHAR2 (50) := 'new_cust_corp_action_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm166_cstdy_chrgs_grp_mappings';
    l_old_column       VARCHAR2 (50) := 'old_cstdy_chrgs_grp_id';
    l_new_column       VARCHAR2 (50) := 'new_cstdy_chrgs_grp_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm167_cstdy_chrgs_slab_mappings';
    l_old_column       VARCHAR2 (50) := 'old_cstdy_chrgs_slab_id';
    l_new_column       VARCHAR2 (50) := 'new_cstdy_chrgs_slab_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm170_ins_cash_acc_con_mappings';
    l_old_column   VARCHAR2 (50) := 'old_ins_cash_acc_con_id';
    l_new_column   VARCHAR2 (50) := 'new_ins_cash_acc_con_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 't500_paymnt_session_c_mappings';
    l_old_column       VARCHAR2 (50) := 'old_paymnt_session_id';
    l_new_column       VARCHAR2 (50) := 'new_paymnt_session_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't501_payment_detail_c_mappings';
    l_old_column   VARCHAR2 (50) := 'old_payment_detail_id';
    l_new_column   VARCHAR2 (50) := 'new_payment_detail_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't61_bulk_share_txn_mappings';
    l_old_column   VARCHAR2 (50) := 'old_bulk_share_txn_id';
    l_new_column   VARCHAR2 (50) := 'new_bulk_share_txn_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't38_conditional_order_mappings';
    l_old_column   VARCHAR2 (50) := 'old_conditional_order_id';
    l_new_column   VARCHAR2 (50) := 'new_conditional_order_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't27_gl_batches_mappings';
    l_old_column   VARCHAR2 (50) := 'old_gl_batches_id';
    l_new_column   VARCHAR2 (50) := 'new_gl_batches_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count         NUMBER := 0;
    l_table         VARCHAR2 (50) := 't27_gl_new_batches_mappings';
    l_old_column1   VARCHAR2 (50) := 'old_gl_table';
    l_old_column2   VARCHAR2 (50) := 'old_txn_date';
    l_old_column3   VARCHAR2 (50) := 'old_reference';
    l_new_column    VARCHAR2 (50) := 'new_reference';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        SELECT COUNT (*)
          INTO l_count
          FROM user_tables
         WHERE table_name = UPPER (l_table);

        IF (l_count = 0)
        THEN
            EXECUTE IMMEDIATE
                   'CREATE TABLE '
                || l_table
                || ' ('
                || l_old_column1
                || ' VARCHAR (100) NOT NULL,'
                || l_old_column2
                || ' DATE NOT NULL,'
                || l_old_column3
                || ' NUMBER (22, 0) NOT NULL,'
                || l_new_column
                || ' NUMBER (22, 0) NOT NULL
    )';
        END IF;
    END IF;
END;
/

DECLARE
    l_count         NUMBER := 0;
    l_table         VARCHAR2 (50) := 't28_gl_rec_wise_entry_mappings';
    l_old_column1   VARCHAR2 (50) := 'old_gl_cash_acc_no';
    l_old_column2   VARCHAR2 (50) := 'old_gl_txn_date';
    l_old_column3   VARCHAR2 (50) := 'old_gl_ref_no';
    l_old_column4   VARCHAR2 (50) := 'old_gl_sub_ref_no';
    l_old_column5   VARCHAR2 (50) := 'old_gl_amount';
    l_new_column    VARCHAR2 (50) := 'new_gl_rec_wise_entry_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        SELECT COUNT (*)
          INTO l_count
          FROM user_tables
         WHERE table_name = UPPER (l_table);

        IF (l_count = 0)
        THEN
            EXECUTE IMMEDIATE
                   'CREATE TABLE '
                || l_table
                || ' ('
                || l_old_column1
                || ' NUMBER (22, 0) NOT NULL,'
                || l_old_column2
                || ' DATE NOT NULL,'
                || l_old_column3
                || ' VARCHAR (100) NOT NULL,'
                || l_old_column4
                || ' VARCHAR (100) NOT NULL,'
                || l_old_column5
                || ' VARCHAR (100) NOT NULL,'
                || l_new_column
                || ' NUMBER (22, 0) NOT NULL
    )';
        END IF;
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't29_gl_col_wise_entry_mappings';
    l_old_column   VARCHAR2 (50) := 'old_gl_col_wise_entry_id';
    l_new_column   VARCHAR2 (50) := 'new_gl_col_wise_entry_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't41_cus_corp_act_dist_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cus_corp_act_dist_id';
    l_new_column   VARCHAR2 (50) := 'new_cus_corp_act_dist_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't42_cust_ca_hold_adj_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cust_ca_hold_adj_id';
    l_new_column   VARCHAR2 (50) := 'new_cust_ca_hold_adj_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't43_cust_ca_cash_adj_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cust_ca_cash_adj_id';
    l_new_column   VARCHAR2 (50) := 'new_cust_ca_cash_adj_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm18_derivat_sprd_mtrx_mappings';
    l_old_column   VARCHAR2 (50) := 'old_derivat_sprd_mtrx_id';
    l_new_column   VARCHAR2 (50) := 'new_derivat_sprd_mtrx_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't15_auth_request_mappings';
    l_old_column   VARCHAR2 (50) := 'old_auth_request_id';
    l_new_column   VARCHAR2 (50) := 'new_auth_request_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't502_change_acc_req_c_mappings';
    l_old_column   VARCHAR2 (50) := 'old_t502_change_acc_req_id';
    l_new_column   VARCHAR2 (50) := 'new_t502_change_acc_req_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm181_murabaha_baskets_mappings';
    l_old_column       VARCHAR2 (50) := 'old_murabaha_basket_id';
    l_new_column       VARCHAR2 (50) := 'new_murabaha_basket_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm182_mrbh_bskt_compst_mappings';
    l_old_column   VARCHAR2 (50) := 'old_mrbh_bskt_compst_id';
    l_new_column   VARCHAR2 (50) := 'new_mrbh_bskt_compst_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't70_mark_to_market_mappings';
    l_old_column   VARCHAR2 (50) := 'old_mark_to_market_id';
    l_new_column   VARCHAR2 (50) := 'new_mark_to_market_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't75_murabaha_contract_mappings';
    l_old_column   VARCHAR2 (50) := 'old_murabaha_contract_id';
    l_new_column   VARCHAR2 (50) := 'new_murabaha_contract_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count         NUMBER := 0;
    l_table         VARCHAR2 (50) := 'h13_inst_indices_hist_mappings';
    l_old_column    VARCHAR2 (50) := 'old_inst_indices_hist_id';
    l_new_column    VARCHAR2 (50) := 'new_inst_indices_hist_id';
    l_date_column   VARCHAR2 (50) := 'history_date';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_date_column
            || ' DATE NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'a06_audit_mappings';
    l_old_column   VARCHAR2 (50) := 'old_audit_id';
    l_new_column   VARCHAR2 (50) := 'new_audit_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count         NUMBER := 0;
    l_table         VARCHAR2 (50) := 'm43_institute_exg_mappings';
    l_old_column1   VARCHAR2 (50) := 'old_from_broker';
    l_old_column2   VARCHAR2 (50) := 'old_exchange_code';
    l_new_column    VARCHAR2 (50) := 'new_institute_exg_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column1
            || ' NUMBER (22, 0) NOT NULL,'
            || l_old_column2
            || ' VARCHAR2 (100) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count         NUMBER := 0;
    l_table         VARCHAR2 (50) := 'u28_emp_exchanges_mappings';
    l_old_column1   VARCHAR2 (50) := 'old_employee_id';
    l_old_column2   VARCHAR2 (50) := 'exchange_code';
    l_new_column    VARCHAR2 (50) := 'new_emp_exchanges_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column1
            || ' NUMBER (22, 0) NOT NULL,'
            || l_old_column2
            || ' VARCHAR2 (100) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count           NUMBER := 0;
    l_table           VARCHAR2 (50) := 'a10_entity_status_his_mappings';
    l_old_column      VARCHAR2 (50) := 'old_ent_status_hist_id';
    l_mapping_table   VARCHAR2 (50) := 'mapping_table';
    l_entity_key      VARCHAR2 (50) := 'entity_key';
    l_new_column      VARCHAR2 (50) := 'new_ent_status_hist_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_mapping_table
            || ' VARCHAR2 (1000) NOT NULL,'
            || l_entity_key
            || ' VARCHAR2 (100) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't67_stk_blk_rqst_mappings';
    l_old_column   VARCHAR2 (50) := 'old_stk_blk_rqst_id';
    l_new_column   VARCHAR2 (50) := 'new_stk_blk_rqst_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm89_customer_category_mappings';
    l_old_column       VARCHAR2 (50) := 'old_customer_category_id';
    l_new_column       VARCHAR2 (50) := 'new_customer_category_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm75_stk_conc_grp_mappings';
    l_old_column       VARCHAR2 (50) := 'global_concentration_pct';
    l_new_column       VARCHAR2 (50) := 'new_stk_conc_grp_id';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count            NUMBER := 0;
    l_table            VARCHAR2 (50) := 'm04_currency_rate_mappings';
    l_from_currency    VARCHAR2 (50) := 'from_currency';
    l_to_currency      VARCHAR2 (50) := 'to_currency';
    l_new_rate_id      VARCHAR2 (50) := 'new_currency_rate';
    new_institute_id   VARCHAR2 (50) := 'new_institute_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_from_currency
            || ' VARCHAR2 (10) NOT NULL,'
            || l_to_currency
            || ' VARCHAR2 (10) NOT NULL,'
            || l_new_rate_id
            || ' NUMBER (22, 0) NOT NULL,'
            || new_institute_id
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm185_cust_excb_csh_ac_mappings';
    l_old_column   VARCHAR2 (50) := 'old_cust_excb_csh_ac_id';
    l_new_column   VARCHAR2 (50) := 'new_cust_excb_csh_ac_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 'm1001_skuk_coup_pmnt_mappings';
    l_old_column   VARCHAR2 (50) := 'old_sukuk_coup_pmnt_id';
    l_new_column   VARCHAR2 (50) := 'new_sukuk_coup_pmnt_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/

DECLARE
    l_count        NUMBER := 0;
    l_table        VARCHAR2 (50) := 't90_murabaha_amortize_mappings';
    l_old_column   VARCHAR2 (50) := 'old_murabaha_amortize_id';
    l_new_column   VARCHAR2 (50) := 'new_murabaha_amortize_id';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' ('
            || l_old_column
            || ' NUMBER (22, 0) NOT NULL,'
            || l_new_column
            || ' NUMBER (22, 0) NOT NULL
    )';
    END IF;
END;
/