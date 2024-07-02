output "training_metric_alarm_arn" {
  value = module.training_aws_ec_2_instance.metric_alarm_arn
}

output "training_ec2_stop_role_arn" {
  value = module.training_aws_ec_2_instance.ec2_stop_role_arn
}

output "training_instance_arn" {
  value = module.training_aws_ec_2_instance.instance_arn
}

output "training_instance_id" {
  value = module.training_aws_ec_2_instance.instance_id
}

output "training_instance_private_ip" {
  value = module.training_aws_ec_2_instance.instance_private_ip
}

output "training_lambda_function_arn" {
  value = module.training_aws_ec_2_instance.lambda_function_arn
}