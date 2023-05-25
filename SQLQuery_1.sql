--Check for duplicates--
SELECT Customer_ID, COUNT(Customer_ID) as COUNT
FROM telecom_customer_churn
GROUP BY Customer_ID
HAVING COUNT(Customer_ID) >1;

--Find total number of customers--
SELECT
COUNT(DISTINCT Customer_ID) AS customer_count
FROM telecom_customer_churn

--How musch revenue lose to churned customer?--
SELECT Customer_Status, 
COUNT(Customer_ID) AS customer_count,
ROUND((SUM(Total_Revenue) * 100.0) / SUM(SUM(Total_Revenue)) OVER(), 1) AS Revenue_Percentage 
FROM telecom_customer_churn
GROUP BY Customer_Status;

-- Typical tenure for churners (How long customer stay brfore leaving)
SELECT
    CASE 
        WHEN Tenure_in_Months <= 6 THEN '6 months'
        WHEN Tenure_in_Months <= 12 THEN '1 Year'
        WHEN Tenure_in_Months <= 24 THEN '2 Years'
        ELSE '> 2 Years'
    END AS Tenure,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(),1) AS Churn_Percentage
FROM
telecom_customer_churn
WHERE
Customer_Status = 'Churned'
GROUP BY
    CASE 
        WHEN Tenure_in_Months <= 6 THEN '6 months'
        WHEN Tenure_in_Months <= 12 THEN '1 Year'
        WHEN Tenure_in_Months <= 24 THEN '2 Years'
        ELSE '> 2 Years'
    END
ORDER BY
Churn_Percentage DESC;

-- Why did customers leave?
SELECT 
  Churn_Category,  
  ROUND(SUM(Total_Revenue),0)AS Churned_Rev,
  CEILING((COUNT(Customer_ID) * 100.0) / SUM(COUNT(Customer_ID)) OVER()) AS Churn_Percentage
FROM 
  telecom_customer_churn
WHERE 
    Customer_Status = 'Churned'
GROUP BY 
  Churn_Category
ORDER BY 
  Churn_Percentage DESC; 

  -- why exactly did customers churn?
SELECT TOP 5
    Churn_Reason,
    Churn_Category,
    ROUND(COUNT(Customer_ID) *100 / SUM(COUNT(Customer_ID)) OVER(), 1) AS churn_percentage
FROM
    telecom_customer_churn
WHERE
    Customer_Status = 'Churned'
GROUP BY 
Churn_Reason,
Churn_Category
ORDER BY churn_percentage DESC;

-- What offers did churners have?
SELECT  
    Offer,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS churned
FROM
    telecom_customer_churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
Offer
ORDER BY 
churned DESC;

-- What Internet Type did churners have?
SELECT
    Internet_Type,
    COUNT(Customer_ID) AS Churned,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM
    telecom_customer_churn
WHERE 
    Customer_Status = 'Churned'
GROUP BY
Internet_Type
ORDER BY 
Churned DESC;

-- What Internet Type did 'Competitor' churners have?
SELECT
    Internet_Type,
    Churn_Category,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM
    telecom_customer_churn
WHERE 
    Customer_Status = 'Churned'
    AND Churn_Category = 'Competitor'
GROUP BY
Internet_Type,
Churn_Category
ORDER BY Churn_Percentage DESC;

-- Did churners have premium tech support?
SELECT 
    Premium_Tech_Support,
    COUNT(Customer_ID) AS Churned,
    ROUND(COUNT(Customer_ID) *100.0 / SUM(COUNT(Customer_ID)) OVER(),1) AS Churn_Percentage
FROM
    telecom_customer_churn
WHERE 
    Customer_Status = 'Churned'
GROUP BY Premium_Tech_Support
ORDER BY Churned DESC;

-- What contract were churners on?
SELECT 
    Contract,
    COUNT(Customer_ID) AS Churned,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM 
    telecom_customer_churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
    Contract
ORDER BY 
    Churned DESC;

--what offer stayed customer have?--
SELECT  
    Offer,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS stayed
FROM
    telecom_customer_churn
WHERE
    Customer_Status = 'Stayed'
GROUP BY
Offer
ORDER BY 
stayed DESC

--internet stayed customers have--
SELECT
    Internet_Type,
    COUNT(Customer_ID) AS Stayed,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Stay_Percentage
FROM
    telecom_customer_churn
WHERE 
    Customer_Status = 'Stayed'
GROUP BY
Internet_Type
ORDER BY 
Stayed DESC