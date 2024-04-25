# S3-SECURITY-CHECKLIST



Check list 

- Review if the block public access settings account (BPA) is disabled.
- If the BPA is disabled and there is no business case to leave it disabled then proceed to enabled it.
- Create a policy to allow only selected IAM users/groups to change the BPA settings.
- Attach the BPA policy to selected IAM users or groups.
- Added a policy to allow access to Amazon S3 Objects only through HTTPS.



### How to run terraform

```terraform init```
```terraform plan --var-file=value.tfvars  --out tfplan```
```terraform apply tfplan```
