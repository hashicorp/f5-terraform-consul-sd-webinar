#cloud-config
write_files:
  - path: /config/custom-config.sh
    permissions: 0755
    owner: root:root
    content: |
      #!/bin/bash
      PYTHONPATH=/opt/aws/awscli-1.10.26/lib/python2.7/site-packages/ /opt/aws/awscli-1.10.26/bin/aws s3 cp s3://${s3_bucket}/admin.shadow /config/admin.shadow
      tmsh modify /auth user admin encrypted-password $(cat /config/admin.shadow)
      tmsh modify auth user admin shell bash
       
      # CVE-2020-5902
      # see: https://support.f5.com/csp/article/K52145254
      #
      # This is not necessary as long as you are running > 15.1.0.4
      #
      # tmsh modify sys httpd include '"
      # CVE-2020-5902
      #<LocationMatch "\"";"\"">
      #   Redirect 404 /
      #</LocationMatch>
      #<LocationMatch "\""hsqldb"\"">
      #   Redirect 404 /
      #</LocationMatch>"'
      tmsh save sys config
      rm -f /config/admin.shadow
      PYTHONPATH=/opt/aws/awscli-1.10.26/lib/python2.7/site-packages/ /opt/aws/awscli-1.10.26/bin/aws s3 rm s3://${s3_bucket}/admin.shadow
      
tmos_declared:
  enabled: true
  icontrollx_trusted_sources: false
  icontrollx_package_urls:
    - https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.19.1/f5-appsvcs-3.19.1-1.noarch.rpm
  post_onboard_enabled: true
  post_onboard_commands:
    - /config/custom-config.sh
