{% from "elasticsearch/map.jinja" import host_lookup as config with context -%}
# Install elasticsearch from a package

package-install-elasticsearch:
  pkg.installed:
    - pkgs:
      - {{ config.package.java_pkg_name }}
      - elasticsearch
    - require:
      - pkgrepo: elasticsearch_repo
