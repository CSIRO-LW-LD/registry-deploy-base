FROM  phusion/baseimage
ADD . /root/registry-deploy
RUN /usr/sbin/enable_insecure_key
RUN apt-get update
RUN apt-get install -y --no-install-recommends git maven curl tomcat7 openjdk-7-jdk
RUN mkdir -p /opt/ldregistry /var/opt/ldregistry /var/log/ldregistry
RUN git clone https://github.com/UKGovLD/registry-core.git ~/registry-core
RUN cp -R ~/registry-deploy/ldregistry/* /opt/ldregistry
RUN cd ~/registry-core && mvn clean package
RUN rm -rf /var/lib/tomcat7/webapps/* 
RUN chown -R tomcat7 /opt/ldregistry /var/opt/ldregistry /var/log/ldregistry
RUN cp ~/registry-core/target/registry*.war /var/lib/tomcat7/webapps/ROOT.war
CMD ["/sbin/my_init"]
EXPOSE 22
EXPOSE 8080
EXPOSE 80

