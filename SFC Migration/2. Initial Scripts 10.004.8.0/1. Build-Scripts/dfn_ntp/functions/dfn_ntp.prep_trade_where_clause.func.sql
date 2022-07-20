CREATE OR REPLACE FUNCTION dfn_ntp.prep_trade_where_clause(p_column_name VARCHAR2,
                                                           p_operator    NUMBER,
                                                           p_from_value  VARCHAR2,
                                                           p_to_value    VARCHAR2)
  RETURN VARCHAR2 AS
  l_clause_string VARCHAR2(4000);
BEGIN
  --Equal
  IF p_operator = 1 THEN
    l_clause_string := ' ' || p_column_name || ' = ' || p_from_value;
  END IF;

  --Greater or Equal
  IF p_operator = 2 THEN
    l_clause_string := ' ' || p_column_name || ' >= ' || p_from_value;
  END IF;

  --Less or Equal
  IF p_operator = 3 THEN
    l_clause_string := ' ' || p_column_name || ' <= ' || p_from_value;
  END IF;

  --Between
  IF p_operator = 4 THEN
    l_clause_string := ' (' || p_column_name || ' BETWEEN ' ||
                       p_from_value || ' AND ' || p_to_value || ')';
  END IF;

  --Not Equal
  IF p_operator = 5 THEN
    l_clause_string := ' ' || p_column_name || ' <> ' || p_from_value;
  END IF;

  --Greater
  IF p_operator = 6 THEN
    l_clause_string := ' ' || p_column_name || ' > ' || p_from_value;
  END IF;

  --Less
  IF p_operator = 7 THEN
    l_clause_string := ' ' || p_column_name || ' < ' || p_from_value;
  END IF;

  RETURN l_clause_string;
END;
/
/
