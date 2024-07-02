output "metric_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.instance_cpu.arn
}

output "ec2_stop_role_arn" {
  value = aws_iam_role.ec2_stop_role.arn
}

output "instance_arn" {
  value = aws_instance.my_test_instance.arn
}

output "instance_id" {
  value = aws_instance.my_test_instance.id
}

output "instance_private_ip" {
  value = aws_instance.my_test_instance.private_ip
}

output "lambda_function_arn" {
  value = aws_lambda_function.stop_instance.arn
}