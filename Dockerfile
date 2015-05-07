FROM centos
ENV HOME /root
ADD . /root/registry-deploy
RUN yum update -y
RUN yum install -y epel-release
RUN yum install -y git maven curl openjdk-7-jdk wget nginx tar
RUN chkconfig nginx on
RUN mkdir -p /opt/ldregistry /var/opt/ldregistry /var/log/ldregistry /var/opt/nginx/cache
RUN wget https://s3-eu-west-1.amazonaws.com/ukgovld/release/com/github/ukgovld/registry-core/0.0.5/registry-core-0.0.5.war
RUN cp -R ~/registry-deploy/ldregistry/* /opt/ldregistry
RUN cp  ~/registry-deploy/proxy-redirectError.conf /var/opt/ldregistry
RUN cat ~/registry-deploy/install/nginx.logrotate.conf >> /etc/logrotate.conf
RUN cp ~/registry-deploy/install/nginx.conf /etc/nginx/conf.d/localhost.conf
#RUN cp ~/registry-deploy/install/sudoers.conf /etc/sudoers.d/ldregistry

#install tomcat
#-------------- TOMCAT  ----------------------------

#manual install of tomcat7
ENV TOMCAT_MAJOR_VERSION 7
ENV TOMCAT_MINOR_VERSION 7.0.55
ENV CATALINA_HOME /opt/tomcat7

RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
   tar zxf apache-tomcat-*.tar.gz && \
   rm apache-tomcat-*.tar.gz && \
   mv apache-tomcat* ${CATALINA_HOME}

ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
ADD tomcat_run.sh /tomcat_run.sh

RUN rm -rf ${CATALINA_HOME}/webapps/* 
RUN chown -R root /opt/ldregistry /var/opt/ldregistry /var/log/ldregistry
RUN cp registry-core-0.0.5.war ${CATALINA_HOME}/webapps/ROOT.war

#RUN rm /etc/nginx/sites-available/default 

#supervisord
RUN yum install -y supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisord.conf

RUN chmod +x /*.sh
CMD ["/usr/bin/supervisord"]

EXPOSE 22
EXPOSE 8080
EXPOSE 80

