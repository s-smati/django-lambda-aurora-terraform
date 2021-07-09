"""
WSGI config for myproject project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/3.1/howto/deployment/wsgi/
"""

import sys, os
import traceback
import json

from django.core.wsgi import get_wsgi_application

import serverless_wsgi


os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings')

application = get_wsgi_application()

# Configure this as your entry point in AWS Lambda
#def handler(event, context):
#    return serverless_wsgi.handle_request(application, event, context)

def handler(event, context):
    """ Lambda event handler, invokes the WSGI wrapper and handles command invocation
    """
    if "_serverless-wsgi" in event:
        import shlex
        import subprocess
        from werkzeug._compat import StringIO, to_native

        native_stdout = sys.stdout
        native_stderr = sys.stderr
        output_buffer = StringIO()

        try:
            sys.stdout = output_buffer
            sys.stderr = output_buffer

            meta = event["_serverless-wsgi"]
            if meta.get("command") == "exec":
                # Evaluate Python code
                exec(meta.get("data", ""))
            elif meta.get("command") == "command":
                # Run shell commands
                result = subprocess.check_output(
                    meta.get("data", ""), shell=True, stderr=subprocess.STDOUT
                )
                output_buffer.write(to_native(result))
            elif meta.get("command") == "manage":
                # Run Django management commands
                from django.core import management

                management.call_command(*shlex.split(meta.get("data", "")))
            else:
                raise Exception("Unknown command: {}".format(meta.get("command")))
        except subprocess.CalledProcessError as e:
            return [e.returncode, e.output.decode("utf-8")]
        except:  # noqa
            return [1, traceback.format_exc()]
        finally:
            sys.stdout = native_stdout
            sys.stderr = native_stderr

        return [0, output_buffer.getvalue()]
    else:
        return serverless_wsgi.handle_request(application, event, context)