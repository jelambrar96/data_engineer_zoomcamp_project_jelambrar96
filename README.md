# Data engineer zoomcamp project

In the modern world, where digital platforms generate vast amounts of data every moment, data engineering plays a pivotal role in extracting meaningful insights from these sea-sized datasets. The challenge of processing, analyzing, and storing this data efficiently can't be understated, especially when dealing with resources like https://www.gharchive.org/, which archives public GitHub events.

## Problem Description and Solution

For this project, the focus is on gharchive.org's comprehensive dataset capturing the myriad events that occur on the GitHub platform. Due to its substantial size, employing data engineering techniques becomes imperative. These techniques allow for the effective handling and processing of the data to distill valuable insights.

The primary objective of this project is to ascertain the most common event type generated on the GitHub platform, and to analyze the event behavior over time. Understanding these dynamics not only provides insights into GitHub's usage patterns but also aids in optimizing platform engagement strategies, making data engineering an essential tool in this analysis.

Specifically, the project aims to ascertain the most common event type generated on GitHub and analyze how this event behavior evolves over time. This objective underscores the importance of robust data processing infrastructure and methodologies to tackle the large volume and variety of data efficiently.

## Solution Infrastructure

This project utilizes a host of cloud computing technologies to address the significant challenge of processing gigantic datasets efficiently The project utilizes a suite of Cloud Computing Technologies for efficient data processing due to their scalability, reliability, and performance benefits. 

Each component's selection was driven by the need for an efficient, scalable, and cost-effective solution to process and analyze large datasets, demonstrating the project's commitment to leveraging cutting-edge data engineering practices.

### Google Cloud Platform

At the core of our infrastructure is the Google Cloud Platform (GCP), chosen for its robustness, scalability, and a wide range of services tailored for big data projects. GCP's ability to handle vast volumes of data quickly and cost-effectively makes it an ideal choice. The Google Cloud Platform (GCP) was chosen for its comprehensive set of tools, including storage, computing, and data analytics capabilities, which are essential for handling large volumes of data.

### Terraform

Terraform, an Infrastructure-as-Code (IaC) tool, streamlines the management of GCP resources, enabling a reproducible and scalable infrastructure setup. Its declarative configuration files offer a reliable way to provision and manage infrastructure with version control and documentation. Using Terraform allows us to define our infrastructure through code, making it replicable and version-controlled. This approach ensures a consistent and error-free environment setup, enabling quick scaling and adjustments as project needs evolve.

### Google Cloud Composer (Airflow)

Google Cloud Composer, a managed Apache Airflow service, orchestrates data workflows, ensuring tasks are efficiently and reliably processed. Its integration within the GCP ecosystem simplifies complex data pipelines, leveraging Airflow without the administrative overhead. Importantly, data is not processed directly within Airflow to prevent overloading the Composer cluster, illustrating our approach to ensuring a smoothly running, scalable infrastructure. This strategic choice prevents overloading the Composer cluster, enhancing system reliability.

### Google Cloud Functions

For data acquisition, Google Cloud Functions, configured to download GH Archive's JSON.GZ files hourly, demonstrate the flexibility of serverless computing in handling event-driven tasks with scalability and cost-effectiveness. The function's code can be found [here](https://github.com/jelambrar96/data_engineer_zoomcamp_project_jelambrar96/blob/master/gfunctions/download_function/main.py).

### Google Cloud Dataproc

Data processing leverages a Spark cluster on Google Cloud Dataproc to transform 24 hours of downloaded data into query-optimizable, date-partitioned Parquet files stored in Google Cloud Storage. This setup optimizes for processing efficiency and data management. The related Spark code is accessible [here](https://github.com/jelambrar96/data_engineer_zoomcamp_project_jelambrar96/blob/master/dataproc/dataproc_01_extract_gh_data.py).

### BigQuery and Looker Studio

External BigQuery tables facilitate robust data analysis, with Looker Studio employed to visualize and interpret the data, turning complex datasets into actionable insights. We employ Looker Studio for generating insightful graphs and plots, thereby enabling a comprehensive understanding of the event data and its trends over time.


## Steps to Replicate the Project

1. Create a Google Cloud Platform account. 
2. Create a Google Cloud project. 
3. Create a service account and assign roles. 
4. Enable key APIs: Environmental Composer API, BigQuery API, Google Storage API, and Dataproc API. 
5. In the `terraform/` folder, create a file named `terraform.tfvars` and set the `project`, `region`, and `zone` parameters accordingly. 
6. Execute `terraform init` and `terraform apply` to provision the infrastructure. 
7. If a BigQuery external table error occurs, it is recommended to wait at least one hour to allow the Spark job to create .parquet files. 
8. Replicate the dashboard on Looker Studio.





------------

Made with :hear: by [@jelambrar96](https://github.com/jelambrar96) :floppy_disk:
