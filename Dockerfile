FROM centos:7

RUN yum -y install epel-release 
RUN yum -y install python-pip && pip install --upgrade pip setuptools
RUN yum -y install git \
 libffi-devel.x86_64 gcc-c++.x86_64 \
 python-devel.x86_64 openssl-devel \
 libxml2-devel.x86_64 libxslt-devel.x86_64  libcurl-devel.x86_64

RUN pip install git+https://github.com/CanDIG/ga4gh-schemas.git@authz#egg=ga4gh_schemas  git+https://github.com/CanDIG/ga4gh-client.git@authz#egg=ga4gh_client git+https://github.com/CanDIG/ga4gh-server.git@authz#egg=ga4gh_server  git+https://github.com/CanDIG/PROFYLE_ingest.git@authz#egg=PROFYLE_ingest requests==2.7.0 gunicorn
WORKDIR /usr/lib/python2.7/site-packages/ga4gh
RUN mkdir -p server/templates && touch server/templates/initial_peers.txt && mkdir ga4gh-example-data
COPY clinical_metadata_tier.json1 /tmp/.
RUN mkdir /etc/ga4gh && chmod 777 /etc/ga4gh
RUN PROFYLE_ingest ga4gh-example-data/registry.db clinical_metadata_tier /tmp/clinical_metadata_tier.json1
RUN pip install gevent
COPY ga4gh_server_gunicorn.py /usr/lib/python2.7/site-packages/ga4gh/server/cli/server.py
EXPOSE 80
ENTRYPOINT ["ga4gh_server"]
CMD ["-c", "TykConfig", "--host", "0.0.0.0", "--port", "80", "--workers", "2"]
