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

[module]: https://registry.terraform.io/modules/ONSdigital/account/aws/latest

## Usage

This repo instantiates the AWS account [module]. Please refer to the account [module]'s [README](https://github.com/ONSdigital/terraform-aws-account#readme) for usage instructions

To provision an AWS account:

1. Create a file i.e. `idp-documentation.tf`


2. Instantiate the account [module]

```terraform
module "idp_documentation" {
  source  = "ONSdigital/account/aws"
  version = "~> 0.2.2"

  account_env        = "documentation"
  account_team       = "cia"
  root_account_email = "aws.d.registration.000@ons.gov.uk"
  name               = "documentation"
  dns_subdomain      = "doc"
  master_zone_id     = aws_route53_zone.org_zone.id
  iam_account_id     = module.iam.account_id

  providers = {
    aws         = aws.idp-documentation
    aws.account = aws.account
  }
}
```

**Note**

For a value to the `root_account_email` argument.  Refer to [AWS Accounts Alias List](./README.md#aws-accounts-alias-list) table below and **remember** to mark the selected
email as `in use`

3. Define a provider referencing the built-in organisation access role.  See: [Provider Config Docs](https://github.com/ONSdigital/terraform-aws-account#provider-configuration)

```terraform
provider "aws" {
  alias  = "idp-documentation"
  region = "eu-west-2"

  assume_role {
    role_arn = "arn:aws:iam::${module.idp_documentation.account_id}:role/OrganizationAccountAccessRole"
  }
}
```

4. Create a record in the AWS-D organisation hosted zone for the account's delegation set

```terraform
resource "aws_route53_record" "idp_documentation" {
  zone_id = aws_route53_zone.org_zone.zone_id
  name    = module.idp_documentation.zone_name
  type    = "NS"
  ttl     = "300"
  records = module.idp_documentation.zone_name_servers
}
```

5. Add the SAN/zone-name to the organisation certificate in [organisation.tf](./organisation.tf)

```terraform
  subject_alternative_names = [
    module.idp_mgmt.zone_name,
    module.idp_mgmt_dev.zone_name,
    module.idp_documentation.zone_name
  ]
```

## Outputs

| Name | Description |
|------|-------------|
| idp\_iam\_account\_id | The Id of the AWS account where you'll manage users |
| org\_member\_account\_ids | A list of organisation member accounts |
| org\_root\_account\_arn | The AWS account arn of the organisation root account |
| org\_root\_account\_email | The AWS account email of the organisation root account |
| org\_root\_account\_id | The AWS account Id of the organisation root account |
| org\_zone\_id | The Id of the organisation route53 zone |
| org\_zone\_name | The name of the organisation route53 zone |
| org\_zone\_name\_servers | The name server records from the organisation route53 zone |


### AWS Accounts Alias List

Please amend this table when creating a new AWS account.

| Alias                                | State       | Organization |
| ------------------------------------ | ------      |:------------:|
| aws.d.registration.001@ons.gov.uk    | in use      | AWS-D        |
| aws.d.registration.002@ons.gov.uk    | in use      | AWS-D        |
| aws.d.registration.003@ons.gov.uk    | in use      | AWS-D        |
| aws.d.registration.004@ons.gov.uk    | available   | AWS-D        |
| aws.d.registration.005@ons.gov.uk    | available   | AWS-D        |
| aws.d.registration.006@ons.gov.uk    | available   | AWS-D        |
| aws.d.registration.007@ons.gov.uk    | available   | AWS-D        |
| aws.d.registration.008@ons.gov.uk    | available   | AWS-D        |
| aws.d.registration.009@ons.gov.uk    | available   | AWS-D        |
| aws.d.registration.010@ons.gov.uk    | available   | AWS-D        |
| aws.d.registration.011@ons.gov.uk    | available   | AWS-D        |
| aws.d.registration.012@ons.gov.uk    | available   | AWS-D        |
| aws.d.registration.013@ons.gov.uk    | available   | AWS-D        |
| aws.d.registration.014@ons.gov.uk    | available   | AWS-D        |
| aws.d.registration.015@ons.gov.uk    | available   | AWS-D        |
| aws.d.registration.016@ons.gov.uk    | available   | AWS-D        |
| aws.d.registration.017@ons.gov.uk    | available   | AWS-D        |
| aws.d.registration.018@ons.gov.uk    | available   | AWS-D        |
| aws.d.registration.019@ons.gov.uk    | available   | AWS-D        |
| aws.d.registration.020@ons.gov.uk    | available   | AWS-D        |
