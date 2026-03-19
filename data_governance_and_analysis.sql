/* PROJECT: Marketing ROI & Sales Performance Intelligence Dashboard
PURPOSE: Data Integrity, Schema Validation & ROI Analysis
AUTHOR: Saravanakumar
*/

-- STEP 1: Identifying Primary Key Constraints
-- Checking for unique identifiers to ensure data integrity and prevent duplicates.
SELECT 
    column_name 
FROM 
    `saran-marketing-analytics`.`MMM_RAW_ZONE`.INFORMATION_SCHEMA.TABLE_CONSTRAINTS as T1 
INNER JOIN 
    `saran-marketing-analytics`.`MMM_RAW_ZONE`.INFORMATION_SCHEMA.KEY_COLUMN_USAGE as T2 
    ON (T1.constraint_name = T2.constraint_name) 
WHERE 
    T1.table_name = 'MARKETING_METRICS_RAW' 
    AND T1.constraint_type = 'PRIMARY KEY' 
ORDER BY 
    t2.ordinal_position;

-- STEP 2: Metadata & Schema Check
-- Verifying data types to ensure they are compatible with Power BI.
SELECT 
    column_name, 
    data_type, 
    is_nullable 
FROM 
    `saran-marketing-analytics`.`MMM_RAW_ZONE`.INFORMATION_SCHEMA.COLUMNS 
WHERE 
    table_name = 'MARKETING_METRICS_RAW';

-- STEP 3: Business Logic - ROI Calculation
-- Calculating the core marketing metric: ROAS (Return on Ad Spend).
SELECT 
    Product, 
    Region, 
    SUM(Sales) as Total_Revenue,
    SUM(Google_Ads_Spend + Meta_Ads_Spend + TV_Spend) as Total_Marketing_Investment,
    ROUND(SUM(Sales) / NULLIF(SUM(Google_Ads_Spend + Meta_Ads_Spend + TV_Spend), 0), 2) as ROAS
FROM 
    `saran-marketing-analytics`.`MMM_RAW_ZONE`.MARKETING_METRICS_RAW
GROUP BY 1, 2
ORDER BY ROAS DESC;

-- STEP 4: Data Extraction for Visualization
-- Selecting core marketing metrics for dashboarding in Power BI.
SELECT 
    `Date`,
    `Product`,
    `Region`,
    `Google_Ads_Spend`,
    `Meta_Ads_Spend`,
    `TV_Spend`,
    `Sales`
FROM 
    `saran-marketing-analytics`.`MMM_RAW_ZONE`.`MARKETING_METRICS_RAW`;