# pull official Amazon lambda python base image
FROM public.ecr.aws/lambda/python:latest

# install dependencies
RUN pip install --upgrade pip
COPY ./requirements.txt ./
RUN pip install -r requirements.txt

# copy project
COPY . ./


CMD ["myproject.wsgi.handler"]