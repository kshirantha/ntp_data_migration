-- Table DFN_NTP.M109_CUSTOMER_FAMILY_MEMBERS

CREATE TABLE dfn_ntp.m109_customer_family_members
(
    m109_id                         NUMBER (18, 0),
    m109_customer_id_u01            NUMBER (18, 0),
    m109_family_member_id_u01       NUMBER (18, 0),
    m109_created_by_id_u17          NUMBER (20, 0),
    m109_created_date               DATE,
    m109_modified_by_id_u17         NUMBER (20, 0),
    m109_modified_date              DATE,
    m109_status_id_v01              NUMBER (2, 0),
    m109_status_changed_by_id_u17   NUMBER (20, 0),
    m109_status_changed_date        DATE
)
/

-- Constraints for  DFN_NTP.M109_CUSTOMER_FAMILY_MEMBERS


  ALTER TABLE dfn_ntp.m109_customer_family_members ADD CONSTRAINT m109_pk PRIMARY KEY (m109_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m109_customer_family_members ADD CONSTRAINT m109_uk UNIQUE (m109_customer_id_u01, m109_family_member_id_u01)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m109_customer_family_members MODIFY (m109_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m109_customer_family_members MODIFY (m109_customer_id_u01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m109_customer_family_members MODIFY (m109_family_member_id_u01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m109_customer_family_members MODIFY (m109_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m109_customer_family_members MODIFY (m109_created_date NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M109_CUSTOMER_FAMILY_MEMBERS

COMMENT ON COLUMN dfn_ntp.m109_customer_family_members.m109_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.m109_customer_family_members.m109_customer_id_u01 IS
    'fk from u01'
/
COMMENT ON COLUMN dfn_ntp.m109_customer_family_members.m109_family_member_id_u01 IS
    'fk from u01'
/
COMMENT ON TABLE dfn_ntp.m109_customer_family_members IS
    'this table keeps the family members for a particualr customer. this is only for filtering purposes'
/
-- End of DDL Script for Table DFN_NTP.M109_CUSTOMER_FAMILY_MEMBERS

alter table dfn_ntp.M109_CUSTOMER_FAMILY_MEMBERS
	add M109_CUSTOM_TYPE varchar2(50) default 1
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.M109_CUSTOMER_FAMILY_MEMBERS  ADD (  M109_INSTITUTE_ID_M02 NUMBER (5, 0) NOT NULL )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('M109_CUSTOMER_FAMILY_MEMBERS')
           AND column_name = UPPER ('M109_INSTITUTE_ID_M02');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/