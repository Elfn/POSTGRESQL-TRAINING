ALTER FUNCTION get_pi()
RENAME TO get_truncated_pi;

SELECT get_truncated_pi();
