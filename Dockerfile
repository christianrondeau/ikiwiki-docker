FROM debian:jessie

MAINTAINER Nicolas Marchildon

RUN apt-get update && apt-get install -y ikiwiki python apache2 wget expect
#RUN apt-get clean

RUN useradd -m ikiwiki

WORKDIR /home/ikiwiki
USER ikiwiki
RUN git config --global user.email "you@example.com" && \
  git config --global user.name "Your Name"

RUN wget --no-proxy https://raw.githubusercontent.com/ewann/ikiwiki-docker/master/install-script.exp && \
  /bin/chmod +x install-script.exp && \
  export USER=ikiwiki && \
  ./install-script.exp && \
  ikiwiki --changesetup wikiwiki.setup --plugin 404 && \
  ikiwiki --setup wikiwiki.setup  

USER root
RUN a2dismod mpm_event && a2enmod mpm_prefork && a2dismod cgid # && service apache2 restart
RUN a2enmod cgi && a2enmod userdir # && service apache2 restart
RUN echo 'AddHandler cgi-script .cgi' >> /etc/apache2/apache2.conf
RUN echo '\
<VirtualHost *:80>\n\
    ServerName example.ikiwiki.info:80\n\
    DocumentRoot /home/ikiwiki/public_html/wikiwiki\n\
    <Directory /home/ikiwiki/public_html/wikiwiki>\n\
        Options Indexes MultiViews ExecCGI\n\
        AllowOverride None\n\
        Require all granted\n\
    </Directory>\n\
    ScriptAlias /ikiwiki.cgi /home/ikiwiki/public_html/wikiwiki/ikiwiki.cgi\n\
    ErrorDocument 404 "/ikiwiki.cgi"\n\
</VirtualHost>\n\
' > /etc/apache2/sites-available/000-default.conf

CMD /usr/sbin/apache2ctl -D FOREGROUND
EXPOSE 80

