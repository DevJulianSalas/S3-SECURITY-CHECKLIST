# S3-SECURITY-CHECKLIST



Check list 
- Create the business required policies allowing access only to the selected IAM users/groups. ✅
- Review the ACLS access to your bucket and its objects. ✅
- Create encryption at rest and transit. ✅
- Allow access to Amazon S3 Objects only through HTTPS (ensure encryption at transit). ✅
- Enable server access logs to provide enough information to security audit. 
- If server access logs is enabled, configure lifecycle rules in the target bucket to expire/delete objects after a specified period of time. ✅
- Use S3 access point at scale. ✅
- Enable Versioning to protect against accidental deletion or modification of objects.
- Enable Cross-Region Replication for DR actions and compliance purposes.
- Enable Object Lock to prevent objects from being deleted or modified for compliance purpose.
- For temporary objects must use signed URLS.
- Enable Public Access (this is enabled for default). ✅
- Regular Audits.



### How to run terraform

```terraform init```
```terraform plan --var-file=value.tfvars  --out tfplan```
```terraform apply tfplan```
```terraform destroy --var-file=value.tfvars```