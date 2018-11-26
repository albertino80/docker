# Use an official Debian distro as a parent image
FROM debian:buster-slim

# Set the working directory to /app
WORKDIR /app

# Install any needed packages specified in requirements.txt
RUN apt-get -y update
RUN apt-get -y install build-essential module-assistant
RUN apt-get -y install git
RUN apt-get -y install postgresql
RUN apt-get -y install qt5-default

