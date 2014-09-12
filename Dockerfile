FROM  phusion/baseimage
ADD . /root/registry-deploy
RUN /usr/sbin/enable_insecure_key
RUN apt-get update
RUN apt-get install -y --no-install-recommends git maven curl tomcat7 openjdk-7-jdk wget
RUN mkdir -p /opt/ldregistry /var/opt/ldregistry /var/log/ldregistry
RUN wget https://s3-eu-west-1.amazonaws.com/ukgovld/release/com/github/ukgovld/registry-core/0.0.5/registry-core-0.0.5.war
RUN cp -R ~/registry-deploy/ldregistry/* /opt/ldregistry
RUN rm -rf /var/lib/tomcat7/webapps/* 
RUN chown -R tomcat7 /opt/ldregistry /var/opt/ldregistry /var/log/ldregistry
RUN cp registry-core-0.0.5.war /var/lib/tomcat7/webapps/ROOT.war
CMD ["/sbin/my_init"]
EXPOSE 22
EXPOSE 8080
EXPOSE 80

