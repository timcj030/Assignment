I.If data volume increased 10x monthly, how would you scale and productionise this pipeline?

- When the data volume increase 10X, the main thing it affects are query performance and also the cost for processing our queries

1.We can use DBT incremental strategy to process only the latest records
    Since we have already partitioned the table, we can mention the partition column  along with the cluster key while using merge strategy so that it will avoid full table scan rather it will scan only the partition. **Note- just to answer same question  asked in my first interview :) ** Or we can use insert_overwrite startegy if the requirement support that
2.We have already partitioned the final table with column EventMonth, so that will help
3.We can cluster the table using policy_id or any other field which we will be using mostly in the filter conditions
4.We can create materialized views if we are doing any aggregations
5.Follow the best practices while querying like don't use select *, use bigger table on the left while joining, don't use subqueries while joining the tables etc.
6.Monitor resource usage and create alert emails for budget
7.Proper documentation and version control also helps when something goes wrong and we have to debug


- To productionise the pipeline 
1.Use seperate environments for development, staging, UAT and Production
2.Automate teh deployment using CI/CD
    a.we can use Cloud Composer to schedule dbt jobs which helps to manage dependencies and optimize resource usage. 
    b.We can also use cloud build and cloud run to schedule the job if we need a simple pipeline and also not too much interdependency between jobs
3. Also schedule the job during off peak ours. This will help us to reduce on demand price surges 

II.Anomaly Detection & Logging:

1. We can write test for checking if new data is not available for a particular day gap or if the volume is not as expected and create alerts. These are 2 of the anomalies I can think of from the csv file

1.For logging- From DBT side- We can use dbt artifacts to see the log and analyse the issues if any
2.From GCP Side- We can use cloud logging to monitor issues, create alerts when  error happens. In my experience I have noted that sometimes the overall job will be successful but there might be some internal sql errors which we won't be able to see even if we create alerts. To address this I have created metrics to check the internal error and send alert email 

III.DAG Logic
In our DAG pipeline we will be having mainly 5 tasks


  1. seed the policy_events.csv to load the data into BigQuery.I will name it as 'seed_policy_events'
  2. Build the staging model named as 'run_stg_policy_events'  
  3. Build the final model named as 'run_policy_lifecycle_enriched' 
  4. Then a task for test -'run_tests' 
  5. Fianlly an alert if any steps fails 'failure_notification' 

  Once the DAG file is created it will run in the below order

    seed_policy_events >> run_stg_policy_events >> run_policy_lifecycle_enriched >> run_tests >> failure_notification



