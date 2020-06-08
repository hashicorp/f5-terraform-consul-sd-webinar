#cloud-config
tmos_declared:
  enabled: true
  icontrollx_trusted_sources: false
  icontrollx_package_urls:
    - https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.19.1/f5-appsvcs-3.19.1-1.noarch.rpm
  post_onboard_enabled: true
  post_onboard_commands:
    # not recommended to set password via cloud-init in AWS
    # this is NOT a secure method, used for demo purposes only
    - tmsh modify auth user admin { password ${password} }
    - tmsh modify auth user admin shell bash
    - tmsh save sys config
