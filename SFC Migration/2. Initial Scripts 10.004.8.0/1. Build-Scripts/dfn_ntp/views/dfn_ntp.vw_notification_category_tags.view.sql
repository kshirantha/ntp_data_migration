CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_notification_category_tags
(
    m147_id,
    m147_event_cat_id_m145,
    m147_tag_id_m146,
    m146_tag,
    m146_description,
    m146_description_lang
)
AS
    SELECT m147.m147_id,
           m147.m147_event_cat_id_m145,
           m147.m147_tag_id_m146,
           m146.m146_tag,
           m146.m146_description,
           m146.m146_description_lang
      FROM m147_notify_event_cat_tag_map m147
           LEFT JOIN m146_notify_tag_master m146
               ON m147.m147_tag_id_m146 = m146.m146_id
/