CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_notification_tags
(
   m146_id,
   m146_tag,
   m146_description,
   m146_description_lang
)
AS
   SELECT m146_id,
          m146_tag,
          m146_description,
          m146_description_lang
     FROM m146_notify_tag_master
/