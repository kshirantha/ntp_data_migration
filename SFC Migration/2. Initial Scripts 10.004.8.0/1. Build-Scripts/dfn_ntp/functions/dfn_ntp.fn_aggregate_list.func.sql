CREATE OR REPLACE FUNCTION dfn_ntp.fn_aggregate_list (p_input VARCHAR2)
    RETURN VARCHAR2
    PARALLEL_ENABLE
    AGGREGATE USING t_string_agg;
/
