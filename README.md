🛒 Superstore Sales Performance Analysis

📖 Overview
This project is an end-to-end Data Analytics Project that analyzes the Superstore Sales Dataset using Python, SQL, and Microsoft Power BI.

The workflow begins with data loading, cleaning, and exploratory analysis in Python, continues with business analysis using SQL, and finishes with an interactive Power BI dashboard that presents key business insights.

🎯 Project Objectives
Load and prepare the dataset.
Clean and validate the data.
Perform exploratory data analysis (EDA).
Analyze sales, profit, customers, products, shipping, and discounts using SQL.
Build an interactive Power BI dashboard.
Generate business insights to support decision-making.


🛠️ Tools & Technologies
Microsoft Excel
Advanced Excel
Python
Pandas
NumPy
Matplotlib
SQL (MySQL)
Microsoft Power BI
Git & GitHub


📂 Project Structure
Superstore-Sales-Analysis/
│
├── Dataset/
│   └── Cleaned Superstore Data.csv
│
├── Python/
│   └── Data_Loading_Cleaning_and_Preparation.ipynb
│
├── SQL/
│   └── Superstore_SQL_Project.sql
│
├── Power BI/
│   └── Superstore Dashboard.pbix
│
├── Images/
│   └── Superstore Sales Dashboard.png
│
└── README.md


🐍 Python Analysis
The Python notebook includes:
Data Loading
Import dataset
Load CSV using Pandas
Inspect dataset structure
Data Cleaning
Check missing values
Remove duplicates
Verify data types
Handle inconsistent values
Exploratory Data Analysis (EDA)
Revenue distribution
Profit distribution
Category analysis
Sub-category analysis
Region analysis
Segment analysis
Monthly sales trend
Top-selling products
Correlation analysis

🗄️ SQL Analysis
The SQL project includes:
Database Setup
Data Overview
Revenue Analysis
Profit Analysis
Customer Analysis
Product Analysis
Order & Shipping Analysis
Discount Analysis
Window Functions (RANK, DENSE_RANK, ROW_NUMBER)

📈 Power BI Dashboard
The dashboard includes:
KPI Cards
Total Revenue
Total Profit
Total Orders
Total Customers
Profit Margin
Interactive Visualizations
Monthly Revenue Trend
Revenue by Category
Profit by Category
Profit by Region
Top 10 Products by Revenue
Top 10 Customers by Revenue
Slicers
Year
Region
Category
Segment
Ship Mode

📷 Dashboard Preview

![Dashboard](Images/Superstore%20Sales%20Dashboard.png)


💡 Key Insights
Technology generated the highest revenue.
Office Supplies contributed significantly to overall profit.
Revenue showed seasonal variations across months.
High discounts generally reduced profit margins.
A small group of customers generated a significant share of total revenue.

📚 Skills Demonstrated
Python
Pandas
NumPy
Data Cleaning
Exploratory Data Analysis (EDA)
SQL
Window Functions
Power BI
Dashboard Design
Business Intelligence
Data Visualization


🔄 Data Processing Pipeline

 1️⃣ Data Loading

The raw CSV file is loaded using Pandas:

Python


df = pd.read_csv("../Dataset/Cleaned Superstore Data.csv", encoding="latin1")