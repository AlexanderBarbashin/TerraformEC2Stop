data "aws_ami" "latest_ubuntu" {
  owners = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

locals {
  common_tags = {
    Owner = "Aleks Barbashin"
    Project = "Terraform learn task"
  }
}

resource "aws_instance" "my_test_instance" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = var.instance_type
  tags = merge(local.common_tags, {Name = "My test aws instance"})
}

resource "aws_cloudwatch_metric_alarm" "instance_cpu" {
  alarm_name          = "MYInstanceCPUUtilization"
  comparison_operator = "LessThanThreshold"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 300
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  statistic = "Average"
  threshold = var.instance_cpu_threshold
  alarm_actions = [aws_lambda_function.stop_instance.arn]
  dimensions = {
    InstanceId = aws_instance.my_test_instance.id
  }
  tags = merge(local.common_tags, {Name = "CPU utilization alarm"})
}

resource "aws_iam_role_policy" "ec2_stop_policy" {
  name = "ec2_stop_policy"
  role = aws_iam_role.ec2_stop_role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:Stop*"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2_stop_role" {
  name = "ec2_stop_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  tags = merge(local.common_tags, {Name = "EC2 instance stop role"})
}

data "archive_file" "lambda_ec2_stop" {
  type        = "zip"
  source_file = "../modules/ec2_instance/lambda_ec2_stop.py"
  output_path = "../modules/ec2_instance/lambda_ec2_stop.zip"
}

resource "aws_lambda_function" "stop_instance" {
  tags = merge(local.common_tags, {Name = "EC2 instance stop lambda function"})
  filename = "../modules/ec2_instance/lambda_ec2_stop.zip"
  function_name = "ec2_instance_stop"
  role          = aws_iam_role.ec2_stop_role.arn
  handler       = "lambda_ec2_stop.ec2_instance_stop"
  runtime = "python3.12"
  timeout = "10"
  environment {
    variables = {
      INSTANCE = aws_instance.my_test_instance.id
    }
  }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_instance.function_name
  principal     = "lambda.alarms.cloudwatch.amazonaws.com"
}