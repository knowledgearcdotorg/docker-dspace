FROM knowledgearcdotorg/tomcat

ENV DSPACE_VERSION 5.6

RUN apt-get update && \
    apt-get install -y wget postgresql-client maven default-jdk && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /opt/dspace
RUN chown tomcat: /opt/dspace

WORKDIR /opt/dspace

USER tomcat

RUN mkdir -p /opt/dspace/build

RUN wget -O /opt/dspace/build/dspace.tar.gz https://github.com/DSpace/DSpace/releases/download/dspace-$DSPACE_VERSION/dspace-$DSPACE_VERSION-release.tar.gz

RUN tar -xzf ./build/dspace.tar.gz --strip-components=1 -C ./build

RUN cd ./build/ && mvn package

RUN sed -i s/dspace\.dir\\\s=\\\s.*/dspace\.dir\ =\ \\\/opt\\\/dspace/ ./build/dspace/target/dspace-installer/config/dspace.cfg

RUN cd ./build/dspace/target/dspace-installer && ant install_code update_webapps update_geolite

RUN rm -Rf ./build

USER root

#COPY docker-entrypoint.sh /usr/local/bin/
#RUN chmod 750 /usr/local/bin/docker-entrypoint.sh
#ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

