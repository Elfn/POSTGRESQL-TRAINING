CREATE FUNCTION get_topics ()
RETURNS TABLE (
  topic_id int,
  topic_name varchar,
  created_year int
) AS $$
DECLARE
  curr_rec record;
BEGIN
  FOR curr_rec IN (SELECT DISTINCT id, LOWER(REPLACE(name, ' ', '_')) AS name, created_date FROM topic) LOOP
    
    topic_id := curr_rec.id;
    topic_name := curr_rec.name;
    created_year := extract( year FROM curr_rec.created_date )::int;
    
    RETURN NEXT;
  END LOOP;
END;
$$ LANGUAGE plpgsql;
SELECT get_topics();