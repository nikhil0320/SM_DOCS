# **Cloudability invoice Generation Solution**
This solution will generate invoice for AWS costs and other third party software costs for all aws accounts incurred for the last quarter.

**AWS services used:**
* RDS
* SQS
* Lambda
* SES
* Step Functions
* System Manager Parameters

**Parameter Details**
 
Parameter | Type |Description 
---------- | ---- |----------- 
Cloudability-userName | string | email address of cloudability user
Cloudability-password|secureString|Password of cloudability
DBName|string| RDS Database name for cbilling and accounts(nova)
DBUsername|string|Database username for RDS
Password|secureString| Database username password
RDSHostName|string|RDS endpoint address
Sender-Email|string|sender email address
ServiceNow-Password|secureString|Service-now username or email
ServiceNow-Username|string|Service-now password

**Floder Structure:**
 * invoice_generation
    * utils
        * common.py
    * commonVariables.yml
    * config.json
    * ConvertToPdf.py
    * FetchAccountDetails.py
    * FetchAWSCosts.py
    * FetchThirdPartyAppCosts.py
    * GetMessageFromSQS.py
    * README.md
    * requirements.txt
    * sample-cost-config.json
    * SendEmail.py
    * serverless.yml
    * template2.html

**CommonVariables Details:**

Key| Value | Description
----|----|-------
cbcap-invoice-generation-serverless-lambda-stack-name|  CBCAP-invoice-generation-lambda-Stack|StackName for deploying invoice-generation serverless 
invoice-generation-serverless-bucket|serverless-cloudability-s3-bucket|Bukcet to deploy serverless lambdas
invoice-generation-configuration-bucket|cbcap-lambda-config-bucket|S3 bucket details where config files are present
invoice-generation-configuration-file-key|cloudability_config/config.json|config files for invoice-generation lambdas
invoice-generation-cost-configuration-file-key| cloudability_config/cost-config.json|configuration file cost for thirdparty software license
invoice-generation-default-log-level|INFO|default Log level for all lambdas
rds-public-subnet|subnet-072648370b3dcfe45|Subnet where RDS present
rds-vpc|vpc-fd06e487| VPC in which RDS is preset
stage| dev | default stage of deloyment.

**Config.json Paramaters details:**

Key| Value | Description 
---------- | ---- | ----------- 
cloudability_endpoint|https://app.cloudability.com/api/1/reporting/cost/run"| Endpoint of cloudabiltiy to fetch AWS costs.
send_email|False|Switch to Send email or not(True or False)
invoice_bucket|someBuket|Bucket to store invoices
servicenow_endpoint| https://deloitteusadvisorydev.service-now.com/api/now/table/"| Endpoint of servicenow to fetch thirdparty license cost
black_listed_accounts"| ["XXXXXXXX","XXXXXXXX"]| Accounts to which no need to send emails

**How to run serverless:**

 1. Clone the repo and navigate to [invoice-generation]  folder. 
 2. set AWS Credentials for the account which you use.
        $ export AWS_PROFILE=*profilename*
 3. Create a S3 bucket or use existing one update the config.json with created invoice-bucket
 4. Update the VPC and Subnet details in which RDS is present in commonVaribales.yaml file.
 5. Update the commonVaribales file with location for config files (config.json and cost_config.json)[if needed]
 6. Run the following command  
        $ *serverless deploy*


