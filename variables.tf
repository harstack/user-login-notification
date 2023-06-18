variable "target_user_arn" {
  description = "Specify the ARN of the user to be monitored for sign-in"
  type        = string
  default     = "arn:aws:iam::xxxxxxx:user/xxxxxx" //Specify the target user ARN to be monitored
}

variable "notification_email" {
  description = "Specify the email to receive the email notification"
  type        = list(string)
  default     = ["notification@email.com"] //Specify the list of Email Endpoints seperated by comma for SNS
}

variable "aws_account" {
  description = "Specify your AWS Account ID"
  type        = number
  default     = 012345678
}