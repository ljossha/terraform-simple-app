# Simple terraform infrastructure for a web application

## Description

I've implemented a simple web application using [terraform](https://www.terraform.io/).

## Structure

- VPC: in eu-central-1 with 3 private subnets, 3 public subnets for each AZ. IGW, NAT gateway and route tables are created, S3 endpoint.

- S3: private bucket, public bucket.

- Cloudfront: distribution and SSL termination for public bucket.

- RDS: postgres database in private subnet with access from ECS cluster.

- ECS: cluster with 1 task to run backend application that has access to RDS.

- ECR: repository for backend application.

- LB: application load balancer under ECS cluster.

## How to use

```bash
  terraform init
  terraform plan
  terraform apply
```

## TODO

- [ ] SQS module
- [ ] Cloudwatch module
- [ ] ASG module
- [ ] Terragrunt to manage different environments
