# Data Catalog for Gold Layer

## Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables** and **fact tables** for specific business metrics.

---

### 1. **gold.dim_customer**
- **Purpose:** Stores customer details enriched with external data.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_key     | INT           | Surrogate key uniquely identifying each customer record in the dimension table.               |
| customer_id      | NVARCHAR(50)  | Unique alphanumeric identifier assigned to each customer.                                     |
| customer_name    | NVARCHAR(50)  | The customer's first and last name, as recorded in the system.         					   |
| segment	       | NVARCHAR(50)  | The segment of customer (Consumer, Home Office or Corporate).								   |

---

### 2. **gold.dim_product**
- **Purpose:** Provides information about the products and their attributes.
- **Columns:**

| Column Name         | Data Type     | Description                                                                                   |
|---------------------|---------------|-----------------------------------------------------------------------------------------------|
| product_key         | INT           | Surrogate key uniquely identifying each product record in the product dimension table.         |
| product_id          | INT           | A unique identifier assigned to the product for internal tracking and referencing.            |
| category            | NVARCHAR(50)  | The broader classification of the product (e.g., Furniture, Office Supplies) to group related items.  |
| subcategory         | NVARCHAR(50)  | A more detailed classification of the product within the category, such as product type.      |
| product_name        | NVARCHAR(50)  | Descriptive name of the product, including key details such as type, color, and size.         |

---

### 3. **gold.fact_sales**
- **Purpose:** Stores transactional sales data for analytical purposes.
- **Columns:**

| Column Name     | Data Type     | Description                                                                                   |
|-----------------|---------------|-----------------------------------------------------------------------------------------------|
| order_number    | NVARCHAR(50)  | A unique alphanumeric identifier for each sales order (e.g., 'CA-2014-148040').                      |
| product_key     | INT           | Surrogate key linking the order to the product dimension table.                               |
| customer_key    | INT           | Surrogate key linking the order to the customer dimension table.                              |
| order_date      | DATE          | The date when the order was placed.                                                           |
| shipping_date   | DATE          | The date when the order was shipped to the customer.                                          |
| shipe_mode      | NVARCHAR(50)  | The mode of shipping.                                                     					  |
| sales_amount    | FLOAT         | The total monetary value of the sale for the line item, in whole currency units (e.g., 38.98).   |
| quantity        | INT           | The number of units of the product ordered for the line item (e.g., 1).                       |
| discount        | FLOAT         | The discount of product (e.g., 0, 0.2).      |
| profit          | FLOAT         | The profit that company earned when it saled this product (e.g., 0, 24.3384, -2.436).      |
| country         | NVARCHAR(50)  | The name of country where the order was from (e.g., United States).      |
| region          | NVARCHAR(50)  | The name of region where the order was from (e.g., West, Central).      |
| city            | NVARCHAR(50)  | The name of city where the order was from (e.g., New Jersey, Florida).      |
| postal code     | INT           | A unique number that identify the specific geographic region.      |



