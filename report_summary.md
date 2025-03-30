## 1. Introduction
This document provides a detailed summary of the Data Warehouse Development & Business Intelligence (DWBI) project, focusing on data warehouse design, ETL processes, SQL query development, and data visualization.

## 2. Data Warehouse Design
• The schema_creation.sql script defines the structure of the data warehouse, including fact and dimension tables.     
• The schema follows a star schema model for optimized analytical processing     

![image](https://github.com/user-attachments/assets/e80018c7-9cc5-4d15-bb9a-046b039b5550)

## 3. ETL Process      
### 3.1 Initial Data Load     
• The initial_load.sql script loads raw data into the staging tables and subsequently into fact and dimension tables.     
• Ensures data consistency and eliminates duplicates before final insertion.      

### 3.2 Subsequent Data Load
• The subsequent_load.sql script handles periodic data updates while maintaining integrity.    
• It ensures that only new or updated records are added to the warehouse.     

## 4. Slowly Changing Dimension (SCD) Type 2 Maintenance     
• The scd2_update.sql script implements SCD Type 2 to track historical changes in menu item prices.     
• This approach allows retaining past records while inserting updated versions with effective and expiration dates.      
• The process includes:      
    1. Identifying the current active record for a menu item.    
    2. Updating the expiration date of the old record.       
    3.Inserting a new record with the updated price and effective date.

## 5. SQL Query Development and Result
### 5.1 Sales Trends Analysis Appetizer Items in Q4 (2021-2023)
 Sales Trends Analysis APPETIZER Items in Q4 (2021-2023)
 Date: 12/09/2024
 Page 1
 Item Name Year Total Quantity Quantity Change Percentage Change(%)--------------------------------------------------------------------------------
CURRY PUFFS 2021 591
 2022 523-68-11.51
 2023 632 109 20.84
 ***************************-------------------
Average: 4.67
 DUMPLINGS 2021 580
 2022 610 30 5.17
 2023 631 21 3.44
 ***************************-------------------
Average: 4.31
 GARLIC BREAD 2021 625
 2022 770 145 23.20
 2023 600-170-22.08
 ***************************-------------------
Average: 0.56
 GYOZA 2021 673
 2022 660-13-1.93
 2023 698 38 5.76
 ***************************-------------------
Average: 1.92
 ONION RINGS 2021 680
 2022 647-33-4.85
 2023 719 72 11.13
 ***************************-------------------
Average: 3.14
 OTAK-OTAK 2021 603
 2022 673 70 11.61
 2023 740 67 9.96
 ***************************-------------------
Average: 10.79
 POPIAH 2021 775
 2022 649-126-16.26
 2023 678 29 4.47
 ***************************-------------------
Average:-5.90
 ROJAK 2021 742
 2022 531-211-28.44
 2023 640 109 20.53
 ***************************-------------------
Average:-3.96
 SATE AYAM 2021 693
 2022 646-47-6.78
 2023 666 20 3.10
 ***************************-------------------
Average:-1.84
 SPRING ROLLS 2021 752
 2022 793 41 5.45
 17
BAIT3003DataWarehouseTechnology
 2023 844 51 6.43
 ***************************-------------------
Average: 5.94
 TAKOYAKI 2021 592
 2022 708 116 19.59
 2023 687-21-2.97
 ***************************-------------------
Average: 8.31
 TEMPURA 2021 626
 2022 646 20 3.19
 2023 661 15 2.32
 ***************************-------------------
Average: 2.76
 WANTON 2021 606
 2022 621 15 2.48
 2023 669 48 7.73
 ***************************-------------------
Average: 5.11
### 5.2 2023-2024 Average Monthly Quantity and Order Changes for Appetizer Items


### 5.3 Lowest 15% Order Share States by Time Period in 2024



## 6. Conclusion    
This report documents the SQL scripts and ETL workflows developed for the DWBI project. The implemented schema design, data loading strategies, and SCD Type 2 updates ensure efficient data processing and historical tracking. The SQL queries provide key business insights, supporting informed decision-making.
