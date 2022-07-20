CREATE OR REPLACE PROCEDURE dfn_ntp.sp_gl_prepare_column_value (
    pname_column         IN     VARCHAR2,
    pdata_type           IN     VARCHAR2,
    pnullable            IN     VARCHAR2,
    pvalue_column        IN     VARCHAR2,
    psrc_name_columns    IN     VARCHAR2,
    psrc_value_columns   IN     VARCHAR2,
    pname_columns           OUT VARCHAR2,
    pvalue_columns          OUT VARCHAR2)
IS
    l_value_column   VARCHAR2 (100);
BEGIN
    IF pdata_type IN ('NUMBER', 'LONG', 'FLOAT', 'INTEGER')
    THEN
        l_value_column :=
            CASE
                WHEN pnullable = 'Y'
                THEN
                    CASE
                        WHEN pvalue_column IS NULL THEN ''' || ''NULL'' ||'''
                        ELSE ''' || NVL(' || pvalue_column || ', 0) || '''
                    END
                ELSE
                    ''' || ' || pvalue_column || ' ||'''
            END;
    ELSE
        l_value_column :=
               ''''''' || REPLACE('
            || pvalue_column
            || ', '''''''', '''''''''''') || ''''''';
    END IF;

    IF psrc_value_columns IS NULL
    THEN
        pvalue_columns := l_value_column;
        pname_columns := pname_column;
    ELSE
        pvalue_columns := psrc_value_columns || ', ' || l_value_column;
        pname_columns := psrc_name_columns || ', ' || pname_column;
    END IF;
END;
/