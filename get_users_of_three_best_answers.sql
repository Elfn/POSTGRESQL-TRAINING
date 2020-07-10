CREATE FUNCTION get_users_of_three_best_answers()
RETURNS TABLE (
user_id int,
user_name varchar,
count_of_answers bigint
) AS $$
BEGIN
RETURN QUERY
SELECT post.user_id,user_account.name,COUNT(post.user_id)
FROM post  JOIN user_account
ON user_account.id = post.user_id
WHERE post.is_best_answer = TRUE
GROUP BY post.user_id, user_account.name
ORDER BY COUNT(post.user_id) DESC, post.user_id ASC
LIMIT 3;

END;
$$ LANGUAGE plpgsql;
SELECT get_users_of_three_best_answers();

