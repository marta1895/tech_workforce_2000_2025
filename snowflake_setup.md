# Data Setup: Kaggle → Snowflake

First, I downloaded the dataset from the Kaggle environment:
https://www.kaggle.com/datasets/aryanmdev/tech-hiring-and-layoffs-workforce-data-20002025

Next, I uploaded the CSV file into my Snowflake workspace by following these steps:
**Home tab → Quick Actions → Upload Local Files**

During the upload, the default warehouse was set as **COMPUTE_WH**. I created a new database and schema **TECH_HIRING_LAYOFFS.PUBLIC**, and a new table named **TECH** to load the dataset into.

<img width="1488" height="1490" alt="unknown" src="https://github.com/user-attachments/assets/95b1122b-04ef-4085-8a25-fa39fe951d2e" />


In the next step, I verified the data types and column names, making adjustments where needed, then loaded the data.

<img width="2048" height="1352" alt="unknown" src="https://github.com/user-attachments/assets/b03df505-6602-4747-9be9-d8bae40b9d22" />


Once the upload was complete, the data was available in the Snowflake workspace and ready for analysis.

<img width="2048" height="1203" alt="unknown" src="https://github.com/user-attachments/assets/449ab39b-268e-4959-831b-f454af035c4a" />
