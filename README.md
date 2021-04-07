# idp-accounts-config
Configuration and provisioning of AWS-D organisation and member accounts

## Requirements

| Name | Version |
|------|---------|
| [Terraform](https://www.terraform.io/downloads.html) | >= 0.14.0, < 0.15.0 |


## Providers

| Name | Version |
|------|---------|
| aws |  >= 3.33.0, < 4.0.0 |


## Outputs

| Name | Description |
|------|-------------|
| org\_member\_account\_ids | A list of organisation member accounts |
| org\_root\_account\_arn | The AWS account arn of the organisation root account |
| org\_root\_account\_email | The AWS account email of the organisation root account |
| org\_root\_account\_id | The AWS account Id of the organisation root account |
| org\_zone\_id | The Id of the organisation route53 zone |
| org\_zone\_name | The name of the organisation route53 zone |
| org\_zone\_name\_servers | The name server records from the organisation route53 zone |


