FROM centos:centos7

ARG version="6.06.08"
LABEL version="${version}"

RUN yum -y install epel-release 
RUN yum -y install gcc-c++ bzip2 git vim libpng libjpeg \
     python-devel libSM libX11 libXext libXpm libXft gsl-devel python-pip make cmake3\
     && yum -y clean all
RUN pip install --upgrade pip # && pip install jupyter
RUN ln -s /usr/bin/cmake3 /usr/bin/cmake

# Set ROOT environment
ENV ROOTSYS         "/opt/root"
ENV PATH            "$ROOTSYS/bin:$ROOTSYS/bin/bin:$PATH"
ENV LD_LIBRARY_PATH "$ROOTSYS/lib:$LD_LIBRARY_PATH"
ENV PYTHONPATH      "$ROOTSYS/lib:$PYTHONPATH"

ADD https://root.cern.ch/download/root_v${version}.Linux-centos7-x86_64-gcc4.8.tar.gz /var/tmp/root.tar.gz
RUN tar xzf /var/tmp/root.tar.gz -C /opt && rm /var/tmp/root.tar.gz

RUN yum install -y krb5-workstation.x86_64

#ADD eos.repo /etc/yum.repos.d
#ADD eos-dep.repo /etc/yum.repos.d
#RUN yum install -y eos-client
#ADD eos /etc/sysconfig

ADD krb5.conf /etc/

RUN mkdir Analysis
WORKDIR /Analysis

ADD user.keytab .

RUN mkdir Step4_tmva 
ADD Step4_tmva Step4_tmva

ADD run_all.sh .
#RUN bash -c "run_all.sh"
