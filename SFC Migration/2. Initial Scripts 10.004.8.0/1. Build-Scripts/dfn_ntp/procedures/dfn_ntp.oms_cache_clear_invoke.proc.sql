CREATE OR REPLACE PROCEDURE dfn_ntp.oms_cache_clear_invoke (a   IN VARCHAR2,
                                                            b   IN NUMBER)
IS
    req       UTL_HTTP.req;
    res       UTL_HTTP.resp;
    url       VARCHAR2 (4000)
                  := 'http://192.168.0.50/OMSRestConnect/CacheMonitor/#/login';
    name      VARCHAR2 (4000);
    buffer    VARCHAR2 (4000);
    content   VARCHAR2 (4000)
        := '{"HED":{"tenantCode":"DEFAULT_TENANT","channel":-1,"commVer":null,"msgTyp":0,"sesnId":null,"loginId":0,"clientIp":null,"unqReqId":null},"DAT":{"tableID":null,"storeKeysAsJson":null,"clearAll":true,"jsonKeyValMap":null,"cache_clear_schedule_types":null}}';
BEGIN
    req := UTL_HTTP.begin_request (url, 'POST', ' HTTP/1.1');
    UTL_HTTP.set_header (req, 'user-agent', 'mozilla/4.0');
    UTL_HTTP.set_header (req, 'content-type', 'application/json');
    UTL_HTTP.set_header (req, 'Content-Length', LENGTH (content));

    UTL_HTTP.write_text (req, content);
    res := UTL_HTTP.get_response (req);

    -- process the response from the HTTP call
    BEGIN
        LOOP
            UTL_HTTP.read_line (res, buffer);
            DBMS_OUTPUT.put_line (buffer);
        END LOOP;

        UTL_HTTP.end_response (res);
    EXCEPTION
        WHEN OTHERS
        THEN
            DBMS_OUTPUT.put_line ('error');
    END;
END oms_cache_clear_invoke;
/