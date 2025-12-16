# Milestone-Explore-Ecommerce-Data
Utilized SQL in Google BigQuery to write and execute queries to find the desired data

**I. Introduction**

This project focuses on exploring an eCommerce dataset with SQL in Google BigQuery. The dataset is based on the Google Analytics public dataset and contains transactional data from an eCommerce website.

**II.  Requirements**
- Google Cloud Platform account
- Project on Google Cloud Platform
- Google BigQuery API enabled
- SQL query editor or IDE

**III. Dataset Access**
The eCommerce dataset is stored in a public Google BigQuery dataset. To access the dataset, follow these steps:

- Log in to your Google Cloud Platform account and create a new project.
- Navigate to the BigQuery console and select your newly created project.
- In the navigation panel, select "Add Data" and then "Search a project".
- Enter the project ID "bigquery-public-data.google_analytics_sample.ga_sessions" and click "Enter".
- Click on the "ga_sessions_" table to open it.

**IV. Exploring the Dataset**

In this project, I will write 08 query in Bigquery base on Google Analytics dataset

**Query 01: Calculate total visit, pageview, transaction and revenue for January, February and March 2017 order by month**
<img width="557" height="593" alt="image" src="https://github.com/user-attachments/assets/ece0b977-a7e2-4c0a-ade1-76a98335de6a" />


**Query 02: Bounce rate per traffic source in July 2017**

<img width="554" height="680" alt="image" src="https://github.com/user-attachments/assets/1a48f376-444f-4ff2-9f44-65895fae6bcf" />


**Query 3: Revenue by traffic source by week, by month in June 2017**
<img width="552" height="558" alt="Screenshot 2025-12-16 210714" src="https://github.com/user-attachments/assets/2c32aa6c-05ba-44bc-8cbb-8ca5a0a634ab" />

<img width="562" height="672" alt="image" src="https://github.com/user-attachments/assets/f1bfdc2a-2c2f-4a90-9959-f986b27493c5" />

**Query 4: Average number of product pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017**

<img width="774" height="610" alt="image" src="https://github.com/user-attachments/assets/fa0be0db-75b9-4bc0-b1f5-eecfb620fed6" />

<img width="762" height="235" alt="image" src="https://github.com/user-attachments/assets/3650732e-05e9-432e-a72b-13e9b6064985" />

**Query 05: Average number of transactions per user that made a purchase in July 2017**

<img width="562" height="561" alt="image" src="https://github.com/user-attachments/assets/6529fc28-9108-4394-bcb4-944e66bbe8bc" />

**Query 06: Average amount of money spent per session. Only include purchaser data in July 2017**

<img width="557" height="497" alt="image" src="https://github.com/user-attachments/assets/031a912f-a62e-46b1-82fc-01593d81d487" />

**Query 07: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.**

<img width="636" height="496" alt="Screenshot 2025-12-16 213812" src="https://github.com/user-attachments/assets/f1c49f7e-3248-4db2-8c75-bc0b2efa86e7" />

<img width="638" height="737" alt="image" src="https://github.com/user-attachments/assets/e05408f2-2b97-4ac2-8d3d-502beb78bf72" />

**Query 8: Calculate cohort map from pageview to addtocart to purchase in last 3 month.**

<img width="677" height="734" alt="image" src="https://github.com/user-attachments/assets/b46e8c9c-78dd-452c-b583-5d4d9a9a1a89" />








