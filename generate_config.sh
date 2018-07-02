#!/bin/bash

# read env variables in same directory. 
# They are shared by both this script and Docker compose files, so .env has to stay in yii2-laradock with this script.
echo "Current working directory: $PWD"
if ! [ -f  ./.env ];then
    echo "ERROR: There is no .env file in this directory. Cannot run the configuration."
    echo "Please, switch to a directory with an .env file before running the configuration"
    exit 1
fi
source "./.env"
echo "Yii path: ${YII_PATH}"
echo "Application path: ${APPLICATION}"
echo "COMPOSE_PROJECT_NAME: ${COMPOSE_PROJECT_NAME}"
if ! [ -f  docker-compose.yml ];then
    echo "INFO: There is no docker-compose.yml file in this directory."
    echo "You must use the '-f' option on docker-compose and specify the path to a valid docker-compose file."
fi

# do the stuff that vagrant would normally do. Even if vagrant is used, doing this stuff regardless is still ok.
mkdir -p ${APPLICATION}/protected/runtime
mkdir -p ${APPLICATION}/assets
mkdir -p ${APPLICATION}/images/tempcaptcha
chmod 777 ${APPLICATION}/protected/runtime
chmod 777 ${APPLICATION}/assets
chmod 777 ${APPLICATION}/images/tempcaptcha

# Generate nginx site config

mkdir -p ${DATA_SAVE_PATH}/nginx/sites-available
sed "s|192.168.42.10|${HOME_URL}" ${NGINX_SITES_PATH}/gigadb.conf > ${DATA_SAVE_PATH}/nginx/sites-available/${APPLICATION}.conf

# Generate config files for gigadb-website application using sed

cp ${APPLICATION}/chef/site-cookbooks/gigadb/templates/default/yii-aws.json.erb ${APPLICATION}/protected/config/aws.json \
	&& sed -i "/<% aws = node\[:aws\] -%>/d" ${APPLICATION}/protected/config/aws.json \
    && sed -i "s|<%= aws\[:aws_access_key_id\] %>|${AWS_ACCESS_KEY_ID}|g" ${APPLICATION}/protected/config/aws.json \
    && sed -i "s|<%= aws\[:aws_secret_access_key\] %>|${AWS_SECRET_ACCESS_KEY}|g" ${APPLICATION}/protected/config/aws.json \
    && sed -i "s|<%= aws\[:s3_bucket_for_file_bundles\] %>|${AWS_S3_BUCKET_FOR_FILE_BUNDLES}|g" ${APPLICATION}/protected/config/aws.json \
    && sed -i "s|<%= aws\[:s3_bucket_for_file_previews\] %>|${AWS_S3_BUCKET_FOR_FILE_PREVIEWS}|g" ${APPLICATION}/protected/config/aws.json \
    && sed -i "s|<%= aws\[:aws_default_region\] %>|${AWS_DEFAULT_REGION}|g" ${APPLICATION}/protected/config/aws.json

cp ${APPLICATION}/chef/site-cookbooks/gigadb/templates/default/yii-console.php.erb ${APPLICATION}/protected/config/console.php \
	&& sed -i "s|<%= node\[:gigadb\]\[:mfr\]\[:preview_server\] %>|${PREVIEW_SERVER_HOST}|g" ${APPLICATION}/protected/config/console.php \
    && sed -i "s|<%= node\[:gigadb\]\[:ftp\]\[:connection_url\] %>|${FTP_CONNECTION_URL}|g" ${APPLICATION}/protected/config/console.php \
    && sed -i "s|<%= node\[:gigadb\]\[:multidownload\]\[:download_host\] %>|${MULTIDOWNLOAD_SERVER_HOST}|g" ${APPLICATION}/protected/config/console.php \
    && sed -i "s|<%= node\[:gigadb\]\[:redis\]\[:server\] %>|${REDIS_SERVER_HOST}|g" ${APPLICATION}/protected/config/console.php \
    && sed -i "s|<%= node\[:gigadb\]\[:beanstalk\]\[:host\] %>|${BEANSTALK_SERVER_HOST}|g" ${APPLICATION}/protected/config/console.php

cp ${APPLICATION}/chef/site-cookbooks/gigadb/templates/default/yii-index.php.erb ${APPLICATION}/index.php \
	&& sed -i "/<% path = node\[:yii\]\[:path\] -%>/d" ${APPLICATION}/index.php \
    && sed -i "s|<%= path %>|${YII_PATH}|g" ${APPLICATION}/index.php

cp ${APPLICATION}/chef/site-cookbooks/gigadb/templates/default/yiic.php.erb ${APPLICATION}/protected/yiic.php \
	&& sed -i "/<% path = node\[:yii\]\[:path\] -%>/d" ${APPLICATION}/protected/yiic.php \
    && sed -i "s|<%= path %>|${YII_PATH}|g" ${APPLICATION}/protected/yiic.php

cp ${APPLICATION}/chef/site-cookbooks/gigadb/templates/default/yii-local.php.erb ${APPLICATION}/protected/config/local.php \
	&& sed -i "/<% home_url = node\[:gigadb\]\[:server_names\] -%>/d" ${APPLICATION}/protected/config/local.php \
    && sed -i "/<% server_email = node\[:gigadb\]\[:admin_email\] -%>/d" ${APPLICATION}/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:mailchimp\]\[:mailchimp_api_key\] %>|${MAILCHIMP_API_KEY}|g" ${APPLICATION}/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:mailchimp\]\[:mailchimp_list_id\] %>|${MAILCHIMP_LIST_ID}|g" ${APPLICATION}/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:analytics\]\[:analytics_client_email\] %>|${ANALYTICS_CLIENT_EMAIL}|g" ${APPLICATION}/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:analytics\]\[:analytics_client_id\] %>|${ANALYTICS_CLIENT_ID}|g" ${APPLICATION}/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:analytics\]\[:analytics_keyfile_path\] %>|${ANALYTICS_KEYFILE_PATH}|g" ${APPLICATION}/protected/config/local.php \
    && sed -i "s|<%= home_url %>|${HOME_URL}|g" ${APPLICATION}/protected/config/local.php \
    && sed -i "s|<%= home_url %>|${SERVER_EMAIL}|g" ${APPLICATION}/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:recaptcha\]\[:recaptcha_publickey\] %>|${RECAPTCHA_PUBLICKEY}|g" ${APPLICATION}/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:recaptcha\]\[:recaptcha_privatekey\] %>|${RECAPTCHA_PRIVATEKEY}|g" ${APPLICATION}/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:analytics\]\[:google_analytics_profile\] %>|${GOOGLE_ANALYTICS_PROFILE}|g" ${APPLICATION}/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:mds\]\[:mds_username\] %>|${MDS_USERNAME}|g" ${APPLICATION}/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:mds\]\[:mds_password\] %>|${MDS_PASSWORD}|g" ${APPLICATION}/protected/config/local.php \
    && sed -i "s|<%= node\[:gigadb\]\[:mds\]\[:mds_prefix\] %>|${MDS_PREFIX}|g" ${APPLICATION}/protected/config/local.php

cp ${APPLICATION}/chef/site-cookbooks/gigadb/templates/default/yii-main.php.erb ${APPLICATION}/protected/config/main.php \
	&& sed -i "s|<%= node\[:gigadb\]\[:facebook\]\[:app_id\] %>|${FACEBOOK_APP_ID}|g" ${APPLICATION}/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:facebook\]\[:app_secret\] %>|${FACEBOOK_APP_SECRET}|g" ${APPLICATION}/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:linkedin\]\[:api_key\] %>|${LINKEDIN_API_KEY}|g" ${APPLICATION}/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:linkedin\]\[:secret_key\] %>|${LINKEDIN_SECRET_KEY}|g" ${APPLICATION}/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:google\]\[:client_id\] %>|${GOOGLE_CLIENT_ID}|g" ${APPLICATION}/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:google\]\[:client_secret\] %>|${GOOGLE_SECRET}|g" ${APPLICATION}/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:twitter\]\[:key\] %>|${TWITTER_KEY}|g" ${APPLICATION}/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:twitter\]\[:secret\] %>|${TWITTER_SECRET}|g" ${APPLICATION}/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:orcid\]\[:client_id\] %>|${ORCID_CLIENT_ID}|g" ${APPLICATION}/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:orcid\]\[:client_secret\] %>|${ORCID_CLIENT_SECRET}|g" ${APPLICATION}/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:ftp\]\[:connection_url\] %>|${FTP_CONNECTION_URL}|g" ${APPLICATION}/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:redis\]\[:server\] %>|${REDIS_SERVER_HOST}|g" ${APPLICATION}/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:beanstalk\]\[:host\] %>|${BEANSTALK_SERVER_HOST}|g" ${APPLICATION}/protected/config/main.php \
    && sed -i "s|<%= node\[:gigadb\]\[:mfr\]\[:preview_server\] %>|${PREVIEW_SERVER_HOST}|g" ${APPLICATION}/protected/config/main.php

cp ${APPLICATION}/chef/site-cookbooks/gigadb/templates/default/yii-db.json.erb ${APPLICATION}/protected/config/db.json \
	&& sed -i "/<% db = node\[:gigadb\]\[:db\] -%>/d" ${APPLICATION}/protected/config/db.json \
    && sed -i "s|<%= db\[:database\] %>|gigadb|g" ${APPLICATION}/protected/config/db.json \
    && sed -i "s|<%= db\[:host\] %>|${GIGADB_HOST}|g" ${APPLICATION}/protected/config/db.json \
    && sed -i "s|<%= db\[:user\] %>|${GIGADB_USER}|g" ${APPLICATION}/protected/config/db.json \
    && sed -i "s|<%= db\[:password\] %>|${GIGADB_PASSWORD}|g" ${APPLICATION}/protected/config/db.json

cp ${APPLICATION}/chef/site-cookbooks/gigadb/templates/default/set_env.sh.erb ${APPLICATION}/protected/scripts/set_env.sh \
	&& sed -i "/<% db = node\[:gigadb\]\[:db\] -%>/d" ${APPLICATION}/protected/scripts/set_env.sh \
    && sed -i "s|<%= db\[:database\] %>|${GIGADB_DATABASE}|g" ${APPLICATION}/protected/scripts/set_env.sh \
    && sed -i "s|<%= db\[:host\] %>|${GIGADB_HOST}|g" ${APPLICATION}/protected/scripts/set_env.sh \
    && sed -i "s|<%= db\[:user\] %>|${GIGADB_USER}|g" ${APPLICATION}/protected/scripts/set_env.sh \
    && sed -i "s|<%= db\[:password\] %>|${GIGADB_PASSWORD}|g" ${APPLICATION}/protected/scripts/set_env.sh

cp ${APPLICATION}/chef/site-cookbooks/gigadb/templates/default/es.json.erb ${APPLICATION}/protected/config/es.json \
	&& sed -i "s|<%= node\[:gigadb\]\[:es_port\] %>|${GIGADB_ES_PORT}|g" ${APPLICATION}/protected/config/es.json

cp ${APPLICATION}/chef/site-cookbooks/gigadb/templates/default/update_links.sh.erb ${APPLICATION}/protected/scripts/update_links.sh \
	&& sed -i "s|<%= node\[:gigadb\]\[:db\]\[:password\] %>|${GIGADB_PASSWORD}|g" ${APPLICATION}/protected/scripts/update_links.sh

cp ${APPLICATION}/chef/site-cookbooks/gigadb/templates/default/yii-help.html.erb ${APPLICATION}/files/html/help.html \
	&& sed -i "/<% path = node\[:yii\]\[:ip_address\] -%>/d" ${APPLICATION}/files/html/help.html \
    && sed -i "s|<%= path %>|${HOME_URL}|g" ${APPLICATION}/files/html/help.html

# Download Yii version 1
if ! [ -f  yii-1.1.16.tar.gz ];then
	curl -o yii-1.1.16.tar.gz -L https://github.com/yiisoft/yii/releases/download/1.1.16/yii-1.1.16.bca042.tar.gz
	tar xvzf yii-1.1.16.tar.gz --directory /opt/ --transform 's/yii-1.1.16.bca042/yii-1.1.16/'
fi

# Generate site.css
${APPLICATION}/protected/yiic lesscompiler

# Download example dataset files
mkdir -p ${APPLICATION}/vsftpd/files
if ! [ -f ${APPLICATION}/vsftpd/files/ftpexamples4.tar.gz ]; then
  curl -o ${APPLICATION}/vsftpd/files/ftpexamples4.tar.gz https://s3-ap-southeast-1.amazonaws.com/gigadb-ftp-sample-data/ftpexamples4.tar.gz
fi
files_count=$(ls -1 ${APPLICATION}/yii2-laradock/vsftpd/files | wc -l)
if ! [ $files_count -eq 11 ]; then
  tar -xzvf ${APPLICATION}/vsftpd/files/ftpexamples4.tar.gz -C ${APPLICATION}/vsftpd/files
fi
