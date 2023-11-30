# utils
Repository for storing utility scripts and other artifacts for JSS

## 📦 [set_openmrs_ip_centos.sh](./set_openmrs_ip.sh)
This script is used to update the OpenMRS Host and port in the atomfeed configuration files of bahmni-lab, erp-conect and pacs-integration. This also updates the markers and failed_events table of the above services. This is useful when OpenMRS is running on a different server.

Example: ./set_openmrs_ip_centos.sh 192.168.0.100 8080

## 📦 [web-clients-0.77.jar](./web-clients-0.77.jar)
This is a custom built jar file to be replaced in older installation of Bahmni when OpenMRS is running on Docker with the upgraded version. This is needed because JSESSIONID is removed from the response body of /ws/rest/v1/session and is available only in Cookie. This file to be replced at /opt/pacs-integration/pacs-integration/WEB-INF/lib. Restart of pacs-integration service is needed after replacing the file.

## 📦 [web-clients-0.91.jar](./web-clients-0.77.jar)
This is a custom built jar file to be replaced in older installation of Bahmni when OpenMRS is running on Docker with the upgraded version. This is needed because JSESSIONID is removed from the response body of /ws/rest/v1/session and is available only in Cookie. This file to be replced at /opt/bahmni-lab/bahmni-lab/WEB-INF/lib && /opt/bahmni-erp-connect/bahmni-erp-connect/WEB-INF/lib. Restart of bahmni-lab, bahmni-erp-connect is needed after replacing the file.

