import boto3
import click



@click.command()
@click.option("--function_name", help="Name of the Lambda Function", 
    required=True)
@click.option("--image_uri", help="Lambda Image URI", required=True)
def update(function_name, image_uri):
    """ Update Lambda Image """
    client = boto3.client("lambda")
    response = client.update_function_code(
        FunctionName = function_name,
        ImageUri = image_uri,
    )
    click.echo(response)


if __name__ == "__main__":
    update()
    