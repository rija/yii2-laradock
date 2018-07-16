FROM laradock/php-fpm:2.2-5.6

RUN pecl install xhprof-0.9.4 mongo-1.6.16\
    && docker-php-ext-enable xhprof \
    && docker-php-ext-enable mongo

EXPOSE 9000
