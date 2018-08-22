# **Cloudability invoice Generation Solution**
This solution will generate invoice for AWS costs and other third party software costs for all aws accounts incurred for the last quarter.

**AWS services used:**
RDS
SQS
Lambda
SES
Step Functions
System Manager Parameters

**Parameter Details**
Parameter | Type |Description |
--------- | ---- |----------- |
Cloudability-userName | string | email address of cloudability user
Cloudability-password|secureString|Password of cloudability
DBName|string| RDS Database name for cbilling and accounts(nova)
DBUsername|string|Database username for RDS
Password|secureString| Database username password
RDSHostName|string|RDS endpoint address
Sender-Email|string|sender email address
ServiceNow-Password|secureString|Service-now username or email
ServiceNow-Username|string|Service-now password

