import json
import boto3
import click


@click.command()
@click.option("--function_name", help="Name of the Lambda Function", 
    required=True)
@click.option('--command', help="Djano Manage Command", required=True, type=str)
def manage(function_name, command):
    """ Call Lambda function to execute Django manage command """
    lambda_payload = {
                        "_serverless-wsgi":{
                            "command": "manage",
                            "data": command 
                        }

    }
    client = boto3.client("lambda")
    response = client.invoke(
        FunctionName=function_name,
        InvocationType='RequestResponse',
        LogType='Tail',
        Payload=json.dumps(lambda_payload)
    )
    response_payload = response['Payload'].read()
    click.echo(response_payload)


if __name__ == "__main__":
    manage()
    