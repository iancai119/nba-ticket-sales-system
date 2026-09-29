# Ticket Sales System
![Oracle SQL](https://img.shields.io/badge/Database-Oracle_SQL-red)
![JavaScript](https://img.shields.io/badge/Script-JavaScript-yellow)
![jQuery](https://img.shields.io/badge/Library-jQuery-blue)
![HTML5](https://img.shields.io/badge/Frontend-HTML5-orange)

## Project Overview
This project simulates a backend database and a frontend dashboard for an NBA ticketing system. It demonstrates database design (normalization), SQL implementation, and data visualization using a web interface.

**Role:** Programmer Analyst Intern Project
**Tech Stack:** Oracle SQL, HTML5, JavaScript (jQuery, DataTables)

## Features
1.  **Relational Database Design:** 3NF normalized schema managing Fans, Games, Seat Tiers, and Transactions.
2.  **Data Integrity:** Implemented Primary Keys, Foreign Keys, and Constraints.
3.  **Frontend Dashboard:** A responsive web interface to visualize real-time ticket sales data.
4.  **Business Intelligence:** SQL scripts designed to analyze revenue streams and identify VIP customers.

## Database Schema (ERD)
![ER Diagram](Ticket%20Sales%20System/Database/erd_diagram.png)

## Key SQL Analysis
The project includes analytical queries to solve business problems, such as:
* Calculating total revenue per game matchup.
* Identifying high-value customers (VIPs) for marketing targeting.
* *See `Ticket Sales System/Database/analytical_queries.sql` for details.*

## How to Run
1.  **Database:** Run `Ticket Sales System/Database/schema_and_data.sql` in any Oracle SQL environment (SQL Developer, SQLPlus) to build the schema and populate data.
2.  **Dashboard:** Open `Ticket Sales System/Web/index.html` in any web browser. (Note: The live demo uses mock data for portability).
