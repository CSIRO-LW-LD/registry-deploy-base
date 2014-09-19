FROM  phusion/baseimage
ADD . /root/registry-deploy
RUN /usr/sbin/enable_insecure_key
RUN apt-get update
RUN apt-get install -y --no-install-recommends git maven curl tomcat7 openjdk-7-jdk wget nginx sysv-rc-conf
RUN sysv-rc-conf tomcat7 on
RUN sysv-rc-conf nginx on
RUN mkdir -p /opt/ldregistry /var/opt/ldregistry /var/log/ldregistry /var/opt/nginx/cache
RUN wget https://s3-eu-west-1.amazonaws.com/ukgovld/release/com/github/ukgovld/registry-core/0.0.5/registry-core-0.0.5.war
RUN cp -R ~/registry-deploy/ldregistry/* /opt/ldregistry
RUN cat ~/registry-deploy/install/nginx.logrotate.conf >> /etc/logrotate.conf
RUN cp ~/registry-deploy/install/nginx.conf /etc/nginx/conf.d/localhost.conf
RUN cp ~/registry-deploy/install/sudoers.conf /etc/sudoers.d/ldregistry
RUN find /opt/ldregistry/ -type f -exec sed -i 's/Environment Registry/CSIRO Test Registry/g' {} \;
RUN rm -rf /var/lib/tomcat7/webapps/* 
RUN chown -R tomcat7 /opt/ldregistry /var/opt/ldregistry /var/log/ldregistry
RUN cp registry-core-0.0.5.war /var/lib/tomcat7/webapps/ROOT.war
CMD ["/sbin/my_init"]
EXPOSE 22
EXPOSE 8080
EXPOSE 80

