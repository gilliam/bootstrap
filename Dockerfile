FROM gilliam/base
MAINTAINER Johan Rydberg <johan.rydberg@gmail.com>
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update && apt-get install -y python python-pip git
RUN pip install git+https://github.com/gilliam/gilliam-py.git
RUN pip install git+https://github.com/gilliam/gilliam-cli.git
ADD . /bootstrap
WORKDIR /bootstrap
CMD ["/bootstrap/bootstrap.sh"]
