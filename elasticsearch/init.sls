{% from "elasticsearch/map.jinja" import host_lookup as config with context %}

include:
  - .es-repo
  - .es-package
  - .es-mount
  - .es-config
  - .es-kernel
  - .{{ config.firewall.firewall_include }}
  - .es-service

