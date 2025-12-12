
-- Kai norim gauti varda is didziosios raides 

SELECT
	CONCAT(UPPER(Left(first_name, 1)) , LOWER(SUBSTR(first_name, 2,50))) AS Name
FROM
customer;

-- Kai reikia kiek praejo laiko (metu, menesiu dienu valandu....)

SELECT 
	NOW() 																				AS CurrentTimeStamp,
    create_date 																		AS CustomerFirstSignDate,
    TIMESTAMPDIFF(YEAR, create_date, NOW()) 			AS Customer_tenure_year,
    TIMESTAMPDIFF(QUARTER, create_date, NOW()) 	AS Customer_tenure_quater,
    TIMESTAMPDIFF(MONTH, create_date, NOW()) 		AS Customer_tenure_month,
    TIMESTAMPDIFF(DAY, create_date, NOW()) 			AS Customer_tenure_days,
	TIMESTAMPDIFF(HOUR, create_date, NOW()) 			AS Customer_tenure_hours,
    TIMESTAMPDIFF(MINUTE, create_date, NOW()) 		AS Customer_tenure_minutes,
    TIMESTAMPDIFF(SECOND, create_date, NOW()) 	AS Customer_tenure_seconds
FROM
    customer;
    
    



