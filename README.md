# Deploying Django to AWS Lambda and Aurora with Terraform

In this tutorial, w'll walk you through the deployment of a Django application to a serverless environment with AWS Lambda, API Gateway and Aurora using Terraform.

## Dependencies:

- Django v3.1
- Docker v20.10.5
- Python v3.7.6
- Terraform v0.14.7

## How to use this project?

1. Sign up for an AWS account

2. Create AWS Access and Secure keys

3. Install Terraform 

4. Fork/Clone

5. Build the Django image and push it to ECR:

```bash
# Ahtehnticate to your default ECR registry:
$ aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com

# Build and tag the image, don’t forget the dot at the end:
$ docker build -t <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/myproject:latest .

#Push the image to ECR:
$ docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/myproject:latest

```

!!! info 
    Be sure to replace <AWS_ACCOUNT_ID> with your AWS account ID.
    We'll be using the us-east-1 region throughout this tutoriel. Feel free to 
    change this if you'd like.

6. Update the variables in terraform/variables.tf.

7. Set the following environment variables, init Terraform, create the infrastructure:

```bash
$ cd terraform
$ export AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID"
$ export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY"

$ terraform init
$ terraform apply
$ cd ..
```

8. Run below command to apply migrations

```bash
$ cd deployment
$ python django_manage.py --function_name myproject-django-dev-lambda --command "migrate"
```

9. Run below command to Create Supper User

```bash
$ python django_manage.py --function_name myproject-django-dev-lambda --command "createsuperuser --username <USER_NAME> --email <USER_EMAIL> --noinput"
```

!!! info 
    Be sure to replace USER_NAME and USER_EMAIL with your information.

10. run below command to collect static files and store them in S3 bucket: 

```bash
$ python django_manage.py --function_name myproject-django-dev-lambda --command "collectstatic --noinput"
```

11. At anytime If you would like to roll back and remove all resources created in AWS you can use below command: 

```bash
$ cd terraform
$ terraform destroy
```