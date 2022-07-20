CREATE OR REPLACE PACKAGE dfn_csm.pkg_dc_t03_audit
IS
    PROCEDURE t03_add (pt03_user_id         NUMBER,
                       pt03_activity_id     NUMBER,
                       pt03_description     VARCHAR2,
                       pt03_reference_no    VARCHAR2 DEFAULT NULL);
END;
/


CREATE OR REPLACE PACKAGE BODY dfn_csm.pkg_dc_t03_audit
IS
    PROCEDURE t03_add (pt03_user_id         NUMBER,
                       pt03_activity_id     NUMBER,
                       pt03_description     VARCHAR2,
                       pt03_reference_no    VARCHAR2 DEFAULT NULL)
    IS
    BEGIN
        IF (pt03_activity_id IS NOT NULL)
        THEN
            INSERT INTO t03_audit (t03_user_id,
                                   t03_activity_id,
                                   t03_description,
                                   t03_reference_no)
                 VALUES (pt03_user_id,
                         pt03_activity_id,
                         pt03_description,
                         pt03_reference_no);
        END IF;
    END;
END;
/