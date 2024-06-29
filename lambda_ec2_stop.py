import os
import boto3

region = 'eu-central-1'
instance = [os.environ["INSTANCE"]]
ec2 = boto3.client('ec2', region_name=region)


def ec2_instance_stop(event, context):
    ec2.stop_instances(InstanceIds=instance)
    print('stopped your instance: ' + str(instance))
