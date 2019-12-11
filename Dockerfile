FROM centos

RUN yum install -y gcc-c++ make sudo

RUN curl -sL https://rpm.nodesource.com/setup_10.x | sudo -E bash -

RUN yum install nodejs -y

COPY . /tmp/presentation

WORKDIR /tmp/presentation

RUN npm i

RUN npm rebuild node-sass

EXPOSE 8000

ENTRYPOINT [ "npm" , "start" ]