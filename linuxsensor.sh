#!/bin/bash

##################################################################

# These are the parameters you need to set on this script:

# 1) You need to enter your API Client ID and Secret here. 
#    If you don't have one, create it on the Crowdstrike Falcon webconsole, under the "Support" menu - "API clients and keys". You need to give at least the "Read" permission on the "Sensor Download" api scope.

# Set here your Client ID and Client Secret
export FALCON_CLIENT_ID="69707d09cb48426b81e44ec619c3c7ee"
export FALCON_CLIENT_SECRET="XE7JWq0PHu2zwdj4sYlQ13MCv6ontZ8Gk5KVmIU9"


# 2) Set here your cloud api address:
target_cloud_api="api.crowdstrike.com"
#
# 	Possible values:
# 		US-GOV-1: api.laggar.gcw.crowdstrike.com
# 		EU-1: api.eu-1.crowdstrike.com
# 		US-2: api.us-2.crowdstrike.com


installation_folder="/tmp/"


####################################################################
# Successfully tested on: 
#                          Oracle Linux v7.9
#			   Debian 9
#                          Amazon Linux v2
#                          Ubuntu 18.04
#			   Centos 7.9
#                          Suse Enterprise Linux ????????
#			   Red Hat Enterprise Linux ===> Not tested but should work.
#			   Amazon Linux v1 ??????????????
#
#####################################################################

registrar () {
echo ""
echo "Registrando seu CID"
/opt/CrowdStrike/falconctl -s -f --cid="$meu_CID"
echo "Sensor registrado com sucesso."
echo ""

echo "Starting the Falcon Service"
systemctl start falcon-sensor
service falcon-sensor start
echo ""
echo ""
ps -aux | grep falcon-sensor
echo ""
echo ""
echo "Processo completado"
}


## ==> STEP 0 - Verify if the sensor is already installed and then stop the execution.
if ls /opt | grep CrowdStrike; then
	echo ""
	echo "Falcon Sensor is already installed. Exiting!"
	echo ""
	exit 1
fi


clear




## ==> STEP 1 - Get an access token
echo "##################################"
echo "Step 1 - Trying to obtain an Access Token to" $target_cloud_api
echo "##################################"
meu_token=$(curl -X POST "https://$target_cloud_api/oauth2/token" -H  "accept: application/json" -H  "Content-Type: application/x-www-form-urlencoded" -d "client_id=$FALCON_CLIENT_ID&client_secret=$FALCON_CLIENT_SECRET" | sed 's/"access_token": //' | grep -v { | grep -v "expires_in" | grep -v "token_type" | grep -v } | sed 's/"//' | sed 's/",//' | sed 's/ //')
echo ""
echo "##################################"
echo "Step 1 - Completed - Access Token was obtained"
echo "##################################"
echo ""
echo ""



## ==> STEP 2 - Get the CID (Customer Tenant ID)
meu_CID=$(curl -X GET "https://$target_cloud_api/sensors/queries/installers/ccid/v1" -H  "accept: application/json" -H  "authorization: Bearer $meu_token" | grep -v { | grep -v } | grep -v "errors" | grep -v ] | grep -v "resources" | grep -v "trace_id" | grep -v "powered_by" | grep -v "query_time" | sed 's/"//' | sed 's/"//' | sed 's/ //' | tr -d ' ')

echo ""
echo "##################################"
echo "Step 2 - Completed - CID Found: "$meu_CID
echo "##################################"
echo ""
echo ""



## ==> STEP 3 - Identify which Linux installer we will need (RHEL, Ubuntu, Amazon Linux, Debian, etc)
echo "##################################"
echo "Starting Step 3 - identifying the linux version you are using"
echo ""
meu_linux=$(hostnamectl | grep System | sed  "s/  Operating System: //")
meu_linux2=$(uname -r)



echo "STEP 3 - Completed - Linux system is: "$meu_linux
echo "##################################"
echo ""
echo ""



## ==> STEP 4 - Download

echo ""
echo "##################################"
echo "Starting Step 4 - Sensor Download"
echo "##################################"




if [[ $meu_linux == *"Oracle Linux Server 6"*   ||  $meu_linux == *"Red Hat Enterprise Linux 6"* ||  $meu_linux == *"CentOS Linux 6"* ]]; then
	  sensor_RHEL_v6_OracleCentOSRedHat=$(curl -X GET "https://$target_cloud_api/sensors/combined/installers/v1?offset=0&limit=1&sort=release_date%7Cdesc&filter=os_version%3A%226%22" -H  "accept: application/json" -H  "authorization: Bearer $meu_token")
	  sha256=$(echo $sensor_RHEL_v6_OracleCentOSRedHat | cut -d ' ' -f32 | sed 's/"//' | sed 's/",//')
	  sensor_FileName=$(echo $sensor_RHEL_v6_OracleCentOSRedHat | cut -d ' ' -f17 | sed 's/"//' | sed 's/",//')
	  echo ""
	  echo "==> Downloading the sensor to the /tmp/ folder"
	  echo ""
	  curl -X GET "https://$target_cloud_api/sensors/entities/download-installer/v1?id=$sha256" -H  "accept: application/json" -H  "authorization: Bearer $meu_token" -o $installation_folder$sensor_FileName
	  yum install -y $installation_folder$sensor_FileName
	  registrar


elif [[ $meu_linux == *"Oracle Linux Server 7"*   ||  $meu_linux == *"Red Hat Enterprise Linux 7"* ||  $meu_linux == *"CentOS Linux 7"* ]]; then
	  sensor_RHEL_v7_OracleCentOSRedHat=$(curl -X GET "https://$target_cloud_api/sensors/combined/installers/v1?offset=0&limit=1&sort=release_date%7Cdesc&filter=os_version%3A%227%22" -H  "accept: application/json" -H  "authorization: Bearer $meu_token")
	  sha256=$(echo $sensor_RHEL_v7_OracleCentOSRedHat | cut -d ' ' -f32 | sed 's/"//' | sed 's/",//')
	  sensor_FileName=$(echo $sensor_RHEL_v7_OracleCentOSRedHat | cut -d ' ' -f17 | sed 's/"//' | sed 's/",//')
	  echo "Downloading the sensor to the /tmp/ folder"
	  curl -X GET "https://$target_cloud_api/sensors/entities/download-installer/v1?id=$sha256" -H  "accept: application/json" -H  "authorization: Bearer $meu_token" -o $installation_folder$sensor_FileName
	  yum install -y $installation_folder$sensor_FileName
	  registrar


elif [[ $meu_linux == *"Oracle Linux Server 8"*   ||  $meu_linux == *"Red Hat Enterprise Linux 8"* ||  $meu_linux == *"CentOS Linux 8"* ]]; then
	  sensor_RHEL_v8_OracleCentOSRedHat=$(curl -X GET "https://$target_cloud_api/sensors/combined/installers/v1? offset=0&limit=1&sort=release_date%7Cdesc&filter=os_version%3A%228%22" -H  "accept: application/json" -H  "authorization: Bearer $meu_token")
	  echo $sensor_RHEL_v8_OracleCentOSRedHat
	  echo ""
	  sha256=$(echo $sensor_RHEL_v8_OracleCentOSRedHat | cut -d ' ' -f32 | sed 's/"//' | sed 's/",//')
	  sensor_FileName=$(echo $sensor_RHEL_v8_OracleCentOSRedHat | cut -d ' ' -f17 | sed 's/"//' | sed 's/",//')
	  echo "Downloading the sensor to the /tmp/ folder"
	  curl -X GET "https://$target_cloud_api/sensors/entities/download-installer/v1?id=$sha256" -H  "accept: application/json" -H  "authorization: Bearer $meu_token" -o $installation_folder$sensor_FileName
	  yum install -y $installation_folder$sensor_FileName
	  registrar


elif [[ $meu_linux == *"Ubuntu"* ]]; then
	  sensor_ubuntu=$(curl -X GET "https://$target_cloud_api/sensors/combined/installers/v1?offset=0&limit=1&sort=release_date%7Cdesc&filter=os%3A%22Ubuntu%22" -H  "accept: application/json" -H  "authorization: Bearer $meu_token")
	  sha256=$(echo $sensor_ubuntu | cut -d ' ' -f35 | sed 's/"//' | sed 's/",//')
	  sensor_FileName=$(echo $sensor_ubuntu | cut -d ' ' -f17 | sed 's/"//' | sed 's/",//')
	  echo "Downloading the sensor to the /tmp/ folder"
	  curl -X GET "https://$target_cloud_api/sensors/entities/download-installer/v1?id=$sha256" -H  "accept: application/json" -H  "authorization: Bearer $meu_token" -o $installation_folder$sensor_FileName
	  dpkg -i $installation_folder$sensor_FileName
	  registrar


elif [[ $meu_linux == *"Debian GNU/Linux"* ]]; then
	  sensor_Debian=$(curl -X GET "https://$target_cloud_api/sensors/combined/installers/v1?offset=0&limit=1&sort=release_date%7Cdesc&filter=os%3A%22Debian%22" -H  "accept: application/json" -H  "authorization: Bearer $meu_token")
	  sha256=$(echo $sensor_Debian | cut -d ' ' -f33 | sed 's/"//' | sed 's/",//')
	  sensor_FileName=$(echo $sensor_Debian| cut -d ' ' -f17 | sed 's/"//' | sed 's/",//')
	  echo "Downloading the sensor to the /tmp/ folder"
	  curl -X GET "https://$target_cloud_api/sensors/entities/download-installer/v1?id=$sha256" -H  "accept: application/json" -H  "authorization: Bearer $meu_token" -o $installation_folder$sensor_FileName
	  apt --fix-broken install -y
	  dpkg -i $installation_folder$sensor_FileName
	  apt --fix-broken install -y
	  dpkg -i $installation_folder$sensor_FileName
	  registrar


elif [[ $meu_linux == *"SUSE Linux Enterprise Server 11"* ]]; then
	  sensor_SLES_11=$(curl -X GET "https://$target_cloud_api/sensors/combined/installers/v1?offset=0&limit=1&sort=release_date%7Cdesc&filter=os_version%3A%2211%22" -H  "accept: application/json" -H  "authorization: Bearer $meu_token")
	  sha256=$(echo $sensor_SLES_11 | cut -d ' ' -f32 | sed 's/"//' | sed 's/",//')
	  sensor_FileName=$(echo $sensor_SLES_11 | cut -d ' ' -f17 | sed 's/"//' | sed 's/",//')
	  echo "Downloading the sensor to the /tmp/ folder"
	  curl -X GET "https://$target_cloud_api/sensors/entities/download-installer/v1?id=$sha256" -H  "accept: application/json" -H  "authorization: Bearer $meu_token" -o $installation_folder$sensor_FileName
	  zypper install $installation_folder$sensor_FileName
	  registrar


elif [[ $meu_linux == *"SUSE Linux Enterprise Server 12"* ]]; then
	  sensor_SLES_12=$(curl -X GET "https://$target_cloud_api/sensors/combined/installers/v1?offset=0&limit=1&sort=release_date%7Cdesc&filter=os_version%3A%2212%22" -H  "accept: application/json" -H  "authorization: Bearer $meu_token")
	  sha256=$(echo $sensor_SLES_12 | cut -d ' ' -f32 | sed 's/"//' | sed 's/",//')
	  sensor_FileName=$(echo $sensor_SLES_12 | cut -d ' ' -f17 | sed 's/"//' | sed 's/",//')
	  echo ""
	  echo "Downloading the sensor to the /tmp/ folder"
	  echo ""
	  curl -X GET "https://$target_cloud_api/sensors/entities/download-installer/v1?id=$sha256" -H  "accept: application/json" -H  "authorization: Bearer $meu_token" -o $installation_folder$sensor_FileName
	  zypper install $installation_folder$sensor_FileName
	  registrar


elif [[ $meu_linux == *"SUSE Linux Enterprise Server 15"* ]]; then
	  sensor_SLES_15=$(curl -X GET "https://$target_cloud_api/sensors/combined/installers/v1?offset=0&limit=1&sort=release_date%7Cdesc&filter=os_version%3A%2215%22" -H  "accept: application/json" -H  "authorization: Bearer $meu_token")
	  sha256=$(echo $sensor_SLES_15 | cut -d ' ' -f32 | sed 's/"//' | sed 's/",//')
	  sensor_FileName=$(echo $sensor_SLES_15 | cut -d ' ' -f17 | sed 's/"//' | sed 's/",//')
	  echo "Downloading the sensor to the /tmp/ folder"
	  curl -X GET "https://$target_cloud_api/sensors/entities/download-installer/v1?id=$sha256" -H  "accept: application/json" -H  "authorization: Bearer $meu_token" -o $installation_folder$sensor_FileName
	  zypper install $installation_folder$sensor_FileName
	  registrar


elif [[ $meu_linux == *"Amazon Linux 2"* ]]; then
	  sensor_amazon_v2=$(curl -X GET "https://$target_cloud_api/sensors/combined/installers/v1?offset=0&limit=13&sort=release_date%7Cdesc&filter=os_version%3A%20%222%22" -H  "accept: application/json" -H  "authorization: Bearer $meu_token")
	  sha256=$(echo $sensor_amazon_v2 | cut -d ' ' -f32 | sed 's/"//' | sed 's/",//')
	  sensor_FileName=$(echo $sensor_amazon_v2 | cut -d ' ' -f17 | sed 's/"//' | sed 's/",//')
	  echo $sha256
	  echo $sensor_FileName
	  echo "Downloading the sensor to the /tmp/ folder"
	  curl -X GET "https://$target_cloud_api/sensors/entities/download-installer/v1?id=$sha256" -H  "accept: application/json" -H  "authorization: Bearer $meu_token" -o $installation_folder$sensor_FileName
	  yum install -y $installation_folder$sensor_FileName
	  registrar


elif [[ $meu_linux2 == *"amzn1"* ]]; then
	  sensor_amazon_v1=$(curl -X GET "https://$target_cloud_api/sensors/combined/installers/v1?  offset=0&limit=1&sort=release_date%7Cdesc&filter=os_version%3A%221%22" -H  "accept: application/json" -H  "authorization: Bearer $meu_token" )
	  amazon_v1_sha256=$(echo $sensor_amazon_v1 | cut -d ' ' -f32 | sed 's/"//' | sed 's/",//')
	  sensor_FileName=$(echo $sensor_amazon_v1| cut -d ' ' -f17 | sed 's/"//' | sed 's/",//')
	  echo "Downloading the sensor to the /tmp/ folder"
	  curl -X GET "https://$target_cloud_api/sensors/entities/download-installer/v1?id=$amazon_v1_sha256" -H  "accept: application/json" -H  "authorization: Bearer $meu_token" -o $installation_folder$sensor_FileName
	  yum install -y $installation_folder$sensor_FileName
	  registrar


else
  echo "I do not know this Operating System. This OS might not be supported or not tested by this script."
  exit 1

fi






	
