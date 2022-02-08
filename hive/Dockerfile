FROM nicholas/hadoop-base:master

MAINTAINER Nicholas H. Park <nicholas.hpark@gmail.com>

HEALTHCHECK CMD curl -f http://localhost:10000/ || exit 1

#INSTALL HADOOP ECO
#HIVE
RUN curl -O dlcdn.apache.org/hive/KEYS
RUN gpg --import KEYS
ENV HIVE_VERSION 3.1.2
ENV HIVE_URL dlcdn.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz

RUN set -x \
    && curl -fSL "$HIVE_URL" -o /tmp/hive.tar.gz \
    && curl -fSL "$HIVE_URL.asc" -o /tmp/hive.tar.gz.asc \
    && gpg --verify /tmp/hive.tar.gz.asc \
    && tar -xvf /tmp/hive.tar.gz -C /opt/ \
    && rm /tmp/hive.tar.gz*

RUN ln -s /opt/apache-hive-$HIVE_VERSION-bin/conf /etc/hive

RUN mkdir /opt/apache-hive-$HIVE_VERSION-bin/logs

ENV HIVE_HOME=/opt/apache-hive-$HIVE_VERSION-bin
ENV HIVE_CONF_DIR=/etc/hive
ENV PATH $HIVE_HOME/bin/:$PATH

ENV MYSQL_CONNECT_URL downloads.mysql.com/archives/get/p/3/file/mysql-connector-java-5.1.46.tar.gz
RUN set -x \
    && curl -fSLk "$MYSQL_CONNECT_URL" -o /tmp/mysql-connector-java.tar.gz \
    && tar -xvf /tmp/mysql-connector-java.tar.gz -C /opt/ \
    && rm /tmp/mysql-connector-java.tar.gz* \
    && mv /opt/mysql-connector-java-5.1.46/mysql-connector-java-5.1.46.jar /opt/apache-hive-$HIVE_VERSION-bin/lib/ \
    && mv /opt/mysql-connector-java-5.1.46/mysql-connector-java-5.1.46-bin.jar /opt/apache-hive-$HIVE_VERSION-bin/lib/ \
    && rm -rf /opt/mysql-connector-java-5.1.46 \
    && mv /opt/apache-hive-$HIVE_VERSION-bin/lib/guava-19.0.jar /opt/apache-hive-$HIVE_VERSION-bin/lib/guava-19.0.jar.bak \
    && cp /opt/hadoop-$HADOOP_VERSION/share/hadoop/common/lib/guava-27.0-jre.jar /opt/apache-hive-$HIVE_VERSION-bin/lib/

ADD hive-site.xml /etc/hive/hive-site.xml

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 10000

CMD ["/run.sh"]
