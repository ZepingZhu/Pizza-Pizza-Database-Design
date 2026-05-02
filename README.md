# Pizza-Pizza-Database-Design

## Project Overview
This project outlines the design and implementation of a relational database system tailored for Pizza Pizza, a leading Canadian quick-service restaurant franchise. The proposed database is engineered to support the organization's core business processes, specifically high-volume order management, complex menu customizations, varied fulfillment methods, and customer loyalty initiatives. It was developed by transforming a conceptual data model into a relational schema running in SQLite.

## Technologies Used
*   Database: SQLite, SQL 
*   Programming Language: Python
*   Data Analysis & Visualization: Pandas, Matplotlib, Seaborn

## Core Features
*   **Order and Customization Management: The system handles various order types (delivery, pickup, and walk-in) while capturing the customer's identity to update loyalty points. It records complex order customizations, linking specific size variants, crust types, and extra instructions directly to the order item.

*   **Inventory and Recipe Management: The database links every menu item to its raw materials through a "Recipe Consists Of" specification. It tracks inventory at the raw material level to monitor expiry dates, track theoretical usage versus actual stock, and trigger low stock alerts.

*   **Workforce and Delivery Logistics: The system manages the allocation of employees to specific franchise locations, distinguishing between specialized roles like Drivers and Kitchen Staff. It tracks specific delivery times, tip amounts, and driver compliance details (e.g., Driver License Numbers and Vehicle Types).

*   **Robust Data Integrity: The relational schema ensures data quality by implementing rigorous constraints, including PRIMARY KEY, FOREIGN KEY, NOT NULL, CHECK, and UNIQUE constraints.

*   **Business Intelligence Analytics: Includes SQL queries and Python visualizations to generate a decision-support report. Key reports analyze menu item profitability (base price vs. customization revenue), driver performance based on tip analysis, and a VIP customer matrix comparing order volume to loyalty points.

## Repository Structure
*   **An Entity Relationship Diagram <img width="2555" height="1280" alt="0730a23ac426974200a2b868839753d" src="https://github.com/user-attachments/assets/6976eaa9-c453-4578-8c97-c369d757c860" />

*   **SQL Scripts: Contains table creation (`CREATE TABLE`) statements and `INSERT` statements to populate the database with realistic sample data.

*   **Ipynb file: Python scripts that connect to the SQLite database, execute complex business queries, and generate data visualizations using Pandas and Seaborn.
