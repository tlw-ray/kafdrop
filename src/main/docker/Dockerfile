FROM openjdk:12.0.1-jdk-oraclelinux7

ADD kafdrop.sh /
ADD dcs-kafka-ui*tar.gz /

RUN chmod +x /kafdrop.sh

ENTRYPOINT ["/kafdrop.sh"]
