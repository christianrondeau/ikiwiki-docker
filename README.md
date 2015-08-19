# Docker for ikiwiki

This is a Dockerfile for a sandbox ikiwiki.

## Build yourself

You can build the image yourself with this git repository.

    docker build -t ikiwiki .

Run the built image:

    docker run -d -p 8001:80 --name ikiwiki ikiwiki

## Stop

    docker stop ikiwiki

## Credentials

ikiwiki admin user name:
    ikiwiki

admin pass:
    ikiwiki
