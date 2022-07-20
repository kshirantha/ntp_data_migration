CREATE OR REPLACE TYPE dfn_ntp.t_string_agg
    AS OBJECT
(
    g_string VARCHAR2 (32767),
    STATIC FUNCTION odciaggregateinitialize (sctx IN OUT t_string_agg)
        RETURN NUMBER,
    MEMBER FUNCTION odciaggregateiterate (self    IN OUT t_string_agg,
                                          VALUE   IN     VARCHAR2)
        RETURN NUMBER,
    MEMBER FUNCTION odciaggregateterminate (self          IN     t_string_agg,
                                            returnvalue      OUT VARCHAR2,
                                            flags         IN     NUMBER)
        RETURN NUMBER,
    MEMBER FUNCTION odciaggregatemerge (self   IN OUT t_string_agg,
                                        ctx2   IN     t_string_agg)
        RETURN NUMBER
)
/

CREATE OR REPLACE TYPE BODY dfn_ntp.t_string_agg
IS
    STATIC FUNCTION odciaggregateinitialize (sctx IN OUT t_string_agg)
        RETURN NUMBER
    IS
    BEGIN
        sctx := t_string_agg (NULL);
        RETURN odciconst.success;
    END;

    MEMBER FUNCTION odciaggregateiterate (self    IN OUT t_string_agg,
                                          VALUE   IN     VARCHAR2)
        RETURN NUMBER
    IS
    BEGIN
        self.g_string := self.g_string || ',' || VALUE;
        RETURN odciconst.success;
    END;

    MEMBER FUNCTION odciaggregateterminate (self          IN     t_string_agg,
                                            returnvalue      OUT VARCHAR2,
                                            flags         IN     NUMBER)
        RETURN NUMBER
    IS
    BEGIN
        returnvalue := RTRIM (LTRIM (self.g_string, ','), ',');
        RETURN odciconst.success;
    END;

    MEMBER FUNCTION odciaggregatemerge (self   IN OUT t_string_agg,
                                        ctx2   IN     t_string_agg)
        RETURN NUMBER
    IS
    BEGIN
        self.g_string := self.g_string || ',' || ctx2.g_string;
        RETURN odciconst.success;
    END;
END;
/
