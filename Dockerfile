FROM ubuntu:12.04
MAINTAINER Johan Rydberg <johan.rydberg@gmail.com>
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update && apt-get install -y python python-pip git
RUN pip install git+https://github.com/gilliam/gilliam-py.git
RUN pip install git+https://github.com/gilliam/client.git
ADD . /bootstrap
WORKDIR /bootstrap
CMD ["/bootstrap/bootstrap.sh"]
