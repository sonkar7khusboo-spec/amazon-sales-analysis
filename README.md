📊 **Project Title**

Amazon Sales Data Analysis using SQL & Power BI
________________________________________
🧾 **Brief One Line Summary**

An end-to-end Amazon sales analytics project involving **data cleaning, star schema modelling, KPI analysis, and an interactive Power BI dashboard** to drive business insights.
________________________________________
🔍 **Overview**

This project focuses on analysing Amazon sales transaction data to understand **revenue trends, order behaviour, product performance, and regional sales distribution patterns**.
The raw CSV data was first processed using **SQL** for cleaning and transformation, then structured into a **star schema**, and finally visualised using **Power BI** to create an interactive business dashboard.
________________________________________
❓ **Problem Statement**

Amazon sales data is large, inconsistent, and not analytics ready.
Key challenges include:
    
    •	Null and blank values
    •	Duplicate transactions
    •	Inconsistent state names and formats
    •	No proper data model for reporting

**Goal:**
To transform raw data into a **clean, structured analytical model** and generate insights that help stakeholders track performance and make data-driven decisions.
________________________________________
📁 **Dataset**

•	**Source:** Amazon Sale Report (CSV file)

•	**Type:** Transactional sales data

•	**Records include:**

    o	Order details (Order ID, Date, Status)
    o	Product attributes (Category, SKU, Size, ASIN)
    o	Quantity & Revenue
    o	Fulfillment & Courier status
    o	Location data (State, Country, Postal Code)
________________________________________
🛠 **Tools and Technologies**

•	**SQL (MySQL)** – Data cleaning, transformation & analysis

•	**Power BI** – Data visualization & dashboard creation

•	**CSV** – Raw data source
________________________________________
⚙️ **Methods**

1️⃣ **Data Loading**

•	Created staging table amazon_sales

•	Loaded CSV using LOAD DATA INFILE

2️⃣ **Data Cleaning & Standardization (SQL)**

•	Removed unnecessary columns

•	Handled NULL & blank values

•	Standardized state names (RJ → Rajasthan, etc.)

•	Replaced missing amounts with 0

•	Fixed country codes (IN → India)

3️⃣ **Duplicate Handling**

•	Identified duplicates using GROUP BY

•	Removed duplicates using ROW_NUMBER() with CTE

4️⃣ **Data Modelling – Star Schema**

Designed a star schema for efficient analytics:

**Fact Table**

•	fact_amazon_sales

**Dimension Tables**

•	dim_order

•	dim_date

•	dim_status

•	dim_service

•	dim_product

•	dim_courier_status

•	dim_location

5️⃣ **KPI & Business Analysis (SQL)**

•	Total Orders

•	Total Revenue

•	Average Order Value (AOV)

•	Shipped, Delivered, Cancelled & Returned orders

•	Weekly, Monthly, Quarterly & Yearly trends

•	State-wise & Product-wise performance
________________________________________
📌 **Key Insights**

•	Total Revenue: $78.59M

•	Total Orders: 120K+

•	Shipped Orders: 110K+

•	Certain product categories (Set, Kurta) dominate sales volume

•	Larger order volumes observed in specific Indian states

•	Peak revenue months visible in the mid-year period

•	Majority of orders are successfully shipped and delivered
________________________________________
📊 **Dashboard / Model / Output**

The **Power BI dashboard** includes:

•	KPI Cards (Revenue, Orders, AOV, Qty Sold, Shipped Orders)

•	Category-wise Sales & Quantity analysis

•	Size-wise Revenue Distribution (Donut Chart)

•	Monthly Revenue Trend (Line / Area Chart)

•	State-wise Revenue & Order Map (Geo Visualization)

•	Interactive slicers for:

    o	State
    o	Fulfillment
    o	Service Level
    o	Order Status
________________________________________
▶️ **How to Run This Project?**

1.	Import the CSV file into MySQL
2.	Execute SQL scripts in sequence:
    o	Table creation
    o	Data loading
    o	Cleaning & transformation
    o	Star schema creation
    o	Fact & dimension inserts
3.	Connect Power BI to MySQL
4.	Load fact & dimension tables
5.	Build visuals and apply filters
________________________________________
✅ **Results & Conclusion**

This project successfully converts raw Amazon sales data into a **clean, analytics-ready data model**.
By combining SQL and Power BI, it provides:

•	Clear visibility into sales performance

•	Actionable insights on products and regions

•	A scalable data model for future analysis
________________________________________
🚀 **Future Work**

•	Add Year-over-Year (YoY) and Month-over-Month (MoM) analysis

•	Automate refresh using Power BI Service

•	Add profit & cost metrics

•	Build customer-level analytics
________________________________________
👤 **Author & Contact**

Khushboo

Aspiring Data Analyst

Skills: SQL | Power BI | Data Modeling

🔗 https://github.com/sonkar7khusboo-spec  | 

https://www.linkedin.com/in/khushboo-sonkar-4411112aa 

________________________________________
**Dashboard Image**

<img width="1325" height="747" alt="image" src="https://github.com/user-attachments/assets/271685c7-d920-4b8a-a6b4-ecabdf0b10ee" />

