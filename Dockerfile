FROM php:8.2-apache

# 1. Desativa os MPMs conflitantes e garante que o correto esteja ativo
RUN a2dismod mpm_event mpm_worker && a2enmod mpm_prefork

# 2. Instala as extensões do PHP
RUN docker-php-ext-install mysqli pdo pdo_mysql

# 3. Ativa a reescrita de URL
RUN a2enmod rewrite

# 4. Define o document root (diretório raiz)
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf

# 5. Copia os arquivos e ajusta as permissões
COPY . /var/www/html/
COPY apache.conf /etc/apache2/conf-available/custom.conf
RUN a2enconf custom
RUN chown -R www-data:www-data /var/www/html