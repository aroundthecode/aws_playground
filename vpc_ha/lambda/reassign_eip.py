import json
import boto3

client = boto3.client('ec2')

def lambda_handler(event, context):
    
    print("Event: " + json.dumps(event))

    instances = client.describe_instances(
    Filters=[
            {
                'Name': 'image-id',
                'Values': [
                    'ami-63ec5b1e',
                ]
            },{
                'Name': 'instance-state-name',
                'Values': [
                    'running',
                ]
            },
        ]
    )

    eip = client.describe_addresses(
        Filters=[
            {
                'Name': 'tag:Name',
                'Values': [
                    'wordpress',
                ]
            },
        ]
    )
    # print("Instances")
    # print(instances)
    # print("EIP")
    # print(eip)

    for r in instances['Reservations']:
        for i in r['Instances']:
            instance_id = i['InstanceId']
            print(instance_id)

    eip_allocation_id = ""
    eip_ip = ""
    for e in eip['Addresses']:
        eip_allocation_id = e['AllocationId']
        eip_ip = e['PublicIp']
        print("eip_allocation_id: " + eip_allocation_id)
        print("eip_ip: " + eip_ip)

    association = client.associate_address(
        InstanceId=instance_id,
        PublicIp=eip_ip,
        AllowReassociation=True
    )
    
    # print("association")
    # print(association)

    response = {
        "instance": instance_id,
        "eip": eip_ip,
        "association": association.get('AssociationId',"Unassigned")
    }
    
    return {
        'statusCode': 200,
        'body': json.dumps(response)
    }
