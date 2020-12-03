#!/bin/bash

mkdir -p /config/cloud
cat << 'EOF' > /config/cloud/runtime-init-conf.yaml
---
runtime_parameters: []
pre_onboard_enabled:
  - name: provision_rest
    type: inline
    commands:
      - /usr/bin/setdb provision.extramb 500
      - /usr/bin/setdb restjavad.useextramb true
      - /usr/bin/setdb setup.run false
extension_packages:
  install_operations:
    - extensionType: as3
      extensionVersion: 3.24.0
      extensionUrl: file:///var/config/rest/downloads/f5-appsvcs-3.24.0-5.noarch.rpm
extension_services:
    service_operations: []
post_onboard_enabled:
    - name: custom-config
      type: inline
      commands:
        - bash /config/custom-config.sh

EOF
cat << 'EOF' > /config/custom-config.sh
#!/bin/bash
sleep 60
source /usr/lib/bigstart/bigip-ready-functions
wait_bigip_ready

PYTHONPATH=/opt/aws/awscli-1.10.26/lib/python2.7/site-packages/ /opt/aws/awscli-1.10.26/bin/aws s3 cp s3://${s3_bucket}/admin.shadow /config/admin.shadow
tmsh modify /auth user admin encrypted-password $(cat /config/admin.shadow)
tmsh modify auth user admin shell bash

tmsh save sys config
rm -f /config/admin.shadow
PYTHONPATH=/opt/aws/awscli-1.10.26/lib/python2.7/site-packages/ /opt/aws/awscli-1.10.26/bin/aws s3 rm s3://${s3_bucket}/admin.shadow

EOF

source /usr/lib/bigstart/bigip-ready-functions
wait_bigip_ready

for i in {1..30}; do
    curl -fv --retry 1 --connect-timeout 5 -L "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.24.0/f5-appsvcs-3.24.0-5.noarch.rpm" -o "/var/config/rest/downloads/f5-appsvcs-3.24.0-5.noarch.rpm" && break || sleep 10
done

for i in {1..30}; do
    curl -fv --retry 1 --connect-timeout 5 -L "https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v1.1.0/dist/f5-bigip-runtime-init-1.1.0-1.gz.run" -o "/var/config/rest/downloads/f5-bigip-runtime-init-1.1.0-1.gz.run" && break || sleep 10
done
bash /var/config/rest/downloads/f5-bigip-runtime-init-1.1.0-1.gz.run -- '--cloud aws'

f5-bigip-runtime-init --config-file /config/cloud/runtime-init-conf.yaml
