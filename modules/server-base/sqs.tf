resource "aws_sqs_queue" "rancher-terminations" {
  name = "rancher-${lower(var.deployment_id)}-shudder-queue"
  visibility_timeout_seconds = 120

  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:${var.region}:${element(split(":", aws_iam_role.rancher-ec2-iam-role.arn), 4)}:rancher-${lower(var.deployment_id)}-shudder-queue",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:events:${var.region}:${element(split(":", aws_iam_role.rancher-ec2-iam-role.arn), 4)}:rule/rancher-${lower(var.deployment_id)}-shudder-rule-*"
        }
      }
    }
  ]
}
POLICY
}
