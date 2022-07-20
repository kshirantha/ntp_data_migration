-- Table DFN_NTP.M111_MESSAGES

CREATE TABLE dfn_ntp.m111_messages
(
    m111_message_id   NUMBER (5, 0),
    m111_en           VARCHAR2 (4000),
    m111_ar           VARCHAR2 (4000),
    m111_msg_type     NUMBER (5, 0) DEFAULT 1,
    m111_id           NUMBER (5, 0)
)
/

-- Constraints for  DFN_NTP.M111_MESSAGES


  ALTER TABLE dfn_ntp.m111_messages ADD CONSTRAINT m111_pk PRIMARY KEY (m111_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m111_messages MODIFY (m111_message_id NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M111_MESSAGES

COMMENT ON COLUMN dfn_ntp.m111_messages.m111_msg_type IS
    '1:default 2:exchange message'
/
-- End of DDL Script for Table DFN_NTP.M111_MESSAGES

ALTER TABLE dfn_ntp.m111_messages
 ADD (
  m111_institute_id_m02 NUMBER (3)
 )
/

ALTER TABLE dfn_ntp.m111_messages
    DROP COLUMN m111_institute_id_m02
/

ALTER TABLE dfn_ntp.m111_messages
RENAME COLUMN m111_en TO m111_message
/
ALTER TABLE dfn_ntp.m111_messages
RENAME COLUMN m111_ar TO m111_message_lang
/

ALTER TABLE dfn_ntp.m111_messages
  ADD(
  m111_test VARCHAR2(10)
  )
/

UPDATE dfn_ntp.m111_messages
   SET m111_test = to_char(m111_message_id);

DECLARE
    l_nullable   CHAR;
    l_ddl        VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m111_messages    MODIFY m111_message_id NULL';
BEGIN
    SELECT nullable
      INTO l_nullable
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m111_messages')
           AND column_name = UPPER ('m111_message_id');

    IF l_nullable = 'N'
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


UPDATE dfn_ntp.m111_messages 
	SET m111_message_id = NULL;

COMMIT;

ALTER TABLE dfn_ntp.m111_messages
	MODIFY m111_message_id VARCHAR2(10)
/


UPDATE dfn_ntp.m111_messages
   SET  m111_message_id = m111_test;

COMMIT;

ALTER TABLE dfn_ntp.m111_messages
 	DROP COLUMN m111_test
/

DECLARE 
	l_count NUMBER := 0; 
	l_ddl VARCHAR2 (1000) 
		:= 'ALTER TABLE dfn_ntp.m111_messages DROP CONSTRAINT M111_PK'; 
BEGIN 
	SELECT COUNT (*) 
		INTO l_count 
		FROM all_constraints 
		WHERE owner = UPPER ('dfn_ntp') 
			AND table_name = UPPER ('m111_messages') 
			AND constraint_name = UPPER ('M111_PK'); 

	IF l_count = 1 
	THEN 
		EXECUTE IMMEDIATE l_ddl; 
	END IF; 
END; 
/

DECLARE 
	l_count NUMBER := 0; 
	l_ddl VARCHAR2 (1000) 
		:= 'ALTER TABLE dfn_ntp.m111_messages DROP COLUMN m111_id'; 

BEGIN 
	SELECT COUNT (*) 
		INTO l_count 
		FROM all_tab_columns 
		WHERE owner = UPPER ('dfn_ntp') 
			AND table_name = UPPER ('m111_messages') 
			AND column_name = UPPER ('m111_id'); 

	IF l_count = 1 
	THEN 
		EXECUTE IMMEDIATE l_ddl; 
	END IF; 
END; 
/

DECLARE 
	l_count NUMBER := 0; 
	l_ddl VARCHAR2 (1000) 
		:= 'ALTER TABLE dfn_ntp.m111_messages ADD CONSTRAINT PK_M111 PRIMARY KEY (m111_message_id) ENABLE VALIDATE'; 

BEGIN 
	SELECT COUNT (*) 
		INTO l_count 
		FROM all_constraints 
		WHERE owner = UPPER ('dfn_ntp') 
			AND table_name = UPPER ('m111_messages') 
			AND constraint_name = UPPER ('PK_M111'); 

	IF l_count = 0 
	THEN 
		EXECUTE IMMEDIATE l_ddl; 
	END IF; 
END; 
/
