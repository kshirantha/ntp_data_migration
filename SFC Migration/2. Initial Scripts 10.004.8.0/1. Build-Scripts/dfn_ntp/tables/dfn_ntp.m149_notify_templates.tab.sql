CREATE TABLE dfn_ntp.m149_notify_templates
(
    m149_id                    NUMBER (10, 0) NOT NULL,
    m149_event_id_m148         NUMBER (5, 0) NOT NULL,
    m149_sms_template          VARCHAR2 (2000 BYTE),
    m149_sms_template_lang     VARCHAR2 (2000 BYTE),
    m149_email_subject         VARCHAR2 (500 BYTE),
    m149_email_subject_lang    VARCHAR2 (500 BYTE),
    m149_email_template        CLOB,
    m149_email_template_lang   CLOB,
    m149_institute_id_m02      NUMBER (5, 0)
)
SEGMENT CREATION IMMEDIATE
LOB ("M149_EMAIL_TEMPLATE") STORE AS lob_m149_email_tmplte
    (NOCACHE LOGGING CHUNK 8192)
LOB ("M149_EMAIL_TEMPLATE_LANG") STORE AS lob_m149_email_tmplte_lang
    (NOCACHE LOGGING CHUNK 8192)
/


ALTER TABLE dfn_ntp.m149_notify_templates
ADD CONSTRAINT pk_m149 PRIMARY KEY (m149_id)
USING INDEX
/

alter table dfn_ntp.M149_NOTIFY_TEMPLATES
	add M149_CUSTOM_TYPE varchar2(50) default 1
/