# Terraform

## Код служит для создания

* AWS EC2 Instance
* AWS CloudWatch Alarm для отслеживания падения нагрузки на instance меньше 3 %
* AWS Lambda function для остановки instance в случае нагрузки на instance меньше 3 %