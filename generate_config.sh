#!/bin/bash

# Generate config files for gigadb-website application using sed
source /vagrant/yii2-laradock/.env

cp /vagrant/chef/site-cookbooks/gigadb/templates/default/yii-index.php.erb /vagrant/index.php
sed -i "/<% path = node\[:yii\]\[:path\] -%>/d" /vagrant/index.php \
    && sed -i "s|<%= path %>|${YII_PATH}|g" /vagrant/index.php

cp /vagrant/chef/site-cookbooks/gigadb/templates/default/yiic.php.erb /vagrant/protected/yiic.php
sed -i "/<% path = node\[:yii\]\[:path\] -%>/d" /vagrant/protected/yiic.php \
    && sed -i "s|<%= path %>|${YII_PATH}|g" /vagrant/protected/yiic.php

cp /vagrant/chef/site-cookbooks/gigadb/templates/default/yii-local.php.erb /vagrant/protected/config/local.php
sed -i "/<% home_url = node\[:gigadb\]\[:server_names\] -%>/d" /vagrant/protected/config/local.php \
    && sed -i "/<% server_email = node\[:gigadb\]\[:admin_email\] -%>/d" /vagrant/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:mailchimp\]\[:mailchimp_api_key\] %>|${MAILCHIMP_API_KEY}|g" /vagrant/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:mailchimp\]\[:mailchimp_list_id\] %>|${MAILCHIMP_LIST_ID}|g" /vagrant/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:analytics\]\[:analytics_client_email\] %>|${ANALYTICS_CLIENT_EMAIL}|g" /vagrant/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:analytics\]\[:analytics_client_id\] %>|${ANALYTICS_CLIENT_ID}|g" /vagrant/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:analytics\]\[:analytics_keyfile_path\] %>|${ANALYTICS_KEYFILE_PATH}|g" /vagrant/protected/config/local.php \
    && sed -i "s|<%= home_url %>|${HOME_URL}|g" /vagrant/protected/config/local.php \
    && sed -i "s|<%= home_url %>|${SERVER_EMAIL}|g" /vagrant/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:recaptcha\]\[:recaptcha_publickey\] %>|${RECAPTCHA_PUBLICKEY}|g" /vagrant/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:recaptcha\]\[:recaptcha_privatekey\] %>|${RECAPTCHA_PRIVATEKEY}|g" /vagrant/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:analytics\]\[:google_analytics_profile\] %>|${GOOGLE_ANALYTICS_PROFILE}|g" /vagrant/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:mds\]\[:mds_username\] %>|${MDS_USERNAME}|g" /vagrant/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:mds\]\[:mds_password\] %>|${MDS_PASSWORD}|g" /vagrant/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:mds\]\[:mds_prefix\] %>|${MDS_PREFIX}|g" /vagrant/protected/config/local.php

cp /vagrant/chef/site-cookbooks/gigadb/templates/default/yii-main.php.erb /vagrant/protected/config/main.php
sed -i "s|<%= node\[:gigadb\]\[:facebook\]\[:app_id\] %>|${FACEBOOK_APP_ID}|g" /vagrant/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:facebook\]\[:app_secret\] %>|${FACEBOOK_APP_SECRET}|g" /vagrant/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:linkedin\]\[:api_key\] %>|${LINKEDIN_API_KEY}|g" /vagrant/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:linkedin\]\[:secret_key\] %>|${LINKEDIN_SECRET_KEY}|g" /vagrant/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:google\]\[:client_id\] %>|${GOOGLE_CLIENT_ID}|g" /vagrant/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:google\]\[:client_secret\] %>|${GOOGLE_SECRET}|g" /vagrant/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:twitter\]\[:key\] %>|${TWITTER_KEY}|g" /vagrant/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:twitter\]\[:secret\] %>|${TWITTER_SECRET}|g" /vagrant/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:orcid\]\[:client_id\] %>|${ORCID_CLIENT_ID}|g" /vagrant/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:orcid\]\[:client_secret\] %>|${ORCID_CLIENT_SECRET}|g" /vagrant/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:ftp\]\[:connection_url\] %>|${FTP_CONNECTION_URL}|g" /vagrant/protected/config/main.php

cp /vagrant/chef/site-cookbooks/gigadb/templates/default/yii-db.json.erb /vagrant/protected/config/db.json
sed -i "/<% db = node\[:gigadb\]\[:db\] -%>/d" /vagrant/protected/config/db.json \
    && sed -i "s|<%= db\[:database\] %>|gigadb|g" /vagrant/protected/config/db.json \
    && sed -i "s|<%= db\[:host\] %>|${GIGADB_HOST}|g" /vagrant/protected/config/db.json \
    && sed -i "s|<%= db\[:user\] %>|${GIGADB_USER}|g" /vagrant/protected/config/db.json \
    && sed -i "s|<%= db\[:password\] %>|${GIGADB_PASSWORD}|g" /vagrant/protected/config/db.json

cp /vagrant/chef/site-cookbooks/gigadb/templates/default/set_env.sh.erb /vagrant/protected/scripts/set_env.sh
sed -i "/<% db = node\[:gigadb\]\[:db\] -%>/d" /vagrant/protected/scripts/set_env.sh \
    && sed -i "s|<%= db\[:database\] %>|${GIGADB_DATABASE}|g" /vagrant/protected/scripts/set_env.sh \
    && sed -i "s|<%= db\[:host\] %>|${GIGADB_HOST}|g" /vagrant/protected/scripts/set_env.sh \
    && sed -i "s|<%= db\[:user\] %>|${GIGADB_USER}|g" /vagrant/protected/scripts/set_env.sh \
    && sed -i "s|<%= db\[:password\] %>|${GIGADB_PASSWORD}|g" /vagrant/protected/scripts/set_env.sh

cp /vagrant/chef/site-cookbooks/gigadb/templates/default/es.json.erb /vagrant/protected/config/es.json
sed -i "s|<%= node\[:gigadb\]\[:es_port\] %>|${GIGADB_ES_PORT}|g" /vagrant/protected/config/es.json

cp /vagrant/chef/site-cookbooks/gigadb/templates/default/update_links.sh.erb /vagrant/protected/scripts/update_links.sh
sed -i "s|<%= node\[:gigadb\]\[:db\]\[:password\] %>|${GIGADB_PASSWORD}|g" /vagrant/protected/scripts/update_links.sh

cp /vagrant/chef/site-cookbooks/gigadb/templates/default/yii-help.html.erb /vagrant/files/html/help.html
sed -i "/<% path = node\[:yii\]\[:ip_address\] -%>/d" /vagrant/files/html/help.html \
    && sed -i "s|<%= path %>|${HOME_URL}|g" /vagrant/files/html/help.html

# Download Yii version 1
mkdir -p ${YII_PATH}
git clone git://github.com/yiisoft/yii.git -b master ${YII_PATH}

# Generate site.css
/vagrant/protected/yiic lesscompiler