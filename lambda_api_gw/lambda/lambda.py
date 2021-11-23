import json

def lambda_handler(event, context):
    
    response = {
        "message": "Hello World!"
    }
    
    return {
        'statusCode': 200,
        'body': json.dumps(response)
    }