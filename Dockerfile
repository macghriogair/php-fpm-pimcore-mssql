FROM basilicom/php-fpm-pimcore:7.2-pimcore-5.8.1

LABEL maintainer "Patrick Mac Gregor <macgregor.porta@gmail.com>"

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN (apt-get update || exit 0;)
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql mssql-tools unixodbc-dev
RUN yes "" | pecl install -f sqlsrv
RUN yes "" | pecl install -f pdo_sqlsrv
RUN echo "extension=sqlsrv" > /usr/local/etc/php/conf.d/docker-php-ext-mssql.ini
RUN echo "extension=pdo_sqlsrv" >> /usr/local/etc/php/conf.d/docker-php-ext-mssql.ini

# Can't open lib '/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.3.so.1.1' : file not found
RUN wget "http://security-cdn.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u11_amd64.deb" \
    && apt-get install -y ./libssl1.0.0_1.0.1t-1+deb8u11_amd64.deb

RUN apt install supervisor -y

USER www-data

CMD ["php-fpm"]
