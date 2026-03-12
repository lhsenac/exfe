FROM php:8.2-apache

# 1. Desativa MPMs concorrentes de forma segura (ignora erro se não existirem) e ativa o prefork
RUN a2dismod -f mpm_event mpm_worker || true \
    && a2enmod mpm_prefork || true

# 2. Instala as extensões do PHP
RUN docker-php-ext-install mysqli pdo pdo_mysql

# 3. Ativa a reescrita de URL
RUN a2enmod rewrite

# 4. Define o document root corretamente em todos os arquivos do Apache
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 5. Copia os arquivos e ajusta configurações personalizadas
COPY . /var/www/html/
COPY apache.conf /etc/apache2/conf-available/custom.conf
RUN a2enconf custom

# 6. Ajusta permissões
RUN chown -R www-data:www-data /var/www/html