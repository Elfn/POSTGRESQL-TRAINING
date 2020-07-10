CREATE FUNCTION lock_user(user_id int)
RETURNS VOID AS $$
BEGIN
  UPDATE user_account  
	SET is_locked = TRUE, locked_date = NOW()  
	WHERE id = user_id; 
  IF NOT FOUND  THEN
  		RAISE EXCEPTION 'Nonexistent user ID --> %', user_id
        USING HINT = 'Please check the user ID';
  END IF;
END;
$$ LANGUAGE plpgsql;
SELECT lock_user(2);