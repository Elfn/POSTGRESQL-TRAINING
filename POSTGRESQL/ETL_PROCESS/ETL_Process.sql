CREATE OR REPLACE FUNCTION load_customers()
RETURNS void AS $$
DECLARE

    insert_cpt int := 0;
    update_cpt int := 0;

BEGIN
		--1 Logs a new message
		PERFORM log_message('load_customers()','ETL process Load Customers Started','info');
        
        --2
         UPDATE dim_customer
         SET 
             title = INITCAP(src.title),
             first_name = INITCAP(src.first_name),
             last_name = INITCAP(src.last_name),
             dob = src.dob,
             marital_status = src.marital_status,
             gender = src.gender,
             annual_salary = src.annual_salary,
             geography_id = src.geography_id,
             date_of_first_purchase = src.date_of_first_purchase,
             email_address = src.email_address
         FROM
          stg_customer AS src
         WHERE
              src.id = dim_customer.id
         AND
         	  src.id IS NOT NULL;
        GET DIAGNOSTICS update_cpt = ROW_COUNT;
        
        --3 Logs a new message 
        PERFORM log_message('load_customers()', CONCAT('Updated Customers: ', update_cpt), 'info');
        
		--4
         --Insert
        INSERT INTO dim_customer(title, first_name, last_name, dob, marital_status, gender, annual_salary, geography_id, date_of_first_purchase, email_address) 
        SELECT 
           INITCAP(src.title),
           INITCAP(src.first_name),
           INITCAP(src.last_name),
           src.dob,
           src.marital_status,
           src.gender,
           src.annual_salary,
           src.geography_id,
           src.date_of_first_purchase,
           src.email_address
        FROM stg_customer AS src
        WHERE src.id IS NULL;
        
        GET DIAGNOSTICS insert_cpt = ROW_COUNT;
        
        --5 Logs a new message 
        PERFORM log_message('load_customers()', CONCAT('Inserted Customers: ', insert_cpt), 'info');
        --6 Removes all rows 
        TRUNCATE TABLE stg_customer;
        
        --7 Logs a new message
        PERFORM log_message('load_customers()','ETL process Load Customers Finished','info');
        
END;
$$ LANGUAGE plpgsql;
SELECT load_customers();
