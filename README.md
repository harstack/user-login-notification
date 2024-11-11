# TERRAFORM: AWS USER LOGIN NOTIFICATION SERVICE
Description: This repository contains terraform code to deploy the AWS user login notification service. <br><br>
<img src="resources\aws-user-login-notification-harsh-3x.png" alt text="User Login Notification Architecture" height="200">

## Tech Stack
<p float="left">
    <img src="resources/Terraform_Logo.png" alt="Terraform Logo" width="100" />
    <img src ="resources/AWS_Logo.png" alt="AWS Logo" height="100" />
</p>

## Table of Contents

-[ Introduction](#introduction) <br>
-[ Getting Started](#getting-started) <br>
-[ Usage](#usage) <br>
-[ Contributing](#contributing) <br>
-[ License](#license) <br>

## Introduction
In this repository, we utilize terraform to deploy and manage AWS Infrastructure as Code.
Terraform provides a declarative language for defining and provisioning cloud resources.

## Getting Started
Follow the below steps to get started:

1. Clone this repository:
```bash
git clone https://github.com/harstack/user-login-notification.git
```

2. Go to the project directory:
```bash
cd user-login-notification
```

3. Initialize the terraform workign directory:
```bash
terraform init
```

4. Validate the terraform code:
```bash
terraform validate
```

5. Review the terraform execution plan:
```bash
terraform plan
```

6. Apply the terraform code:
```bash
terraform apply
```
Enter "yes" when prompted to deploy the code

7. Upon deployement, terraform will output the values for Target User an Notification Email

8. To destruct the infrastructure deployed and managed by terraform, run:
```bash
terraform destroy
```
BEWARE: This command will delete all the deployed infrastructure resources managed by terraform

## Usage

This repository is designed to deploy the following resources using terraform:
- SNS Topic
- SNS Topic Subscription (for receiving email notification via Email Endpoint)
- S3 Bucket (for cloudtrail logs)
- CloudTrail (for auditing and user login events)
- Amazon EventBridge Rule (for detecting user login)

This are the desired resources deployed for the mentioned use-case, feel free to modify it to your need and utilize further. Review the code and play safe!

## Contributing
It's GitHub, contributions are always welcome. If you find any issues or have suggestions, please open an issue or submit a pull request. You can help maintain this repository through your contributions.

## License
This project is licensed under the Apache License (Version 2.0, January 2004) License - see the [LICENSE](https://github.com/harstack/user-login-notification/blob/main/LICENSE) file for details.