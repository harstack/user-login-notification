//AWS USER LOGIN NOTIFICATION SYSTEM
//STEP 1: Create an SNS Topic
resource "aws_sns_topic" "user_login_notification_topic" {
  name         = "user-login-notification-topic"
  display_name = "user-login-notification-topic"
}

//Sub step: Attaching the required SNS Policy
resource "aws_sns_topic_policy" "user_login_notification_sns_policy" {
  arn    = aws_sns_topic.user_login_notification_topic.arn
  policy = <<EOF
    {
        "Version": "2008-10-17",
        "Id": "__default_policy_ID",
        "Statement": [
            {
                "Sid": "__default_statement_ID",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "*"
                },
                "Action": [
                    "SNS:GetTopicAttributes",
                    "SNS:SetTopicAttributes",
                    "SNS:AddPermission",
                    "SNS:RemovePermission",
                    "SNS:DeleteTopic",
                    "SNS:Subscribe",
                    "SNS:ListSubscriptionsByTopic",
                    "SNS:Publish"
                ],
                "Resource": "${aws_sns_topic.user_login_notification_topic.arn}",
                "Condition": {
                    "StringEquals": {
                        "AWS:SourceOwner": "${var.aws_account}"
                    }
                }
            },
            {
                "Effect":"Allow",
                "Principal": {
                    "Service": "events.amazonaws.com"
                },
                "Action": "sns:Publish",
                "Resource": "${aws_sns_topic.user_login_notification_topic.arn}"
            }
        ]
    }
    EOF
}

//Sub step: SNS Topic Subscription
resource "aws_sns_topic_subscription" "user_login_notification_subscription" {
  for_each  = toset(var.notification_email)
  topic_arn = aws_sns_topic.user_login_notification_topic.arn
  protocol  = "email"
  endpoint  = each.key
}

//STEP 2: Create an S3 Bucket
resource "aws_s3_bucket" "user_login_notification_bucket" {
  bucket = "user-login-notification-bucket"
  acl    = "private"
}

//Sub step: Attach the S3 Bucket Policy
resource "aws_s3_bucket_policy" "user_login_notification_bucket_policy" {
  bucket = aws_s3_bucket.user_login_notification_bucket.id
  policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudTrail",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.user_login_notification_bucket.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.user_login_notification_bucket.arn}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
EOF
}

//STEP 3: Create an CloudTrail trail
resource "aws_cloudtrail" "user_login_notification_trail" {
  name                          = "user-login-notification-trail"
  s3_bucket_name                = aws_s3_bucket.user_login_notification_bucket.bucket
  is_multi_region_trail         = true
  is_organization_trail         = false
  include_global_service_events = true
  enable_logging                = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
}

//STEP 4: Create an Amazon EventBridge
resource "aws_cloudwatch_event_rule" "user_login_notification_rule" {
  name           = "user-login-notification-rule"
  description    = "This rule monitors user login"
  event_pattern  = <<PATTERN
  {
    "source": ["aws.signin"],
    "detail-type": ["AWS Console Sign In via CloudTrail"],
    "detail": {
        "userIdentity": {
            "arn": ["${var.target_user_arn}"]
        }
     }
  }
  PATTERN
  event_bus_name = "default"
}

//Sub step: Create an CloudWatch Event Target
resource "aws_cloudwatch_event_target" "user_login_notification_event_target" {
  rule      = aws_cloudwatch_event_rule.user_login_notification_rule.name
  arn       = aws_sns_topic.user_login_notification_topic.arn
  target_id = "sns"
}

//OUTPUT VALUES
//Target User ARN
output "target_user_arn" {
  value = var.target_user_arn
}

//Notification Email 
output "notification_email" {
  value = var.notification_email
}