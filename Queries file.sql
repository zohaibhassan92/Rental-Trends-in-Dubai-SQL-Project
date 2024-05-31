/*Project Title: Understanding Rental Trends in Dubai: A Data Analysis Approach*/

-- Create Table
CREATE TABLE dubai_properties (
    Address VARCHAR(255),
    Rent DECIMAL(10, 2),
    Beds INT,
    Baths INT,
    Type VARCHAR(50),
    Area_in_sqft INT,
    Rent_per_sqft DECIMAL(10, 2),
    Rent_category VARCHAR(50),
    Frequency VARCHAR(50),
    Furnishing VARCHAR(50),
    Purpose VARCHAR(50),
    Posted_date DATE,
    Age_of_listing_in_days INT
);

-- Import Data from CSV
COPY dubai_properties(Address, Rent, Beds, Baths, Type, Area_in_sqft, Rent_per_sqft, Rent_category, Frequency, Furnishing, Purpose, Posted_date, Age_of_listing_in_days)
FROM 'D:/data/dubai_properties.csv'
DELIMITER ','
CSV HEADER;

-- Remove Rows with Blank Data
DELETE FROM dubai_properties
WHERE 
    Address IS NULL OR Address = '' OR
    Rent IS NULL OR Rent = 0 OR
    Beds IS NULL OR Beds = 0 OR
    Baths IS NULL OR Baths = 0 OR
    Type IS NULL OR Type = '' OR
    Area_in_sqft IS NULL OR Area_in_sqft = 0 OR
    Rent_per_sqft IS NULL OR Rent_per_sqft = 0 OR
    Rent_category IS NULL OR Rent_category = '' OR
    Frequency IS NULL OR Frequency = '' OR
    Furnishing IS NULL OR Furnishing = '' OR
    Purpose IS NULL OR Purpose = '' OR
    Posted_date IS NULL OR
    Age_of_listing_in_days IS NULL OR Age_of_listing_in_days = 0;

-- Add Columns for Location and City
ALTER TABLE dubai_properties
ADD COLUMN Location VARCHAR(100),
ADD COLUMN City VARCHAR(100);

-- Update Columns with Extracted Location and City
UPDATE dubai_properties
SET 
    City = TRIM(split_part(Address, ',', array_length(string_to_array(Address, ','), 1))),
    Location = TRIM(split_part(Address, ',', array_length(string_to_array(Address, ','), 1) - 1));

-- 1. Basic Descriptive Statistics
SELECT 
    COUNT(*) AS total_properties,
    AVG(Rent) AS average_rent,
    MIN(Rent) AS minimum_rent,
    MAX(Rent) AS maximum_rent,
    AVG(Area_in_sqft) AS average_area,
    AVG(Beds) AS average_beds,
    AVG(Baths) AS average_baths
FROM 
    dubai_properties;

-- 2. Distribution of Property Types and Average Rents
SELECT 
    Type,
    COUNT(*) AS count,
    AVG(Rent) AS average_rent
FROM 
    dubai_properties
GROUP BY 
    Type
ORDER BY 
    count DESC;

-- 3. Average Rent per Sqft by Location
SELECT 
    Location,
    AVG(Rent_per_sqft) AS average_rent_per_sqft
FROM 
    dubai_properties
GROUP BY 
    Location
ORDER BY 
    average_rent_per_sqft DESC;

-- 4. Listings Over Time
SELECT 
    DATE_TRUNC('month', Posted_date) AS month,
    COUNT(*) AS total_listings
FROM 
    dubai_properties
GROUP BY 
    month
ORDER BY 
    month;

-- 5. Average Age of Listings by Location and City
-- Average age of listings by location
SELECT 
    Location,
    AVG(Age_of_listing_in_days) AS average_age
FROM 
    dubai_properties
GROUP BY 
    Location
ORDER BY 
    average_age DESC;

-- Average age of listings by city
SELECT 
    City,
    AVG(Age_of_listing_in_days) AS average_age
FROM 
    dubai_properties
GROUP BY 
    City
ORDER BY 
    average_age DESC;

-- 6. Furnishing and Purpose Analysis
-- Comparison of furnished vs. unfurnished properties
SELECT 
    Furnishing,
    COUNT(*) AS count,
    AVG(Rent) AS average_rent,
    AVG(Area_in_sqft) AS average_area
FROM 
    dubai_properties
GROUP BY 
    Furnishing
ORDER BY 
    count DESC;

-- Analysis by purpose
SELECT 
    Purpose,
    COUNT(*) AS count,
    AVG(Rent) AS average_rent,
    AVG(Area_in_sqft) AS average_area
FROM 
    dubai_properties
GROUP BY 
    Purpose
ORDER BY 
    count DESC;

-- 7. Additional Analyses
-- Top 10 Locations by Total Listings
SELECT 
    Location,
    COUNT(*) AS total_listings
FROM 
    dubai_properties
GROUP BY 
    Location
ORDER BY 
    total_listings DESC
LIMIT 10;

-- Rent Distribution by Bed and Bath Count
SELECT 
    Beds,
    Baths,
    AVG(Rent) AS average_rent,
    COUNT(*) AS total_listings
FROM 
    dubai_properties
GROUP BY 
    Beds, Baths
ORDER BY 
    Beds, Baths;

-- Properties Listed in the Last 30 Days
SELECT 
    Address,
    Rent,
    Beds,
    Baths,
    Type,
    Area_in_sqft,
    Rent_per_sqft,
    Rent_category,
    Frequency,
    Furnishing,
    Purpose,
    Posted_date,
    Age_of_listing_in_days
FROM 
    dubai_properties
WHERE 
    Posted_date >= NOW() - INTERVAL '30 days'
ORDER BY 
    Posted_date DESC;
