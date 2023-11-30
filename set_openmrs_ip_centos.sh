#!/bin/bash

if [ $# -ne 2 ]
then
echo "Invalid Arguments. Need target IP address/domain, target port"
exit 2
fi

TARGET_IP=$1
TARGET_PORT=$2

echo "Stopping services.."
service bahmni-lab stop
service bahmni-erp-connect stop
service pacs-integration stop
sleep 10

echo "Updating atomfeed properties files.."
cd /opt/bahmni-lab/bahmni-lab/WEB-INF/classes/ && sed -i.bak -e "s|http://.*/openmrs|http://$TARGET_IP:$TARGET_PORT/openmrs|g" atomfeed.properties
cd /opt/bahmni-erp-connect/bahmni-erp-connect/WEB-INF/classes && sed -i.bak -e "s|http://.*/openmrs|http://$TARGET_IP:$TARGET_PORT/openmrs|g" atomfeed.properties
cd /opt/pacs-integration/pacs-integration/WEB-INF/classes/ && sed -i.bak -e "s|http://.*/openmrs|http://$TARGET_IP:$TARGET_PORT/openmrs|g" atomfeed.properties

echo "Updating markers,failed_events for clinlims db.."
psql -U clinlims  -c "UPDATE markers SET feed_uri_for_last_read_entry = regexp_replace(feed_uri_for_last_read_entry, 'http://.*/openmrs', 'http://$TARGET_IP:$TARGET_PORT/openmrs'),feed_uri = regexp_replace(feed_uri, 'http://.*/openmrs', 'http://$TARGET_IP:$TARGET_PORT/openmrs') where feed_uri ~ 'openmrs';"
psql -U clinlims  -c "UPDATE failed_events SET feed_uri = regexp_replace(feed_uri, 'http://.*/openmrs', 'http://$TARGET_IP:$TARGET_PORT/openmrs') where feed_uri ~'openmrs';"
psql -U clinlims  -c "SELECT * from markers;"

echo "Updating markers,failed_events for openerp db.."
psql -U openerp  -c "UPDATE markers SET feed_uri_for_last_read_entry = regexp_replace(feed_uri_for_last_read_entry, 'http://.*/openmrs', 'http://$TARGET_IP:$TARGET_PORT/openmrs'),feed_uri = regexp_replace(feed_uri, 'http://.*/openmrs', 'http://$TARGET_IP:$TARGET_PORT/openmrs') where feed_uri ~ 'openmrs';"
psql -U openerp  -c "UPDATE failed_events SET feed_uri = regexp_replace(feed_uri, 'http://.*/openmrs', 'http://$TARGET_IP:$TARGET_PORT/openmrs') where feed_uri ~'openmrs';"
psql -U openerp  -c "SELECT * from markers;"

echo "Updating markers,failed_events for bahmni_pacs db.."
psql -U postgres -w bahmni_pacs -c "UPDATE markers SET feed_uri_for_last_read_entry = regexp_replace(feed_uri_for_last_read_entry, 'http://.*/openmrs', 'http://$TARGET_IP:$TARGET_PORT/openmrs'),feed_uri = regexp_replace(feed_uri, 'http://.*/openmrs', 'http://$TARGET_IP:$TARGET_PORT/openmrs') where feed_uri ~ 'openmrs';"
psql -U postgres -w bahmni_pacs -c "UPDATE failed_events SET feed_uri = regexp_replace(feed_uri, 'http://.*/openmrs', 'http://$TARGET_IP:$TARGET_PORT/openmrs') where feed_uri ~'openmrs';"
psql -U postgres -w bahmni_pacs -c "SELECT * from markers;"